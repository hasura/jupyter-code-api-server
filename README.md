# jupyter-code-api-server

A container with Jupyter and Jupyter Kernal Gateway to write python code and expose it as an HTTP API.

```sh
# build the container
docker build . -t jupyter-code-api-server

# run the container
docker run -p 5000:8080 jupyter-code-api-server 
```

or deploy to Hasura:

```sh
hasura connector create jupyter --github-repo-url https://github.com/hasura/jupyter-code-api-server/tree/main
```

### Authentication

HTTP Basic authentication is configured by default.
Username is `hasura` and password is `hasurajupyter`.

To override the password, create a file `config.json` with the following content:
```json
{
  "password": "newpassword"
}
```
And then deploy the with
```
hasura connector create jupyter --github-repo-url https://github.com/hasura/jupyter-code-api-server/tree/main -c config.json
```

### Usage

Visit the deployed app in a browser. Enter authentication credentials and a page with basic instructions will be shown.

Head to `http(s)://<hostname>/jupyter` for Jupyter notebook, password is `hasurajupyter`.

The container has `server.ipynb` packaged, which exposes a `/hello_world` endpoint. 

Use Jupyter notebook to browse the code. Hit `http(s)://<hostname>/process/start` to start the server and then hit `http(s)://<hostname>/invoke/hello_world` to invoke the API.

More details on how to write APIs using Jupyter can be found here: https://jupyter-kernel-gateway.readthedocs.io/en/latest/http-mode.html

### APIs exposed

- `/jupyter`: Jupyter notebook
- `/invoke/<path>` APIs exposed by Jupyter Kernel Gateway at `<path>`
- `/process/start`: start Jupyter Kernel Gateway
- `/process/restart`: restart Jupyter Kernel Gateway
- `/process/stop`: stop Jupyter Kernel Gateway

---

Container packaging inspired by: http://ahmet.im/blog/cloud-run-multiple-processes-easy-way.
