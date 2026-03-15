"""Logging configuration for rekitten."""

from __future__ import annotations

import logging
import sys
from pathlib import Path

from .config import LOG_FILE, DEBUG, REKITTEN_STATE_DIR

_initialized = False


def setup_logging() -> None:
    """Set up logging configuration."""
    global _initialized
    if _initialized:
        return

    # Ensure log directory exists
    REKITTEN_STATE_DIR.mkdir(parents=True, exist_ok=True)

    level = logging.DEBUG if DEBUG else logging.INFO

    # Create formatter
    formatter = logging.Formatter(
        fmt="%(asctime)s [%(levelname)s] %(name)s: %(message)s",
        datefmt="%Y-%m-%d %H:%M:%S",
    )

    # File handler
    file_handler = logging.FileHandler(LOG_FILE)
    file_handler.setLevel(level)
    file_handler.setFormatter(formatter)

    # Configure root logger for rekitten
    logger = logging.getLogger("rekitten")
    logger.setLevel(level)
    logger.addHandler(file_handler)

    # Also log to stderr if DEBUG is enabled
    if DEBUG:
        stderr_handler = logging.StreamHandler(sys.stderr)
        stderr_handler.setLevel(logging.DEBUG)
        stderr_handler.setFormatter(formatter)
        logger.addHandler(stderr_handler)

    _initialized = True


def get_logger(name: str) -> logging.Logger:
    """Get a logger instance."""
    setup_logging()
    return logging.getLogger(name)
