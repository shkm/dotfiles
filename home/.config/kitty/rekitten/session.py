"""Session save/load logic for rekitten."""

from __future__ import annotations

import json
from pathlib import Path
from typing import Any, TYPE_CHECKING

from .config import SESSION_FILE, STATE_FILE, REKITTEN_STATE_DIR
from .logger import get_logger

if TYPE_CHECKING:
    from kitty.boss import Boss

log = get_logger(__name__)


def get_kitty_state_from_boss(boss: "Boss") -> list[dict[str, Any]]:
    """Get Kitty state directly from the boss object."""
    # boss.list_os_windows() returns the same structure as `kitten @ ls`
    return list(boss.list_os_windows())


def _get_window_cwd(window: dict[str, Any]) -> str | None:
    """Get the CWD for a window, preferring foreground process CWD."""
    fg_processes = window.get("foreground_processes", [])
    if fg_processes:
        cwd = fg_processes[0].get("cwd")
        if cwd:
            return cwd
    return window.get("cwd")


def _build_group_to_window_map(tab: dict[str, Any]) -> dict[int, dict[str, Any]]:
    """Build a mapping from group ID to window data."""
    windows_by_id = {w["id"]: w for w in tab.get("windows", [])}
    layout_state = tab.get("layout_state", {})
    all_windows = layout_state.get("all_windows", {})
    window_groups = all_windows.get("window_groups", [])

    group_map = {}
    for group in window_groups:
        group_id = group.get("id")
        window_ids = group.get("window_ids", [])
        if group_id is not None and window_ids:
            # Use the first window in the group
            window_id = window_ids[0]
            if window_id in windows_by_id:
                window = windows_by_id[window_id]
                group_map[group_id] = {
                    "id": window_id,
                    "cwd": _get_window_cwd(window),
                    "is_active": window.get("is_active", False),
                }
    return group_map


def _parse_pairs_tree(
    pairs: dict[str, Any] | int,
    group_map: dict[int, dict[str, Any]],
    default_horizontal: bool = True,
) -> tuple[list[dict[str, Any]], int | None]:
    """Parse the pairs tree structure and return windows with split info.

    Returns:
        - List of windows in creation order, with split information
        - Index of the last window in the list (for parent to reference)

    For complex layouts, tracks which window to split from using indices.
    """
    if isinstance(pairs, int):
        # Leaf node - just a group ID
        group_id = pairs
        if group_id in group_map:
            window = {"group_id": group_id, **group_map[group_id]}
            return [window], 0
        return [], None

    if not isinstance(pairs, dict):
        return [], None

    # Internal node with one/two branches
    one = pairs.get("one")
    two = pairs.get("two")
    horizontal = pairs.get("horizontal", default_horizontal)
    bias = pairs.get("bias", 0.5)

    # Recursively parse left branch
    left_windows, left_last_idx = _parse_pairs_tree(one, group_map, default_horizontal) if one is not None else ([], None)

    # Recursively parse right branch
    right_windows, right_last_idx = _parse_pairs_tree(two, group_map, default_horizontal) if two is not None else ([], None)

    if not left_windows and not right_windows:
        return [], None

    if not left_windows:
        return right_windows, right_last_idx

    if not right_windows:
        return left_windows, left_last_idx

    # The first window of right branch is created by splitting the LAST
    # window of left branch (which is the current window after creating left)
    right_windows[0]["split"] = {
        "horizontal": horizontal,
        "bias": bias,
        "from_idx": left_last_idx,  # Index into left_windows
    }

    # Adjust from_idx for windows in right branch that reference other right windows
    for window in right_windows:
        if "split" in window and "from_idx" in window["split"]:
            if window["split"]["from_idx"] != left_last_idx:
                # This references a window in the right subtree, adjust index
                window["split"]["from_idx"] += len(left_windows)

    # First window of right branch references left branch
    right_windows[0]["split"]["from_idx"] = left_last_idx

    all_windows = left_windows + right_windows
    # Last window is now at adjusted index
    new_last_idx = len(left_windows) + right_last_idx if right_last_idx is not None else left_last_idx

    return all_windows, new_last_idx


def _unwrap_pairs_tree(
    pairs: dict[str, Any] | int,
    group_map: dict[int, dict[str, Any]],
    default_horizontal: bool = True,
) -> list[dict[str, Any]]:
    """Wrapper for _parse_pairs_tree that returns just the window list."""
    windows, _ = _parse_pairs_tree(pairs, group_map, default_horizontal)
    return windows


