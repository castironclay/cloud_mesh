#!/usr/bin/python3
import os
import shutil
import subprocess
import uuid

from rich import print as rprint


def list_folders(base_path: str):
    uuid_folders = [
        folder
        for folder in os.listdir(base_path)
        if os.path.isdir(os.path.join(base_path, folder)) and is_valid_uuid(folder)
    ]
    return uuid_folders


def is_valid_uuid(folder_name):
    try:
        uuid.UUID(folder_name)
        return True
    except ValueError:
        return False


def select_folder_from_list(folders):
    for i, folder in enumerate(folders, 1):
        print(f"{i}. {folder}")
    choice = input("Select a deployment: ")
    try:
        choice = int(choice)
        if 1 <= choice <= len(folders):
            return folders[choice - 1]
        else:
            print("Invalid choice. Please enter a number within the range.")
            return select_folder_from_list(folders)
    except ValueError:
        print("Invalid choice. Please enter a valid number.")
        return select_folder_from_list(folders)


def ansible_destroy(script_path: str, project_path: str):
    command = f"ansible-playbook {script_path}/ansible/destroy.yml -e project_path={project_path}"

    process = subprocess.Popen(
        command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True
    )
    print(command)

    while True:
        line = process.stdout.readline()
        if not line:
            break
        rprint(line, end="")
    process.wait()


if __name__ == "__main__":
    script_path = os.path.dirname(os.path.abspath(__file__))
    base_path = "/tmp"
    uuid_folders = list_folders(base_path)
    selected_folder = ""
    if not uuid_folders:
        print(f"No deployments found in {base_path}")
    else:
        selected_folder = select_folder_from_list(uuid_folders)
        print(f"You selected: {selected_folder}")
    project_path = f"{base_path}/{selected_folder}"
    ansible_destroy(script_path, project_path)
    shutil.rmtree(project_path)
