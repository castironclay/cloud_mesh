import random

import boto3


def list_aws_instances(region: str, creds) -> list:
    # Create an EC2 client for the specified region
    ec2 = boto3.client(
        "ec2",
        region_name=region,
        aws_access_key_id=creds.get("aws").get("access_key"),
        aws_secret_access_key=creds.get("aws").get("secret_key"),
    )

    # Retrieve all running instances
    response = ec2.describe_instances()

    # Extract instance details
    instances = []
    for reservation in response["Reservations"]:
        for instance in reservation["Instances"]:
            instances.append(instance["InstanceId"])

    return instances


# List of AWS regions in the US and EU
regions = [
    "us-east-1",
    "us-west-1",
    "us-west-2",
    "eu-north-1",
    "eu-west-1",
    "eu-west-2",
    "eu-west-3",
]


def check_aws(creds: dict) -> str:
    valid_region = ""
    random.shuffle(regions)
    for region in regions:
        instances = list_aws_instances(region, creds)

        if len(instances) > 0:
            continue

        else:
            valid_region = region
            break

    return valid_region