def extract_tab_cwds(state: list[dict[str, Any]]) -> list[dict[str, Any]]:
    """Extract tab information with CWDs and window layouts from Kitty state.

    Returns a list of OS windows, each containing tabs with their window layouts.
    """
    os_windows = []

    for os_window in state:
        tabs = []
        for tab in os_window.get("tabs", []):
            windows = tab.get("windows", [])
            if not windows:
                continue

            layout = tab.get("layout", "splits")
            layout_state = tab.get("layout_state", {})

            # Build group -> window mapping
            group_map = _build_group_to_window_map(tab)

            # Parse the layout tree
            pairs = layout_state.get("pairs", {})
            opts = layout_state.get("opts", {})
            default_horizontal = opts.get("default_axis_is_horizontal", True)

            parsed_windows = _unwrap_pairs_tree(pairs, group_map, default_horizontal)

            # Fallback: if parsing failed, just use windows directly
            if not parsed_windows:
                parsed_windows = []
                for w in windows:
                    cwd = _get_window_cwd(w)
                    if cwd:
                        parsed_windows.append({
                            "id": w["id"],
                            "cwd": cwd,
                            "is_active": w.get("is_active", False),
                        })

            if parsed_windows:
                tabs.append({
                    "title": tab.get("title", ""),
                    "layout": layout,
                    "is_active": tab.get("is_active", False),
                    "windows": parsed_windows,
                })

        if tabs:
            os_windows.append({
                "id": os_window.get("id"),
                "is_active": os_window.get("is_active", False),
                "tabs": tabs,
            })

    return os_windows


def generate_session_file(os_windows: list[dict[str, Any]]) -> str:
    """Generate Kitty session file content from extracted state."""
    lines = []

    for i, os_window in enumerate(os_windows):
        if i > 0:
            lines.append("")
            lines.append("new_os_window")

        for j, tab in enumerate(os_window.get("tabs", [])):
            title = tab.get("title", "")

            if j > 0:
                lines.append("")
                if title:
                    lines.append(f"new_tab {title}")
                else:
                    lines.append("new_tab")
            elif title:
                # First tab: use title command
                lines.append(f"title {title}")

            layout = tab.get("layout", "splits")
            lines.append(f"layout {layout}")

            windows = tab.get("windows", [])
            # Track the "current" window index (last created window)
            current_idx = 0

            for k, window in enumerate(windows):
                cwd = window.get("cwd", "")
                split = window.get("split")

                if cwd:
                    lines.append(f"cd {cwd}")

                if k == 0:
                    # First window: simple launch with variable for potential back-reference
                    if len(windows) > 2:
                        # Only use variables if we have complex splits
                        lines.append(f"launch --var window=w{k}")
                    else:
                        lines.append("launch")
                    current_idx = 0
                else:
                    # Subsequent windows: may need to focus a different window first
                    from_idx = split.get("from_idx", k - 1) if split else k - 1

                    # If we need to split from a window that's not current, focus it first
                    if from_idx != current_idx and len(windows) > 2:
                        lines.append(f"focus_matching_window var:window=w{from_idx}")
                        current_idx = from_idx

                    # Build launch command
                    launch_args = ["launch"]

                    if split:
                        # Determine split direction
                        # horizontal=True means side-by-side (hsplit)
                        # horizontal=False means stacked (vsplit)
                        if split.get("horizontal", True):
                            launch_args.append("--location=hsplit")
                        else:
                            launch_args.append("--location=vsplit")

                        # Add bias if not 50/50
                        bias = split.get("bias", 0.5)
                        if abs(bias - 0.5) > 0.01:  # Only if noticeably different from 50%
                            # Bias is the proportion of the first pane
                            # For the new pane, we want the inverse percentage
                            new_pane_bias = round((1 - bias) * 100)
                            # Clamp to valid range (10-90)
                            new_pane_bias = max(10, min(90, new_pane_bias))
                            launch_args.append(f"--bias={new_pane_bias}")
                    else:
                        # No split info, default to hsplit
                        launch_args.append("--location=hsplit")

                    # Add variable for back-reference if we have complex splits
                    if len(windows) > 2:
                        launch_args.append(f"--var window=w{k}")

                    lines.append(" ".join(launch_args))
                    current_idx = k  # New window is now current

            if tab.get("is_active"):
                lines.append("focus")

    return "\n".join(lines) + "\n"


def save_state(boss: "Boss") -> bool:
    """Save current Kitty state to session file."""
    log.debug("Saving state...")

    try:
        state = get_kitty_state_from_boss(boss)
    except Exception as e:
        log.error(f"Failed to get Kitty state: {e}")
        return False

    if not state:
        log.warning("No state returned from boss")
        return False

    os_windows = extract_tab_cwds(state)
    if not os_windows:
        log.warning("No tabs found to save")
        return False

    # Ensure state directory exists
    REKITTEN_STATE_DIR.mkdir(parents=True, exist_ok=True)

    # Save raw state as JSON (for debugging/inspection)
    try:
        STATE_FILE.write_text(json.dumps(os_windows, indent=2))
        log.debug(f"Saved state JSON to {STATE_FILE}")
    except OSError as e:
        log.error(f"Failed to write state file: {e}")
        return False

    # Generate and save session file
    session_content = generate_session_file(os_windows)
    try:
        SESSION_FILE.write_text(session_content)
        log.info(f"Saved session to {SESSION_FILE}")
        log.debug(f"Session content:\n{session_content}")
    except OSError as e:
        log.error(f"Failed to write session file: {e}")
        return False

    return True
