import QtQuick 2.12
import QtQuick.Layouts 1.2

import App 1.0
import "../Components"
import "../Constants"
import "../Screens"
import Dex.Themes 1.0 as Dex

MouseArea
{
    property alias spacing: _columnLayout.spacing

    signal lineSelected(var lineType)

    height: lineHeight * 5
    hoverEnabled: true

    Connections
    {
        target: parent.parent

        function onIsExpandedChanged()
        {
            if (isExpanded) waitForSidebarExpansionAnimation.start();
            else
            {
                _portfolioLine.label.opacity = 0;
                _walletLine.label.opacity = 0;
                _dexLine.label.opacity = 0;
                //_addressBookLine.label.opacity = 0;
                //_fiatLine.label.opacity = 0;
                _arbibotLine.label.opacity = 0;
                _gamesLine.label.opacity = 0;
                _coinSightLine.label.opacity = 0;
                _discordLine.label.opacity = 0;
            }
        }
    }

    NumberAnimation
    {
        id: waitForSidebarExpansionAnimation
        targets: [_portfolioLine.label, _walletLine.label, _dexLine.label, _arbibotLine.label, _gamesLine.label, _coinSightLine.label, _discordLine.label]
        properties: "opacity"
        duration: 200
        from: 0
        to: 0
        onFinished: labelsOpacityAnimation.start()
    }

    NumberAnimation
    {
        id: labelsOpacityAnimation
        targets: [_portfolioLine.label, _walletLine.label, _dexLine.label, _arbibotLine.label, _gamesLine.label, _coinSightLine.label, _discordLine.label]
        properties: "opacity"
        duration: 350
        from: 0.0
        to: 1
    }

    // Selection List
    ColumnLayout
    {
        id: _columnLayout
        anchors.fill: parent
        FigurativeLine
        {
            id: _portfolioLine

            Layout.fillWidth: true
            type: Main.LineType.Portfolio
            label.text: isExpanded ? qsTr("Portfolio") : ""
            icon.source: General.image_path + "menu-assets-portfolio.svg"
            onClicked: lineSelected(type)
        }

        FigurativeLine
        {
            id: _walletLine

            Layout.fillWidth: true
            type: Main.LineType.Wallet
            label.text: isExpanded ? qsTr("Wallet") : ""
            icon.source: General.image_path + "menu-assets-white.svg"
            onClicked: lineSelected(type)
        }

        FigurativeLine
        {
            id: _dexLine

            Layout.fillWidth: true
            type: Main.LineType.DEX
            label.text: isExpanded ? qsTr("DEX") : ""
            icon.source: General.image_path + "menu-exchange-white.svg"
            onClicked: lineSelected(type)
        }

//        FigurativeLine
//        {
//            id: _addressBookLine

//            Layout.fillWidth: true
//            type: Main.LineType.Addressbook
//            label.text: isExpanded ? qsTr("Address Book") : ""
//            icon.source: General.image_path + "menu-news-white.svg"
//            onClicked: lineSelected(type)
//        }

//        FigurativeLine
//        {
//            id: _fiatLine

//            label.enabled: false
//            icon.enabled: false
//            Layout.fillWidth: true
//            label.text: isExpanded ? qsTr("Fiat") : ""
//            icon.source: General.image_path + "bill.svg"
//        }

        FigurativeLine
        {
            id: _arbibotLine

            Layout.fillWidth: true
            type: Main.LineType.Arbibot
            label.text: isExpanded ? qsTr("Arbitration Bot") : ""
            icon.source: General.image_path + "bill.svg"
            onClicked: lineSelected(type)
        }

        FigurativeLine
        {
            id: _gamesLine

            Layout.fillWidth: true
            type: Main.LineType.Games
            label.text: isExpanded ? qsTr("Games") : ""
            icon.source: General.inColliderApp && dashboard.currentPage === Dashboard.PageType.Games ? General.image_path + "menu-games-exit.svg" : General.image_path + "menu-games-white.svg"
            isGamesLine: true
            onClicked: lineSelected(type)
        }

        FigurativeLine
        {
            id: _coinSightLine

            Layout.fillWidth: true
            type: Main.LineType.CoinSight
            label.text: isExpanded ? qsTr("coinSight") : ""
            icon.source: General.image_path + "menu-games-white.svg"
            onClicked: lineSelected(type)
        }

        FigurativeLine
        {
            id: _discordLine

            Layout.fillWidth: true
            type: Main.LineType.Discord
            label.text: isExpanded ? qsTr("Discord") : ""
            icon.source: General.image_path + "menu-discord-white.svg"
            icon.anchors.leftMargin: 26
            onClicked: lineSelected(type)
        }
    }
}
