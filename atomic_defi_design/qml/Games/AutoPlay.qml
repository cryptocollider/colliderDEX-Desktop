import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15
import QtQuick.Controls.Universal 2.15
import QtGraphicalEffects 1.0
import QtQml.Models 2.1
import QtWebChannel 1.0
import QtWebEngine 1.7
import QtQml 2.2

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
    //property string dynaMinBalanceText: parseFloat(localSetAmount - parseFloat(autoPlay.stValue)).toFixed(2) + " ($" + parseFloat(minBalanceFiatValue).toFixed(2) + ")"
    //property string dynaThrowSizeText: parseFloat(autoPlay.rkValue * parseFloat(autoPlay.stValue)).toFixed(2) + " ($" + parseFloat(autoPlay.rkValue * minBalanceFiatValue).toFixed(2) + ")"
    //property string throwsPerMinText: parseFloat(1.1 - parseFloat(autoPlay.rkValue)).toFixed(2)
//    property string kmdAddy: RRBbUHjMaAg2tmWVj8k5fR2Z99uZchdUi4
    property string staticMinBalanceText
    property string staticThrowSizeText
    //property real staticMinBalanceValue
    property real staticThrowSizeValue
    property real extraThrowSize
    //property real riskValue: 0.28
    //property real rkValue: risk_slider.valueAt(risk_slider.position)
    property real setAmountValue: 49.5
    //property real staticSetAmount
    //property real stValue: set_amount_slider.valueAt(set_amount_slider.position)
    property real localSetAmount: current_ticker_infos.balance
    //property real minBalanceFiatValue: ((1 / localSetAmount) * (localSetAmount - parseFloat(autoPlay.stValue))) * current_ticker_infos.fiat_amount
    property bool balanceAboveSetAmount: localSetAmount > (parseFloat(staticMinBalanceText) + parseFloat(staticThrowSizeText)) ? true : false
    property bool hasEnoughBalance: General.apHasSelected && parseFloat(current_ticker_infos.balance) > (parseFloat(currentMinWager) * 4) ? true : false
    //property bool hasAnyBalance: false
    property int throwSeconds
    property var currentMinWager

    property int waitFinishTime: 60
    property real throwAmountValue: 49.5
    property real throwRateValue: 0.55
    property string setAmountPercentage: hasAutoAddress && hasEnoughBalance ? "" + Math.floor(set_amount_slider.position * 100) : ""
    //property string throwAmountPercentage: hasAutoAddress && hasEnoughBalance ? "" + Math.floor(throw_amount_slider.position * 100) : ""
    property bool hasAutoAddress: General.apAddress === undefined ? false : General.apAddress.autoAddress === undefined ? false : true
    property var returnAddyA
    property var returnAddyB
    property var returnAddyC
    property var returnAddyD
    property var returnAddyE

    function playAuto(){
        if(General.autoPlaying){
            General.autoPlaying = false
            if(wait_finish_timer.running){
                General.apCanThrow = true
                waitFinishTime = 60
                apStatusLabel.text = "Finished! Throw(s): " + General.apThrows
                setAutoTicker(tempTkr) //resets the sliders & fields
                wait_finish_timer.stop()
            }
        }else{
            //check apCanThrow here
            if(General.apCanThrow){
                General.autoPlaying = true
//                webIndex.url = "qrc:///atomic_defi_design/qml/Games/testCom.html"
                General.apThrows = 0
                var tempMinBalance = minBalanceInput.text
                staticMinBalanceText = tempMinBalance
                minBalanceInput.text = staticMinBalanceText
                //staticMinBalanceText = staticMinBalanceValue + " ($" + parseFloat(minBalanceFiatValue).toFixed(2) + ")"
                var tempThrowSize = throwSizeInput.text
                staticThrowSizeText = tempThrowSize
                staticThrowSizeValue = parseFloat(staticThrowSizeText)
                throwSizeInput.text = staticThrowSizeText
                //staticThrowSizeText = staticThrowSizeValue + " ($" + parseFloat(autoPlay.rkValue * minBalanceFiatValue).toFixed(2) + ")"
                ap_timer.interval = (60 / parseFloat(throw_rate_slider.value)) * 1000
                throwSeconds = Math.floor(parseFloat(ap_timer.interval / 1000))
                ap_timer.restart()
                throw_timer.restart()
            }else{
                apStatusLabel.text = "Waiting on previous throw!"
            }
        }
    }

    function setAutoTicker(tmpT){
        tempTkr = tmpT
        grabAutoAddress(tempTkr)
        setMinWager()
        api_wallet_page.ticker = tempTkr
        dashboard.current_ticker = api_wallet_page.ticker
        General.apCurrentTicker = dashboard.current_ticker
        if(!General.apHasSelected){
            General.apHasSelected = true
        }
        if(parseFloat(current_ticker_infos.balance) > (parseFloat(currentMinWager) * 4)){
            apStatusLabel.text = "Enough funds available !"
        }else{
            apStatusLabel.text = "You don't have enough funds"
        }
    }

    function grabAutoAddress(tmpA){
        //here should check for address already saved
        //if not, saves the address
        General.apAddress = undefined
        tempGrabTkr = tmpA
        someObject.getAutoAddress(tempGrabTkr)
    }

    function recievedAutoAddress(){
        if(hasAutoAddress){
            if(hasEnoughBalance){
                set_amount_slider.value = set_amount_slider.valueAt(0.5)
                minBalanceInput.text = (localSetAmount - set_amount_slider.value).toFixed(2)
                throw_amount_slider.value = throw_amount_slider.valueAt(0.5)
                throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
                throw_rate_slider.value = throw_rate_slider.valueAt(0.5)
                throwRateInput.text = Math.floor(((600 / 1) * (1.1 - throw_rate_slider.value)))
                apStatusLabel.text = "Address validated. Ready to throw!"
                autoAddress_label.text = ("autoAddress " + General.apAddress.autoAddress)
            }else{
                setDefaultVals()
                autoAddress_label.text = ("autoAddress " + General.apAddress.autoAddress)
            }
        }else{
            setDefaultVals()
            apStatusLabel.text = "Couldn't fetch address"
            autoAddress_label.text = "no address"
        }
    }

    function autoThrow(){
        if(General.autoPlaying){
            if(balanceAboveSetAmount){
                //sendThrow()
                prep_timer.restart()
                General.apThrows++
                General.apCanThrow = false
                apStatusLabel.text = "Throw(s): " + General.apThrows
            }else{
                ap_timer.running = false
                wait_finish_timer.restart()
                apStatusLabel.text = "Waiting " + waitFinishTime + "m for updated balance. Throw(s) " + General.apThrows
            }
        }else{
            ap_timer.running = false
            General.apCanThrow = true
            apStatusLabel.text = "Finished! Throw(s): " + General.apThrows
            setAutoTicker(tempTkr) //resets the sliders & fields
        }
    }

    function prepThrow(){
        //var tempSendAddress = "RRBbUHjMaAg2tmWVj8k5fR2Z99uZchdUi4"
        //api_wallet_page.send(tempSendAddress, staticThrowSizeValue, false, false, fees_info_ap)
        //send_modal.item.prepareSendCoin(kmdAddy, (autoPlay.rkValue * parseFloat(autoPlay.stValue)).toFixed(2), false, "", General.isTokenType(current_ticker_infos.type), "", "")
        //send_modal.item.apPrepSendCoin(tempSendAddress, staticThrowSizeValue, false, false, "", "", 0)
        var randExtra = Math.floor(Math.random() * 99999) + 10000
        extraThrowSize = staticThrowSizeValue + (randExtra * 0.00000001)
        var tmpApTick = General.apCurrentTicker
        api_wallet_page.ticker = tmpApTick
        dashboard.current_ticker = api_wallet_page.ticker
        if(hasAutoAddress){
            ap_send_modal.apPrepSendCoin(General.apAddress.autoAddress, extraThrowSize, false, false, "", "", 0)
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
            ap_send_modal.apSendCoin(extraThrowSize)
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
            if(dashboard.current_page !== idx_dashboard_games){
                var tmpWtTick = General.walletCurrentTicker
                api_wallet_page.ticker = tmpWtTick
                dashboard.current_ticker = api_wallet_page.ticker
            }
        }
    }

    function checkUpdatedBalance(){
        if(balanceAboveSetAmount){
            waitFinishTime = 60
            wait_finish_timer.stop()
            ap_timer.restart()
        }else{
            waitFinishTime -= 1
            if(waitFinishTime >= 1){
                apStatusLabel.text = "Waiting " + waitFinishTime + "m for updated balance. Throw(s) " + General.apThrows
            }else{
                General.apCanThrow = true
                waitFinishTime = 60
                wait_finish_timer.stop()
                apStatusLabel.text = "Finished! Throw(s): " + General.apThrows
                General.autoPlaying = false
                setAutoTicker(tempTkr) //resets the sliders & fields
            }
        }
    }

    function setDefaultVals(){
        set_amount_slider.value = set_amount_slider.valueAt(0.5)
        throw_amount_slider.value = throw_amount_slider.valueAt(0.5)
        throw_rate_slider.value = throw_rate_slider.valueAt(0.5)
        minBalanceInput.text = "N/A"
        throwSizeInput.text = "N/A"
        throwRateInput.text = "N/A"
    }

    function setMinWager() {
        switch(controlAp.currentText){
            case "KMD":
                currentMinWager = someObject.coinData.kmd.minWager
                break
            case "CLC":
                currentMinWager = someObject.coinData.clc.minWager
                break
            case "BTC":
                currentMinWager = someObject.coinData.btc.minWager
                break
            case "VRSC":
                currentMinWager = someObject.coinData.vrsc.minWager
                break
            case "CHIPS":
                currentMinWager = someObject.coinData.chips.minWager
                break
            case "DASH":
                currentMinWager = someObject.coinData.dash.minWager
                break
            case "DGB":
                currentMinWager = someObject.coinData.dgb.minWager
                break
            case "DOGE":
                currentMinWager = someObject.coinData.doge.minWager
                break
            case "ETH":
                currentMinWager = someObject.coinData.eth.minWager
                break
            case "LTC":
                currentMinWager = someObject.coinData.ltc.minWager
                break
            case "RVN":
                currentMinWager = someObject.coinData.rvn.minWager
                break
            case "XPM":
                currentMinWager = someObject.coinData.xpm.minWager
                break
            case "TKL":
                currentMinWager = someObject.coinData.tkl.minWager
                break
        }
    }

    function setCoinData() {
        if(someObject.coinData === undefined){
            coinData_timer.interval = 5000
            someObject.getCoinData()
        }else{
            coinData_timer.stop()
        }
    }

    function slideMinBalance() {
        minBalanceInput.text = (localSetAmount - set_amount_slider.value).toFixed(2)
        throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
    }

    function slideThrowSize() {
        throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
    }

    function slideThrowRate() {
        throwRateInput.text = Math.floor(((600 / 1) * (1.1 - throw_rate_slider.value)))
    }

    function validateMinBalance(minBalanceTxt) {
        if(Number(minBalanceTxt) > (localSetAmount - set_amount_slider.from)){
            minBalanceInput.text = (localSetAmount - set_amount_slider.from).toFixed(2)
            throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
        }else if(Number(minBalanceTxt) < 0.1){
            minBalanceInput.text = 0.1
            throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
        }else{
        }
        set_amount_slider.value = (localSetAmount - parseFloat(minBalanceInput.text)).toFixed(2)
        throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
    }

    function validateThrowSize(throwSizeTxt) {
        if(Number(throwSizeTxt) > throw_amount_slider.to){
            throwSizeInput.text = (throw_amount_slider.to).toFixed(2)
        }else if(Number(throwSizeTxt) < throw_amount_slider.from){
            throwSizeInput.text = (throw_amount_slider.from).toFixed(2)
        }else{
        }
        throw_amount_slider.value = parseFloat(throwSizeInput.text).toFixed(2)
    }

    function validateThrowRate(throwRateTxt) {
        if(Number(throwRateTxt) > 600){
            throwRateInput.text = 600
        }else if(Number(throwRateTxt) < 60){
            throwRateInput.text = 60
        }else{
        }
        throw_rate_slider.value = parseFloat(((600 * 1.1) - throwRateInput.text) / 600).toFixed(2)
    }

