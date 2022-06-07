//function showRequestInfo(text) {
//        msg.text = msg.text + "\n" + text
//}

//function kcInit(){
//    var doc = new XMLHttpRequest();
//    doc.onreadystatechange = function() {
//        if (doc.readyState == 4) {
//            if (doc.status == 240) {
//                //console.log("init response");
//                qmain.qmResponse(doc.responseText);
//            }
//        }
//    }
//    var kcreq = encodeURIComponent('init');
//    var filvar = encodeURIComponent('203.12');
//    var linkd = "http://localhost:8020/?kcreq=" + kcreq + "&filvar=" + filvar;
//    doc.open("GET", linkd, true);
//    doc.send();
//}


//function kcServerTime(){
//    var doc = new XMLHttpRequest();
//    doc.onreadystatechange = function() {
//        if (doc.readyState == 4) {
//            if (doc.status == 241) {
//                var svtemp = JSON.parse(doc.responseText);
//                console.log(svtemp.data);
//                //qmain.qmResponse(JSON.stringify(doc.responseText));
//            }
//        }
//    }
//    var kcreq = encodeURIComponent('svrtime');
//    var linkd = "http://localhost:8020/?kcreq=" + kcreq;
//    //var linkd = "http://localhost:8020/?tickr=" + tickr + "&amnt=" + amnt;
//    doc.open("GET", linkd, true);
//    doc.send();
//}
