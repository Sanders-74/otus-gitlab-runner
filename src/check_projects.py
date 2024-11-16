"""
Script: check_projects.py
Description: Скрипт для получения списка проектов из GitLab.
"""

import os
from typing import List, Dict, Optional

import requests
from requests.exceptions import RequestException
from dotenv import load_dotenv
from loguru import logger


def get_gitlab_projects(url: str, token: str) -> Optional[List[Dict[str, any]]]:
    """
    Получает список проектов из GitLab API.

    Parameters
    ----------
    url : str
        URL GitLab API.
    token : str
        Токен доступа к GitLab.

    Returns
    -------
    Optional[List[Dict[str, any]]]
        Список проектов или None в случае ошибки.
    """
    api_url = f"{url}/api/v4/projects"
    headers = {"Private-Token": token}
    params = {"per_page": 1}  # Запрашиваем только один проект для проверки

    try:
        response = requests.get(api_url, headers=headers, params=params, timeout=30)
        response.raise_for_status()
        projects = response.json()
        logger.debug(f"Получено проектов: {len(projects)}")
        return projects
    except RequestException as e:
        logger.error(f"Произошла ошибка при запросе к API GitLab (projects): {e}")
        return None


def main() -> None:
    """
    Основная функция для получения и отображения списка раннеров GitLab.
    """
    load_dotenv()

    gitlab_token = os.getenv("GITLAB_TOKEN")
    gitlab_url = os.getenv("GITLAB_URL", "https://gitlab.com")

    if not gitlab_token:
        logger.error("GITLAB_TOKEN не найден в переменных окружения.")
        return

    logger.info(f"Используется GitLab URL: {gitlab_url}")

    projects = get_gitlab_projects(gitlab_url, gitlab_token)

    if projects:
        logger.info(
            f"Успешно получен список проектов. Найдено проектов: {len(projects)}"
        )
    else:
        logger.warning("Не удалось получить список проектов.")


if __name__ == "__main__":
    main()
