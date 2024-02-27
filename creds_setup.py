import os

from jinja2 import Environment, FileSystemLoader

environment = Environment(
    loader=FileSystemLoader(f"{os.path.dirname(os.path.abspath(__file__))}/templates/")
)


def generate_vars_file(
    creds: dict, providers: list, base_path: str, chain_id: str
) -> None:
    """
    Build the vars.tf file for the project by rendering and combining
    the variables for both providers.
    """
    with open(f"{base_path}/{chain_id}/vars.tf", mode="w", encoding="utf-8") as message:
        for index, provider in enumerate(providers):
            index += 1
            # Execute function based on value of 'provider' in loop
            content = globals()[provider](creds)
            message.write(content)
            message.write("\n")


def azure(creds: dict) -> str:
    template = environment.get_template("azure_vars.tf")
    app_client_id = creds.get("azure").get("app_client_id")
    tenant = creds.get("azure").get("tenant")
    secret = creds.get("azure").get("secret")
    sub_id = creds.get("azure").get("sub_id")

    content = template.render(
        AZURE_APP_CLIENT_ID=app_client_id,
        AZURE_TENANT_ID=tenant,
        AZURE_SECRET=secret,
        AZURE_SUB_ID=sub_id,
    )

    return content


def aws(creds: dict) -> str:
    template = environment.get_template("aws_vars.tf")
    access_key = creds.get("aws").get("access_key")
    secret_key = creds.get("aws").get("secret_key")

    content = template.render(
        AWS_ACCESS_KEY=access_key,
        AWS_SECRET_KEY=secret_key,
    )

    return content


def linode(creds: dict) -> str:
    template = environment.get_template("linode_vars.tf")
    key = creds.get("linode").get("key")

    content = template.render(
        LINODE_TOKEN=key,
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
