import os
import shutil
import subprocess
from pathlib import Path
from uuid import UUID, uuid4

import yaml
from loguru import logger


def read_creds_file(creds) -> dict:
    with open(creds, "r") as creds_file:
        all_creds = yaml.safe_load(creds_file)

    return all_creds


def gather_providers(providers) -> list:
    with open(providers, "r") as file:
        all_providers = yaml.safe_load(file)

    return all_providers


def providers_with_creds(creds: dict, providers: list) -> list:
    valid_providers = []
    for provider in providers:
        if provider in creds.keys():
            valid_providers.append(provider)

    return valid_providers


def make_op_path(base_path: str) -> UUID:
    op_name = uuid4()
    directory_path = Path(f"{base_path}/{op_name}")

    # Make the directory by calling mkdir() on the path instance
    logger.info(f"Creating path: {directory_path}")
    directory_path.mkdir()

    # logger.info(f"Deleting path: {directory_path}")
    # directory_path.rmdir()

    return op_name


def copy_specific_modules(
    script_path: str, dest_dir: str, modules_to_copy: list
) -> None:
    src_dir = os.path.join(script_path, "modules")
    for module in modules_to_copy:
        src_folder_path = os.path.join(src_dir, module)
        dest_folder_path = os.path.join(dest_dir, module)

        shutil.copytree(src_folder_path, dest_folder_path)


if __name__ == "__main__":
    script_path = os.path.dirname(os.path.abspath(__file__))
    creds_file = f"{script_path}/keys.yaml"
    providers = f"{script_path}/providers.yaml"
    base_path = "/tmp"

    creds = read_creds_file(creds_file)
    providers = gather_providers(providers)

    valid_providers = providers_with_creds(creds, providers)

    logger.info(valid_providers)
    chain_id = make_op_path(base_path)

    dest_directory = f"{base_path}/{chain_id}"
    folders_to_copy = valid_providers
    copy_specific_modules(script_path, dest_directory, folders_to_copy)
