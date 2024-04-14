import os

from python_on_whales import docker

script_path = os.path.dirname(os.path.abspath(__file__))
docker.run(
    "cloud_mesh:latest",
    ["/bin/bash"],
    volumes=[
        (script_path, "/work/cloud_mesh"),
        ("/tmp/", "/tmp/"),
    ],
    interactive=True,
    tty=True,
    remove=True,
)
