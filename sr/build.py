#!/usr/bin/python3
import datetime
import json
import os
import random
import shutil
import string
import subprocess
from pathlib import Path
from uuid import UUID, uuid4

import yaml
from jinja2 import Environment, FileSystemLoader
from loguru import logger
from rich import print as rprint

from sr.gen_ssh import generate_keys
from sr.parse_state import get_ips
from sr.vars_setup import generate_vars_file

environment = Environment(
    loader=FileSystemLoader(f"{os.path.dirname(os.path.abspath(__file__))}/templates/")
)


def random_values() -> tuple:
    resource_name_lengths = [6, 7, 8, 9]
    N = random.choices(resource_name_lengths)[0]
    hop1_resource_name = "".join(random.choices(string.ascii_lowercase, k=N))

    N = random.choices(resource_name_lengths)[0]
    hop2_resource_name = "".join(random.choices(string.ascii_lowercase, k=N))

    wg_port = random.randint(20000, 50000)

    return hop1_resource_name, hop2_resource_name, wg_port 


def read_creds_file(creds: Path) -> dict:
    with open(creds, "r") as creds_file:
        all_creds = yaml.safe_load(creds_file)

    return all_creds


def gather_providers(providers: str) -> dict[str, list[str]]:
    with open(providers, "r") as file:
        all_providers = yaml.safe_load(file)
    return all_providers


def choose_one(providers: list) -> list[str]:
    chosen_provider = random.choices(providers, k=1)

    return chosen_provider


def providers_with_creds(creds: dict, provider) -> bool:
    if provider in creds.keys():
        return True

    else:
        return False


def make_op_path(base_path: str) -> UUID:
    op_name = uuid4()
    directory_path = Path(f"{base_path}/{op_name}")

    logger.info(f"Creating path: {directory_path}")
    directory_path.mkdir()

    return op_name


def copy_specific_modules(
    script_path: str, dest_dir: str, provider1: str, provider2: str
) -> None:
    src_dir = os.path.join(script_path, "modules")
    # Provider1
    dest_folder_name = f"hop1" + "_" + provider1
    src_folder_path = os.path.join(src_dir, provider1)
    dest_folder_path = os.path.join(dest_dir, dest_folder_name)
    shutil.copytree(src_folder_path, dest_folder_path)

    # Provider2
    dest_folder_name = f"hop2" + "_" + provider2
    src_folder_path = os.path.join(src_dir, provider2)
    dest_folder_path = os.path.join(dest_dir, dest_folder_name)

    shutil.copytree(src_folder_path, dest_folder_path)


def setup_terraform(
    script_path: str, creds_file: Path, provider1: str, provider2: str, base_path: str
) -> tuple:
    creds = read_creds_file(creds_file)

    # Choose first and second hop providers
    logger.success(f"Provider 1: {provider1} | Provider 2: {provider2}")

    # Move modules to project directory
    chain_id = make_op_path(base_path)
    dest_directory = f"{base_path}/{chain_id}/modules"
    copy_specific_modules(script_path, dest_directory, provider1, provider2)
    generate_vars_file(creds, provider1, provider2, base_path, chain_id)

    # Move GCP file if required
    if "gcp" in creds.keys():
        shutil.copyfile(
            f"{script_path}/{creds.get('gcp').get('creds_file')}",
            f"{base_path}/{chain_id}/{creds.get('gcp').get('creds_file')}",
        )
    project_path = f"{base_path}/{chain_id}"
    return project_path, chain_id


def ansible_build(
    script_path: str, project_path: str, provider1: str, provider2: str, chain_id: str, clean: bool
) -> tuple:
    hop1_resource_name, hop2_resource_name, wg_port = random_values()
    command = f"ansible-playbook {script_path}/ansible/build.yml -e project_path={project_path} -e provider1={provider1} -e provider2={provider2} -e project_id={chain_id} \
    -e hop1_resource_name={hop1_resource_name} -e hop2_resource_name={hop2_resource_name} -e wg_port={wg_port} -e clean={clean}"

    process = subprocess.Popen(
        command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
    )

    while True:
        line = process.stdout.readline()
        if not line:
            break
        rprint(line, end="")
    process.wait()

    provider1_ip, provider2_ip = get_ips(f"{project_path}/terraform.tfstate")

    return provider1_ip, provider2_ip


def create_receipt_file(
    project_path: str,
    provider1: str,
    provider2: str,
    provider1_ip: str,
    provider2_ip: str,
    chain_id: str,
):
    receipt = dict({})
    now = datetime.datetime.now()
    receipt["created"] = now.strftime("%Y-%m-%d %H:%M:%S")
    receipt["id"] = str(chain_id)
    
    receipt["provider1"] = provider1
    receipt["provider1_ip"] = provider1_ip
    if (provider1 == 'gcp' or provider1 == 'aws'):
        receipt["provider1_user"] = 'admin'
    else:
        receipt["provider1_user"] = 'root'

    receipt["provider2"] = provider2
    receipt["provider2_ip"] = provider2_ip
    if (provider2 == 'gcp' or provider2 == 'aws'):
        receipt["provider2_user"] = 'admin'
    else:
        receipt["provider2_user"] = 'root'

    json_data = json.dumps(receipt)

    with open(f"{project_path}/receipt.json", "w") as json_file:
        json_file.write(json_data)

    return json_data


def build(provider1, provider2, creds_file, clean):
# if __name__ == "__main__":
    script_path = os.path.dirname(os.path.abspath(__file__))
    base_path = "/tmp"

    project_path, chain_id = setup_terraform(
        script_path, creds_file, provider1, provider2, base_path
    )

    generate_keys(project_path)
    provider1_ip, provider2_ip = ansible_build(
        script_path, project_path, provider1, provider2, chain_id, clean
    )
    receipt_data = create_receipt_file(
        project_path, provider1, provider2, provider1_ip, provider2_ip, chain_id
    )
    logger.success(receipt_data)
