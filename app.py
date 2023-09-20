import subprocess

from flask import Flask, json, request
from datetime import datetime
from werkzeug.exceptions import HTTPException
import os

app = Flask(__name__)


class JupyterCodeAPIServer:
    def __init__(self):
        self.__process = None
        self.__seed = "/mnt/gcs/notebook/server.ipynb"

    def __str__(self) -> str:
        current_pid = (
            "No process running currenly"
            if self.__process is None
            else self.__process.pid
        )
        return f"current process_id: {current_pid}"

    def __repr__(self) -> str:
        current_pid = "None" if self.__process is None else self.__process.pid
        return f"JupyterCodeAPIServer({current_pid})"

    def get_ipynb_files(self):
        notebooks = {}
        for root, dirs, files in os.walk("/mnt/gcs/notebook"):
            for file in files:
                if file.endswith(".ipynb") and root.find(".ipynb_checkpoints") == -1:
                    notebooks[file] = os.path.join(root, file)

        return {"files": notebooks}

    def start_handler(self, seed):
        if self.__process is not None:
            return {
                "message": f"API server is already running and serving {self.__seed}"
            }
        seed_file = seed or self.__seed
        self.__process = subprocess.Popen(
            [
                "jupyter",
                "kernelgateway",
                "--api='kernel_gateway.notebook_http'",
                f"--seed_uri='{seed_file}'",
                "--port",
                "9090",
            ]
        )
        self.__seed = seed_file

        return {"message": f"API server started and now serving {seed_file}"}

    def restart_handler(self):
        if self.__process is None:
            return self.start_handler(self.__seed)

        self.__process.kill()
        self.__process = None

        self.start_handler(self.__seed)
        return {"message": f"API server restarted and serving {self.__seed}"}

    def stop_handler(self):
        if self.__process is None:
            return {"message": "API server is already stopped"}

        pid = self.__process.pid

        self.__process.kill()
        self.__process = None
        self.__seed = "/mnt/gcs/notebook/server.ipynb"

        return {"message": f"API server stopped"}


jcas = JupyterCodeAPIServer()


@app.route("/start")
def start():
    seed_uri = request.args.get("seed")
    return jcas.start_handler(seed_uri)


@app.route("/restart")
def restart():
    return jcas.restart_handler()


@app.route("/stop")
def stop():
    return jcas.stop_handler()


@app.route("/list_notebooks")
def list_notebooks():
    return jcas.get_ipynb_files()


@app.route("/")
def hello_world():
    return "Hello from the server, the time is {}".format(datetime.now())


@app.route("/test")
def hello_world_test():
    return "Hello test from the server, the time is {}".format(datetime.now())


# Generic exception handler
@app.errorhandler(Exception)
def handle_exception(e):
    if isinstance(e, HTTPException):
        response = e.get_response()
        response.data = json.dumps(
            {
                "code": e.code,
                "name": e.name,
                "description": e.description,
            }
        )
        response.content_type = "application/json"
        return response

    return {"error": f"{e}", "message": "unexpected failure occurred"}


if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=6060)

# jupyter kernelgateway --api='kernel_gateway.notebook_http' --seed_uri='/notebook/server.ipynb' --port 9090
