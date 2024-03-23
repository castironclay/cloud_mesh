import os

from sshkey_tools.keys import RsaPrivateKey


def generate_keys(project_path: str) -> None:
    # Generate RSA (default is 4096 bits)
    ## Key1
    rsa_priv = RsaPrivateKey.generate()
    rsa_priv.to_file(f"{project_path}/id_ssh_rsa1")
    rsa_priv.public_key.to_file(f"{project_path}/id_ssh_rsa1.pub")
    os.chmod(f"{project_path}/id_ssh_rsa1", 0o600)

    ## Key2
    rsa_priv = RsaPrivateKey.generate()
    rsa_priv.to_file(f"{project_path}/id_ssh_rsa2")
    rsa_priv.public_key.to_file(f"{project_path}/id_ssh_rsa2.pub")
    os.chmod(f"{project_path}/id_ssh_rsa2", 0o600)
