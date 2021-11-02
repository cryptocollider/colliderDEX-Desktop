import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtWebChannel 1.0
import QtWebEngine 1.7

import Qaterial 1.0 as Qaterial
//import "hprequest.js" as hprequest

import "../Components"
import "../Constants"
import "../Wallet"
import "../Exchange/Trade"

Item {
    id: autoPlay
    enabled: true
    visible: dashboard.current_page !== idx_dashboard_games ? false : General.inAuto ? true : false
    anchors.fill: parent

    property string tempTkr: "t"
    property real riskValue: 0.55
    property real rkValue: risk_slider.valueAt(risk_slider.position)
    property real setAmountValue: 50
    property real stValue: set_amount_slider.valueAt((set_amount_slider.position))
    property real localSetAmount: current_ticker_infos.fiat_amount
    property bool hasEnoughBalance: localSetAmount > 0.1 ? true : false


    function playAuto(){
        if(General.autoPlaying){
            General.autoPlaying = false
        }else{
            //check apCanThrow here
            if(General.apCanThrow){
                General.autoPlaying = true
//                webIndex.url = "qrc:///atomic_defi_design/qml/Games/testCom.html"
                General.apThrows = 0
                ap_timer.interval = (60 / (1.1 - parseFloat(autoPlay.rkValue)).toFixed(2)) * 1000
                ap_timer.restart()
            }else{
                apStatusLabel.text = "Waiting on previous throw!"
            }
        }
    }

    function setAutoTicker(tmpT){
        tempTkr = tmpT
        api_wallet_page.ticker = tempTkr
        dashboard.current_ticker = api_wallet_page.ticker
        General.apCurrentTicker = dashboard.current_ticker
        set_amount_slider.to = localSetAmount
        General.apHasSelected = true
        if(!hasEnoughBalance){
            apStatusLabel.text = "You don't have enough funds"
        }else{
            apStatusLabel.text = ""
        }
    }

    function autoThrow(){
        if(General.autoPlaying){
            if(hasEnoughBalance){
                //sendThrow()
                General.apThrows++
                General.apCanThrow = false
                apStatusLabel.text = "Throw(s): " + General.apThrows
                var tempIdText = General.apCurrentTicker
                someObject.getAutoAddress(tempIdText)
            }else{
                ap_timer.running = false
                General.apCanThrow = true
                apStatusLabel.text = "Out of funds! Throw(s) " + General.apThrows
            }
        }else{
            ap_timer.running = false
            General.apCanThrow = true
            apStatusLabel.text = "Finished! Throw(s): " + General.apThrows
        }
    }

    function canThrow(){
        //check to see if address for coin already exists
            //if not save an address to portfolio or local JSON
        //if can, call throw
    }

//    function sendThrow(){
//        someObject.getAutoAddress(General.apCurrentTicker)
//    }

    Timer {
        id: ap_timer
        repeat: true
        triggeredOnStart: true
        running: false
        onTriggered: autoThrow()
    }

    ColumnLayout{
        width: 400
        height: 590
        x: (parent.width * 0.5) - (width * 0.5) //half window - width
        y: (parent.height * 0.5) - (height * 0.5) //half window - height

        DexLabel{
            Layout.alignment: Qt.AlignCenter
            font: DexTypo.head6
            text: qsTr("Game Liquidity Mining")
        }

        DefaultText{
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: qsTr("Use these settings to mine Collider Coin (and diversify your assets) via automated Collider Arena Game Playing")
        }
        FloatingBackground{
            width: 340
            height: 510
            Layout.topMargin: 4
            Layout.alignment: Qt.AlignHCenter

            ColumnLayout{
                width: parent.width

                DexLabel{
                    Layout.alignment: Qt.AlignHCenter
                    height: 60
                    Layout.topMargin: 4
                    font: DexTypo.head6
                    text: qsTr("Choose Asset to Auto-Play")
                }
//                    TickerSelector {
//                        id: selector_ap
//                        Layout.alignment: Qt.AlignHCenter
//                        Layout.minimumHeight: 75
//                        Layout.maximumHeight: 80
//                        Layout.minimumWidth: 280
//                        Layout.topMargin: 4
//                        left_side: true
//                        ticker_list: API.app.trading_pg.market_pairs_mdl.left_selection_box
//                        ticker: atomic_app_primary_coin
////                        ticker: "CLC"
//                    }
                ComboBox {
                    enabled: General.autoPlaying ? false : true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.minimumHeight: 75
                    Layout.maximumHeight: 80
                    Layout.minimumWidth: 200
                    Layout.topMargin: 4
                    displayText: General.apHasSelected ? currentText : "Select a Coin"
                    model: ListModel {
                        id: ap_model
                        ListElement { text: "KMD"}
                        ListElement { text: "CLC"}
                        ListElement { text: "BTC"}
                        ListElement { text: "VRSC"}
                        ListElement { text: "CHIPS"}
                        ListElement { text: "DASH"}
                        ListElement { text: "DGB"}
                        ListElement { text: "DOGE"}
                        ListElement { text: "ETH"}
                        ListElement { text: "LTC"}
                        ListElement { text: "RVN"}
                    }
                    onActivated: {
                        setAutoTicker(currentText)
                    }
                }
                DexLabel{
                    Layout.alignment: Qt.AlignHCenter
                    height: 60
                    Layout.topMargin: 4
                    font: DexTypo.head6
                    text: qsTr("Set Play Risk Style")
                }
                DexSlider {
                    id: risk_slider
                    enabled: General.autoPlaying || !autoPlay.hasEnoughBalance || !General.apHasSelected ? false : true
                    Layout.alignment: Qt.AlignHCenter
                    from: 0.1
                    to: 1
                    live: true
                    value: autoPlay.riskValue
                }
                DexLabel{
                    Layout.alignment: Qt.AlignHCenter
                    height: 60
                    Layout.topMargin: 4
                    font: DexTypo.head6
                    text: qsTr("Set Amount to Play")
                }
                DefaultText{
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: parent.width
                    wrapMode: Text.WordWrap
                    text: qsTr("(% of balance)")
                }
                DexSlider {
                    id: set_amount_slider
                    enabled: General.autoPlaying || !autoPlay.hasEnoughBalance || !General.apHasSelected ? false : true
                    Layout.alignment: Qt.AlignHCenter
                    from: 0
                    to: 100
                    live: true
                    value: autoPlay.setAmountValue
                }
                RowLayout{
                    Layout.minimumWidth: parent.width
                    Layout.topMargin: 16

                    DexLabel{
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 20
                        height: 60
                        font: DexTypo.head6
                        text: qsTr("Min Balance:")
                    }
                    DexLabel{
                        id: min_balance_label
                        Layout.alignment: Qt.AlignRight
                        Layout.rightMargin: 20
                        height: 60
                        font: DexTypo.head6
                        text: qsTr("$" + parseFloat(autoPlay.stValue).toFixed(2))
//                            text: qsTr("$" + parseFloat(autoPlay.setAmountValue).toFixed(2))
                    }
                }
                RowLayout{
                    Layout.minimumWidth: parent.width

                    DexLabel{
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 20
                        height: 60
                        font: DexTypo.head6
                        text: qsTr("Throws Per Min:")
                    }
                    DexLabel{
                        Layout.alignment: Qt.AlignRight
                        Layout.rightMargin: 20
                        height: 60
                        font: DexTypo.head6
                        text: qsTr((1.1 - parseFloat(autoPlay.rkValue)).toFixed(2))
//                            text: qsTr((1.1 - parseFloat(autoPlay.riskValue)).toFixed(2))
                    }
                }
                RowLayout{
                    Layout.minimumWidth: parent.width

                    DexLabel{
                        Layout.alignment: Qt.AlignLeft
                        Layout.leftMargin: 20
                        height: 60
                        font: DexTypo.head6
                        text: qsTr("Throw Size:")
                    }
                    DexLabel{
                        id: throw_size_label
                        Layout.alignment: Qt.AlignRight
                        Layout.rightMargin: 20
                        height: 60
                        font: DexTypo.head6
                        text: qsTr((autoPlay.rkValue * parseFloat(autoPlay.stValue)).toFixed(2))
//                            text: qsTr((autoPlay.riskValue * parseFloat(autoPlay.setAmountValue)).toFixed(2))
                    }
                }
                DexButton{
                    id: apbutton
                    enabled: autoPlay.hasEnoughBalance && General.apHasSelected ? true : false
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 16
                    Layout.minimumWidth: 180
                    Layout.minimumHeight: 48
                    text: General.autoPlaying ? qsTr("Stop Auto-Play") : qsTr("Start Auto-Play")
                    onClicked: playAuto()
                }
                DefaultText{
                    id: apStatusLabel
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: parent.width
                    Layout.topMargin: 4
                    wrapMode: Text.WordWrap
                    leftPadding: 10
                    rightPadding: 10
                    text: ""
                }
            }
        }
        DefaultText{
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: ("ticker: " + dashboard.current_ticker + " balance: " + General.formatFiat("", current_ticker_infos.fiat_amount, API.app.settings_pg.current_currency))
//                text: qsTr("*Numbers are auto adjusted based on the risk slider")
        }
        DefaultText{
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: ("localSetAmount: " + autoPlay.localSetAmount + " hasEnoughBalance: " + autoPlay.hasEnoughBalance + " hasSelected: " + General.apHasSelected)
        }
        DefaultText{
            id: arena_response
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: ("autoAddressResponder " + dashboard.apAddress)
        }

//    function request(url, callback) {
//        var xhr = new XMLHttpRequest();
//        xhr.onreadystatechange = (function(myxhr) {
//            return function() {
//                if(myxhr.readyState === 4) { callback(myxhr); }
//            }
//        })(xhr);

//        xhr.open("GET", url);
//        xhr.send();
//    }

//            DexButton{
//                id: reqButton
//                enabled: true
//                Layout.alignment: Qt.AlignHCenter
//                Layout.topMargin: 16
//                Layout.minimumWidth: 180
//                Layout.minimumHeight: 48
//                text: qsTr("Send Request")
//                onClicked: {
//                    request("qrc:///atomic_defi_design/qml/Games/testReq.html", function (o) {
//                        if (o.status === 200)
//                        {
//                            var jsn = JSON.parse(o.responseText);
//                            for(var i in jsn)
//                            {
//                                reqLabel.text = i + ": " + jsn[i];
//                                otherReqLabel.text = o.responseText
//                            }
//                        }
//                        else
//                        {
//                            reqLabel.text = "Some error has occurred";
//                        }
//                    });
//                }
//            }
    }

//    WebEngineView {
//        id: reqIndex
//        width: 400
//        height: parent.height
//        x: parent.width - 400
//        enabled: General.inAuto ? true : false
//        visible: General.inAuto ? true : false
//        settings.pluginsEnabled: true
//        url: "qrc:///atomic_defi_design/qml/Games/testReq.html"
//    }
}
