import os
import subprocess

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


if __name__ == "__main__":
    creds_file = "keys.yaml"
    providers = "providers.yaml"
    creds = read_creds_file(creds_file)
    providers = gather_providers(providers)

    for provider in providers:
        if provider in creds.keys():
            print(provider)
