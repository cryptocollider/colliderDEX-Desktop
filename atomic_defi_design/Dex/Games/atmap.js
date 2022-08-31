function dexGetPk(usrpass, coin){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            var obResp = JSON.parse(doc.responseText);
            var respPk = obResp.result.priv_key;
            someObject.clcPrivKey = respPk;
        }
    }
    var linkd = "http://127.0.0.1:7783";
    var parOne = `{\"userpass\":\"`;
    var parTwo = `\",\"method\":\"show_priv_key\",\"coin\":\"`;
    var parThree = `\"}`;
    var params = parOne + usrpass + parTwo + coin + parThree;
    doc.open("POST", linkd, true);
    doc.send(params);
}

function dexGetCoins(usrpass){ //Gets all enabled coins
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            var obRespTwo = JSON.parse(doc.responseText);
            for (let i = 0; i < obRespTwo.result.length; i++) {
                if(obRespTwo.result[i].ticker == "KMD"){
                    autoHedge.usrKeyJsonData = obRespTwo.result[i].address;
                }
            }
        }
    }
    var linkd = "http://127.0.0.1:7783";
    var parOne = `{\"userpass\":\"`;
    var parTwo = `\",\"method\":\"get_enabled_coins\"}`;
    var params = parOne + usrpass + parTwo;
    doc.open("POST", linkd, true);
    doc.send(params);
}
