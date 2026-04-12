# Based on MIT licensed code at https://github.com/chancez/dotfiles/blob/badc69d3895a6a942285amount26b8c372a55d77533eamount/kitty/.config/kitty/relative_resize.py
from kittens.tui.handler import result_handler
from kitty.key_encoding import KeyEvent, parse_shortcut


def encode_key_mapping(window, key_mapping):
    mods, key = parse_shortcut(key_mapping)
    event = KeyEvent(
        mods=mods,
        key=key,
        shift=bool(mods & 1),
        alt=bool(mods & 2),
        ctrl=bool(mods & 4),
        super=bool(mods & 8),
        hyper=bool(mods & 16),
        meta=bool(mods & 32),
    ).as_window_system_event()

    return window.encoded_key(event)


def main(args):
    pass


def _tree_contains(node, wid):
    """Check if a layout tree node contains the given window ID."""
    if isinstance(node, int):
        return node == wid
    if hasattr(node, 'one'):
        return _tree_contains(node.one, wid) or _tree_contains(node.two, wid)
    return False


def _find_side_in_nearest_split(node, wid, want_horizontal):
    """Walk the pair tree to find which side of the nearest matching split
    contains the window.

    In kitty's splits layout, each Pair has a 'horizontal' attribute:
      horizontal=True  -> children are side by side (left | right)
      horizontal=False -> children are stacked (top / bottom)

    'one' is always the before-child (left or top).
    'two' is always the after-child (right or bottom).

    Returns 'one' or 'two', or None if not found.
    """
    if isinstance(node, int) or not hasattr(node, 'one'):
        return None
    in_one = _tree_contains(node.one, wid)
    if not in_one and not _tree_contains(node.two, wid):
        return None
    child = node.one if in_one else node.two
    deeper = _find_side_in_nearest_split(child, wid, want_horizontal)
    if deeper is not None:
        return deeper
    if getattr(node, 'horizontal', None) == want_horizontal:
        return 'one' if in_one else 'two'
    return None


# Maps (direction, tree-side) to the resize action that moves the border
# in the correct direction. 'one' = left/top child, 'two' = right/bottom.
_RESIZE_ACTIONS = {
    ('left', 'one'): 'narrower',    # one shrinks from right -> border moves left
    ('left', 'two'): 'wider',       # two grows from left   -> border moves left
    ('right', 'one'): 'wider',      # one grows from right  -> border moves right
    ('right', 'two'): 'narrower',   # two shrinks from left -> border moves right
    ('up', 'one'): 'shorter',       # one shrinks from below -> border moves up
    ('up', 'two'): 'taller',        # two grows from above   -> border moves up
    ('down', 'one'): 'taller',      # one grows from below  -> border moves down
    ('down', 'two'): 'shorter',     # two shrinks from above -> border moves down
}


def relative_resize_window(direction, amount, target_window_id, boss):
    window = boss.window_id_map.get(target_window_id)
    if window is None:
        return

    neighbors = boss.active_tab.current_layout.neighbors_for_window(
        window, boss.active_tab.windows
    )

    left_neighbors = neighbors.get('left')
    right_neighbors = neighbors.get('right')
    top_neighbors = neighbors.get('top')
    bottom_neighbors = neighbors.get('bottom')

    if direction in ('left', 'right'):
        has_before, has_after = bool(left_neighbors), bool(right_neighbors)
    else:
        has_before, has_after = bool(top_neighbors), bool(bottom_neighbors)

    if has_before and has_after:
        # Window has neighbors on both sides. We need to check the layout
        # tree to determine which border resize_window will move, and pick
        # the action that moves it in the requested direction.
        layout = boss.active_tab.current_layout
        root = getattr(layout, 'pairs_root', None)
        side = None
        if root is not None:
            want_horizontal = direction in ('left', 'right')
            side = _find_side_in_nearest_split(root, target_window_id, want_horizontal)
        action = _RESIZE_ACTIONS.get((direction, side))
        if action:
            boss.active_tab.resize_window(action, amount)
            return
        # Fallback if tree inspection failed: use single-neighbor logic
        # (treat as if only the before-neighbor exists)
        has_after = False

    if has_before:
        # Window is at the after-edge; only border is on the before-side
        if direction in ('left', 'up'):
            boss.active_tab.resize_window(
                'wider' if direction in ('left', 'right') else 'taller', amount)
        else:
            boss.active_tab.resize_window(
                'narrower' if direction in ('left', 'right') else 'shorter', amount)
    elif has_after:
        # Window is at the before-edge; only border is on the after-side
        if direction in ('left', 'up'):
            boss.active_tab.resize_window(
                'narrower' if direction in ('left', 'right') else 'shorter', amount)
        else:
            boss.active_tab.resize_window(
                'wider' if direction in ('left', 'right') else 'taller', amount)


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    direction = args[1]
    amount = int(args[2])
    window = boss.window_id_map.get(target_window_id)

    cmd = window.child.foreground_cmdline[0]
    if cmd == 'tmux':
        keymap = args[3]
        encoded = encode_key_mapping(window, keymap)
        window.write_to_child(encoded)
    else:
        relative_resize_window(direction, amount, target_window_id, boss)
