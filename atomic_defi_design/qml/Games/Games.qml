import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtWebChannel 1.0
import QtWebEngine 1.7
import QtMultimedia 5.6
import QtQuick.Window 2.2

import Qaterial 1.0 as Qaterial
//import "hprequest.js" as hprequest

import "../Components"
import "../Constants"
import "../Wallet"
import "../Exchange/Trade"

Item {
    id: games
    anchors.fill: parent    
    property string tempTickr: "t"

    //strings for coins pub address
    property string addyKMD: "t"
    property string addyCLC: "t"
    property string addyBTC: "t"
    property string addyVRSC: "t"
    property string addyCHIPS: "t"
    property string addyDASH: "t"
    property string addyDGB: "t"
    property string addyDOGE: "t"
    property string addyETH: "t"
    property string addyLTC: "t"
    property string addyRVN: "t"
    property string addyXPM: "t"
    property string addyTKL: "t"

    //strings for coins balance
    property string balKMD: "t"
    property string balCLC: "t"
    property string balBTC: "t"
    property string balVRSC: "t"
    property string balCHIPS: "t"
    property string balDASH: "t"
    property string balDGB: "t"
    property string balDOGE: "t"
    property string balETH: "t"
    property string balLTC: "t"
    property string balRVN: "t"
    property string balXPM: "t"
    property string balTKL: "t"

    property var addyList:
    {
        "KMD": addyKMD,
        "CLC": addyCLC,
        "BTC": addyBTC,
        "VRSC": addyVRSC,
        "CHIPS": addyCHIPS,
        "DASH": addyDASH,
        "DGB": addyDGB,
        "DOGE": addyDOGE,
        "ETH": addyETH,
        "LTC": addyLTC,
        "RVN": addyRVN,
        "XPM": addyXPM,
        "TKL": addyTKL
    }

    property var balList:
    {
        "KMD": balKMD,
        "CLC": balCLC,
        "BTC": balBTC,
        "VRSC": balVRSC,
        "CHIPS": balCHIPS,
        "DASH": balDASH,
        "DGB": balDGB,
        "DOGE": balDOGE,
        "ETH": balETH,
        "LTC": balLTC,
        "RVN": balRVN,
        "XPM": balXPM,
        "TKL": balTKL
    }

    property var gamesDataList:
    {
        "userAddresses": addyList,
        "balances": balList
    }

    function openArena(){
       // buildAddyList();
//        webIndex.url = "qrc:///atomic_defi_design/qml/Games/testCom.html"
//        someObject.preloadCoin("KMD", "testAddress")
        if(!General.openedArena){
            webIndex.url = "https://cryptocollider.com/app/indexDex.html"
            buildAddyList();
            dex_user_data_timer.restart()
            General.openedArena = true
        }
        General.inArena = true
    }

    function openChallenge(){
        if(!General.openedChallenge){
            webChallenge.url = "https://cryptocollider.com/challenge/app"
            buildAddyList();
            General.openedChallenge = true
        }
        General.inChallenge = true
    }

    function openAutoPlay(){
        if(!General.openedArena){
            webIndex.url = "https://cryptocollider.com/app/indexDex.html"
            buildAddyList();
            dex_user_data_timer.restart()
            General.openedArena = true
        }
        tempTickr = General.apCurrentTicker
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        General.inAuto = true
    }

    function checkDexUserData(){
        //build address list for HTML &
        //checks if dexUserData has been sent
        if(!dashboard.sentDexUserData){
            someObject.dexAutoLogin("temp")
            dashboard.sentDexUserData = true
        }
    }

    function buildAddyList(){
        tempTickr = "KMD"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyKMD = current_ticker_infos.address
        balKMD = current_ticker_infos.balance
        tempTickr = "CLC"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyCLC = current_ticker_infos.address
        challengeObject.clcAddyTwo = addyCLC
        challengeObject.clcAddyThree = JSON.stringify(addyCLC)
        balCLC = current_ticker_infos.balance
        tempTickr = "BTC"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyBTC = current_ticker_infos.address
        balBTC = current_ticker_infos.balance
        tempTickr = "VRSC"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyVRSC = current_ticker_infos.address
        balVRSC = current_ticker_infos.balance
        tempTickr = "CHIPS"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyCHIPS = current_ticker_infos.address
        balCHIPS = current_ticker_infos.balance
        tempTickr = "DASH"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyDASH = current_ticker_infos.address
        balDASH = current_ticker_infos.balance
        tempTickr = "DGB"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyDGB = current_ticker_infos.address
        balDGB = current_ticker_infos.balance
        tempTickr = "DOGE"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyDOGE = current_ticker_infos.address
        balDOGE = current_ticker_infos.balance
        tempTickr = "ETH"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyETH = current_ticker_infos.address
        balETH = current_ticker_infos.balance
        tempTickr = "LTC"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyLTC = current_ticker_infos.address
        balLTC = current_ticker_infos.balance
        tempTickr = "RVN"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyRVN = current_ticker_infos.address
        balRVN = current_ticker_infos.balance
        tempTickr = "XPM"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyXPM = current_ticker_infos.address
        balXPM = current_ticker_infos.balance
        tempTickr = "TKL"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyTKL = current_ticker_infos.address
        balTKL = current_ticker_infos.balance
        dashboard.dataList = gamesDataList;
    }

    function playVids(){
        vid_player.play()
        vid_two_player.play()
    }

    Shortcut {
        sequence: "F8"
        onActivated: playVids()
    }

    Timer {
        id: dex_user_data_timer
        interval: 2000
        repeat: false
        triggeredOnStart: false
        running: false
        onTriggered: checkDexUserData()
    }

    FloatingBackground{
        id: challenge
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: 490
        height: 500
        x: (parent.width * 0.25) - (width / 2)
        y: 40
        ColumnLayout{
            anchors.fill: parent
            DexLabel{
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 6
                horizontalAlignment: Text.AlignHCenter
                font: DexTypo.head4
                text: qsTr("Crypto Challenge")
            }
            DexLabel{
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: -4
                font: DexTypo.head6
                text: qsTr("Fun way to learn Crypto")
            }
            DexButton{
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: 200
                Layout.minimumWidth: 120
                Layout.maximumHeight: 60
                Layout.minimumHeight: 80
                //Layout.topMargin: 70 * (arena.height / 532)
                Layout.topMargin: 276
                text: qsTr("Play")
                onClicked: openChallenge()
            }
        }
        Video {
            id: vid_player
            width: 426
            height: 240
            anchors.left: parent.left
            anchors.leftMargin: 32
            y: y + 116
            fillMode: VideoOutput.PreserveAspectFit
            flushMode: VideoOutput.FirstFrame
            source: General.image_path + "games-page-challenge.avi"
            //focus: true
        }
    }

    FloatingBackground{
        id: arena
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: 490
        height: 500
        x: (parent.width * 0.75) - (width / 2)
        y: 40
        ColumnLayout{
            anchors.fill: parent
            DexLabel{
                Layout.alignment: Qt.AlignCenter
//                Layout.maximumWidth: parent.width
//                Layout.minimumWidth: parent.width - 30 //minus the paddings
                Layout.topMargin: 6
//                wrapMode: Text.WordWrap
//                leftPadding: 15
//                rightPadding: 15
                horizontalAlignment: Text.AlignHCenter
                font: DexTypo.head4
                text: qsTr("Crypto Collider Trading Arena")
            }
            DexLabel{
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: -4
                font: DexTypo.head6
                text: qsTr("Use Skill and grow your assets")
            }
            DexButton{
                //enabled: General.autoPlaying ? false : true //can't open CryptoCollider while using auto-play
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: 200
                Layout.minimumWidth: 120
                Layout.maximumHeight: 60
                Layout.minimumHeight: 80
                //Layout.topMargin: 60 * (arena.height / 532)
                Layout.topMargin: 276
                text: qsTr("Play")
                onClicked: openArena()
            }
        }
        Video {
            id: vid_two_player
            width: 426
            height: 240
            anchors.left: parent.left
            anchors.leftMargin: 32
            y: y + 116
            fillMode: VideoOutput.PreserveAspectFit
            flushMode: VideoOutput.FirstFrame
            source: General.image_path + "games-page-collider.avi"
        }
    }

    FloatingBackground{
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: 560
        height: 160
        x: (parent.width / 2) - (width / 2)
        y: 580 + (0.625 * (window.height - (General.minimumHeight - 1)))
        ColumnLayout{
            anchors.fill: parent
            DexButton{
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: 240
                Layout.minimumWidth: 160
                Layout.maximumHeight: 60
                Layout.minimumHeight: 80
                //Layout.topMargin: 70 * (arena.height / 532)
                Layout.topMargin: 16
                text: qsTr("Auto Hedging")
                onClicked: openAutoPlay()
                //onClicked: someObject.preloadCoin("KMD", "testAddress")
            }

            DexLabel{
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width
                Layout.minimumWidth: parent.width - 30 //minus the paddings
                Layout.topMargin: 10
                wrapMode: Text.WordWrap
                leftPadding: 15
                rightPadding: 15
                horizontalAlignment: Text.AlignHCenter
                font: DexTypo.head6
                text: qsTr("Provide automated game liquidity to")
            }
            DexLabel{
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width
                Layout.minimumWidth: parent.width - 30 //minus the paddings
                wrapMode: Text.WordWrap
                bottomPadding: 10
                leftPadding: 15
                rightPadding: 15
                horizontalAlignment: Text.AlignHCenter
                font: DexTypo.head6
                text: qsTr("diversify your assets & mine Collider Coin")
            }
        }
    }

//    FloatingBackground{
//        enabled: General.inColliderApp ? false : true
//        visible: General.inColliderApp ? false : true
//        width: parent.width * 0.35
//        height: parent.height * 0.7
//        x: (parent.width * 0.5) - (width + 40) //half window - (width + margin)
//        y: ((parent.height * 0.5) - (height * 0.5)) //half window - half height

//        ColumnLayout{
//            width: parent.width

//            DexLabel {
//                Layout.alignment: Qt.AlignCenter
//                Layout.topMargin: 15
//                font: DexTypo.head6
//                text: qsTr("Crypto Challenge")
//            }

//            DefaultText {
//                Layout.alignment: Qt.AlignCenter
//                Layout.maximumWidth: parent.width
//                Layout.topMargin: 15
//                wrapMode: Text.WordWrap
//                leftPadding: 15
//                rightPadding: 15
//                text_value: qsTr("Lorem ipsum dolor sit amet, sea modus choro constituto eu. Ex nec ignota delenit officiis, ei nam ferri tantas doming. Vel ei solet populo, per ad facilis iracundia definitionem. Mei option dissentiunt cu, mea legimus placerat et. Praesent postulant vis ut, in utinam bonorum fabulas has")
//            }

//            DexButton {
//                Layout.alignment: Qt.AlignCenter
//                Layout.maximumWidth: parent.width - 80
//                Layout.minimumWidth: parent.width - 80
//                Layout.maximumHeight: 60
//                Layout.minimumHeight: 60
//                Layout.topMargin: 70 * (arena.height / 532)
//                text: qsTr("Play Crypto Challenge")
//                onClicked: openChallenge()
//            }
//        }
//    }

//    FloatingBackground{
//        enabled: General.inColliderApp ? false : true
//        visible: General.inColliderApp ? false : true
//        width: parent.width * 0.35
//        height: parent.height * 0.7
//        x: ((parent.width * 0.5) + 40) //half window + margin
//        y: ((parent.height * 0.5) - (height * 0.5)) //half window - half height

//        ColumnLayout{
//            width: parent.width

//            DexLabel {
//                Layout.alignment: Qt.AlignCenter
//                Layout.maximumWidth: parent.width
//                Layout.minimumWidth: parent.width - 30 //minus the paddings
//                Layout.topMargin: 15
//                wrapMode: Text.WordWrap
//                leftPadding: 15
//                rightPadding: 15
//                horizontalAlignment: Text.AlignHCenter
//                font: DexTypo.head6
//                text: qsTr("Crypto Collider Trading Arena")
//            }

//            DefaultText {
//                Layout.alignment: Qt.AlignCenter
//                Layout.maximumWidth: parent.width
//                Layout.topMargin: 15
//                wrapMode: Text.WordWrap
//                leftPadding: 15
//                rightPadding: 15
//                text_value: qsTr("Lorem ipsum dolor sit amet, sea modus choro constituto eu. Ex nec ignota delenit officiis, ei nam ferri tantas doming. Vel ei solet populo, per ad facilis iracundia definitionem. Mei option dissentiunt cu, mea legimus placerat et. Praesent postulant vis ut, in utinam bonorum fabulas has")
//            }

//            DexButton {
////                enabled: General.autoPlaying ? false : true //can't open CryptoCollider while using auto-play
//                Layout.alignment: Qt.AlignCenter
//                Layout.maximumWidth: parent.width - 80
//                Layout.minimumWidth: parent.width - 80
//                Layout.maximumHeight: 60
//                Layout.minimumHeight: 60
//                Layout.topMargin: 60 * (arena.height / 532)
//                text: qsTr("Play Collider Arena")
//                onClicked: openArena()
//            }

//            DexButton {
//                Layout.alignment: Qt.AlignCenter
//                Layout.maximumWidth: parent.width - 80
//                Layout.minimumWidth: parent.width - 80
//                Layout.maximumHeight: 60
//                Layout.minimumHeight: 60
//                Layout.topMargin: 60 * (arena.height / 532)
//                text: qsTr("Auto-Play")
//                onClicked: openAutoPlay()
////                onClicked: someObject.preloadCoin("KMD", "testAddress")
//            }
//        }
//    }
}