//    function createInvisContact() {
//        var tempInvis = "456";
//        API.app.addressbook_pg.model.add_invis_contact(tempInvis.toString());
//    }

    function getAddressInfoAp(){
        var tempNameB = "arena";
        var tempTypeB = "KMD";
        var tempKeyB = "KMD";
        returnAddyA = API.app.addressbook_pg.model.get_wallet_info_address(tempNameB.toString(), tempTypeB.toString(), tempKeyB.toString());
        //returnAddyB = JSON.parse(API.app.addressbook_pg.model.get_wallet_info_address(tempNameB.toString(), tempTypeB.toString(), tempKeyB.toString()));
        addy_label.text = "A: " + returnAddyA
        returnAddyC = JSON.stringify(returnAddyA);
        addy_label.text = "A: " + returnAddyA + " C: " + returnAddyC;
        //returnAddyD = JSON.parse(returnAddyC);
        //returnAddyE = JSON.stringify(returnAddyB);
        addy_label.text = "A: " + returnAddyA + " C: " + returnAddyC;
        //addy_label.text = "A: " + returnAddyA + " B: " + returnAddyB + " C: " + returnAddyC + " D: " + returnAddyD + " E: " + returnAddyE;

    }

    function setContactInfoAp(){
        var tempName = "arena";
        var tempType = "KMD";
        var tempKey = "KMD";
        var tempAddress = "RRBbUHjMaAg2tmWVj8k5fR2Z99uZchdUi4";
        API.app.addressbook_pg.model.set_contact_wallet_info(tempName.toString(), tempType.toString(), tempKey.toString(), tempAddress.toString());
        tempType = "LTC";
        tempKey = "LTC";
        tempAddress = "MRiPvVUxZLNws5NokrBh6Hy9WnCCt6GbGP";
        API.app.addressbook_pg.model.set_contact_wallet_info(tempName.toString(), tempType.toString(), tempKey.toString(), tempAddress.toString());
    }

    function createVisibleContact() {
        var tempVis = "arena";
        var visible_contact_result = API.app.addressbook_pg.model.add_contact(tempVis.toString());
    }

    function viewArena(){
        General.inAuto = false
        General.inArena = true
    }

    function viewStats(){
        General.inAuto = false
        General.inArena = true
        someObject.loadStats()
    }

    Shortcut {
        sequence: "F4"
        onActivated: getAddressInfoAp()
    }

    Shortcut {
        sequence: "F5"
        onActivated: setContactInfoAp()
    }

    Shortcut {
        sequence: "F6"
        onActivated: createVisibleContact()
    }

    Shortcut {
        sequence: "F7"
        onActivated: dashboard.switchPage(idx_dashboard_addressbook)
    }

    Timer {
        id: coinData_timer
        repeat: true
        triggeredOnStart: false
        running: true
        interval: 10000
        onTriggered: setCoinData()
    }

    Timer {
        id: ap_timer
        repeat: true
        triggeredOnStart: true
        running: false
        onTriggered: autoThrow()
    }

    Timer {
        id: throw_timer
        repeat: true
        triggeredOnStart: false
        interval: 1000
        onTriggered: {
            throwSeconds--;
            if(throwSeconds == 0){
                running = false;
            }
        }
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

    Timer {
        id: wait_finish_timer
        interval: 60000
        repeat: true
        triggeredOnStart: false
        running: false
        onTriggered: checkUpdatedBalance()
    }

    SendModal {
        id: ap_send_modal
        visible: false
        //opacity: 0
        //z: 1
    }

    ColumnLayout{
        width: 400
        height: 680
        x: (parent.width * 0.5) - (width * 0.5) //half window - width
        y: (parent.height * 0.5) - (height * 0.5) //half window - height

        DexLabel{
            Layout.alignment: Qt.AlignCenter
            font: DexTypo.head4
            text: qsTr("Game Liquidity Mining")
        }

        DefaultText{
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            leftPadding: 0
            rightPadding: 0
            text: qsTr("Use these settings to mine Collider Coin (and diversify your assets) via automated Collider Arena Game Hedging")
        }
        FloatingBackground{
            width: 348
            height: 580
            Layout.topMargin: 4
            Layout.alignment: Qt.AlignHCenter

            ColumnLayout{
                width: parent.width

                DexLabel{
                    Layout.alignment: Qt.AlignHCenter
                    height: 60
                    Layout.topMargin: 6
                    font: DexTypo.head5
                    text: qsTr("Choose Asset to Auto-Hedge")
                }
                DexComboBox {
                    id: controlAp
                    enabled: General.autoPlaying || someObject.coinData === undefined ? false : true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.minimumHeight: 46
                    Layout.maximumHeight: 46
                    Layout.minimumWidth: 200
                    Layout.topMargin: 4
                    displayText: someObject.coinData === undefined ? "Loading.." : General.apHasSelected ? currentText : "Select a Coin"
                    model: ["KMD", "RVN", "TKL", "VRSC", "XPM"]
                    delegate: ItemDelegate {
                        width: controlAp.width
                        height: controlAp.height
                        highlighted: controlAp.highlightedIndex === index
                        RowLayout {
                            anchors.fill: parent
                            //spacing: -13
                            DefaultImage {
                                id: comboApImage
                                Layout.preferredHeight: 32
                                Layout.leftMargin: 4
                                source: General.coin_icons_path + "32" + modelData + ".png"
                            }
                            DexLabel {
                                //Layout.alignment: Qt.AlignHCenter
                                Layout.preferredWidth: 150
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr(modelData)
                            }
                        }
//                        onClicked: {
//                            if (modelData !== API.app.settings_pg.lang) {
//                                API.app.settings_pg.lang = modelData
//                            }
//                        }
                    }
                    contentItem: Text {
                        width: controlAp.width
                        height: controlAp.height
                        leftPadding: 0
                        //rightPadding: controlAp.indicator.width + controlAp.spacing

                        //text: controlAp.displayText
                        font: controlAp.font
                        color: controlAp.pressed ? "#17a81a" : "#21be2b"
                        //verticalAlignment: Text.AlignVCenter
                        //elide: Text.ElideRight
                        RowLayout {
                            anchors.fill: parent
                            DefaultImage {
                                id: comboApContentImage
                                //height: 32
                                //x: 8
                                //anchors.verticalCenter: parent.verticalCenter
                                Layout.preferredHeight: 32
                                Layout.leftMargin: 4
                                source: General.apHasSelected ? General.coin_icons_path + "32" + controlAp.currentText + ".png" : General.image_path + "menu-news-white.svg"
                            }
                            DexLabel {
                                //Layout.alignment: Qt.AlignHCenter
                                horizontalAlignment: Text.AlignHCenter
                                text: qsTr(controlAp.displayText)
                            }
                        }
                    }
                    onActivated: {
                        setAutoTicker(currentText)
                    }
                }
                DexLabel{
                    Layout.alignment: Qt.AlignHCenter
                    height: 40
                    font: DexTypo.body1
                    text: hasEnoughBalance ? qsTr("Balance: ") + parseFloat(localSetAmount).toFixed(2) + " ($" + parseFloat(current_ticker_infos.fiat_amount).toFixed(2) + ")" : qsTr("Balance: N/A")
                }
                Rectangle{
                    Layout.alignment: Qt.AlignHCenter
                    Layout.minimumWidth: 316
                    Layout.minimumHeight: 121
                    Layout.topMargin: 2
                    antialiasing: true
                    border.color: Qt.rgba(255, 255, 255, 0.5)
                    border.width: 1
                    color: "transparent"
                    radius: 6
                    ColumnLayout{
                        width: parent.width
                        DexLabel{
                            Layout.alignment: Qt.AlignHCenter
                            height: 60
                            font: DexTypo.head6
                            text: qsTr("Set Amount to Play")
                        }
                        DefaultText{
                            Layout.alignment: Qt.AlignHCenter
                            Layout.maximumWidth: parent.width
                            Layout.topMargin: -4
                            wrapMode: Text.WordWrap
                            text: qsTr("(" + set_amount_slider.value.toFixed(2) + " of balance)")
                        }
                        RowLayout{
                            Layout.alignment: Qt.AlignHCenter
                            Layout.leftMargin: 6
                            ColumnLayout{
                                Layout.rightMargin: 4
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    font: Qt.font({
                                        pixelSize: 13,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'forestgreen'
                                    wrapMode: Text.WordWrap
                                    text: "1%"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -9
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'forestgreen'
                                    wrapMode: Text.WordWrap
                                    text: "LOW"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -8
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'forestgreen'
                                    wrapMode: Text.WordWrap
                                    text: "RISK"
                                }
                            }
                            DexSlider {
                                id: set_amount_slider
                                enabled: hasAutoAddress && !General.autoPlaying && hasEnoughBalance ? true : false
                                Layout.minimumWidth: 220
                                background: Rectangle {
                                    x: set_amount_slider.leftPadding
                                    y: set_amount_slider.topPadding + set_amount_slider.availableHeight / 2 - height / 2
                                    implicitWidth: 200
                                    implicitHeight: 4
                                    width: set_amount_slider.availableWidth
                                    height: implicitHeight
                                    radius: 2
                                    color: Qt.rgba((set_amount_slider.position + 0.001) * 0.99, 1.0 - ((set_amount_slider.position + 0.001) * 0.99), 0, 1)
                                }
                                handle: FloatingBackground {
                                    x: set_amount_slider.leftPadding + set_amount_slider.visualPosition * (set_amount_slider.availableWidth - width)
                                    y: set_amount_slider.topPadding + set_amount_slider.availableHeight / 2 - height / 2
                                    implicitWidth: 26
                                    implicitHeight: 26
                                    radius: 13
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 10
                                        height: 10
                                        radius: 10
                                        color: Qt.rgba((set_amount_slider.position + 0.001) * 0.99, 1.0 - ((set_amount_slider.position + 0.001) * 0.99), 0, 1)
                                    }
                                }
                                from: hasAutoAddress && hasEnoughBalance ? (currentMinWager * 4) : 1
                                to: hasAutoAddress && hasEnoughBalance ? localSetAmount : 100
                                live: true
                                value: setAmountValue
                                onMoved: slideMinBalance()
                            }
                            ColumnLayout{
                                Layout.leftMargin: -2
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    font: Qt.font({
                                        pixelSize: 13,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'darkred'
                                    wrapMode: Text.WordWrap
                                    text: "100%"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -9
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'darkred'
                                    wrapMode: Text.WordWrap
                                    text: "HIGH"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -8
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'darkred'
                                    wrapMode: Text.WordWrap
                                    text: "RISK"
                                }
                            }
                        }
                        RowLayout{
                            Layout.minimumWidth: parent.width
                            Layout.topMargin: -6
                            DexLabel{
                                Layout.alignment: Qt.AlignLeft
                                Layout.leftMargin: 10
                                height: 24
                                font: DexTypo.body1
                                text: qsTr("Min Balance:")
                            }
                            TextField{
                                id: minBalanceInput
                                Layout.alignment: Qt.AlignHCenter
                                height: 24
                                readOnly: hasAutoAddress && !General.autoPlaying && hasEnoughBalance ? false : true
                                font: DexTypo.body1
                                validator: RegularExpressionValidator { regularExpression: /(\d{1,7})([.,]\d{1,3})?$/ }
                                color: 'white'
                                Behavior on color {
                                    ColorAnimation {
                                        duration: Style.animationDuration
                                    }
                                }
                                background: DexRectangle {
                                    color: "#252a4d"
                                    border.color: 'white'
                                    border.width: 1
                                    radius: 6
                                }
                                placeholderText: "N/A"
                                //text: !hasEnoughBalance || !hasAutoAddress ? "N/A" : General.autoPlaying ? staticMinBalanceText : dynaMinBalanceText
                                //onTextEdited: validateMinBalance(text)
                                onEditingFinished: validateMinBalance(text)
                            }
                            DexLabel{
                                Layout.alignment: Qt.AlignRight
                                Layout.rightMargin: 10
                                height: 24
                                font: DexTypo.body1
                                text: hasAutoAddress && hasEnoughBalance ? "$" + (parseFloat(minBalanceInput.text) * current_ticker_infos.current_currency_ticker_price).toFixed(2) : "N/A"
                            }
                        }
                    }
                }
                Rectangle{
                    Layout.alignment: Qt.AlignHCenter
                    Layout.minimumWidth: 316
                    Layout.minimumHeight: 104
                    Layout.topMargin: 2
                    antialiasing: true
                    border.color: Qt.rgba(255, 255, 255, 0.5)
                    border.width: 1
                    color: "transparent"
                    radius: 6
                    ColumnLayout{
                        width: parent.width
                        DexLabel{
                            Layout.alignment: Qt.AlignHCenter
                            height: 60
                            font: DexTypo.head6
                            text: qsTr("Set Throw Amount")
                        }
                        RowLayout{
                            Layout.alignment: Qt.AlignHCenter
                            Layout.leftMargin: 6
                            ColumnLayout{
                                Layout.rightMargin: 4
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    font: Qt.font({
                                        pixelSize: 13,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'forestgreen'
                                    wrapMode: Text.WordWrap
                                    text: "1%"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -9
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'forestgreen'
                                    wrapMode: Text.WordWrap
                                    text: "LOW"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -8
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'forestgreen'
                                    wrapMode: Text.WordWrap
                                    text: "RISK"
                                }
                            }
                            DexSlider {
                                id: throw_amount_slider
                                enabled: hasAutoAddress && !General.autoPlaying && hasEnoughBalance ? true : false
                                Layout.minimumWidth: 220
                                background: Rectangle {
                                    x: throw_amount_slider.leftPadding
                                    y: throw_amount_slider.topPadding + throw_amount_slider.availableHeight / 2 - height / 2
                                    implicitWidth: 200
                                    implicitHeight: 4
                                    width: throw_amount_slider.availableWidth
                                    height: implicitHeight
                                    radius: 2
                                    color: Qt.rgba((throw_amount_slider.position + 0.001) * 0.99, 1.0 - ((throw_amount_slider.position + 0.001) * 0.99), 0, 1)
                                }
                                handle: FloatingBackground {
                                    x: throw_amount_slider.leftPadding + throw_amount_slider.visualPosition * (throw_amount_slider.availableWidth - width)
                                    y: throw_amount_slider.topPadding + throw_amount_slider.availableHeight / 2 - height / 2
                                    implicitWidth: 26
                                    implicitHeight: 26
                                    radius: 13
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 10
                                        height: 10
                                        radius: 10
                                        color: Qt.rgba((throw_amount_slider.position + 0.001) * 0.99, 1.0 - ((throw_amount_slider.position + 0.001) * 0.99), 0, 1)
                                    }
                                }
                                from: hasAutoAddress && hasEnoughBalance ? currentMinWager : 0.5
                                to: hasAutoAddress && hasEnoughBalance ? set_amount_slider.valueAt(set_amount_slider.position) : 100
                                live: true
                                value: throwAmountValue
                                onMoved: slideThrowSize()
                            }
                            ColumnLayout{
                                Layout.leftMargin: -2
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    font: Qt.font({
                                        pixelSize: 13,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'darkred'
                                    wrapMode: Text.WordWrap
                                    text: "100%"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -9
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'darkred'
                                    wrapMode: Text.WordWrap
                                    text: "HIGH"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -8
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'darkred'
                                    wrapMode: Text.WordWrap
                                    text: "RISK"
                                }
                            }
                        }
                        RowLayout{
                            Layout.minimumWidth: parent.width
                            Layout.topMargin: -6
                            DexLabel{
                                Layout.alignment: Qt.AlignLeft
                                Layout.leftMargin: 10
                                height: 24
                                font: DexTypo.body1
                                text: qsTr("Throw Size:")
                            }
                            TextField{
                                id: throwSizeInput
                                Layout.alignment: Qt.AlignHCenter
                                height: 24
                                readOnly: hasAutoAddress && !General.autoPlaying && hasEnoughBalance ? false : true
                                font: DexTypo.body1
                                validator: RegularExpressionValidator { regularExpression: /(\d{1,7})([.,]\d{1,3})?$/ }
                                color: 'white'
                                Behavior on color {
                                    ColorAnimation {
                                        duration: Style.animationDuration
                                    }
                                }
                                background: DexRectangle {
                                    color: "#252a4d"
                                    border.color: 'white'
                                    border.width: 1
                                    radius: 6
                                }
                                placeholderText: "N/A"
                                //text: !hasEnoughBalance || !hasAutoAddress ? "N/A" : General.autoPlaying ? staticThrowSizeText : dynaThrowSizeText
                                //onTextEdited: validateThrowSize(text)
                                onEditingFinished: validateThrowSize(text)
                            }
                            DexLabel{
                                Layout.alignment: Qt.AlignRight
                                Layout.rightMargin: 10
                                height: 24
                                font: DexTypo.body1
                                text: hasAutoAddress && hasEnoughBalance ? "$" + (parseFloat(throwSizeInput.text) * current_ticker_infos.current_currency_ticker_price).toFixed(2) : "N/A"
                            }
                        }
                    }
                }
                Rectangle{
                    Layout.alignment: Qt.AlignHCenter
                    Layout.minimumWidth: 316
                    Layout.minimumHeight: 104
                    Layout.topMargin: 2
                    antialiasing: true
                    border.color: Qt.rgba(255, 255, 255, 0.5)
                    border.width: 1
                    color: "transparent"
                    radius: 6
                    ColumnLayout{
                        width: parent.width
                        DexLabel{
                            Layout.alignment: Qt.AlignHCenter
                            height: 60
                            font: DexTypo.head6
                            text: qsTr("Set Throw Rate")
                        }
                        RowLayout{
                            Layout.alignment: Qt.AlignHCenter
                            Layout.rightMargin: 2
                            ColumnLayout{
                                Layout.rightMargin: -1
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    font: Qt.font({
                                        pixelSize: 13,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'darkred'
                                    wrapMode: Text.WordWrap
                                    text: "SLOW"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -9
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'darkred'
                                    wrapMode: Text.WordWrap
                                    text: "HIGH"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -8
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'darkred'
                                    wrapMode: Text.WordWrap
                                    text: "RISK"
                                }
                            }
                            DexSlider {
                                id: throw_rate_slider
                                enabled: hasAutoAddress && !General.autoPlaying && hasEnoughBalance ? true : false
                                Layout.minimumWidth: 220
                                background: Rectangle {
                                    x: throw_rate_slider.leftPadding
                                    y: throw_rate_slider.topPadding + throw_rate_slider.availableHeight / 2 - height / 2
                                    implicitWidth: 200
                                    implicitHeight: 4
                                    width: throw_rate_slider.availableWidth
                                    height: implicitHeight
                                    radius: 2
                                    color: Qt.rgba(1.0 - ((throw_rate_slider.position + 0.001) * 0.99), (throw_rate_slider.position + 0.001) * 0.99, 0, 1)
                                }
                                handle: FloatingBackground {
                                    x: throw_rate_slider.leftPadding + throw_rate_slider.visualPosition * (throw_rate_slider.availableWidth - width)
                                    y: throw_rate_slider.topPadding + throw_rate_slider.availableHeight / 2 - height / 2
                                    implicitWidth: 26
                                    implicitHeight: 26
                                    radius: 13
                                    Rectangle {
                                        anchors.centerIn: parent
                                        width: 10
                                        height: 10
                                        radius: 10
                                        color: Qt.rgba(1.0 - ((throw_rate_slider.position + 0.001) * 0.99), (throw_rate_slider.position + 0.001) * 0.99, 0, 1)
                                    }
                                }
                                from: 0.1
                                to: 1.0
                                live: true
                                value: throwRateValue
                                onMoved: slideThrowRate()
                            }
                            ColumnLayout{
                                //Layout.leftMargin: -2
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    font: Qt.font({
                                        pixelSize: 13,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'forestgreen'
                                    wrapMode: Text.WordWrap
                                    text: "FAST"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -9
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'forestgreen'
                                    wrapMode: Text.WordWrap
                                    text: "LOW"
                                }
                                DefaultText{
                                    Layout.alignment: Qt.AlignHCenter
                                    Layout.topMargin: -8
                                    font: Qt.font({
                                        pixelSize: 11,
                                        letterSpacing: 0.25,
                                        weight: Font.Normal,
                                    })
                                    color: 'forestgreen'
                                    wrapMode: Text.WordWrap
                                    text: "RISK"
                                }
                            }
                        }
                        RowLayout{
                            Layout.minimumWidth: parent.width
                            Layout.topMargin: -6
                            DexLabel{
                                Layout.alignment: Qt.AlignLeft
                                Layout.leftMargin: 10
                                height: 24
                                font: DexTypo.body1
                                text: qsTr("1 Throw every (seconds):")
                            }
                            TextField{
                                id: throwRateInput
                                Layout.alignment: Qt.AlignRight
                                Layout.rightMargin: 40
                                height: 24
                                readOnly: hasAutoAddress && !General.autoPlaying && hasEnoughBalance ? false : true
                                font: DexTypo.body1
                                validator: RegularExpressionValidator { regularExpression: /(\d{1,3})?$/ }
                                color: 'white'
                                Behavior on color {
                                    ColorAnimation {
                                        duration: Style.animationDuration
                                    }
                                }
                                background: DexRectangle {
                                    color: "#252a4d"
                                    border.color: 'white'
                                    border.width: 1
                                    radius: 6
                                }
                                placeholderText: "N/A"
                                //text: !hasEnoughBalance || !hasAutoAddress ? "N/A" : qsTr("1 throw per ") + (60 / parseFloat(throw_rate_slider.value)) + qsTr("seconds")
                                //onTextEdited: validateThrowRate(text)
                                onEditingFinished: validateThrowRate(text)
                            }
                        }
                    }
                }
                DexButton{
                    id: apbutton
                    enabled: wait_finish_timer.running ? true : hasAutoAddress && dashboard.sentDexUserData && hasEnoughBalance ? true : false
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 8
                    Layout.minimumWidth: 180
                    Layout.minimumHeight: 48
                    text: General.autoPlaying ? qsTr("Stop Auto-Hedge") : qsTr("Start Auto-Hedge")
                    onClicked: playAuto()
                }
                DefaultText{
                    //id: throwTimeLabel
                    visible: General.apCanThrow ? false : true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: parent.width
                    //Layout.topMargin: 4
                    wrapMode: Text.WordWrap
                    leftPadding: 10
                    rightPadding: 10
                    text: throwSeconds + " seconds left"
                }
                DefaultText{
                    id: apStatusLabel
                    Layout.alignment: Qt.AlignHCenter
                    Layout.maximumWidth: parent.width
                    //Layout.topMargin: 4
                    wrapMode: Text.WordWrap
                    leftPadding: 10
                    rightPadding: 10
                    text: ""
                }
            }
        }
        DefaultText{
            id: addy_label
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: ""
            //text: "currentText: " + controlAp.currentText + " fiat rate: " + current_ticker_infos.current_currency_ticker_price
            //text: ("ticker: " + dashboard.current_ticker + " balance: " + General.formatFiat("", current_ticker_infos.fiat_amount, API.app.settings_pg.current_currency))
//                text: qsTr("*Numbers are auto adjusted based on the risk slider")
        }
//        TextInput {
//            enabled: dashboard.sentDexUserData ? true : false
//            Layout.alignment: Qt.AlignCenter
//            Layout.maximumWidth: parent.width
//            Layout.topMargin: 4
//            wrapMode: Text.WordWrap
//            leftPadding: 10
//            rightPadding: 10
//            text: JSON.stringify(dashboard.dexList)
//        }
        DefaultText{
            enabled: General.apHasSelected ? true : false
            visible: General.apHasSelected ? true : false
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            //text: ("localSetAmount: " + autoPlay.localSetAmount + " hasEnoughBalance: " + autoPlay.hasEnoughBalance + " hasSelected: " + General.apHasSelected)
            //text: ("autoAddressResponder " + General.apAddress)
            text: "coinData.minWager: " + currentMinWager + " localSetAmt: " + localSetAmount + " hasEnoughBalnce: " + hasEnoughBalance
        }
        DefaultText{
            id: autoAddress_label
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
        }
        DefaultText{
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.topMargin: 4
            wrapMode: Text.WordWrap
            leftPadding: 10
            rightPadding: 10
            text: ("hasAutoAddress: " + hasAutoAddress)
        }
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
        DexButton{
            Layout.alignment: Qt.AlignHCenter
            Layout.minimumWidth: 180
            Layout.minimumHeight: 48
            text: "View Game"
            onClicked: viewArena()
        }
        DexButton{
            Layout.alignment: Qt.AlignHCenter
            Layout.minimumWidth: 180
            Layout.minimumHeight: 48
            text: "View Stats"
            onClicked: viewStats()
        }
//        DefaultText{
//            Layout.alignment: Qt.AlignCenter
//            Layout.maximumWidth: parent.width
//            Layout.topMargin: 1
//            wrapMode: Text.WordWrap
//            leftPadding: 10
//            rightPadding: 10
//            text: ("real value: " + (autoPlay.rkValue * parseFloat(autoPlay.stValue)) + " autoplaying: " + General.autoPlaying)
//        }
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
