import os
import random
import shutil
import subprocess
from pathlib import Path
from uuid import UUID, uuid4

import yaml
from jinja2 import Environment, FileSystemLoader
from loguru import logger
from rich import print as rprint

environment = Environment(
    loader=FileSystemLoader(f"{os.path.dirname(os.path.abspath(__file__))}/templates/")
)


def read_creds_file(creds) -> dict:
    with open(creds, "r") as creds_file:
        all_creds = yaml.safe_load(creds_file)

    return all_creds


def gather_providers(providers) -> list[str]:
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


def choose_two(providers: list) -> list[str]:
    chosen_providers = random.choices(providers, k=2)

    return chosen_providers


def copy_specific_modules(
    script_path: str, dest_dir: str, modules_to_copy: list
) -> None:
    src_dir = os.path.join(script_path, "modules")
    for index, module in enumerate(modules_to_copy):
        index += 1
        dest_folder_name = f"hop{index}" + "_" + str(module)
        src_folder_path = os.path.join(src_dir, module)
        dest_folder_path = os.path.join(dest_dir, dest_folder_name)

        shutil.copytree(src_folder_path, dest_folder_path)


def setup_terraform(
    script_path: str, creds_file: str, providers: str, base_path: str
) -> tuple:
    creds = read_creds_file(creds_file)
    providers = gather_providers(providers)

    valid_providers = providers_with_creds(creds, list(providers))
    logger.success(f"Credentials discovered for {valid_providers}")

    select_two = choose_two(valid_providers)
    logger.success(f"Providers chosen: {select_two}")

    chain_id = make_op_path(base_path)
    dest_directory = f"{base_path}/{chain_id}/modules"

    copy_specific_modules(script_path, dest_directory, select_two)
    for index, module in enumerate(select_two):
        provider = f"hop{index}" + "_" + str(module)
        template = environment.get_template("main.tf.j2")
        content = template.render(hop_name=provider)
        with open(
            f"{base_path}/{chain_id}/{provider}.tf", mode="w", encoding="utf-8"
        ) as message:
            message.write(content)

    project_path = f"{base_path}/{chain_id}/"
    return project_path, select_two, chain_id


def ansible_deploy(
    script_path: str, project_path: str, select_two: list, chain_id: str
):
    command = f"ansible-playbook {script_path}/ansible/deploy.yml -e project_path={project_path} -e provider1={select_two[0]} -e provider2={select_two[1]} -e project_id={chain_id}"

    process = subprocess.Popen(
        command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
    )

    # Read and print the output in real-time
    while True:
        line = process.stdout.readline()
        if not line:
            break
        rprint(line, end="")
    process.wait()


if __name__ == "__main__":
    script_path = os.path.dirname(os.path.abspath(__file__))
    creds_file = f"{script_path}/keys.yaml"
    providers = f"{script_path}/providers.yaml"
    base_path = "/tmp"

    project_path, select_two, chain_id = setup_terraform(
        script_path, creds_file, providers, base_path
    )

    ansible_deploy(script_path, project_path, select_two, chain_id)
