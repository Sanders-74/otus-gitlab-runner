"""
Module: logger.py
Description: Модуль для настройки логгера.
"""

import os
import sys
from loguru import logger


def setup_logger(logs_dir: str = "logs", logs_file: str = "output.log") -> None:
    """
    Настраивает логгер для скрипта.

    Parameters
    ----------
    logs_dir : str, optional
        Директория для хранения логов, by default 'logs'
    logs_file : str, optional
        Имя файла для логов, by default 'output.log'
    """
    logger.remove()
    logger.add(sys.stderr, level="INFO")

    if not os.path.exists(logs_dir):
        os.makedirs(logs_dir)

    logs_path = os.path.join(logs_dir, logs_file)
    logger.add(logs_path, rotation="50 MB")
