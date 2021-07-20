import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "../Constants"

Item {
    property alias back_image: back_image
    property alias back_image_path: back_image.source
    property alias image: image
    property alias image_path: image.source
    property alias image_scale: image.scale
    property alias content: inner_space.sourceComponent
    property alias bottom_content: bottom_content.sourceComponent
    property double image_margin: 5

    Image {
        id: back_image
        width: window.application.width
        height: window.application.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        visible: true
//        antialiasing: true
    }

    ColumnLayout {
        id: window_layout

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        transformOrigin: Item.Center
        spacing: image_margin

        DefaultImage {
            id: image
//            Layout.maximumWidth: 300
//            Layout.maximumHeight: Layout.maximumWidth * paintedHeight/paintedWidth

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            antialiasing: true
        }

        Pane {
            id: pane

            leftPadding: 30
            rightPadding: leftPadding
            topPadding: leftPadding * 0.5
            bottomPadding: topPadding

            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            background: FloatingBackground {
                color: theme.backgroundColor
            }

            Loader {
                id: inner_space
            }
        }

        Loader {
            id: bottom_content
            Layout.alignment: Qt.AlignHCenter
        }
    }
}
