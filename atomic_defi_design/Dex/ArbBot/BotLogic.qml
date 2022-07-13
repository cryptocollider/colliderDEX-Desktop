import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtQml.Models 2.1
import QtQml 2.2
import Qaterial 1.0 as Qaterial

import "../ArbBot"
import "../Components"
import "../Constants"
import "../Screens"
import "arbibot.js" as Arbibot


Item {
    id: bot_logic
    anchors.fill: parent
    property int apiCount: 0
    property bool inArbBot: dashboard.currentPage === Dashboard.PageType.Arbibot ? true : false
    property bool inViewBot: true
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
        };
    }

    function createCoinObj(propType, propTick, propMin, propCur){
        this[propType] = {
            ticker: propTick,
            min: propMin,
            current: propCur
        };
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
}
