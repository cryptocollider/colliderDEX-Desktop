import QtQuick 2.12

import "../Components"
import "../Constants"
import Dex.Themes 1.0 as Dex

// FigurativeLine acts the same as Line but contains a figurative icon on the left of its label
Line
{
    property alias icon: _icon
    property bool isGamesLine: false

    DefaultImage
    {
        id: _icon
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 30
        height: 16
    }

    DefaultColorOverlay
    {
        enabled: !isGamesLine? true : General.inColliderApp ? false : true
        visible: !isGamesLine? true : General.inColliderApp ? false : true
        anchors.fill: _icon
        source: _icon
        color: !_icon.enabled ? Dex.CurrentTheme.textDisabledColor :
               mouseArea.containsMouse && currentLineType !== type       ? Dex.CurrentTheme.sidebarLineTextHovered :
               currentLineType === type && type != Main.LineType.Support ? Dex.CurrentTheme.sidebarLineTextSelected :
                                                                           Dex.CurrentTheme.foregroundColor
    }

    DefaultColorOverlay
    {
        enabled: !isGamesLine? false : General.inColliderApp ? true : false
        visible: !isGamesLine? false : General.inColliderApp ? true : false
        anchors.fill: _icon
        source: _icon
        color: mouseArea.containsMouse && currentLineType !== type       ? "#9c2c2c" :
               currentLineType === type && type != Main.LineType.Support ? "#9c2c2c" :
                                                                           "#910000"
    }
}
