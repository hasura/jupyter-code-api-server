# jupyter-code-api-server

A container with Jupyter and Jupyter Kernal Gateway to write python code and expose it as an HTTP API.

```sh
# build the container
docker build -t jupyter-code-api-server

# run the container
docked run -p 5000:8080 jupyter-code-api-server 
```

or deploy to Hasura:

```sh
hasura connector create --github-repo-url https://github.com/hasura/jupyter-code-api-server/tree/main
```

Head to `http(s)://<hostname>/jupyter` for Jupyter notebook, get the token from container log output.

The container has `server.ipynb` packaged, which exposes a `/hello_world` endpoint. 

Use Jupyter notebook to browse the code. Hit `http(s)://<hostname>/start` to start the server and then hit `http(s)://<hostname>/invoke/hello_world` to invoke the API.

More details on how to write APIs using Jupyter can be found here: https://jupyter-kernel-gateway.readthedocs.io/en/latest/http-mode.html

### APIs exposed

- `/jupyter`: Jupyter notebook
- `/invoke/<path>` APIs exposed by Jupyter Kernel Gateway at `<path>`
- `/start`: start Jupyter Kernel Gateway
- `/restart`: restart Jupyter Kernel Gateway
- `/stop`: stop Jupyter Kernel Gateway

---

Container packaging inspired by: http://ahmet.im/blog/cloud-run-multiple-processes-easy-way.
