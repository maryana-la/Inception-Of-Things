const http = require('http');
const port = 8888;
const version = process.env.APP_VERSION || "v1";

const requestHandler = (req, res) => {
    res.end(`Hello, this is version ${version}`);
}

const server = http.createServer(requestHandler);
server.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
