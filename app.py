import os
from flask import Flask
from datetime import datetime
import subprocess

app = Flask(__name__)

process = None

@app.route('/start')
def start():
    global process
    process = subprocess.Popen(["jupyter", "kernelgateway", "--api='kernel_gateway.notebook_http'", "--seed_uri='/mnt/gcs/notebook/server.ipynb'", "--port", "9090"])
    return str(process.pid)

@app.route('/restart')
def restart():
    global process
    process.kill()
    process = subprocess.Popen(["jupyter", "kernelgateway", "--api='kernel_gateway.notebook_http'", "--seed_uri='/mnt/gcs/notebook/server.ipynb'", "--port", "9090"])
    return str(process.pid)

@app.route('/stop')
def stop():
    global process
    process.kill()
    return str(process.pid)

@app.route('/')
def hello_world():
    return 'Hello from the server, the time is {}'.format(datetime.now())

@app.route('/test')
def hello_world_test():
    return 'Hello test from the server, the time is {}'.format(datetime.now())

if __name__ == "__main__":
    app.run(debug=True,host='0.0.0.0',port=6060)


# jupyter kernelgateway --api='kernel_gateway.notebook_http' --seed_uri='/notebook/server.ipynb' --port 9090
