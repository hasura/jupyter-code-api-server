import React, { useEffect, useState } from "react";
import GithubIcon from "./GithubIcon";
import HasuraLogo from "./HasuraLogo";
import { toast } from "react-toastify";
import Dropdown from "./Dropdown";

const REPO_LINK = "https://github.com/hasura/jupyter-code-api-server";

const request = (path) => {
  return fetch(makeUrl(path)).then((data) => data.json());
};

const openLink = (url) => {
  if (window && window.open) {
    window.open(url, "_blank").focus();
  }
};

const PATHS = {
  process: {
    start: "/process/start",
    restart: "/process/restart",
    stop: "/process/stop",
    getCurrentNb: "/process/get_current_nb",
    listNotebooks: "/process/list_notebooks",
  },
  invoke: {
    hello_world: "/invoke/hello_world",
  },
};

const makeUrl = (path) => {
  return `${window.location.protocol}//${window.location.host}${path}`;
};

function App() {
  const [currentServingNb, setCurrentServingNb] = useState("None");
  const [selectedNb, setSelectedNb] = useState("");
  const [allNotebooks, setAllNotebooks] = useState({});
  const getCurrentServingNb = () => {
    const res = request(PATHS.process.getCurrentNb);
    res.then((data) => {
      setCurrentServingNb(data.message);
      if (data.message !== "None") {
        setSelectedNb(data.message);
      }
    });
  };

  const listNotebooks = () => {
    const res = request(PATHS.process.listNotebooks);
    res.then((data) => {
      setAllNotebooks(data.files);
    });
  };

  useEffect(() => {
    getCurrentServingNb();
    listNotebooks();
  }, []);

  const onClickStartButton = () => {
    if (!selectedNb) {
      toast.error("Select a notebook to serve");
      return;
    }
    const res = request(PATHS.process.start + `?seed=${selectedNb}`);
    toast.promise(res, {
      success: {
        render({ data }) {
          getCurrentServingNb();
          return `${data.message}`;
        },
      },
      error: "Failed",
    });
  };

  const onClickRestartButton = () => {
    if (!selectedNb) {
      toast.error("Select a notebook to re-start");
      return;
    }
    const res = request(PATHS.process.restart + `?seed=${selectedNb}`);
    toast.promise(res, {
      success: {
        render({ data }) {
          getCurrentServingNb();
          return `${data.message}`;
        },
      },
      error: "Failed",
    });
  };

  const onClickStopButton = () => {
    if (currentServingNb === "None") {
      toast.error("No notebook server is running to Stop");
      return;
    }
    const res = request(PATHS.process.stop);
    toast.promise(res, {
      success: {
        render({ data }) {
          getCurrentServingNb();
          return `${data.message}`;
        },
      },
      error: "Failed",
    });
  };

  const onClickTestApiButton = () => {
    if (currentServingNb === "None") {
      toast.error("No notebook server is running to test");
      return;
    }
    const res = request(PATHS.invoke.hello_world);
    toast.promise(res, {
      success: {
        render({ data }) {
          getCurrentServingNb();
          return "Response -> " + JSON.stringify(data);
        },
      },
      error: "Test Failed",
    });
  };

  const selectNotebook = (item) => {
    setSelectedNb(item);
  };

  return (
    <div className="w-screen h-screen bg-bg flex items-center justify-center">
      <div className="w-full h-[80%] max-h-full flex p-[72px] rounded-[24px] bg-white my-[130px] mx-[100px] shadow-md overflow-y-auto overflow-x-auto">
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
            <div className="flex flex-col w-1/2 items-left">
              <form action="/jupyter" target="_blank">
                <Button type="submit">Launch Notebook</Button>
              </form>
              <Dropdown
                items={allNotebooks}
                onItemClick={selectNotebook}
                alreadySelectedItem={selectedNb}
              />
              <Button onClick={onClickStartButton}>Start API</Button>

              <Button onClick={onClickRestartButton}>Restart API</Button>
              <Button onClick={onClickStopButton}>Stop API</Button>
              <Button onClick={onClickTestApiButton}>Test API</Button>
              <span className="font-inter text-xl mb-3">
                Currently Serving: {currentServingNb}
              </span>
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
