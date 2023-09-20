import subprocess

from flask import Flask, json
from datetime import datetime
from werkzeug.exceptions import HTTPException

app = Flask(__name__)


class JupyterCodeAPIServer:
    def __init__(self):
        self.__process = None

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

    def start_handler(self):
        if self.__process is not None:
            return {"message": f"API server is already running"}

        self.__process = subprocess.Popen(
            [
                "jupyter",
                "kernelgateway",
                "--api='kernel_gateway.notebook_http'",
                "--seed_uri='/mnt/gcs/notebook/server.ipynb'",
                "--port",
                "9090",
            ]
        )

        return {"message": "API server started"}

    def restart_handler(self):
        if self.__process is None:
            return self.start_handler()

        self.__process.kill()
        self.__process = None

        self.start_handler()
        return {"message": f"API server restarted"}

    def stop_handler(self):
        if self.__process is None:
            return {"message": "API server is already stopped"}

        pid = self.__process.pid

        self.__process.kill()
        self.__process = None

        return {"message": f"API server stopped"}


jcas = JupyterCodeAPIServer()


@app.route("/start")
def start():
    return jcas.start_handler()


@app.route("/restart")
def restart():
    return jcas.restart_handler()


@app.route("/stop")
def stop():
    return jcas.stop_handler()


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
