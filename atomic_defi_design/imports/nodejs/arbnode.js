const http = require("http");
const url = require('url');
const api = require('kucoin-node-api');

//const config = {
//  apiKey: '61f12ccca2de0c0001b8e19d',
//  secretKey: '1f99379e-f478-47f3-9edb-400f2fd7ad05',
//  passphrase: 'f99ac6kz4',
//  environment: 'live'
//}

const host = 'localhost';
const port = 8020;


const requestListener = function (req, res) {
    res.setHeader("Content-Type", "application/json");
    var queryObject = url.parse(req.url, true).query;
    var answr;
    switch(decodeURI(queryObject.kcreq)){
        case "init":
            const confgA = JSON.parse(decodeURI(queryObject.filvar));
            api.init(confgA);
            console.log("success init");
            answr = "initialized from node";
            res.writeHead(240);
            res.end(JSON.stringify(answr));
            break;
        case "initcheck":
            const confgB = JSON.parse(decodeURI(queryObject.filvar));
            api.init(confgB);
            console.log("success init");
            answr = "initialized from node";
            res.writeHead(241);
            res.end(JSON.stringify(answr));
            break;
        case "svrtime":
            api.getServerTime().then((r) => {
                console.log("success server time");
                console.log(r);
                answr = r;
                res.writeHead(242);
                res.end(JSON.stringify(answr));
                //res.end(JSON.stringify(r.data));
            }).catch((e) => {
                console.log(e.response.data.msg);
                res.writeHead(242);
                res.end(JSON.stringify(e.response.data.msg));
            });
            break;
        case "getacc":
            api.getAccounts().then((r) => {
                console.log("success got accounts");
                console.log(r);
                answr = r;
                res.writeHead(243);
                res.end(JSON.stringify(answr));
                //res.end(JSON.stringify(r.data));
            }).catch((e) => {
                console.log(e.response.data.msg);
                res.writeHead(243);
                res.end(JSON.stringify(e.response.data.msg));
            });
            break;
        case "checkacc":
            api.getAccounts().then((r) => {
                console.log("success checking accounts");
                console.log(r);
                answr = "1";
                res.writeHead(244);
                res.end(JSON.stringify(answr));
                //res.end(JSON.stringify(r.data));
            }).catch((e) => {
                console.log(e.response.data.msg);
                answr = "2";
                res.writeHead(244);
                res.end(JSON.stringify(answr));
            });
            break;
        default:
            console.log("default");
            answr = "Resource not found";
            res.writeHead(500);
            res.end(JSON.stringify(answr));
    }    
    //res.end(JSON.stringify(answr));
};

const server = http.createServer(requestListener);
server.listen(port, host, () => {
    console.log(`Server is running on http://${host}:${port}`);
});

    // console.log(decodeURI(queryObject.kcreq));
    // if(decodeURI(queryObject.kcreq) == "init"){
    //     api.init(config);
    //     console.log("success init");
    // }
    // api.getServerTime().then((r) => {
    //     console.log("success server time");
    //     console.log(r);
    // }).catch((e) => {
    //     res.writeHead(500);
    //     console.log(e);
    //     return;
    // });
