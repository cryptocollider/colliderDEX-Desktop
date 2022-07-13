//JS script for CreateArb.qml (create bot screen)

function kcCbotInit(conf){ //initialize API for the create bot
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 241) {
                kcCbotCheckAcc();
            }
        }
    }
    var kcreq = encodeURIComponent('initcheck');
    var filvar = encodeURIComponent(JSON.stringify(conf));
    var linkd = "http://localhost:8020/?kcreq=" + kcreq + "&filvar=" + filvar;
    doc.open("GET", linkd, true);
    doc.send();
}

function kcCbotCheckAcc(){ //checks API for the create bot - to see if it exists
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 244) {
                create_arb.setUserApi(doc.responseText);
            }
        }
    }
    var kcreq = encodeURIComponent('checkacc');
    var linkd = "http://localhost:8020/?kcreq=" + kcreq;
    doc.open("GET", linkd, true);
    doc.send();
}

function adOrderBook(usrpass){ //checks API for the create bot - to see if it exists
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            create_arb.setDbugTxt(doc.responseText);
        }
    }
    var linkd = "http://127.0.0.1:7783"
    var params = 'userpass=' + usrpass + '&method=orderbook&base=KMD&rel=BTC';
    doc.open("POST", linkd, true);
    doc.send(params);
}
