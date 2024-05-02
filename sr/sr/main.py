import typer
from sr.build import build as add
from sr.destroy import destroy as remove

app = typer.Typer()

@app.command()
def build():
    add()    


@app.command()
def destroy():
    remove()

if __name__ == "__main__":
    app()
