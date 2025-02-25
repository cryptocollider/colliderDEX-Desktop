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

import "../Components"
import "../Constants"
import "../Screens"
import "../Wallet"
import "../Exchange/Trade"
import App 1.0
import Dex.Themes 1.0 as Dex


Item {
    id: autoHedge
    enabled: true
    visible: dashboard.currentPage !== Dashboard.PageType.Games ? false : General.inAuto ? true : false
    anchors.fill: parent

    property string broadcast_resul_ap: api_wallet_page.broadcast_rpc_data
    property var portfol_modl: API.app.portfolio_pg.portfolio_mdl
    property var setting_pge: API.app.settings_pg
    property string tempTkr: "t"
    property string tempGrabTkr: "t"
    property string autoAddy
    property string staticMinBalanceText
    property string staticThrowSizeText
    property real staticThrowSizeValue
    property real extraThrowSize
    property real setAmountValue: 49.5
    property real localSetAmount: current_ticker_infos.balance
    property bool balanceAboveSetAmount: localSetAmount > (parseFloat(staticMinBalanceText) + parseFloat(staticThrowSizeText)) ? true : false
    property bool hasEnoughBalance: General.apHasSelected && parseFloat(current_ticker_infos.balance) > (parseFloat(currentMinWager) * 4) ? true : false
    property bool gotEnoughBalance: false //same condition as above but used a switch instead (due to time delay to check above)
    property int throwSeconds
    property var currentMinWager
    property int waitFinishTime: 720
    property real throwAmountValue: 49.5
    property real throwRateValue: 0.55
    property string setAmountPercentage: hasAutoAddress && hasEnoughBalance ? "" + Math.floor(set_amount_slider.position * 100) : ""
    property string minBalancePercentage: hasAutoAddress && hasEnoughBalance ? "" + ((100 / localSetAmount) * set_amount_slider.value).toFixed(2) : "x"
    property bool gettingAutoAddress: false
    property bool localAutoAddress: false
    property bool hasAutoAddress: localAutoAddress ? true : gettingAutoAddress || General.apAddress === undefined ? false : !General.apAddress.result ? false : true
    property bool hasColliderData: false
    property bool hasCheckedCoin: true //false when user selects a coin until its checked balance & validated address. (to prevent coin change spam == bugs)
    property bool hasKp: false
    property bool showKp: false
    property var colliderJsonData
    property var cmdVal
    property var returnAddyA
    property var returnAddyB
    property var returnAddyC
    property var returnAddyD
    property var returnAddyE
    property var proxV
    property int proxI: 21
    property int portI: 1
    property var portV
    property var prKi
    property string rTickA: "KMD"
    property string rTickB: "Komodo"
    property string rTickC: "komodo"
    property string cmdStr: "cmdLabelX"
    property string s1: qsTr("Finished! Throws: ")
    property string s2: qsTr("Throws: ")
    property string s3: qsTr("Waiting ")
    property string s4: qsTr("for updated balance. Throws: ")
    property string s5: qsTr("Loading..")
    property string s6: qsTr("Select a Coin")
    property string s7: qsTr("Balance: ")
    property string s8: qsTr("% of balance)")
    property string s9: qsTr("Stop Auto-Hedge")
    property string s10: qsTr("Start Auto-Hedge")
    property string s11: qsTr(" seconds left")

    function playAuto(){
        if(General.autoPlaying){
            General.autoPlaying = false
            if(wait_finish_timer.running){
                General.apCanThrow = true
                waitFinishTime = 720
                ahTopStatus.text = s1 + General.apThrows
                setAutoTicker(tempTkr) //resets the sliders & fields
                wait_finish_timer.stop()
            }
        }else{
            //check apCanThrow here
            ahTopStatus.text = ""
            ahTopStatus.color = "white"
            ahBottomStatus.text = ""
            if(General.apCanThrow){
                General.autoPlaying = true
//                webIndex.url = "qrc:///atomic_defi_design/qml/Games/testCom.html"
                General.apThrows = 0
                var tempMinBalance = minBalanceInput.text
                staticMinBalanceText = tempMinBalance
                minBalanceInput.text = staticMinBalanceText
                var tempThrowSize = throwSizeInput.text
                staticThrowSizeText = tempThrowSize
                staticThrowSizeValue = parseFloat(staticThrowSizeText)
                throwSizeInput.text = staticThrowSizeText
                ap_timer.interval = parseInt(throwRateInput.text) * 1000
                ap_timer.restart()
            }else{
                ahTopStatus.text = qsTr("Waiting on previous throw!")
            }
        }
    }

    function setAutoTicker(tmpT){
        hasCheckedCoin = false;
        tempTkr = tmpT
        api_wallet_page.ticker = tempTkr
        dashboard.current_ticker = api_wallet_page.ticker
        General.apCurrentTicker = dashboard.current_ticker
        ahTopStatus.text = ""
        ahBottomStatus.text = ""
        setMinWager()
        if(!General.apHasSelected){
            General.apHasSelected = true
        }
        if(parseFloat(current_ticker_infos.balance) > (parseFloat(currentMinWager) * 4)){
            ahTopStatus.color = 'forestgreen'
            ahTopStatus.text = qsTr("Enough funds available")
            gotEnoughBalance = true;
        }else{
            ahTopStatus.color = 'darkred'
            ahTopStatus.text = qsTr("You do not have enough funds")
        }
        grabAutoAddress(tempTkr)
    }

    function grabAutoAddress(tmpA){
        //here should check for address already saved if not, saves the address
        General.apAddress = undefined
        localAutoAddress = false
        tempGrabTkr = tmpA
        //var gotData = colliderJsonData !== undefined ? true : false
        //testLabel.text = "defined? " + gotData + " data: " + colliderJsonData[tmpA]
        if(Number(colliderJsonData[tmpA]) === 1){
            gettingAutoAddress = true
            someObject.getAutoAddress(tempGrabTkr)
        }else{
            setAutoAddress(tempGrabTkr)
        }
    }

    function setAutoAddress(tempAd){
        autoAddy = colliderJsonData[tempAd]
        localAutoAddress = true
        if(hasEnoughBalance || gotEnoughBalance){
            set_amount_slider.value = set_amount_slider.valueAt(0.5)
            minBalanceInput.text = (set_amount_slider.value).toFixed(2)
            throw_amount_slider.value = throw_amount_slider.valueAt(0.0)
            throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
            throw_rate_slider.value = throw_rate_slider.valueAt(1.0)
            throwRateInput.text = Math.floor(((600 / 1) * (1.1 - throw_rate_slider.value)))
        }else{
            setDefaultVals()
        }
        ahBottomStatus.color = 'forestgreen'
        ahBottomStatus.text = qsTr("Address validated")
        gotEnoughBalance = false; //reset the switch
        hasCheckedCoin = true;
    }

    function recievedAutoAddress(){
        gettingAutoAddress = false
        if(General.apAddress.result){
            colliderJsonData[General.apCurrentTicker] = General.apAddress.autoAddress
            autoAddy = colliderJsonData[General.apCurrentTicker]
            var colliderJsonFilename = app.currentWalletName + ".col.json"
            var overWright = true
            if(API.qt_utilities.save_collider_data(colliderJsonFilename, colliderJsonData, overWright)){
                //testLabel.text = "set collider data"
            }else{
                //testLabel.text = "failed set collider data"
            }
            if(hasEnoughBalance || gotEnoughBalance){
                set_amount_slider.value = set_amount_slider.valueAt(0.5)
                minBalanceInput.text = (set_amount_slider.value).toFixed(2)
                throw_amount_slider.value = throw_amount_slider.valueAt(0.0)
                throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
                throw_rate_slider.value = throw_rate_slider.valueAt(1.0)
                throwRateInput.text = Math.floor(((600 / 1) * (1.1 - throw_rate_slider.value)))
            }else{
                setDefaultVals()
            }
            ahBottomStatus.color = 'forestgreen'
            ahBottomStatus.text = qsTr("Address validated")
        }else{
            setDefaultVals()
            ahBottomStatus.color = 'darkred'
            ahBottomStatus.text = qsTr("Could not fetch address")
        }
        gotEnoughBalance = false; //reset the switch
        hasCheckedCoin = true;
    }

    function autoThrow(){
        if(General.autoPlaying){
            if(balanceAboveSetAmount){
                //sendThrow()
                prep_timer.restart()
                General.apThrows++
                General.apCanThrow = false
                ahTopStatus.text = s2 + General.apThrows
                throwSeconds = Math.floor(parseFloat(ap_timer.interval / 1000))
                throw_timer.restart()
            }else{
                ap_timer.running = false
                wait_finish_timer.restart()
                ahTopStatus.text = s3 + waitFinishTime + "m " + s4 + General.apThrows
            }
        }else{
            ap_timer.running = false
            General.apCanThrow = true
            ahTopStatus.text = s1 + General.apThrows
            setAutoTicker(tempTkr) //resets the sliders & fields
        }
    }

    function prepThrow(){
        var randExtra = Math.floor(Math.random() * 99999) + 10000
        extraThrowSize = staticThrowSizeValue + (randExtra * 0.00000001)
        var tmpApTick = General.apCurrentTicker
        //api_wallet_page.ticker = tmpApTick
        //dashboard.current_ticker = api_wallet_page.ticker
        if(hasAutoAddress){
            ap_send_modal.apPrepSendCoin(autoAddy, extraThrowSize, false, false, "", "", 0)
            broadcast_timer.restart()
        }else{
            prep_timer.restart()
        }
    }

    function broadcastThrow(){
        if(api_wallet_page.is_send_busy){
            //send_info_label.text = "prep = busy!"
            broadcast_timer.restart()
        }else{
            ap_send_modal.apSendCoin(extraThrowSize)
            //General.hasAutoAddress = false
            //broadcast_values_label.text = JSON.stringify(ap_send_modal.send_result)
            close_send_timer.restart()
        }
    }

    function closeSendThrow(){
        if(api_wallet_page.is_broadcast_busy){
            //send_info_label.text = "broadcast = busy!"
            close_send_timer.restart()
        }else{
            //explorer_button.enabled = true
            //send_info_label.text = "broadcast = done!"
//            if(dashboard.currentPage !== Dashboard.PageType.Games){
//                var tmpWtTick = General.walletCurrentTicker
//                api_wallet_page.ticker = tmpWtTick
//                dashboard.current_ticker = api_wallet_page.ticker
//            }
        }
    }

    function checkUpdatedBalance(){
        if(balanceAboveSetAmount){
            waitFinishTime = 720
            wait_finish_timer.stop()
            ap_timer.restart()
        }else{
            waitFinishTime -= 1
            if(waitFinishTime >= 1){
                ahTopStatus.text = s3 + waitFinishTime + s4 + General.apThrows
            }else{
                General.apCanThrow = true
                waitFinishTime = 720
                wait_finish_timer.stop()
                ahTopStatus.text = s1 + General.apThrows
                General.autoPlaying = false
                setAutoTicker(tempTkr) //resets the sliders & fields
            }
        }
    }

    function setDefaultVals(){
        set_amount_slider.value = set_amount_slider.valueAt(0.5)
        throw_amount_slider.value = throw_amount_slider.valueAt(0.0)
        throw_rate_slider.value = throw_rate_slider.valueAt(1.0)
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
            //portI++;
            //cmdLabel.text = "no coinData: " + (portI - 1);
            coinData_timer.restart()
            someObject.getCoinData()
        }else{
            //cmdLabel.text = "has coinData"
            coinData_timer.stop()
        }
    }

    function slideMinBalance() {
        minBalanceInput.text = (set_amount_slider.value).toFixed(2)
        throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
    }

    function slideThrowSize() {
        throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
    }

    function slideThrowRate() {
        throwRateInput.text = Math.floor(((600 / 1) * (1.1 - throw_rate_slider.value)))
    }

    function validateMinBalance(minBalanceTxt) {
        if(Number(minBalanceTxt) > set_amount_slider.to){
            minBalanceInput.text = (set_amount_slider.to).toFixed(2)
            throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
        }else if(Number(minBalanceTxt) < set_amount_slider.from){
            minBalanceInput.text = (set_amount_slider.from).toFixed(2)
            throwSizeInput.text = (throw_amount_slider.value).toFixed(2)
        }else{
        }
        set_amount_slider.value = (parseFloat(minBalanceInput.text)).toFixed(2)
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
        //addy_label.text = "A: " + returnAddyA
        returnAddyC = JSON.stringify(returnAddyA);
        //addy_label.text = "A: " + returnAddyA + " C: " + returnAddyC;
        //returnAddyD = JSON.parse(returnAddyC);
        //returnAddyE = JSON.stringify(returnAddyB);
        //addy_label.text = "A: " + returnAddyA + " C: " + returnAddyC;
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

    function getColliderData(){
        if(!hasColliderData){
            colliderJsonData = API.qt_utilities.load_collider_data(app.currentWalletName)
            hasColliderData = true
        }
        //var gotData = colliderJsonData !== undefined ? true : false
        //testLabel.text = "defined? " + gotData + " data: " + colliderJsonData.test
    }

    function setColliderData(){
        colliderJsonData.test = "testingback"
        var colliderJsonFilename = app.currentWalletName + ".col.json"
        var overWright = true
        if(API.qt_utilities.save_collider_data(colliderJsonFilename, colliderJsonData, overWright)){
            //testLabel.text = "set collider data"
        }else{
            //testLabel.text = "failed set collider data"
        }
    }

    function apPopKp(){
        hasKp = API.app.settings_pg.retrieve_kp();
    }

    function apGetKp(tckr){
        var indxKp = 0;
        var gotTckr = false;
        for(indxKp; indxKp < (coin_tck_list.count - 1); indxKp++){
            if(tckr === coin_tck_list.itemAtIndex(indxKp).text){
                gotTckr = true;
                break;
            }
        }
        if(gotTckr){
            kp_timer.restart();
            return coin_key_list.itemAtIndex(indxKp).text;
        }else{
            kp_timer.restart();
            return "failed to find ticker(priv key)";
        }
    }

    function clearKp(){
        hasKp = false;
        portfol_modl.clean_priv_keys();
    }

    function viewArena(){
        General.inAuto = false
        General.inArena = true
        dashboard.viewingArena = true
    }

    function viewStats(){
        General.inAuto = false
        General.inArena = true
        dashboard.viewingArena = true
        someObject.loadStats()
    }

    function runCoinData(){
        coinData_timer.restart();
    }

    function chngedLang(){
        ahBottomStatus.text = "";
        ahTopStatus.color = 'darkred';
        ahTopStatus.text = qsTr("Restart ColliderDEX to use with changed language");
    }

    function viewCmd(){
        cmdVal = API.qt_utilities.load_cmd_data();
        cmdLabel.text = JSON.stringify(cmdVal)
    }

    function portMod(){
//        var ptA
//        var ptB
//        var ptC
//        try {
//            portV = portfol_modl.collider_key(portI);
//            ptA = JSON.stringify(portV);
//        } catch (e) {}
//        try {
//            portI = 1;
//            portV = portfol_modl.collider_key(portI);
//            ptB = JSON.stringify(portV);
//        } catch (e) {}
//        try {
//            portI = 2;
//            portV = portfol_modl.collider_key(portI);
//            ptC = JSON.stringify(portV);
//        } catch (e) {}
        portV = portfol_modl.collider_key(portI);
        cmdLabel.text = portV[0];
        cmdLabel2.text = portV.count;
        cmdLabel3.text = portV;
        //var element_count = 0;
        //for (e in portV) {  if (portV.hasOwnProperty(e)) element_count++; }
        //portI = 2;
        //var ptV = portfol_modl.collider_key(portI);
        //cmdLabel2.text = ptV[0];
    }

    function proxMod(){
//        var pxA
//        var pxB
//        var pxC
//        try {
//            proxV = portfol_modl.portfolio_proxy_mdl.get(proxI);
//            pxA = JSON.stringify(proxV);
//        } catch (e) {}
//        try {
//            proxI = 21
//            proxV = portfol_modl.portfolio_proxy_mdl.get(proxI);
//            pxB = JSON.stringify(proxV);
//        } catch (e) {}
//        try {
//            proxI = 22
//            proxV = portfol_modl.portfolio_proxy_mdl.get(proxI);
//            pxC = JSON.stringify(proxV);
//        } catch (e) {}
        proxV = portfol_modl.portfolio_proxy_mdl.get(proxI);
        //cmdLabel.text = proxV[0];
        var element_count2 = 0;
        for (e in proxV) {  if (proxV.hasOwnProperty(e)) element_count2++; }
        cmdLabel2.text = element_count2;
    }

    function showApk(){
        var retA = API.app.settings_pg.retrieve_at_kp(rTickA);
        cmdLabel.text = retA;
    }

    function showBpk(){
        cmdLabel2.text = coin_tck_list.itemAtIndex(4).text;
//        var retB = API.app.settings_pg.retrieve_at_kp(rTickB);
//        cmdLabel2.text = retB;
    }

    function showCpk(){
        cmdLabel3.text = coin_key_list.itemAtIndex(4).text;
//        var retC = API.app.settings_pg.retrieve_at_kp(rTickC);
//        cmdLabel3.text = retC;
    }

    function retrieveKp(){
        hasKp = API.app.settings_pg.retrieve_kp();
        //retrieve_kp()
    }

    function toggleHideKp(){
        if(showKp){
            showKp = false;
        }else{
            showKp = true;
        }
    }

    Timer {
        id: coinData_timer
        repeat: false
        triggeredOnStart: false
        running: true
        interval: 5000
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
            if(throwSeconds < 1){
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

    Timer {
        id: kp_timer
        interval: 2000
        repeat: false
        triggeredOnStart: false
        running: false
        onTriggered: clearKp()
    }

//    Timer {
//        id: kp_timer_two
//        interval: 1000
//        repeat: false
//        triggeredOnStart: false
//        running: false
//        onTriggered: apGetKpThree("KMD")
//    }

//    Shortcut {
//        sequence: "F5"
//        onActivated: apGetKp("KMD")
//    }

//    Shortcut {
//        sequence: "F6"
//        onActivated: apGetKpTwo()
//    }

//    Shortcut {
//        sequence: "F7"
//        onActivated: retrieveKp()
//    }

//    Shortcut {
//        sequence: "F8"
//        onActivated: toggleHideKp()
//    }

//    Shortcut {
//        sequence: "F9"
//        onActivated: showBpk()
//    }

//    Shortcut {
//        sequence: "F10"
//        onActivated: showCpk()
//    }

    SendModal {
        id: ap_send_modal
        visible: false
        //opacity: 0
        //z: 1
    }

    ColumnLayout{
        width: 500
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
            Layout.maximumWidth: parent.width - 80
            Layout.topMargin: 4
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            leftPadding: 0
            rightPadding: 0
            text: qsTr("Use these settings to mine Collider Coin (and diversify your assets) via automated Collider Arena Game Hedging")
        }
        DexRectangle{
            width: 384
            height: 580
            Layout.topMargin: 4
            Layout.alignment: Qt.AlignHCenter
            gradient: Gradient
            {
                orientation: Gradient.Vertical
                GradientStop { position: 0.001; color: Dex.CurrentTheme.innerBackgroundColor }
                GradientStop { position: 1; color: Dex.CurrentTheme.backgroundColor }
            }

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
                    enabled: General.autoPlaying || someObject.coinData === undefined || !hasCheckedCoin || General.chngdLang ? false : true
                    Layout.alignment: Qt.AlignHCenter
                    Layout.minimumHeight: 46
                    Layout.maximumHeight: 46
                    Layout.minimumWidth: 200
                    Layout.topMargin: 4
                    displayText: someObject.coinData === undefined ? s5 : General.apHasSelected ? currentText : s6
                    model: ["KMD", "RVN", "TKL", "VRSC", "XPM"]
                    background: FloatingBackground{
                        implicitWidth: 120
                        implicitHeight: 45
                        color: Dex.CurrentTheme.floatingBackgroundColor
                        border.color: someObject.coinData === undefined ? DexTheme.contentColorTopBold : !General.apHasSelected ? Dex.CurrentTheme.accentColor : DexTheme.getCoinColor(controlAp.currentText)
                        radius: 20
                    }
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
                                text: modelData
                            }
                        }
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
                                text: controlAp.displayText
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
                    text: hasEnoughBalance ? s7 + parseFloat(localSetAmount).toFixed(2) + " ($" + parseFloat(current_ticker_infos.fiat_amount).toFixed(2) + ")" : s7 + "N/A"
                }
                Rectangle{
                    id: minBalanceRect
                    Layout.alignment: Qt.AlignHCenter
                    Layout.minimumWidth: 364
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
                            text: qsTr("Set Minimum Balance to Maintain")
                        }
                        DefaultText{
                            Layout.alignment: Qt.AlignHCenter
                            Layout.maximumWidth: parent.width
                            Layout.topMargin: -4
                            wrapMode: Text.WordWrap
                            text: "(" + minBalancePercentage + s8
                        }
                        RowLayout{
                            Layout.minimumWidth: parent.width
                            Layout.topMargin: 37
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
                                readOnly: hasAutoAddress && !General.autoPlaying && hasEnoughBalance && !General.chngdLang ? false : true
                                font: DexTypo.body1
                                validator: RegularExpressionValidator { regularExpression: /(\d{1,7})([.,]\d{1,3})?$/ }
                                color: General.autoPlaying ? Qt.rgba(255, 255, 255, 0.5) : 'white'
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
                                color: General.autoPlaying ? Qt.rgba(255, 255, 255, 0.5) : 'white'
                                text: hasAutoAddress && hasEnoughBalance ? "$" + (parseFloat(minBalanceInput.text) * current_ticker_infos.current_currency_ticker_price).toFixed(2) : "N/A"
                            }
                        }
                    }
                    FloatingBackground{
                        width: 16
                        height: 16
                        x: 4
                        y: 4
                        border.width: 1
                        border.color: Dex.CurrentTheme.accentColor
                        DefaultText{
                            anchors.centerIn: parent
                            text: "?"
                        }
                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {minBalanceTip.visible = true}
                            onExited: {minBalanceTip.visible = false}
                        }
                        ToolTip{
                            id: minBalanceTip
                            width: 600
                            x: 20
                            text: qsTr("Here set the percentage of your current balance that you will hedge into other coins (by setting your minimum balance to maintain). Your dex wallet balance for this coin will not go below this amount as a result of auto-hedge. You may still withdraw manually but the auto-hedge feature will not make throws if the balance is below this amount.")
                        }
                    }
                    DexSlider {
                        id: set_amount_slider
                        enabled: hasAutoAddress && !General.autoPlaying && hasEnoughBalance && !General.chngdLang ? true : false
                        width: 220
                        x: (parent.width / 2) - (width / 2)
                        y: 49
                        //from: hasAutoAddress && hasEnoughBalance ? (currentMinWager * 4) : 1
                        //to: hasAutoAddress && hasEnoughBalance ? localSetAmount : 100
                        from: hasAutoAddress && hasEnoughBalance ? (currentMinWager * 3) : 1
                        to: hasAutoAddress && hasEnoughBalance ? localSetAmount - (currentMinWager * 4) : 100
                        live: true
                        value: setAmountValue
                        onMoved: slideMinBalance()
                    }
                    DefaultText{
                        anchors.right: set_amount_slider.left
                        anchors.rightMargin: hasAutoAddress && hasEnoughBalance ? 4 : 6
                        y: 60
                        font: Qt.font({
                            pixelSize: 13,
                            letterSpacing: 0.25,
                            weight: Font.Normal,
                        })
                        color: 'white'
                        wrapMode: Text.WordWrap
                        text: hasAutoAddress && hasEnoughBalance ? "" + (currentMinWager * 3).toFixed(2) : "N/A"
                    }
                    DefaultText{
                        anchors.left: set_amount_slider.right
                        anchors.leftMargin: hasAutoAddress && hasEnoughBalance ? 4 : 6
                        y: 60
                        font: Qt.font({
                            pixelSize: 13,
                            letterSpacing: 0.25,
                            weight: Font.Normal,
                        })
                        color: 'white'
                        wrapMode: Text.WordWrap
                        text: hasAutoAddress && hasEnoughBalance ? "" + (localSetAmount - (currentMinWager * 4)).toFixed(2) : "N/A"
                    }
                }
                Rectangle{
                    Layout.alignment: Qt.AlignHCenter
                    Layout.minimumWidth: 364
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
                            text: qsTr("Set Throw Size")
                        }
                        RowLayout{
                            Layout.minimumWidth: parent.width
                            Layout.topMargin: 37
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
                                readOnly: hasAutoAddress && !General.autoPlaying && hasEnoughBalance && !General.chngdLang ? false : true
                                font: DexTypo.body1
                                validator: RegularExpressionValidator { regularExpression: /(\d{1,7})([.,]\d{1,3})?$/ }
                                color: General.autoPlaying ? Qt.rgba(255, 255, 255, 0.5) : 'white'
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
                                color: General.autoPlaying ? Qt.rgba(255, 255, 255, 0.5) : 'white'
                                text: hasAutoAddress && hasEnoughBalance ? "$" + (parseFloat(throwSizeInput.text) * current_ticker_infos.current_currency_ticker_price).toFixed(2) : "N/A"
                            }
                        }
                    }
                    FloatingBackground{
                        width: 16
                        height: 16
                        x: 4
                        y: 4
                        border.width: 1
                        border.color: Dex.CurrentTheme.accentColor
                        DefaultText{
                            anchors.centerIn: parent
                            text: "?"
                        }
                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {throwAmountTip.visible = true}
                            onExited: {throwAmountTip.visible = false}
                        }
                        ToolTip{
                            id: throwAmountTip
                            width: 600
                            x: 20
                            text: qsTr("Set here the size of each individual throw. A higher number of smaller throws is a lower risk/reward approach than a lower number of larger throws. In order to maintain consistent play the maximum throw size is 40% of your available balance (set using minimum balance above).")
                        }
                    }
                    DexSlider {
                        id: throw_amount_slider
                        enabled: hasAutoAddress && !General.autoPlaying && hasEnoughBalance && !General.chngdLang ? true : false
                        width: 220
                        x: (parent.width / 2) - (width / 2)
                        y: 28
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
                        to: hasAutoAddress && hasEnoughBalance ? ((localSetAmount - (set_amount_slider.valueAt(set_amount_slider.position))) * 0.4) : 100
                        live: true
                        value: throwAmountValue
                        onMoved: slideThrowSize()
                    }
                    ColumnLayout{
                        anchors.right: throw_amount_slider.left
                        anchors.rightMargin: 4
                        y: 29
                        DefaultText{
                            Layout.alignment: Qt.AlignHCenter
                            font: Qt.font({
                                pixelSize: 13,
                                letterSpacing: 0.25,
                                weight: Font.Normal,
                            })
                            color: 'forestgreen'
                            wrapMode: Text.WordWrap
                            text: hasAutoAddress && hasEnoughBalance ? "" + parseFloat(currentMinWager).toFixed(2) : "N/A"
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
                    ColumnLayout{
                        anchors.left: throw_amount_slider.right
                        anchors.leftMargin: 4
                        y: 29
                        DefaultText{
                            Layout.alignment: Qt.AlignHCenter
                            font: Qt.font({
                                pixelSize: 13,
                                letterSpacing: 0.25,
                                weight: Font.Normal,
                            })
                            color: 'darkred'
                            wrapMode: Text.WordWrap
                            text: hasAutoAddress && hasEnoughBalance ? "" + ((localSetAmount - parseFloat(set_amount_slider.valueAt(set_amount_slider.position))) * 0.4).toFixed(2) : "N/A"
                            //text: hasAutoAddress && hasEnoughBalance ? "" + parseFloat(throw_amount_slider.valueAt(set_amount_slider.position) * 0.4).toFixed(2) : "N/A"
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
                Rectangle{
                    Layout.alignment: Qt.AlignHCenter
                    Layout.minimumWidth: 364
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
                            Layout.minimumWidth: parent.width
                            Layout.topMargin: 37
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
                                readOnly: hasAutoAddress && !General.autoPlaying && hasEnoughBalance && !General.chngdLang ? false : true
                                font: DexTypo.body1
                                validator: RegularExpressionValidator { regularExpression: /(\d{1,3})?$/ }
                                color: General.autoPlaying ? Qt.rgba(255, 255, 255, 0.5) : 'white'
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
                    FloatingBackground{
                        width: 16
                        height: 16
                        x: 4
                        y: 4
                        border.width: 1
                        border.color: Dex.CurrentTheme.accentColor //old colour - "#313c7d"
                        DefaultText{
                            anchors.centerIn: parent
                            text: "?"
                        }
                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            onEntered: {throwRateTip.visible = true}
                            onExited: {throwRateTip.visible = false}
                        }
                        ToolTip{
                            id: throwRateTip
                            width: 600
                            x: 20
                            text: qsTr("This is the time interval (in seconds) between each throw attempt. If your wallet balance at the time of each attempt is lower than the set minimum then a throw will not be made and the auto-hedge feature will automatically try again on the next interval. Auto-hedge will be disabled once it has been over 12hrs since the last successful throw.")
                        }
                    }
                    DexSlider {
                        id: throw_rate_slider
                        enabled: hasAutoAddress && !General.autoPlaying && hasEnoughBalance && !General.chngdLang ? true : false
                        width: 220
                        x: (parent.width / 2) - (width / 2)
                        y: 28
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
                        anchors.right: throw_rate_slider.left
                        anchors.rightMargin: 4
                        y: 29
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
                            Layout.rightMargin: 1
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
                            Layout.rightMargin: 1
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
                    ColumnLayout{
                        anchors.left: throw_rate_slider.right
                        anchors.leftMargin: 4
                        y: 29
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
                            Layout.rightMargin: 1
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
                            Layout.rightMargin: 1
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
            }
            DexButton{
                id: apbutton
                enabled: wait_finish_timer.running ? true : hasAutoAddress && dashboard.sentDexUserData && hasEnoughBalance && !General.chngdLang ? true : false
                width: 180
                height: 48
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 55
                border.color: enabled ? Dex.CurrentTheme.accentColor : DexTheme.contentColorTopBold
                text: General.autoPlaying ? s9 : s10
                onClicked: playAuto()
            }
            DefaultText{
                id: ahTopStatus
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: !General.chngdLang || API.app.settings_pg.lang == "en" ? 32 : 20
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                leftPadding: 4
                rightPadding: 4
                text: ""
            }
            DefaultText{
                id: ahBottomStatus
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: !General.chngdLang || API.app.settings_pg.lang == "en" ? 10 : 4
                wrapMode: Text.WordWrap
                leftPadding: 4
                rightPadding: 4
                text: ""
            }
            DefaultText{
                //id: throwTimeLabel
                visible: General.apCanThrow ? false : true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: !General.chngdLang || API.app.settings_pg.lang == "en" ? 10 : 4
                wrapMode: Text.WordWrap
                leftPadding: 4
                rightPadding: 4
                text: throwSeconds + s11
            }
        }
    }

    DexRectangle{
        width: 220
        height: 160
        x: (parent.width * 0.83) - (width * 0.5) //83& window - width
        y: (parent.height * 0.5) - (height * 0.5) //half window - height
        gradient: Gradient
        {
            orientation: Gradient.Vertical
            GradientStop { position: 0.001; color: Dex.CurrentTheme.innerBackgroundColor }
            GradientStop { position: 1; color: Dex.CurrentTheme.backgroundColor }
        }
//        DexButton{
//            id: explorer_button
//            visible: true
//            enabled: false
//            Layout.alignment: Qt.AlignHCenter
//            Layout.minimumWidth: 180
//            Layout.minimumHeight: 48
//            text: "View on Explorer"
//            onClicked: General.viewTxAtExplorer(api_wallet_page.ticker, broadcast_resul_ap)
//        }
        DexButton{
            width: 180
            height: 48
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 20
            border.color: Dex.CurrentTheme.accentColor
            text: qsTr("View Game")
            onClicked: viewArena()
        }
        DexButton{
            width: 180
            height: 48
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            border.color: Dex.CurrentTheme.accentColor
            text: qsTr("View Stats")
            onClicked: viewStats()
        }
    }

    DexRectangle{
        width: 260
        height: 121
        x: (parent.width * 0.5) - 460
        y: (parent.height * 0.5) - 121
        DefaultText{
            anchors.centerIn: parent
            width: parent.width
            anchors.topMargin: 4
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            leftPadding: 6
            rightPadding: 6
            text: qsTr("Your dex wallet balance for this coin will not go below this amount as a result of auto-hedge.")
        }
    }

    DexRectangle{
        width: 260
        height: 104
        x: (parent.width * 0.5) - 460
        y: (parent.height * 0.5) + 7
        DefaultText{
            anchors.centerIn: parent
            width: parent.width
            anchors.topMargin: 4
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            leftPadding: 6
            rightPadding: 6
            text: qsTr("Set here the size of each individual throw.")
        }
    }

    DexRectangle{
        width: 260
        height: 104
        x: (parent.width * 0.5) - 460
        y: (parent.height * 0.5) + 118
        DefaultText{
            anchors.centerIn: parent
            width: parent.width
            anchors.topMargin: 4
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            leftPadding: 6
            rightPadding: 6
            text: qsTr("This is the time interval (in seconds) between each throw attempt.")
        }
    }

    DexListView {
        id: coin_tck_list
        visible: showKp
        enabled: hasKp
        x: 40
        y: 10
        width: 400
        height: 400
        model: hasKp ? portfolio_mdl.portfolio_proxy_mdl : null

        delegate: Text {
            height: 25
            width: 300
            text: model.ticker
            font.pixelSize: Style.textSizeSmall3
        }
    }

    DexListView {
        id: coin_key_list
        visible: showKp
        enabled: hasKp
        x: 460
        y: 10
        width: 400
        height: 400
        model: hasKp ? portfolio_mdl.portfolio_proxy_mdl : null

        delegate: Text {
            height: 25
            width: 300
            text: model.priv_key
            font.pixelSize: Style.textSizeSmall3
        }
    }

//    DefaultText{
//        id: tstLabel
//        Layout.maximumWidth: parent.width
//        x: parent.width * 0.25
//        y: 2
//        wrapMode: Text.WordWrap
//        text: "gettingAutoAddress: " + gettingAutoAddress + " - currentText: " + controlAp.currentText + " - lang: " + API.app.settings_pg.lang
//    }

//    DefaultText{
//        id: tstLabelTwo
//        Layout.maximumWidth: parent.width
//        x: parent.width * 0.25
//        y: 20
//        wrapMode: Text.WordWrap
//        text: "tstLabelTwo"
//    }

//    DefaultText{
//        id: cmdLabel
//        Layout.maximumWidth: parent.width
//        x: parent.width * 0.02
//        y: parent.height * 0.04
//        wrapMode: Text.WordWrap
//        text: "cmdLabel"
//    }
//    DefaultText{
//        id: cmdLabel2
//        x: parent.width * 0.02
//        y: parent.height * 0.06
//        wrapMode: Text.WordWrap
//        //text: "cmdLabel2"
//        text: "hasAutoAddress: " + hasAutoAddress + " apAddress.result: " + (General.apAddress === undefined ? false : General.apAddress.result);
//    }
//    DefaultText{
//        id: cmdLabel3
//        x: parent.width * 0.02
//        y: parent.height * 0.08
//        wrapMode: Text.WordWrap
//        text: cmdStr
//    }
//    DefaultText{
//        id: cmdLabel4
//        x: parent.width * 0.02
//        y: parent.height * 0.1
//        wrapMode: Text.WordWrap
//        text: someObject.autoplayAddress === undefined ? "apAddress: undef" : JSON.stringify(someObject.autoplayAddress);
//    }

//    DefaultText{
//        id: addy_label
//        Layout.alignment: Qt.AlignCenter
//        Layout.maximumWidth: parent.width
//        Layout.topMargin: 4
//        wrapMode: Text.WordWrap
//        leftPadding: 10
//        rightPadding: 10
//        text: ""
//        //text: "currentText: " + controlAp.currentText + " fiat rate: " + current_ticker_infos.current_currency_ticker_price
//        //text: ("ticker: " + dashboard.current_ticker + " balance: " + General.formatFiat("", current_ticker_infos.fiat_amount, API.app.settings_pg.current_currency))
////                text: qsTr("*Numbers are auto adjusted based on the risk slider")
//    }
//    TextInput {
//        enabled: dashboard.sentDexUserData ? true : false
//        Layout.alignment: Qt.AlignCenter
//        Layout.maximumWidth: parent.width
//        Layout.topMargin: 4
//        wrapMode: Text.WordWrap
//        leftPadding: 10
//        rightPadding: 10
//        text: JSON.stringify(dashboard.dexList)
//    }
//    DefaultText{
//        enabled: General.apHasSelected ? true : false
//        visible: General.apHasSelected ? true : false
//        Layout.alignment: Qt.AlignCenter
//        Layout.maximumWidth: parent.width
//        Layout.topMargin: 4
//        wrapMode: Text.WordWrap
//        leftPadding: 10
//        rightPadding: 10
//        //text: ("localSetAmount: " + autoHedge.localSetAmount + " hasEnoughBalance: " + autoHedge.hasEnoughBalance + " hasSelected: " + General.apHasSelected)
//        //text: ("autoAddressResponder " + General.apAddress)
//        text: "coinData.minWager: " + currentMinWager + " localSetAmt: " + localSetAmount + " hasEnoughBalnce: " + hasEnoughBalance
//    }
//    DefaultText{
//        id: autoAddress_label
//        Layout.alignment: Qt.AlignCenter
//        Layout.maximumWidth: parent.width
//        Layout.topMargin: 4
//        wrapMode: Text.WordWrap
//        leftPadding: 10
//        rightPadding: 10
//    }
//    DefaultText{
//        id: testLabel
//        Layout.alignment: Qt.AlignCenter
//        Layout.maximumWidth: parent.width
//        Layout.topMargin: 4
//        wrapMode: Text.WordWrap
//        leftPadding: 10
//        rightPadding: 10
//        text: ""
//        //text: ("hasAutoAddress: " + hasAutoAddress)
//    }

//    DefaultText{
//        x: parent.width * 0.2
//        y: parent.height * 0.35
//        wrapMode: Text.WordWrap
//        text: api_wallet_page.is_send_busy ? "sending.." : api_wallet_page.is_broadcast_busy ? "broadcasting.." : "Closed"
//    }
//    DexButton{
//        id: explorer_button
//        visible: true
//        enabled: false
//        width: 180
//        height: 48
//        text: "View on Explorer"
//        onClicked: General.viewTxAtExplorer(General.apCurrentTicker, broadcast_resul_ap)
//    }
    //        DefaultText{
    //            Layout.alignment: Qt.AlignCenter
    //            Layout.maximumWidth: parent.width
    //            Layout.topMargin: 1
    //            wrapMode: Text.WordWrap
    //            leftPadding: 10
    //            rightPadding: 10
    //            text: ("real value: " + (autoHedge.rkValue * parseFloat(autoHedge.stValue)) + " autoplaying: " + General.autoPlaying)
    //        }
    //        DefaultText{
    //            id: send_info_label
    //            Layout.alignment: Qt.AlignCenter
    //            Layout.maximumWidth: parent.width
    //            Layout.topMargin: 1
    //            wrapMode: Text.WordWrap
    //            leftPadding: 10
    //            rightPadding: 10
    //            text: ""
    //        }
    //        DefaultText{
    //            id: broadcast_values_label
    //            Layout.alignment: Qt.AlignCenter
    //            Layout.maximumWidth: parent.width
    //            Layout.topMargin: 1
    //            wrapMode: Text.WordWrap
    //            leftPadding: 10
    //            rightPadding: 10
    //            text: "sendValuesLabel2"
    //        }

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
