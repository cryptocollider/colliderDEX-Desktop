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
import App 1.0
import Dex.Themes 1.0 as Dex

Item {
    id: games
    anchors.fill: parent
    property string g1: qsTr("Waiting: ")
    property string g2: qsTr("Play")
    property string g3: qsTr("Auto Hedging")
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
//        webIndex.url = "qrc:///atomic_defi_design/qml/Games/testCom.html"
        if(!General.openedArena){
            webIndex.url = "https://cryptocollider.com/app/indexDex.html"
            buildAddyList();
            dex_user_data_timer.restart()
            General.openedArena = true
        }
        if(challenge_video.playbackState === MediaPlayer.PlayingState || arena_video.playbackState === MediaPlayer.PlayingState){
            challenge_video.stop()
            arena_video.stop()
        }
        checkVids();
        General.inArena = true
    }

    function openChallenge(){
        if(!General.openedChallenge){
            webChallenge.url = "https://cryptocollider.com/challenge/app"
            buildAddyList();
            General.openedChallenge = true
        }
        if(challenge_video.playbackState === MediaPlayer.PlayingState || arena_video.playbackState === MediaPlayer.PlayingState){
            challenge_video.stop()
            arena_video.stop()
        }
        checkVids();
        General.inChallenge = true
    }

    function openAutoPlay(){
        if(!General.openedArena){
            webIndex.url = "https://cryptocollider.com/app/indexDex.html"
            buildAddyList();
            dex_user_data_timer.restart()
            General.openedArena = true
        }
        if(!General.openedAutoP){
            autoHedge.runCoinData();
            autoHedge.throwSeconds = 0;
            General.apCanThrow = true;
            General.openedAutoP = true;
        }
        if(challenge_video.playbackState === MediaPlayer.PlayingState || arena_video.playbackState === MediaPlayer.PlayingState){
            challenge_video.stop()
            arena_video.stop()
        }
        checkVids();
        tempTickr = General.apCurrentTicker
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        General.inAuto = true
    }

    function checkVids(){
        if(autoHedge.hasColliderData){
            if(autoHedge.colliderJsonData.seenVids == "1"){
                autoHedge.colliderJsonData.seenVids = "2";
                var colliderJsonFilename = app.currentWalletName + ".col.json"
                var overWright = true
                if(API.qt_utilities.save_collider_data(colliderJsonFilename, autoHedge.colliderJsonData, overWright)){
                    //testLabel.text = "set collider data"
                }else{
                    //testLabel.text = "failed set collider data"
                }
            }else{
            }
        }
        dashboard.watchedVids = true;
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
        challengeObject.clcAddy = addyCLC
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

    Timer {
        id: dex_user_data_timer
        interval: 2000
        repeat: false
        triggeredOnStart: false
        running: false
        onTriggered: checkDexUserData()
    }

    DexRectangle{
        id: challenge
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: 490
        height: 500
        x: (parent.width * 0.25) - (width / 2)
        y: 40
        gradient: Gradient
        {
            orientation: Gradient.Vertical
            GradientStop { position: 0.001; color: Dex.CurrentTheme.innerBackgroundColor }
            GradientStop { position: 1; color: Dex.CurrentTheme.backgroundColor }
        }
        DexLabel{
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 28
            font: Qt.font({
                pixelSize: 36,
                letterSpacing: 0.15,
                family: "Ubuntu",
                weight: Font.Medium
            })
            text: qsTr("Crypto Challenge")
        }
        DexLabel{
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            font: Qt.font({
                pixelSize: 20,
                letterSpacing: 0.15,
                family: "Ubuntu",
                weight: Font.Normal
            })
            text: qsTr("Fun way to learn Crypto")
        }
        DexButton{
            width: 240
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            font: Qt.font({
                pixelSize: 28,
                letterSpacing: 0.25,
                family: "Ubuntu",
                weight: Font.Medium
            })
            border.color: enabled ? Dex.CurrentTheme.accentColor : DexTheme.contentColorTopBold
            text: qsTr("Play")
            onClicked: openChallenge()
        }
        Rectangle{
            width: 426
            height: 240
            anchors.left: parent.left
            anchors.leftMargin: 32
            y: 140
            Video {
                id: challenge_video
                visible: dashboard.challengeVideo ? true : dashboard.watchedVids ? false : autoHedge.colliderJsonData.seenVids === "1" ? true : false
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectFit
                source: General.image_path + "games-page-challenge.avi"
                autoLoad: autoHedge.colliderJsonData.seenVids === "1" ? true : false
                autoPlay: true
                onStopped: {
                    dashboard.challengeVideo = false
                    checkVids();
                }
            }
            Image{
                visible: dashboard.challengeVideo ? false : dashboard.watchedVids ? true : autoHedge.colliderJsonData.seenVids === "1" ? false : true
                anchors.fill: parent
                source: General.image_path + "still-challenge.png"
            }
            Image{
                id: challenge_play
                visible: dashboard.challengeVideo ? false : dashboard.watchedVids ? true : autoHedge.colliderJsonData.seenVids === "1" ? false : true
                anchors.fill: parent
                source: General.image_path + "video-play.png"
            }
            ColorOverlay{
                visible: dashboard.challengeVideo ? false : dashboard.watchedVids ? true : autoHedge.colliderJsonData.seenVids === "1" ? false : true
                source: challenge_play
                color: challenge_mouse.containsMouse ? Qt.rgba(1.0, 1.0, 1.0, 0.6) : Qt.rgba(1.0, 1.0, 1.0, 0.2)
            }
            MouseArea{
                id: challenge_mouse
                enabled: dashboard.challengeVideo ? false : dashboard.watchedVids ? true : autoHedge.colliderJsonData.seenVids === "1" ? false : true
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    challenge_video.play()
                    dashboard.challengeVideo = true
                }
            }
        }
    }

    DexRectangle{
        id: arena
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: 490
        height: 500
        x: (parent.width * 0.75) - (width / 2)
        y: 40
        gradient: Gradient
        {
            orientation: Gradient.Vertical
            GradientStop { position: 0.001; color: Dex.CurrentTheme.innerBackgroundColor }
            GradientStop { position: 1; color: Dex.CurrentTheme.backgroundColor }
        }
        DexLabel{
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 8
            font: Qt.font({
                pixelSize: 36,
                letterSpacing: 0.15,
                family: "Ubuntu",
                weight: Font.Medium
            })
            text: qsTr("Crypto Collider")
        }
        DexLabel{
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 48
            font: Qt.font({
                pixelSize: 36,
                letterSpacing: 0.15,
                family: "Ubuntu",
                weight: Font.Medium
            })
            text: qsTr("Trading Arena")
        }
        DexLabel{
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.top: parent.top
            anchors.topMargin: 100
            font: Qt.font({
                pixelSize: 20,
                letterSpacing: 0.15,
                family: "Ubuntu",
                weight: Font.Normal
            })
            text: qsTr("Throw & Grow your Assets!")
        }
        DexButton{
            enabled: autoHedge.colliderJsonData.seenVids == "2" ? true : autoHedge.doneInitialBoot ? true : false
            width: 240
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 30
            font: Qt.font({
                pixelSize: 28,
                letterSpacing: 0.25,
                family: "Ubuntu",
                weight: Font.Medium
            })
            border.color: enabled ? Dex.CurrentTheme.accentColor : DexTheme.contentColorTopBold
            text: autoHedge.colliderJsonData.seenVids == "2" ? g2 : autoHedge.doneInitialBoot ? g2 : g1 + autoHedge.initialBootTime
            onClicked: openArena()
        }
        Rectangle{
            width: 426
            height: 240
            anchors.left: parent.left
            anchors.leftMargin: 32
            y: 140
            Video {
                id: arena_video
                visible: dashboard.arenaVideo ? true : dashboard.watchedVids ? false : autoHedge.colliderJsonData.seenVids === "1" ? true : false
                anchors.fill: parent
                fillMode: VideoOutput.PreserveAspectFit
                source: General.image_path + "games-page-collider.avi"
                autoLoad: autoHedge.colliderJsonData.seenVids === "1" ? true : false
                autoPlay: true
                onStopped: {
                    dashboard.arenaVideo = false
                    checkVids();
                }
            }
            Image{
                visible: dashboard.arenaVideo ? false : dashboard.watchedVids ? true : autoHedge.colliderJsonData.seenVids === "1" ? false : true
                anchors.fill: parent
                source: General.image_path + "still-arena.png"
            }
            Image{
                id: arena_play
                visible: dashboard.arenaVideo ? false : dashboard.watchedVids ? true : autoHedge.colliderJsonData.seenVids === "1" ? false : true
                anchors.fill: parent
                source: General.image_path + "video-play.png"
            }
            ColorOverlay{
                visible: dashboard.arenaVideo ? false : dashboard.watchedVids ? true : autoHedge.colliderJsonData.seenVids === "1" ? false : true
                source: arena_play
                color: arena_mouse.containsMouse ? Qt.rgba(1.0, 1.0, 1.0, 0.6) : Qt.rgba(1.0, 1.0, 1.0, 0.2)
            }
            MouseArea{
                id: arena_mouse
                enabled: dashboard.arenaVideo ? false : dashboard.watchedVids ? true : autoHedge.colliderJsonData.seenVids === "1" ? false : true
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    arena_video.play()
                    dashboard.arenaVideo = true
                }
            }
        }
    }

    DexRectangle{
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: 640
        height: 160
        x: (parent.width / 2) - (width / 2)
        y: 580 + (0.625 * (window.height - (General.minimumHeight - 1)))
        gradient: Gradient
        {
            orientation: Gradient.Vertical
            GradientStop { position: 0.001; color: Dex.CurrentTheme.innerBackgroundColor }
            GradientStop { position: 1; color: Dex.CurrentTheme.backgroundColor }
        }
        DexButton{
            enabled: autoHedge.colliderJsonData.seenVids == "2" ? true : autoHedge.doneInitialBoot ? true : false
            width: API.app.settings_pg.lang == "ru" || "tr" ? 460 : 320
            height: 60
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 16
            font: Qt.font({
                pixelSize: 28,
                letterSpacing: 0.25,
                family: "Ubuntu",
                weight: Font.Medium
            })
            border.color: enabled ? Dex.CurrentTheme.accentColor : DexTheme.contentColorTopBold
            text: autoHedge.colliderJsonData.seenVids == "2" ? g3 : autoHedge.doneInitialBoot ? g3 : g1 + autoHedge.initialBootTime
            onClicked: openAutoPlay()
        }
        ColumnLayout{
            anchors.fill: parent
            DexLabel{
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width
                Layout.minimumWidth: parent.width - 30 //minus the paddings
                Layout.topMargin: 84
                wrapMode: Text.WordWrap
                leftPadding: 15
                rightPadding: 15
                horizontalAlignment: Text.AlignHCenter
                font: Qt.font({
                    pixelSize: 20,
                    letterSpacing: 0.15,
                    family: "Ubuntu",
                    weight: Font.Normal
                })
                text: qsTr("Provide automated game liquidity to")
            }
            DexLabel{
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width
                Layout.minimumWidth: parent.width - 30 //minus the paddings
                wrapMode: Text.WordWrap
                bottomPadding: 20
                leftPadding: 15
                rightPadding: 15
                horizontalAlignment: Text.AlignHCenter
                font: Qt.font({
                    pixelSize: 20,
                    letterSpacing: 0.15,
                    family: "Ubuntu",
                    weight: Font.Normal
                })
                text: qsTr("diversify your assets & mine Collider Coin")
            }
        }
    }
}
