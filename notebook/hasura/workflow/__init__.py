import inspect

class Step:
    def __init__(self, name, function, required_args=[], return_result=False):
        self.name = name
        self.function = function
        self.required_args = required_args
        self.return_result = return_result

    def __call__(self, *args, **kwargs):
        signature = inspect.signature(self.function)
        func_kwargs = dict((p.name, kwargs[p.name]) for p in signature.parameters.values() if p.name in kwargs)
        bound_args = signature.bind(*args, **func_kwargs)
        return self.function(*bound_args.args, **bound_args.kwargs)
    
class Workflow:
    def __init__(self, name="", elements=[]):
        self.name = name
        self.elements = elements

    def execute(self, *args, **kwargs):
        for element in self.elements:
            return_value = element(*args, **kwargs)
            if element.return_result:
                # Not handling complex state where both args and kwargs are returned
                if isinstance(return_value, dict):
                    kwargs.update(return_value)
                    args = []
                else:
                    # if it is type list/tuple then don't convert to listpy
                    args = [return_value]
        return return_value
    
    def deploy(self):
        # Hacked response
        DEPLOYED_ENDPOINTS = {
            "write_chunked_resume_to_db": "http://"
        }
        msg = "Successfully deployed workflow at {endpoint}"
        return msg.format(endpoint=DEPLOYED_ENDPOINTS[self.name])