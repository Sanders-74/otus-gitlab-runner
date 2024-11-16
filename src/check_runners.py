"""
Script: check_runners.py
Description: Script to retrieve the list of shared runners from GitLab.
"""

import os
from typing import List, Dict, Optional

import requests
from requests.exceptions import RequestException
from dotenv import load_dotenv
from loguru import logger
from src.logger import setup_logger


def get_gitlab_runners(
    url: str, token: str, params: Dict[str, any]
) -> Optional[List[Dict[str, any]]]:
    """
    Retrieves the list of runners from GitLab API.

    Parameters
    ----------
    url : str
        GitLab API URL.
    token : str
        GitLab access token.
    params : Dict[str, any]
        Request parameters.

    Returns
    -------
    Optional[List[Dict[str, any]]]
        List of runners or None in case of an error.
    """
    api_url = f"{url}/api/v4/runners/all"
    headers = {"Private-Token": token}

    logger.info(f"Sending request to {api_url}")
    logger.debug(f"Request parameters: {params}")

    try:
        response = requests.get(api_url, headers=headers, params=params, timeout=30)
        logger.debug(f"Response status: {response.status_code}")
        logger.debug(f"Response headers: {response.headers}")

        response.raise_for_status()

        runners = response.json()
        logger.debug(f"Runners received: {len(runners)}")
        return runners
    except RequestException as e:
        logger.error(f"An error occurred while requesting GitLab API: {e}")
        if hasattr(e.response, "text"):
            logger.error(f"Response text: {e.response.text}")
        return None


def main() -> None:
    """
    Main function for retrieving and displaying the list of shared GitLab runners.
    """
    load_dotenv()
    setup_logger(
        logs_dir=os.getenv("LOGS_DIR", "logs"),
        logs_file=os.path.basename(__file__).replace(".py", ".log"),
    )

    gitlab_token = os.getenv("GITLAB_TOKEN")
    gitlab_url = os.getenv("GITLAB_URL", "https://gitlab.com")

    if not gitlab_token:
        logger.error("GITLAB_TOKEN not found in environment variables.")
        return

    logger.info(f"Using GitLab URL: {gitlab_url}")

    params = {"scope": "shared", "per_page": 100}
    runners = get_gitlab_runners(gitlab_url, gitlab_token, params)

    if runners is not None:
        if runners:
            logger.info(f"Found {len(runners)} shared runners:")
            for runner in runners:
                runner_id = runner.get("id")
                description = runner.get("description", "No description")
                status = runner.get("status")
                logger.info(f"Runner ID: {runner_id}, Description: {description}, Status: {status}")
        else:
            logger.warning("No shared runners found.")
            logger.info("Please check the following:")
            logger.info(
                "1. Ensure your token has the necessary access rights (admin rights required)"
            )
            logger.info(
                "2. Verify the existence of shared runners in your GitLab instance"
            )
    else:
        logger.error("Failed to retrieve the list of shared runners.")
        logger.info("Please check the following:")
        logger.info("1. Correctness of the GitLab URL")
        logger.info("2. Presence of necessary access rights for the token")
        logger.info("3. Availability of the GitLab API")


if __name__ == "__main__":
    main()
