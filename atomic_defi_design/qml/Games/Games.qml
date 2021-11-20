import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtWebChannel 1.0
import QtWebEngine 1.7
import QtMultimedia 5.12

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
    property var gamesDataList: {"userAddresses": addyList}

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
        tempTickr = "CLC"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyCLC = current_ticker_infos.address
        tempTickr = "BTC"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyBTC = current_ticker_infos.address
        tempTickr = "VRSC"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyVRSC = current_ticker_infos.address
        tempTickr = "CHIPS"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyCHIPS = current_ticker_infos.address
        tempTickr = "DASH"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyDASH = current_ticker_infos.address
        tempTickr = "DGB"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyDGB = current_ticker_infos.address
        tempTickr = "DOGE"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyDOGE = current_ticker_infos.address
        tempTickr = "ETH"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyETH = current_ticker_infos.address
        tempTickr = "LTC"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyLTC = current_ticker_infos.address
        tempTickr = "RVN"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyRVN = current_ticker_infos.address
        tempTickr = "XPM"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyXPM = current_ticker_infos.address
        tempTickr = "TKL"
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        addyTKL = current_ticker_infos.address
        dashboard.dataList = gamesDataList;
    }

    Timer {
        id: dex_user_data_timer
        interval: 2000
        repeat: false
        triggeredOnStart: false
        running: false
        onTriggered: checkDexUserData()
    }

    ColumnLayout{
        id: challenge
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: 500
        height: 500
        x: (parent.width * 0.25) - (width / 2)
        y: 40

        DexLabel{
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: 16
            horizontalAlignment: Text.AlignHCenter
            font: DexTypo.head4
            text: qsTr("Crypto Challenge")
        }

        DexButton{
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: 200
            Layout.minimumWidth: 120
            Layout.maximumHeight: 60
            Layout.minimumHeight: 80
            //Layout.topMargin: 70 * (arena.height / 532)
            Layout.topMargin: 16
            text: qsTr("Play")
            onClicked: openChallenge()
        }

        Video {
            width: 426
            height: 240
            Layout.topMargin: 16
            fillMode: VideoOutput.PreserveAspectFit
            flushMode: VideoOutput.FirstFrame
            source: General.image_path + "games-page-2.mp4"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    video.play()
                }
            }
            focus: true
        }

        DexLabel{
            Layout.alignment: Qt.AlignCenter
            font: DexTypo.head6
            text: qsTr("Fun way to learn Crypto")
        }
    }

    ColumnLayout{
        id: arena
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: 500
        height: 500
        x: (parent.width * 0.75) - (width / 2)
        y: 40

        DexLabel{
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: parent.width
            Layout.minimumWidth: parent.width - 30 //minus the paddings
            Layout.topMargin: 16
            wrapMode: Text.WordWrap
            leftPadding: 15
            rightPadding: 15
            horizontalAlignment: Text.AlignHCenter
            font: DexTypo.head4
            text: qsTr("Crypto Collider Trading Arena")
        }

        DexButton{
            //enabled: General.autoPlaying ? false : true //can't open CryptoCollider while using auto-play
            Layout.alignment: Qt.AlignCenter
            Layout.maximumWidth: 200
            Layout.minimumWidth: 120
            Layout.maximumHeight: 60
            Layout.minimumHeight: 80
            //Layout.topMargin: 60 * (arena.height / 532)
            Layout.topMargin: 16
            text: qsTr("Play")
            onClicked: openArena()
        }

        Video{
            width: 426
            height: 240
            Layout.topMargin: 16
            fillMode: VideoOutput.PreserveAspectFit
            flushMode: VideoOutput.FirstFrame
            source: General.image_path + "games-page-2.mp4"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    video.play()
                }
            }
            focus: true
        }

        DexLabel{
            Layout.alignment: Qt.AlignCenter
            font: DexTypo.head6
            text: qsTr("Use Skill and grow your assets")
        }
    }

    ColumnLayout{
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: 720
        height: 160
        x: (parent.width / 2) - (width / 2)
        y: 580

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
            Layout.topMargin: 16
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
            leftPadding: 15
            rightPadding: 15
            horizontalAlignment: Text.AlignHCenter
            font: DexTypo.head6
            text: qsTr("diversify your assets & mine Collider Coin")
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
