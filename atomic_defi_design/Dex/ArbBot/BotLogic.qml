import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtQml.Models 2.15
import QtQml 2.2
import Qaterial 1.0 as Qaterial
//import "CreateArb.qml" as CrArb

import "../ArbBot"
import "../Components"
import "../Constants"
import "arbibot.js" as Arbibot


Item {
    id: bot_logic
    anchors.fill: parent
    property int apiCount: 0
    property bool inCreateBot: false
    property bool inBotStats: false
    property bool hasArbData: false
    property var arbData

    function qmResponse(tempReq){
        console.log(tempReq);
    }

    function countApi(){
        apiCount = 0;
        if(arbData.apiKucoin !== undefined){
            for (let e in arbData.apiKucoin) {  if (arbData.apiKucoin.hasOwnProperty(e)) apiCount++; }
        }
    }

    function createApi(propName, propApi, propPhrase, propSec){
        this[propName] = {
            name: propName,
            apiKey: propApi,
            passPhrase: propPhrase,
            secretKey: propSec
        }
    }

    function getArbData(){
        if(!hasArbData){
            arbData = API.qt_utilities.load_arbibot_data(app.currentWalletName)
            hasArbData = true
            countApi()
        }
    }

    function setArbData(){
        var arbJsonFilename = app.currentWalletName + ".arb.json"
        var overWright = true
        if(API.qt_utilities.save_arbibot_data(arbJsonFilename, arbData, overWright)){
        }else{
        }
        arbData = API.qt_utilities.load_arbibot_data(app.currentWalletName)
        countApi()
    }

    function checkUserApi(checkConf){
        var tmpInCh = Arbibot.kcInitCheck(checkConf);
        createArb.setUserApi(tmpInCh);
    }
}
