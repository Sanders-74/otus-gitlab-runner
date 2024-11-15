"""
Invoke tasks
"""

from dotenv import load_dotenv
from invoke import task
from invoke.context import Context

load_dotenv()

@task
def hello(cxt: Context, name: str="world!") -> None:
    """Prints 'Hello, {name}'"""
    cxt.run(f"echo Hello, {name}")

@task
def check_pythonpath(cxt: Context) -> None:
    """Check PYTHONPATH"""
    cxt.run("echo $PYTHONPATH")

@task
def download_log(cxt: Context) -> None:
    """Download log"""
    cxt.run("bash scripts/download_log.sh")

@task
def check_projects(cxt: Context) -> None:
    """Check projects"""
    cxt.run("python3 src/check_projects.py")

@task
def check_runners(cxt: Context) -> None:
    """Check runners"""
    cxt.run("python3 src/check_runners.py")
