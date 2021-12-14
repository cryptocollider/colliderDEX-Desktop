import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtQml.Models 2.1

import Qaterial 1.0 as Qaterial

import "../Components"
import "../Constants"


RowLayout{
    property string elementName: ""
    Rectangle{
        //width: 64
        //height: 64
        color: 'blue'
    }
    DefaultText{
        Layout.alignment: Qt.AlignHCenter
        wrapMode: Text.WordWrap
        text: qsTr(elementName)
    }
}

