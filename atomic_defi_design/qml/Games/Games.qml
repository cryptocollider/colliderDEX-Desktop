import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0

import Qaterial 1.0 as Qaterial

import "../Components"
import "../Constants"

Item {
    id: games

    Layout.fillWidth: true
    Layout.fillHeight: true
    DefaultText {
        anchors.centerIn: parent
        text_value: qsTr("Content for this section will be added later. Stay tuned! -GAMES")
    }

//    ColumnLayout{
//        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
//        layoutDirection: Qt.LeftToRight

//        FloatingBackground{
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            Layout.bottomMargin: 10
//            Layout.topMargin: 10
//            Layout.leftMargin: 10
//            Layout.rightMargin: 10
//        }

//        FloatingBackground{
//            Layout.fillWidth: true
//            Layout.fillHeight: true
//            Layout.bottomMargin: 10
//            Layout.topMargin: 10
//            Layout.leftMargin: 10
//            Layout.rightMargin: 10
//        }
//    }
}
