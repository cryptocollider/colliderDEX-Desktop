import QtQuick 2.12

import "../Components"
import "../Constants"
import "../Screens"
import Dex.Themes 1.0 as Dex

Item
{
    id: root

    enum LineType
    {
        Portfolio,
        Wallet,
        DEX,         // DEX == Trading page
        Addressbook,
        Arbibot,
        Games,
        CoinSight,
        Discord,
        Support
    }

    property bool   isExpanded: containsMouse
    property real   lineHeight: 44
    property var    currentLineType: Main.LineType.Portfolio
    property alias  _selectionCursor: _selectionCursor
    property bool   containsMouse: mouseArea.containsMouse

    signal lineSelected(var lineType)
    signal settingsClicked()
    signal privacySwitched(var checked)
    signal expanded(var isExpanded)
    signal expandStarted(var isExpanding)

    width: isExpanded ? 200 : 80
    height: parent.height

    Timer {
        interval: 250
        repeat: false
        triggeredOnStart: false
        running: true
        onTriggered: {
            if(autoHedge.colliderJsonData.waitedInitial == "2"){
                currentLineType = Main.LineType.Games;
                root.lineSelected(Main.LineType.Games);
            }
        }
    }

    // Background Rectangle
    Rectangle
    {
        anchors.fill: parent
        color: Dex.CurrentTheme.sidebarBgColor
    }

    // Animation when changing width.
    Behavior on width
    {
        NumberAnimation { duration: 300; targets: [width, _selectionCursor.width]; properties: "width"; onRunningChanged: { if (!running) expanded(isExpanded); else expandStarted(isExpanded); } }
    }

    // Selection Cursor
    AnimatedRectangle
    {
        id: _selectionCursor

        y:
        {
            if (currentLineType === Main.LineType.Support) return bottom.y + lineHeight + bottom.spacing;
            else if(currentLineType === Main.LineType.Addressbook) return center.y + (Main.LineType.Wallet) * (lineHeight + center.spacing);
            else if(currentLineType === Main.LineType.Arbibot || Main.LineType.Games || Main.LineType.CoinSight || Main.LineType.Discord) return center.y + (currentLineType - 1) * (lineHeight + center.spacing);
            else if(currentLineType === Main.LineType.Portfolio || Main.LineType.Wallet || Main.LineType.DEX) return center.y + currentLineType * (lineHeight + center.spacing);
        }

        anchors.left: parent.left
        anchors.leftMargin: 12
        radius: 18
        width: parent.width - 14
        height: lineHeight

        opacity: .7

        gradient: Gradient
        {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.125; color: Dex.CurrentTheme.sidebarCursorStartColor }
            GradientStop { position: 0.933; color: Dex.CurrentTheme.sidebarCursorEndColor }
        }

        Behavior on y
        {
            NumberAnimation { duration: 180 }
        }
    }

    MouseArea
    {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        Top
        {
            id: top
            width: parent.width
            height: 180
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 16
        }

        Center
        {
            id: center
            width: parent.width
            anchors.top: top.bottom
            anchors.topMargin: 29.5
            onLineSelected:
            {
                if(lineType === Main.LineType.Games && General.inColliderApp && dashboard.currentPage === Dashboard.PageType.Games){
                    if(General.inAuto){
                        General.inAuto = false
                    }else{
                        if(dashboard.viewingArena){
                            General.inArena = false
                            General.inAuto = true
                            dashboard.viewingArena = false
                        }else{
                            General.inArena = false
                            General.inChallenge = false
                        }
                    }
                }
//                else if(dashboard.hasCoinSight){
//                    if(dashboard.inCoinSight && General.openedCoinSight){
//                        coin_sight_timer.restart()
//                    }
//                    if(currentLineType === Main.LineType.CoinSight){
//                        coin_sight_timer.stop()
//                        dashboard.idleCoinSight = false
//                        if(!General.openedCoinSight){
//                            webCoinS.url = "https://coinsig.ht"
//                            General.openedCoinSight = true
//                        }
//                    }
//                }
                else{
                    if(dashboard.currentPage === Dashboard.PageType.Wallet){
                        General.walletCurrentTicker = api_wallet_page.ticker
                    }else if(dashboard.currentPage === Dashboard.PageType.Games){
                        General.apCurrentTicker = api_wallet_page.ticker
                    }else{
                    }

                    if(lineType === Main.LineType.Wallet){
                        var tmpWtTick = General.walletCurrentTicker
                        api_wallet_page.ticker = tmpWtTick
                        dashboard.current_ticker = api_wallet_page.ticker
                    }else if(lineType === Main.LineType.Games){
                        var tmpApTick = General.apCurrentTicker
                        api_wallet_page.ticker = tmpApTick
                        dashboard.current_ticker = api_wallet_page.ticker
                    }else if(lineType === Main.LineType.Discord){
                        dashboard.openedDisc = true
                    }else if(lineType === Main.LineType.CoinSight && !General.openedCoinSight){
                        webCoinS.url = "https://coinsig.ht"
                        General.openedCoinSight = true
                    }
    //                if(General.inAuto){
    //                    var tmpTick = General.apCurrentTicker
    //                    api_wallet_page.ticker = tmpTick
    //                    dashboard.current_ticker = api_wallet_page.ticker
    //                }
                    currentLineType = lineType;
                    root.lineSelected(lineType);
                }
//                if (currentLineType === lineType)
//                    return;
//                currentLineType = lineType;
//                root.lineSelected(lineType);
            }
        }

        Bottom
        {
            id: bottom
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 62

            onSupportLineSelected:
            {
                if (currentLineType === lineType)
                    return;
                currentLineType = lineType;
                root.lineSelected(lineType);
            }
            onSettingsClicked: root.settingsClicked()
        }

        VerticalLine
        {
            height: parent.height
            anchors.right: parent.right
        }
    }
}
