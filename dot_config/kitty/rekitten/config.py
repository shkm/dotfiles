"""Configuration for rekitten."""

import os
from pathlib import Path


def _get_xdg_path(env_var: str, default_subdir: str) -> Path:
    """Get XDG directory path, respecting environment variables."""
    if env_var in os.environ:
        return Path(os.environ[env_var])
    return Path.home() / default_subdir


# XDG Base Directories
XDG_CONFIG_HOME = _get_xdg_path("XDG_CONFIG_HOME", ".config")
XDG_STATE_HOME = _get_xdg_path("XDG_STATE_HOME", ".local/state")

# Kitty config directory (Kitty's own env var takes precedence)
KITTY_CONFIG_DIR = Path(os.environ.get("KITTY_CONFIG_DIRECTORY", XDG_CONFIG_HOME / "kitty"))

# rekitten state directory - use XDG_STATE_HOME by default
# Can be overridden with REKITTEN_STATE_DIR
_default_state_dir = XDG_STATE_HOME / "rekitten"
REKITTEN_STATE_DIR = Path(os.environ.get("REKITTEN_STATE_DIR", _default_state_dir))

# Files
SESSION_FILE = REKITTEN_STATE_DIR / "session"
STATE_FILE = REKITTEN_STATE_DIR / "state.json"
LOG_FILE = REKITTEN_STATE_DIR / "rekitten.log"

# Behavior
DEBUG = os.environ.get("REKITTEN_DEBUG", "").lower() in ("1", "true", "yes")
