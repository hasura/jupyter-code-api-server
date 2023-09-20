const { createProxyMiddleware } = require("http-proxy-middleware");
module.exports = function (app) {
  app.use(
    "/process",
    createProxyMiddleware({
      target: "http://localhost:5000/process",
      changeOrigin: true,
      logger: console,
      logLevel: "debug",
      prependPath: false,
    })
  );
  app.use(
    "/invoke",
    createProxyMiddleware({
      target: "http://localhost:5000/invoke",
      changeOrigin: true,
      logger: console,
      logLevel: "debug",
      prependPath: false,
    })
  );
};
