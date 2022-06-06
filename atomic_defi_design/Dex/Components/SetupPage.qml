import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.2

import "../Constants"
import App 1.0
import Dex.Themes 1.0 as Dex

Item
{
    id: _control

    property alias back_image: back_image
    property alias back_image_path: back_image.source
    property alias image: image
    property alias image_path: image.source
    property alias image_scale: image.scale
    property alias content: inner_space.sourceComponent
    property alias bottom_content: bottom_content.sourceComponent
    property double image_margin: 5
    property color backgroundColor: 'transparent' //Dex.CurrentTheme.floatingBackgroundColor
    property int verticalCenterOffset: 0

    Image {
        id: back_image
        source: General.image_path + "final-background.gif"
        width: window.width
        height: window.height - 30
        y: 0
        visible: true
//        antialiasing: true
    }

    ColumnLayout
    {
        id: window_layout

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: _control.verticalCenterOffset
        transformOrigin: Item.Center
        spacing: image_margin

        DefaultImage
        {
            id: image
            Layout.maximumWidth: 300
            Layout.maximumHeight: Layout.maximumWidth * paintedHeight / paintedWidth

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            antialiasing: true
        }

        Pane
        {
            id: pane

            leftPadding: 30
            rightPadding: leftPadding
            topPadding: leftPadding * 0.5
            bottomPadding: topPadding
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            background: DefaultRectangle
            {
                radius: 20
                color: _control.backgroundColor
            }

            contentChildren: Loader
            {
                id: inner_space
            }
        }

        Loader
        {
            id: bottom_content
            Layout.alignment: Qt.AlignHCenter
        }
    }

    DexLanguage
    {
        y: 52
        anchors.right: parent.right
        anchors.rightMargin: 52
        width: 72
    }

}
