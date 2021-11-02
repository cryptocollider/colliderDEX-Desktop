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
        "RVN": addyRVN
    }
    property var gamesDataList: {"userAddresses": addyList}

    function openArena(){
        buildAddyList();
//        webIndex.url = "https://cryptocollider.com/app/indexDex.html"
//        webIndex.url = "qrc:///atomic_defi_design/qml/Games/testCom.html"
        General.inArena = true
//        someObject.preloadCoin("KMD", "testAddress")
    }

    function openChallenge(){
        webChallenge.url = "https://cryptocollider.com/challenge/app"
        General.inChallenge = true
    }

    function openAutoPlay(){
        tempTickr = General.apCurrentTicker
        api_wallet_page.ticker = tempTickr
        dashboard.current_ticker = api_wallet_page.ticker
        General.inAuto = true
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
        dashboard.dataList = gamesDataList;
    }

    FloatingBackground{
        id: challenge
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: parent.width * 0.35
        height: parent.height * 0.7
        x: (parent.width * 0.5) - (width + 40) //half window - (width + margin)
        y: ((parent.height * 0.5) - (height * 0.5)) //half window - half height

        ColumnLayout{
            width: parent.width

            DexLabel {
                Layout.alignment: Qt.AlignCenter
                Layout.topMargin: 15
                font: DexTypo.head6
                text: qsTr("Crypto Challenge")
            }

            DefaultText {
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width
                Layout.topMargin: 15
                wrapMode: Text.WordWrap
                leftPadding: 15
                rightPadding: 15
                text_value: qsTr("Lorem ipsum dolor sit amet, sea modus choro constituto eu. Ex nec ignota delenit officiis, ei nam ferri tantas doming. Vel ei solet populo, per ad facilis iracundia definitionem. Mei option dissentiunt cu, mea legimus placerat et. Praesent postulant vis ut, in utinam bonorum fabulas has")
            }

            DexButton {
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width - 80
                Layout.minimumWidth: parent.width - 80
                Layout.maximumHeight: 60
                Layout.minimumHeight: 60
                Layout.topMargin: 70 * (arena.height / 532)
                text: qsTr("Play Crypto Challenge")
                onClicked: openChallenge()
            }
        }
    }

    FloatingBackground{
        id: arena
        enabled: General.inColliderApp ? false : true
        visible: General.inColliderApp ? false : true
        width: parent.width * 0.35
        height: parent.height * 0.7
        x: ((parent.width * 0.5) + 40) //half window + margin
        y: ((parent.height * 0.5) - (height * 0.5)) //half window - half height

        ColumnLayout{
            width: parent.width

            DexLabel {
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width
                Layout.minimumWidth: parent.width - 30 //minus the paddings
                Layout.topMargin: 15
                wrapMode: Text.WordWrap
                leftPadding: 15
                rightPadding: 15
                horizontalAlignment: Text.AlignHCenter
                font: DexTypo.head6
                text: qsTr("Crypto Collider Trading Arena")
            }

            DefaultText {
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width
                Layout.topMargin: 15
                wrapMode: Text.WordWrap
                leftPadding: 15
                rightPadding: 15
                text_value: qsTr("Lorem ipsum dolor sit amet, sea modus choro constituto eu. Ex nec ignota delenit officiis, ei nam ferri tantas doming. Vel ei solet populo, per ad facilis iracundia definitionem. Mei option dissentiunt cu, mea legimus placerat et. Praesent postulant vis ut, in utinam bonorum fabulas has")
            }

            DexButton {
//                enabled: General.autoPlaying ? false : true //can't open CryptoCollider while using auto-play
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width - 80
                Layout.minimumWidth: parent.width - 80
                Layout.maximumHeight: 60
                Layout.minimumHeight: 60
                Layout.topMargin: 60 * (arena.height / 532)
                text: qsTr("Play Collider Arena")
                onClicked: openArena()
            }

            DexButton {
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: parent.width - 80
                Layout.minimumWidth: parent.width - 80
                Layout.maximumHeight: 60
                Layout.minimumHeight: 60
                Layout.topMargin: 60 * (arena.height / 532)
                text: qsTr("Auto-Play")
                onClicked: openAutoPlay()
//                onClicked: someObject.preloadCoin("KMD", "testAddress")
            }
        }
    }
}
