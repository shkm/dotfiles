import re
from xkeysnail.transform import *

define_keymap(None, {
    K("RM-J"): K("down"),
    K("RM-K"): K("up"),
    K("RM-H"): K("left"),
    K("RM-L"): K("right"),
    K("RM-KEY_0"): K("home"),
    K("RM-Shift-KEY_4"): K("end")
    }, "Right-Alt Vim")

define_keymap(re.compile("konsole"), {
    K("LC-J"): launch(["konsole-vim-navigate", "down"]),
    K("LC-K"): launch(["konsole-vim-navigate", "up"]),
    K("LC-H"): launch(["konsole-vim-navigate", "left"]),
    K("LC-L"): launch(["konsole-vim-navigate", "right"]),
}, "Konsole")

define_keymap(re.compile("firefox"), {
    # Meta-J, Meta-K tab navigation
    K("M-J"): K("C-TAB"),
    K("M-K"): K("C-Shift-TAB"),
}, "Firefox")

define_keymap(re.compile("dolphin"), {
    K("BACKSPACE"): K("DELETE"),
    K("Shift-BACKSPACE"): K("Shift-DELETE"),
}, "Dolphin")
