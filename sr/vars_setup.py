import os
from uuid import UUID

from jinja2 import Environment, FileSystemLoader

environment = Environment(
    loader=FileSystemLoader(f"{os.path.dirname(os.path.abspath(__file__))}/templates/")
)


def generate_vars_file(
    creds: dict, provider1: str, provider2: str, base_path: str, chain_id: UUID
) -> None:
    """
    Build the vars.tf file for the project by rendering and combining the variables for both providers.
    Dedup to ensure we aren't writing the same variable names twice and causing a Terraform error.
    """
    if provider1 == provider2:
        # Both values are the same, only execute the function once
        content = globals()[provider1](creds)

        with open(
            f"{base_path}/{chain_id}/vars.tf", mode="w", encoding="utf-8"
        ) as message:
            message.write(content)

    else:
        with open(
            f"{base_path}/{chain_id}/vars.tf", mode="w", encoding="utf-8"
        ) as message:
            content = globals()[provider1](creds)
            message.write(content)
            message.write("\n")

            content = globals()[provider2](creds)
            message.write(content)
            message.write("\n")


def aws(creds: dict) -> str:
    aws_creds = creds.get("aws")

    if aws_creds is None:
        raise ValueError("AWS credentials not found in creds dictionary")

    access_key = aws_creds.get("access_key")
    secret_key = aws_creds.get("secret_key")

    if access_key is None or secret_key is None:
        raise ValueError("AWS access key or secret key not found in creds dictionary")

    template = environment.get_template("aws_vars.tf")

    content = template.render(AWS_ACCESS_KEY=access_key, AWS_SECRET_KEY=secret_key)

    return content


def digitalocean(creds: dict) -> str:
    do_creds = creds.get("digitalocean")

    if do_creds is None:
        raise ValueError("Digitalocean credentials not found in creds dictionary")

    do_key = do_creds.get("key")

    if do_key is None:
        raise ValueError("Digitalocean key not found in creds dictionary")

    template = environment.get_template("digitalocean_vars.tf")

    content = template.render(
        DO_TOKEN=do_key,
    )

    return content


def linode(creds: dict) -> str:
    template = environment.get_template("linode_vars.tf")
    key = creds.get("linode").get("key")

    content = template.render(
        LINODE_TOKEN=key,
    )

    return content


def gcp(creds: dict) -> str:
    template = environment.get_template("gcp_vars.tf")
    creds_file = creds.get("gcp").get("creds_file")
    project_id = creds.get("gcp").get("project_id")

    content = template.render(
        GCP_CREDS=creds_file,
        GCP_PROJECT=project_id,
    )

    return content


def vultr(creds: dict) -> str:
    template = environment.get_template("vultr_vars.tf")
    key = creds.get("vultr").get("key")

    content = template.render(
        VULTR_TOKEN=key,
    )

    return content


def exoscale(creds: dict) -> str:
    template = environment.get_template("exoscale_vars.tf")
    access_key = creds.get("exoscale").get("access_key")
    secret_key = creds.get("exoscale").get("secret_key")

    content = template.render(
        EXOSCALE_ACCESS=access_key,
        EXOSCALE_SECRET=secret_key,
    )

    return content
