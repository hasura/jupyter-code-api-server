# Configuration file for jupyter-notebook.

c = get_config()  #noqa

## The base URL for the notebook server.
#  
#                                 Leading and trailing slashes can be omitted,
#                                 and will automatically be added.
#  Default: '/'
c.NotebookApp.base_url = 'jupyter'

## Set the Access-Control-Allow-Origin header
#  
#          Use '*' to allow any origin to access your server.
#  
#          Takes precedence over allow_origin_pat.
#  Default: ''
c.NotebookApp.allow_origin = '*'

## The IP address the notebook server will listen on.
#  Default: 'localhost'
c.NotebookApp.ip = '0.0.0.0'

## The port the notebook server will listen on (env: JUPYTER_PORT).
#  Default: 8888
c.NotebookApp.port = 7070

## Hashed password to use for web authentication.
#  
#                        To generate, type in a python/IPython shell:
#  
#                          from notebook.auth import passwd; passwd()
#  
#                        The string should be of the form type:salt:hashed-
#  password.
#  Default: ''
c.NotebookApp.password = u'argon2:$argon2id$v=19$m=10240,t=10,p=8$7hFu6c8KN4tlHCRMqL8+WA$r+GLGgcJiF7xLmg0Oj8WZ2fKoU6oQoBM+MuCHHuHOcs'

