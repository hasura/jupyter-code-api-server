import GithubIcon from "./GithubIcon";
import HasuraLogo from "./HasuraLogo";

const REPO_LINK = "https://github.com/hasura/jupyter-code-api-server";

const openLink = (url) => {
  if (window && window.open) {
    window.open(url, "_blank").focus();
  }
};

function App() {
  return (
    <div className="w-screen h-screen bg-bg flex items-center justify-center">
      <div className="w-full h-[80%] max-h-full flex p-[72px] rounded-[24px] bg-white my-[130px] mx-[100px] shadow-md">
        <div className="w-full h-full flex flex-col">
          <HasuraLogo />
          <h2 className="font-inter mt-3 text-[32px] text-center mb-3">
            Jupyter Python Notebook & API server
          </h2>
          <div className="flex mt-4">
            <div className="flex flex-col w-1/2 items-center h-full">
              <span className="font-inter text-xl mb-3">
                Check out the github repo here
              </span>
              <Button variant="github">
                <span className="flex flex-row items-center justify-evenly px-4">
                  <GithubIcon />
                  hasura/jupyter-code-api-server
                </span>
              </Button>
            </div>
            <div className="flex flex-col w-1/2 items-center">
              <form action="/jupyter" target="_blank">
                <Button type="submit">Launch Notebook</Button>
              </form>

              <form action="/process/start" method="get" target="_blank">
                <Button type="submit">Start API</Button>
              </form>

              <form action="/process/restart" method="get" target="_blank">
                <Button type="submit">Restart API</Button>
              </form>

              <form action="/process/stop" method="get" target="_blank">
                <Button type="submit">Stop API</Button>
              </form>

              <form action="/invoke/hello_world" method="get" target="_blank">
                <Button type="submit">Test API</Button>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

function Button(props) {
  if (props.variant === "github") {
    return (
      <button
        className="bg-black text-white leading-8 font-inter font-semibold text-[14px] rounded-[100px] py-3 px-6"
        onClick={() => openLink(REPO_LINK)}
      >
        {props.children}
      </button>
    );
  }

  return (
    <button
      className="bg-[#3970FD] text-white leading-8 font-inter font-semibold text-[14px] rounded-[100px] py-3 px-6 w-72 my-2"
      {...props}
    >
      {props.children}
    </button>
  );
}

export default App;
