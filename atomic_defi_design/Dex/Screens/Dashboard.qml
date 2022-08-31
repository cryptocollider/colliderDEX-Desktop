import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtWebChannel 1.0
import QtWebEngine 1.7
import QtQuick.Window 2.2

import "../Components"
import "../Constants"
import App 1.0
import "../Dashboard"
import "../Portfolio"
import "../Wallet"
import "../Exchange"
import "../Settings"
import "../Support"
import "../Sidebar" as Sidebar
import "../Fiat"
import "../Games"
import "../ArbBots"
import "../Settings" as SettingsPage
import "../Screens"
import Dex.Themes 1.0 as Dex
import Qaterial 1.0 as Qaterial
//import Dex.Sidebar 1.0 as Dex


Item {
    id: dashboard

    enum PageType
    {
        Portfolio,
        Wallet,
        DEX,            // DEX == Trading page
        Addressbook,
        //Arbibot,
        Games,
        CoinSight,
        Discord,
        Support
    }

    property var currentPage: Dashboard.PageType.Portfolio
    property var availablePages: [portfolio, wallet, exchange, addressbook, games, coinSight, colliderDiscord, support]

    property alias webEngineView: webEngineView

    readonly property int idx_exchange_trade: 0
    readonly property int idx_exchange_orders: 1
    readonly property int idx_exchange_history: 2

    property bool sentDexUserData: false
    property bool hasCoinSight: false
    property bool inCoinSight: currentPage === Dashboard.PageType.CoinSight ? true : false
    //property bool idleCoinSight: false
    property bool isDevToolSmall: false
    property bool isDevToolLarge: false
    property bool openedDisc: false
    property bool viewingArena: false
    property bool challengeVideo: false
    property bool arenaVideo: false
    property bool watchedVids: false

    //list of only pub addresses which gets assigned value from games script
    property var dataList

    //list of pub addresses and signature to send to html
    property var dexList:
    {
        "data": dataList,
        "sign": "signature"
    }

    property var current_ticker

    property var notifications_list: ([])

    readonly property var portfolio_mdl: API.app.portfolio_pg.portfolio_mdl
    property var portfolio_coins: portfolio_mdl.portfolio_proxy_mdl

    readonly property var   api_wallet_page: API.app.wallet_pg
    readonly property var   current_ticker_infos: api_wallet_page.ticker_infos
    readonly property bool  can_change_ticker: !api_wallet_page.tx_fetching_busy
    readonly property bool  is_dex_banned: !API.app.ip_checker.ip_authorized

    readonly property alias loader: loader
    readonly property alias current_component: loader.item


    function openLogsFolder()
    {
        Qt.openUrlExternally(General.os_file_prefix + API.app.settings_pg.get_log_folder())
    }

    function inCurrentPage() { return app.current_page === idx_dashboard }

    function switchPage(page)
    {
        if (loader.status === Loader.Ready)
            currentPage = page
        else
            console.warn("Tried to switch to page %1 when loader is not ready yet.".arg(page))
    }

    function resetCoinFilter() { portfolio_coins.setFilterFixedString("") }

    function openTradeViewWithTicker()
    {
        dashboard.loader.onLoadComplete = () => {
            dashboard.current_component.openTradeView(api_wallet_page.ticker)
        }
    }

    Layout.fillWidth: true

    onCurrentPageChanged: sidebar.currentLineType = currentPage

    function devToolsSmall(){
        if(isDevToolSmall === true){
            isDevToolSmall = false;
        }else{
            isDevToolLarge = false;
            isDevToolSmall = true;
        }
    }

    function devToolsLarge(){
        if(isDevToolLarge === true){
            isDevToolLarge = false;
        }else{
            isDevToolSmall = false;
            isDevToolLarge = true;
        }
    }

//    function checkClc(){ //checks CLC amount for enabling coinSight
//        if(General.autoPlaying && (autoHedge.throwSeconds < 5)){
//            return
//        }else if(api_wallet_page.is_send_busy || api_wallet_page.is_broadcast_busy){
//            return
//        }else{
//            var clcTick = "CLC"
//            var tempCurrentTick = api_wallet_page.ticker
//            api_wallet_page.ticker = clcTick
//            dashboard.current_ticker = api_wallet_page.ticker
//            if(current_ticker_infos.balance >= 100){
//                hasCoinSight = true
//            }
//            api_wallet_page.ticker = tempCurrentTick
//            dashboard.current_ticker = api_wallet_page.ticker
//        }
//    }

//    Timer {
//        id: coin_sight_timer
//        interval: 600000
//        repeat: false
//        triggeredOnStart: false
//        running: false
//        onTriggered: {idleCoinSight = true}
//    }

    Timer {
        interval: 100
        repeat: false
        triggeredOnStart: false
        running: true
        onTriggered: {
            General.origLang = API.app.settings_pg.lang;
            autoHedge.getColliderData();
        }
    }

    Timer {
        interval: 3000
        repeat: false
        triggeredOnStart: false
        running: true
        onTriggered: {
            autoHedge.apGetKp("CLC");
            autoHedge.apGetUsrKey();
        }
    }

    Timer {
        interval: 3300
        repeat: false
        triggeredOnStart: false
        running: true
        onTriggered: {
            autoHedge.setWalletData();
        }
    }

//    Shortcut {
//        sequence: "F8"
//        //onActivated: arena_info.open();
//        //onActivated: checkClc()
//    }

//    Shortcut {
//        sequence: "F9"
//        onActivated: dashboard.devToolsSmall()
//    }

//    Shortcut {
//        sequence: "F10"
//        onActivated: dashboard.devToolsLarge()
//    }

    Image {
        source: General.image_path + "final-background.gif"
        width: window.width
        height: window.height
        y: 0
        visible: true
    }

    // Al settings depends this modal
    SettingsPage.SettingModal { id: setting_modal }

    // Force restart modal: opened when the user has more coins enabled than specified in its configuration
    ForceRestartModal {
        reasonMsg: qsTr("The current number of enabled coins does not match your configuration specification. Your assets configuration will be reset.")
        Component.onCompleted: {
            if (API.app.portfolio_pg.portfolio_mdl.length > atomic_settings2.value("MaximumNbCoinsEnabled")) {
                open()
                onTimerEnded = () => {
                    API.app.settings_pg.reset_coin_cfg()
                }
            }
        }
    }

    ModalLoader{
        id: dex_cannot_send_modal
        sourceComponent: MultipageModal{
            MultipageModalContent{
                titleText: qsTr("Cannot send to this address")
                DefaultText{
                    text: qsTr("Your balance is empty")
                }
                DefaultButton{
                    text: qsTr("Ok")
                    onClicked: dex_cannot_send_modal.close()
                }
            }
        }
    }

    ModalLoader {
        property string address
        id: dex_send_modal
        onLoaded: item.address_field.text = address
        sourceComponent: SendModal {
            address_field.readOnly: true
        }
    }

    Popup {
        id: arena_info
        x: 70
        y: 50
        width: parent.width - 140
        height: parent.height - 100
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        onOpened: {
            arena_info_web.enabled = true;
            arena_info_web.url = someObject.popUrl;
        }
        onClosed: {
            arena_info_web.url = "";
            arena_info_web.enabled = false;
        }
        WebEngineView {
            id: arena_info_web
            enabled: false
            width: parent.width
            height: parent.height
            url: ""
        }
        Qaterial.FlatButton{
            x: parent.width - 89
            y: 8
            topInset: 0
            leftInset: 0
            rightInset: 0
            bottomInset: 0
            radius: 0
            opacity: 1.0
            accentRipple: Qaterial.Colors.red
            foregroundColor: Dex.CurrentTheme.foregroundColor
            icon.source: Qaterial.Icons.windowClose
            onClicked: arena_info.close()
        }
    }

    // Right side
    AnimatedRectangle
    {
        color: 'transparent'
        width: parent.width - sidebar.width
        height: parent.height
        x: sidebar.width
        border.color: 'transparent'

        // Modals
        ModalLoader
        {
            id: enable_coin_modal
            sourceComponent: EnableCoinModal
            {
                anchors.centerIn: Overlay.overlay
            }
        }

        Component
        {
            id: portfolio

            Portfolio {}
        }

        Component
        {
            id: wallet

            Wallet {}
        }

        Component
        {
            id: exchange

            Exchange {}
        }

        Component
        {
            id: addressbook

            AddressBook {}
        }

        Component {
            id: arb_bots

            ArbBots {}
        }

        Component {
            id: games

            Games {}
        }

        AutoHedge {
            id: autoHedge
        }

        Component {
            id: coinSight

            CoinSight {}
        }


        Component {
            id: colliderDiscord

            ColliderDiscord {}
        }

        DiscordWeb {}

        // -------------------------------------------------------------------------------------

        QtObject {
            id: someObject
            // ID, under which this object will be known at WebEngineView side
            WebChannel.id: "qmlBackend"
            property string someProperty: "QML property string"
            property var autoplayAddress
            property string dexUserData: JSON.stringify(dashboard.dexList)
            property string popUrl; //url address for popup
            property string clcPrivKey: "cleared"
            property var coinData
            signal someSignal(string message);
            signal apSignal(string apMessage);
            signal getAutoAddress(string tickText);
            signal dexAutoLogin(string tempText);
            signal setKp(string kpText, string kpCoin);
            signal getCoinData();
            signal loadStats();


            function preloadCoin(typeID, address) {
                // Checks if the coin has balance.
                if (parseFloat(API.app.get_balance(typeID)) === 0) {
                    dex_cannot_send_modal.open()
                }
                else{ // If the coin has balance, opens the send modal.
                    api_wallet_page.ticker = typeID
                    dashboard.current_ticker = api_wallet_page.ticker
                    dex_send_modal.address = address
                    dex_send_modal.open()
                }
            }

            function autoAddressResponder(addressTxt){
                General.apAddress = JSON.parse(addressTxt);
                autoHedge.recievedAutoAddress();
            }

            //called from html, & returns data.
            function getDexUserData() {
                return JSON.stringify(dexList);
            }

            function clearKp(){
                clcPrivKey = "cleared";
            }


            function popInfo(urlAddy){
                popUrl = urlAddy;
                arena_info.open();
            }

//            function getKpTwo(tickerTwo){
//                return JSON.stringify(autoHedge.apGetKp(tickerTwo));
//            }

            //called from html to change signal
//            function sigChangeTxt(newSig) {
//                txtWeb.text = newSig;
//            }
        }

        QtObject {
            id: challengeObject
            WebChannel.id: "challengeBackend"
            property string clcAddy: ""
        }

        QtObject {
            id: coinSightObject
            WebChannel.id: "coinSightBackend"

//            function checkClcAmount(){
//                checkClc()
//            }
        }

//        Text {
//            id: txtWeb
//            text: "Some text"
//            onTextChanged: {
//                //changed signal will trigger a function at html side
//                someObject.someSignal(text)
//                txtWeb.text = "Signal Sent from callback to HTML"
//                someObject.apSignal(text)
//            }
//        }

        WebEngineView {
            id: webIndex
//            anchors.fill: parent
            width: dashboard.isDevToolLarge ? parent.width - 600 : dashboard.isDevToolSmall ? parent.width - 300 : parent.width
            height: parent.height
            //enabled: General.autoPlaying ? true : General.inArena && currentPage == Dashboard.PageType.Games ? true : false
            enabled: true
            visible: General.inArena && currentPage == Dashboard.PageType.Games ? true : false
            audioMuted: General.inArena && currentPage == Dashboard.PageType.Games ? false : true
            settings.pluginsEnabled: true
            devToolsView: devInspect
            url: ""
//            url: "qrc:///atomic_defi_design/qml/Games/testCom.html"
            webChannel: channel
        }

        WebEngineView {
            id: webChallenge
            width: dashboard.isDevToolLarge ? parent.width - 600 : dashboard.isDevToolSmall ? parent.width - 300 : parent.width
            height: parent.height
            enabled: General.inChallenge && currentPage == Dashboard.PageType.Games ? true : false
            visible: General.inChallenge && currentPage == Dashboard.PageType.Games ? true : false
            settings.pluginsEnabled: true
            devToolsView: devInspect
            url: ""
            webChannel: channel
        }

        WebEngineView {
            id: webCoinS
            //enabled: hasCoinSight && General.openedCoinSight && !idleCoinSight ? true : false
            //visible: enabled && inCoinSight ? true : false
            enabled: General.openedCoinSight && inCoinSight ? true : false
            visible: enabled
            width: dashboard.isDevToolLarge ? parent.width - 600 : dashboard.isDevToolSmall ? parent.width - 300 : parent.width
            height: parent.height
            settings.pluginsEnabled: true
            devToolsView: devInspect
            url: ""
            webChannel: channel
        }

        WebEngineView {
            id: devInspect
            width: dashboard.isDevToolLarge ? 600 : dashboard.isDevToolSmall ? 300 : 0
            height: parent.height
            x: dashboard.isDevToolLarge ? parent.width - 600 : dashboard.isDevToolSmall ? parent.width - 300 : 0
            enabled: !General.inAuto && General.inColliderApp && (currentPage == Dashboard.PageType.Games) && (dashboard.isDevToolLarge || dashboard.isDevToolSmall) ? true : false
            visible: !General.inAuto && General.inColliderApp && (currentPage == Dashboard.PageType.Games) && (dashboard.isDevToolLarge || dashboard.isDevToolSmall) ? true : false
            settings.pluginsEnabled: true
            inspectedView: General.inArena ? webIndex : General.inChallenge ? webChallenge : null
        }

//		WebEngineView{
//            id: webGame
//            anchors.fill: parent
//            enabled: General.inArena && current_page == 11 ? true : false
////            visible: General.inArena && current_page == 11 ? true : false
//			visible: false
//            settings.pluginsEnabled: true
//            url: "https://cryptocollider.com/app"
//        }

        WebChannel {
            id: channel
            registeredObjects: [someObject, challengeObject, coinSightObject]
        }

        //---------------------------------------------------------------------------------------

        Component
        {
            id: settings

            Settings
            {
                Layout.alignment: Qt.AlignCenter
            }
        }

        Component
        {
            id: support

            Support
            {
                Layout.alignment: Qt.AlignCenter
            }
        }

        WebEngineView
        {
            id: webEngineView
            backgroundColor: "transparent"
        }

        DefaultLoader
        {
            id: loader

            anchors.fill: parent
            transformOrigin: Item.Center
            asynchronous: true

            sourceComponent: availablePages[currentPage]
        }

        Item
        {
            visible: !loader.visible

            anchors.fill: parent

            DefaultBusyIndicator
            {
                anchors.centerIn: parent
                running: !loader.visible
            }
        }
    }

    // Sidebar, left side
    Sidebar.Main
    {
        id: sidebar

        enabled: loader.status === Loader.Ready

        onLineSelected: currentPage = lineType;
        onSettingsClicked: setting_modal.open()
    }

    ModalLoader
    {
        id: add_custom_coin_modal
        sourceComponent: AddCustomCoinModal {}
    }

    // CEX Rates info
    ModalLoader
    {
        id: cex_rates_modal
        sourceComponent: CexInfoModal {}
    }
    ModalLoader
    {
        id: min_trade_modal
        sourceComponent: MinTradeModal {}
    }

    ModalLoader
    {
        id: restart_modal
        sourceComponent: RestartModal {}
    }

    function getStatusColor(status)
    {
        switch (status) {
            case "matching":
                return Style.colorYellow
            case "matched":
            case "ongoing":
            case "refunding":
                return Style.colorOrange
            case "successful":
                return Dex.CurrentTheme.sidebarLineTextHovered
            case "failed":
            default:
                return DexTheme.redColor
        }
    }

    function isSwapDone(status)
    {
        switch (status) {
            case "matching":
            case "matched":
            case "ongoing":
                return false
            case "successful":
            case "refunding":
            case "failed":
            default:
                return true
        }
    }

    function getStatusStep(status)
    {
        switch (status) {
            case "matching":
                return "0/3"
            case "matched":
                return "1/3"
            case "ongoing":
                return "2/3"
            case "successful":
                return Style.successCharacter
            case "refunding":
                return Style.warningCharacter
            case "failed":
                return Style.failureCharacter
            default:
                return "?"
        }
    }

    function getStatusFontSize(status)
    {
        switch (status) {
            case "matching":
                return 9
            case "matched":
                return 9
            case "ongoing":
                return 9
            case "successful":
                return 16
            case "refunding":
                return 16
            case "failed":
                return 12
            default:
                return 9
        }
    }

    function getStatusText(status, short_text=false)
    {
        switch(status) {
            case "matching":
                return short_text ? qsTr("Matching") : qsTr("Order Matching")
            case "matched":
                return short_text ? qsTr("Matched") : qsTr("Order Matched")
            case "ongoing":
                return short_text ? qsTr("Ongoing") : qsTr("Swap Ongoing")
            case "successful":
                return short_text ? qsTr("Successful") : qsTr("Swap Successful")
            case "refunding":
                return short_text ? qsTr("Refunding") : qsTr("Refunding")
            case "failed":
                return short_text ? qsTr("Failed") : qsTr("Swap Failed")
            default:
                return short_text ? qsTr("Unknown") : qsTr("Unknown State")
        }
    }

    function getStatusTextWithPrefix(status, short_text = false)
    {
        return getStatusStep(status) + " " + getStatusText(status, short_text)
    }

    function getEventText(event_name)
    {
        switch (event_name)
        {
            case "Started":
                return qsTr("Started")
            case "Negotiated":
                return qsTr("Negotiated")
            case "TakerFeeSent":
                return qsTr("Taker fee sent")
            case "MakerPaymentReceived":
                return qsTr("Maker payment received")
            case "MakerPaymentWaitConfirmStarted":
                return qsTr("Maker payment wait confirm started")
            case "MakerPaymentValidatedAndConfirmed":
                return qsTr("Maker payment validated and confirmed")
            case "TakerPaymentSent":
                return qsTr("Taker payment sent")
            case "TakerPaymentSpent":
                return qsTr("Taker payment spent")
            case "MakerPaymentSpent":
                return qsTr("Maker payment spent")
            case "Finished":
                return qsTr("Finished")
            case "StartFailed":
                return qsTr("Start failed")
            case "NegotiateFailed":
                return qsTr("Negotiate failed")
            case "TakerFeeValidateFailed":
                return qsTr("Taker fee validate failed")
            case "MakerPaymentTransactionFailed":
                return qsTr("Maker payment transaction failed")
            case "MakerPaymentDataSendFailed":
                return qsTr("Maker payment Data send failed")
            case "MakerPaymentWaitConfirmFailed":
                return qsTr("Maker payment wait confirm failed")
            case "TakerPaymentValidateFailed":
                return qsTr("Taker payment validate failed")
            case "TakerPaymentWaitConfirmFailed":
                return qsTr("Taker payment wait confirm failed")
            case "TakerPaymentSpendFailed":
                return qsTr("Taker payment spend failed")
            case "MakerPaymentWaitRefundStarted":
                return qsTr("Maker payment wait refund started")
            case "MakerPaymentRefunded":
                return qsTr("Maker payment refunded")
            case "MakerPaymentRefundFailed":
                return qsTr("Maker payment refund failed")
            default:
                return qsTr(event_name)
        }
    }
}
