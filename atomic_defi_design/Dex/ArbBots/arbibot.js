function showRequestInfo(text) {
        msg.text = msg.text + "\n" + text
}

function kcInit(){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 240) {
                bot_logic.qmResponse(doc.responseText);
            }
        }
    }
    var kcreq = encodeURIComponent('init');
    var filvar = encodeURIComponent('203.12');
    var linkd = "http://localhost:8020/?kcreq=" + kcreq + "&filvar=" + filvar;
    doc.open("GET", linkd, true);
    doc.send();
}

function kcInitCheck(){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 241) {
                kcCheckAccounts();
            }
        }
    }
    var kcreq = encodeURIComponent('initcheck');
    var linkd = "http://localhost:8020/?kcreq=" + kcreq;
    doc.open("GET", linkd, true);
    doc.send();
}

function kcServerTime(){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 242) {
                bot_logic.qmResponse(doc.responseText);
            }
        }
    }
    var kcreq = encodeURIComponent('svrtime');
    var linkd = "http://localhost:8020/?kcreq=" + kcreq;
    //var linkd = "http://localhost:8020/?tickr=" + tickr + "&amnt=" + amnt;
    doc.open("GET", linkd, true);
    doc.send();
}

function kcGetAccounts(){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 243) {
                bot_logic.qmResponse(doc.responseText);
            }
        }
    }
    var kcreq = encodeURIComponent('getacc');
    var linkd = "http://localhost:8020/?kcreq=" + kcreq;
    doc.open("GET", linkd, true);
    doc.send();
}

function kcCheckAccounts(){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 244) {
                bot_logic.qmResponse(doc.responseText);
            }
        }
    }
    var kcreq = encodeURIComponent('checkacc');
    var linkd = "http://localhost:8020/?kcreq=" + kcreq;
    doc.open("GET", linkd, true);
    doc.send();
}
