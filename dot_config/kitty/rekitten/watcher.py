"""Kitty watcher hooks for rekitten.

This module is loaded by Kitty as a global watcher. It hooks into tab/window
events to automatically save session state.
"""

from __future__ import annotations

import time
from typing import Any, TYPE_CHECKING

if TYPE_CHECKING:
    from kitty.boss import Boss
    from kitty.window import Window

# Import our modules - handle both direct execution and as kitty watcher
try:
    from rekitten.session import save_state
    from rekitten.logger import get_logger
except ImportError:
    # When loaded by Kitty, we may need to add our parent to path
    import sys
    from pathlib import Path
    # Add the rekitten package parent directory to path
    _pkg_dir = Path(__file__).parent.parent
    if str(_pkg_dir) not in sys.path:
        sys.path.insert(0, str(_pkg_dir))
    from rekitten.session import save_state
    from rekitten.logger import get_logger

log = get_logger(__name__)

_save_in_progress = False  # Re-entrancy guard
_boss: "Boss | None" = None  # Store boss reference

# Startup grace period - don't save during initial session load
_startup_time: float | None = None
STARTUP_GRACE_SECONDS = 5.0  # Wait 5 seconds after startup before allowing saves


def _do_save() -> None:
    """Execute a save operation."""
    global _save_in_progress

    # Prevent re-entrancy
    if _save_in_progress:
        log.debug("Save already in progress, skipping")
        return

    if _boss is None:
        log.error("Boss not available")
        return

    # Skip saves during startup grace period
    if _startup_time is not None:
        time_since_startup = time.time() - _startup_time
        if time_since_startup < STARTUP_GRACE_SECONDS:
            log.debug(f"Skipping save during startup grace period ({time_since_startup:.1f}s < {STARTUP_GRACE_SECONDS}s)")
            return

    _save_in_progress = True
    try:
        save_state(_boss)
    except Exception as e:
        log.exception(f"Error saving state: {e}")
    finally:
        _save_in_progress = False


# Kitty watcher callbacks


def on_load(boss: "Boss", data: dict[str, Any]) -> None:
    """Called once when the watcher module is first loaded."""
    global _startup_time, _boss
    _startup_time = time.time()
    _boss = boss
    log.info("rekitten watcher loaded")
    log.debug(f"Debounce interval: {DEBOUNCE_SECONDS}s, startup grace: {STARTUP_GRACE_SECONDS}s")


def on_tab_bar_dirty(boss: "Boss", window: "Window", data: dict[str, Any]) -> None:
    """Called when tabs change (created, closed, moved, renamed)."""
    log.debug("on_tab_bar_dirty triggered")
    _do_save()


def on_close(boss: "Boss", window: "Window", data: dict[str, Any]) -> None:
    """Called when a window is closed."""
    log.debug(f"on_close triggered for window {window.id if window else 'unknown'}")
    _do_save()


