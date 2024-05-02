import json


def get_ips(state_path: str) -> tuple:
    f = open(state_path)
    data = json.load(f)
    hop1_ip = data["outputs"]["hop1_public_ip"]["value"]
    hop2_ip = data["outputs"]["hop2_public_ip"]["value"]
    f.close()

    return hop1_ip, hop2_ip
