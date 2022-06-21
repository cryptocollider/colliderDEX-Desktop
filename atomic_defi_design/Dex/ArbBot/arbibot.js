function showRequestInfo(text) {
        msg.text = msg.text + "\n" + text
}

function kcInit(conf){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 240) {
                //bot_logic.qmResponse(doc.responseText);
            }
        }
    }
    var kcreq = encodeURIComponent('init');
    var filvar = encodeURIComponent(JSON.stringify(conf));
    var linkd = "http://localhost:8020/?kcreq=" + kcreq + "&filvar=" + filvar;
    doc.open("GET", linkd, true);
    doc.send();
}

function kcInitCheck(conf){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 241) {
                //bot_logic.qmResponse(doc.responseText);
                var tmp = kcCheckAccounts();
                return tmp;
            }
        }
    }
    var kcreq = encodeURIComponent('initcheck');
    var filvar = encodeURIComponent(JSON.stringify(conf));
    var linkd = "http://localhost:8020/?kcreq=" + kcreq + "&filvar=" + filvar;
    doc.open("GET", linkd, true);
    doc.send();
}

function kcServerTime(){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 242) {
                //bot_logic.qmResponse(doc.responseText);
            }
        }
    }
    var kcreq = encodeURIComponent('svrtime');
    var linkd = "http://localhost:8020/?kcreq=" + kcreq;
    doc.open("GET", linkd, true);
    doc.send();
}

function kcGetAccounts(){
    var doc = new XMLHttpRequest();
    doc.onreadystatechange = function() {
        if (doc.readyState == 4) {
            if (doc.status == 243) {
                //bot_logic.qmResponse(doc.responseText);
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
                //bot_logic.qmResponse(doc.responseText);
                return doc.responseText;
            }
        }
    }
    var kcreq = encodeURIComponent('checkacc');
    var linkd = "http://localhost:8020/?kcreq=" + kcreq;
    doc.open("GET", linkd, true);
    doc.send();
}
