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
import App 1.0


Item {
    id: autoPlay
    enabled: true
    visible: dashboard.current_page !== idx_dashboard_games ? false : General.inAuto ? true : false
    anchors.fill: parent

    property string broadcast_resul_ap: api_wallet_page.broadcast_rpc_data
    property string tempTkr: "t"
    property string tempGrabTkr: "t"
    property string staticMinBalanceText: ""
    property string staticThrowSizeText: ""
//    property string kmdAddy: RRBbUHjMaAg2tmWVj8k5fR2Z99uZchdUi4
    property real staticMinBalanceValue: 1
    property real staticThrowSizeValue: 1
    property real riskValue: 0.55
    property real rkValue: risk_slider.valueAt(risk_slider.position)
    property real setAmountValue: 50
    property real stValue: set_amount_slider.valueAt((set_amount_slider.position))
    property real localSetAmount: current_ticker_infos.balance
    property real currentFiatValue: General.apHasSelected ? ((1 / set_amount_slider.to) * set_amount_slider.value) * current_ticker_infos.fiat_amount : 50
    property bool hasEnoughBalance: localSetAmount > staticMinBalanceValue ? true : false

    function playAuto(){
        if(General.autoPlaying){
            General.autoPlaying = false
        }else{
            //check apCanThrow here
            if(General.apCanThrow){
                General.autoPlaying = true
//                webIndex.url = "qrc:///atomic_defi_design/qml/Games/testCom.html"
                General.apThrows = 0
                staticMinBalanceText = parseFloat(autoPlay.stValue).toFixed(2) + " ($" + currentFiatValue.toFixed(2) + ")"
                staticMinBalanceValue = parseFloat(autoPlay.stValue).toFixed(2)
                staticThrowSizeText = (autoPlay.rkValue * parseFloat(autoPlay.stValue)).toFixed(2) + " ($" + (autoPlay.rkValue * currentFiatValue).toFixed(2) + ")"
                staticThrowSizeValue = (autoPlay.rkValue * parseFloat(autoPlay.stValue)).toFixed(2)
                ap_timer.interval = (60 / (1.1 - parseFloat(autoPlay.rkValue)).toFixed(2)) * 1000
                ap_timer.restart()
            }else{
                apStatusLabel.text = "Waiting on previous throw!"
            }
        }
    }

    function setAutoTicker(tmpT){
        tempTkr = tmpT
        if(!General.hasAutoAddress){
            grabAutoAddress(tempTkr)
        }
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

    function grabAutoAddress(tmpA){
        //here should check for address already saved
        //if not, saves the address
        tempGrabTkr = tmpA
        someObject.getAutoAddress(tempGrabTkr)
    }

    function autoThrow(){
        if(General.autoPlaying){
            if(hasEnoughBalance){
                //sendThrow()
                prep_timer.restart()
                General.apThrows++
                General.apCanThrow = false
                apStatusLabel.text = "Throw(s): " + General.apThrows
                var tempIdText = General.apCurrentTicker
            }else{
                //ap_timer.running = false
                //General.apCanThrow = true
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

    function sendThrow(){
        //someObject.getAutoAddress(General.apCurrentTicker)
        //send_modal.open()
        //send_modal.item.address_field.text = "RRBbUHjMaAg2tmWVj8k5fR2Z99uZchdUi4"
        //send_modal.item.amount_field.text = staticThrowSizeValue
        //send_modal.item.max_mount.checked = false
        //prep_timer.restart()
    }

    function prepThrow(){
        //var tempSendAddress = "RRBbUHjMaAg2tmWVj8k5fR2Z99uZchdUi4"
        //api_wallet_page.send(tempSendAddress, staticThrowSizeValue, false, false, fees_info_ap)
        //send_modal.item.prepareSendCoin(kmdAddy, (autoPlay.rkValue * parseFloat(autoPlay.stValue)).toFixed(2), false, "", General.isTokenType(current_ticker_infos.type), "", "")
        //send_modal.item.apPrepSendCoin(tempSendAddress, staticThrowSizeValue, false, false, "", "", 0)
        if(General.hasAutoAddress){
            ap_send_modal.apPrepSendCoin(General.apAddress.autoAddress, staticThrowSizeValue, false, false, "", "", 0)
            broadcast_timer.restart()
        }else{
            prep_timer.restart()
        }
    }

    function broadcastThrow(){
        if(api_wallet_page.is_send_busy){
            send_info_label.text = "prep = busy!"
            broadcast_timer.restart()
        }else{
            //send_modal.item.apSendCoin(staticThrowSizeValue)
            //api_wallet_page.broadcast(send_result.withdraw_answer.tx_hex, false, false, staticThrowSizeValue)
            ap_send_modal.apSendCoin(staticThrowSizeValue)
            //General.hasAutoAddress = false
            broadcast_values_label.text = JSON.stringify(ap_send_modal.send_result)
            close_send_timer.restart()
        }
    }

    function closeSendThrow(){
        if(api_wallet_page.is_broadcast_busy){
            send_info_label.text = "broadcast = busy!"
            close_send_timer.restart()
        }else{
            explorer_button.enabled = true
            send_info_label.text = "broadcast = done!"
        }
    }

    function oneApSendModal(){

    }

    function twoApSendModal(){
        ap_send_modal.respondHidden()
    }

    function threeApSendModal(){
        //send_values_label.text = "F8 - keys still work !"
//        ap_send_modal.open()
//        ap_send_modal.z = 1
    }

//    ModalLoader{
//        id: send_modal
//        sourceComponent: SendModal {}
//    }

//    Shortcut {
//        sequence: "F5"
//        onActivated: ap_send_modal.close()
//    }

//    Shortcut {
//        sequence: "F6"
//        onActivated: oneApSendModal()
//    }

//    Shortcut {
//        sequence: "F7"
//        onActivated: twoApSendModal()
//    }

//    Shortcut {
//        sequence: "F8"
//        onActivated: threeApSendModal()
//    }

    Timer {
        id: ap_timer
        repeat: true
        triggeredOnStart: true
        running: false
        onTriggered: autoThrow()
    }

    Timer {
        id: prep_timer
        interval: 250
        repeat: false
        triggeredOnStart: false
        running: false
        onTriggered: prepThrow()
    }

    Timer {
        id: broadcast_timer
        interval: 250
        repeat: false
        triggeredOnStart: false
        running: false
        onTriggered: broadcastThrow()
    }

    Timer {
        id: close_send_timer
        interval: 250
        repeat: false
        triggeredOnStart: false
        running: false
        onTriggered: closeSendThrow()
    }

    SendModal {
        id: ap_send_modal
        visible: false
        //opacity: 0
        //z: 1
    }

    ColumnLayout{
        width: 400
        height: 590
        x: (parent.width * 0.5) - (width * 0.5) //half window - width
        y: (parent.height * 0.5) - (height * 0.5) //half window - height
        z: 2

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
                        //ListElement { text: "CLC"}
                        //ListElement { text: "BTC"}
                        //ListElement { text: "VRSC"}
                        //ListElement { text: "CHIPS"}
                        //ListElement { text: "DASH"}
                        //ListElement { text: "DGB"}
                        ListElement { text: "DOGE"}
                        //ListElement { text: "ETH"}
                        ListElement { text: "LTC"}
                        //ListElement { text: "RVN"}
                        //ListElement { text: "XPM"}
                        //ListElement { text: "TKL"}
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
                    from: 0.1
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
                        text: General.autoPlaying ? qsTr(staticMinBalanceText) : qsTr(parseFloat(autoPlay.stValue).toFixed(2) + " ($" + currentFiatValue.toFixed(2) + ")")
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
                        text: General.autoPlaying ? qsTr(staticThrowSizeText) : qsTr((autoPlay.rkValue * parseFloat(autoPlay.stValue)).toFixed(2) + " ($" + (autoPlay.rkValue * currentFiatValue).toFixed(2) + ")")
//                            text: qsTr((autoPlay.riskValue * parseFloat(autoPlay.setAmountValue)).toFixed(2))
                    }
                }
                DexButton{
                    id: apbutton
                    enabled: autoPlay.hasEnoughBalance && General.apHasSelected && dashboard.sentDexUserData ? true : false
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
            //text: ("ticker: " + dashboard.current_ticker + " balance: " + General.formatFiat("", current_ticker_infos.fiat_amount, API.app.settings_pg.current_currency))
//                text: qsTr("*Numbers are auto adjusted based on the risk slider")
        }
        DefaultText{
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            //text: ("localSetAmount: " + autoPlay.localSetAmount + " hasEnoughBalance: " + autoPlay.hasEnoughBalance + " hasSelected: " + General.apHasSelected)
            text: ("autoAddressResponder " + General.apAddress)
        }
        DefaultText{
            id: arena_response
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: ("autoAddress " + General.apAddress.autoAddress)
        }
        DefaultText{
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: ("hasAutoAddress " + General.hasAutoAddress)
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

    ColumnLayout{
        width: 300
        height: 400
        x: parent.width - 300 //half window - width
        y: (parent.height * 0.5) - (height * 0.5) //half window - height

        DexButton{
            id: explorer_button
            visible: true
            enabled: false
            Layout.alignment: Qt.AlignHCenter
            Layout.minimumWidth: 180
            Layout.minimumHeight: 48
            text: "View on Explorer"
            onClicked: General.viewTxAtExplorer(api_wallet_page.ticker, broadcast_resul_ap)
        }

//        DefaultText{
//            Layout.alignment: Qt.AlignCenter
//            Layout.maximumWidth: parent.width
//            Layout.topMargin: 1
//            wrapMode: Text.WordWrap
//            leftPadding: 10
//            rightPadding: 10
//            text: ("is send busy " + send_modal.item.is_send_busy)
//        }
//        DefaultText{
//            Layout.alignment: Qt.AlignCenter
//            Layout.maximumWidth: parent.width
//            Layout.topMargin: 1
//            wrapMode: Text.WordWrap
//            leftPadding: 10
//            rightPadding: 10
//            text: ("is broadcast busy " + send_modal.item.is_broadcast_busy)
//        }
        DefaultText{
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 1
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: ("real value: " + (autoPlay.rkValue * parseFloat(autoPlay.stValue)) + " autoplaying: " + General.autoPlaying)
        }
        DefaultText{
            id: send_info_label
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 1
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: ""
        }
//        DefaultText{
//            id: is_empty_label
//            Layout.alignment: Qt.AlignCenter
//            Layout.maximumWidth: parent.width
//            Layout.topMargin: 1
//            wrapMode: Text.WordWrap
//            leftPadding: 10
//            rightPadding: 10
//            text: "empty"
//        }
//        DefaultText{
//            id: send_values_label
//            Layout.alignment: Qt.AlignCenter
//            Layout.maximumWidth: parent.width
//            Layout.topMargin: 1
//            wrapMode: Text.WordWrap
//            leftPadding: 10
//            rightPadding: 10
//            text: "sendValuesLabel!"
//        }
        DefaultText{
            id: broadcast_values_label
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 1
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: "sendValuesLabel2"
        }
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
