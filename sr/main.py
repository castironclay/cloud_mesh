import importlib.metadata
from enum import Enum
from typing_extensions import Annotated
from typing import Optional
from pathlib import Path

import typer

from sr.build import build as add
from sr.destroy import destroy as remove

app = typer.Typer()

class Providers(str, Enum):
    gcp = "gcp"
    aws = "aws"
    digitalocean = "digitalocean"
    exoscale = "exoscale"
    linode = "linode"
    vultr = "vultr"

@app.callback()
def callback():
    """
    Split Rail.\n
    Build 2-hop chains of VPS'.\n
    """

@app.command()
def version():
    """
    Show version
    """
    _DISTRIBUTION_METADATA = importlib.metadata.metadata("sr")
    print(f"Version: {_DISTRIBUTION_METADATA['Version']}")


@app.command()
def build(
    provider1: Providers = typer.Option(help="Set provider1", prompt="Select provider1"),
    provider2: Providers = typer.Option(help="Set provider2", prompt="Select provider2"),
    keys: Annotated[Optional[Path], typer.Option(help="Keys file", prompt="Keys file")] = None,
    clean: bool = typer.Option(False, help="Leave VPS' unconfigured")
    ):
    """
    Build chain
    """
    if keys is None:
        print("No keys file specified")
        raise typer.Abort()
    elif keys.is_dir():
        print("Must specify single file")
        raise typer.Abort()
    elif not keys.exists():
        print("The file doesn't exist")
        raise typer.Abort()

    add(provider1, provider2, keys, clean)    


@app.command()
def destroy():
    """
    Destroy chain
    """
    remove()

if __name__ == "__main__":
    app()
