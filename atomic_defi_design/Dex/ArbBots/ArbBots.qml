import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtQml.Models 2.15
import QtQml 2.2
import Qaterial 1.0 as Qaterial

import "../Components"
import "../Constants"
import Dex.Themes 1.0 as Dex


Item {
    id: arb_bot
    anchors.fill: parent
    property var mdlist: ["KMD", "CLC", "RVN", "TKL", "VRSC", "XPM", "DASH", "DOGE", "ETH", "BTC", "LTC", "DGB", "CHIPS"]

    function openCreateBot(){
        bot_logic.inCreateBot = true;
    }

    Shortcut {
        sequence: "F7"
        onActivated: bot_logic.setArbData()
    }

    CreateArb{
        id: create_arb
        enabled: bot_logic.inCreateBot
        visible: bot_logic.inCreateBot
    }
    DexLabel{
        enabled: bot_logic.inCreateBot || bot_logic.inBotStats ? false : true
        visible: bot_logic.inCreateBot || bot_logic.inBotStats ? false : true
        anchors.horizontalCenter: arb_overview_panel.horizontalCenter
        y: 20
        text: qsTr("Automated Arbitration Overview")
        font: DexTypo.head4
        color: 'white'
    }
    DexRectangle{
        id: arb_overview_panel
        enabled: bot_logic.inCreateBot || bot_logic.inBotStats ? false : true
        visible: bot_logic.inCreateBot || bot_logic.inBotStats ? false : true
        width: parent.width - 30
        height: parent.height - 200
        x: 15
        y: 90
        Item{ //HEADER PANEL
            id: arb_overview_header
            width: parent.width
            height: 72
            y: 6
            DexLabel{
                id: arb_ov_id_text
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: 10
                text: "ID"
                font: DexTypo.head5
                color: 'white'
            }
            DexLabel{
                id: arb_ov_coinA_txt
                width: parent.width * 0.23
                x: (parent.width * 0.18) - (width / 2)
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Coin A")
                font: DexTypo.head5
                color: 'white'
                DexLabel{
                    id: arb_ov_coinA_bal
                    anchors.top: parent.bottom
                    anchors.left: parent.left
                    anchors.topMargin: 10
                    anchors.leftMargin: 12
                    text: qsTr("Balance:")
                    font: DexTypo.body1
                    color: 'white'
                }
                DexLabel{
                    anchors.top: parent.bottom
                    anchors.right: arb_ov_coinA_mid.left
                    anchors.topMargin: 10
                    anchors.rightMargin: 12
                    text: "Min"
                    font: DexTypo.body1
                    color: 'white'
                }
                DexLabel{
                    id: arb_ov_coinA_mid
                    x: (arb_ov_coinA_bal.width / 2) + ((parent.width - (arb_ov_coinB_bal.width / 2)) / 2)
                    anchors.top: parent.bottom
                    anchors.topMargin: 10
                    text: "/"
                    font: DexTypo.body1
                    color: 'white'
                }
                DexLabel{
                    anchors.top: parent.bottom
                    anchors.left: arb_ov_coinA_mid.right
                    anchors.topMargin: 10
                    anchors.leftMargin: 12
                    text: qsTr("Current")
                    font: DexTypo.body1
                    color: 'white'
                }
            }
            DexLabel{
                id: arb_ov_coinB_txt
                width: parent.width * 0.23
                x: (parent.width * 0.42) - (width / 2)
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("Coin B")
                font: DexTypo.head5
                color: 'white'
                DexLabel{
                    id: arb_ov_coinB_bal
                    anchors.top: parent.bottom
                    anchors.left: parent.left
                    anchors.topMargin: 10
                    anchors.leftMargin: 12
                    text: qsTr("Balance:")
                    font: DexTypo.body1
                    color: 'white'
                }
                DexLabel{
                    anchors.top: parent.bottom
                    anchors.right: arb_ov_coinB_mid.left
                    anchors.topMargin: 10
                    anchors.rightMargin: 12
                    text: "Min"
                    font: DexTypo.body1
                    color: 'white'
                }
                DexLabel{
                    id: arb_ov_coinB_mid
                    x: (arb_ov_coinB_bal.width / 2) + ((parent.width - (arb_ov_coinB_bal.width / 2)) / 2)
                    anchors.top: parent.bottom
                    anchors.topMargin: 10
                    text: "/"
                    font: DexTypo.body1
                    color: 'white'
                }
                DexLabel{
                    anchors.top: parent.bottom
                    anchors.left: arb_ov_coinB_mid.right
                    anchors.topMargin: 10
                    anchors.leftMargin: 12
                    text: qsTr("Current")
                    font: DexTypo.body1
                    color: 'white'
                }
            }
            DexLabel{
                id: arb_ov_24hr_txt
                width: parent.width * 0.29
                x: (parent.width * 0.69) - (width / 2)
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignHCenter
                text: qsTr("24hr Stats")
                font: DexTypo.head5
                color: 'white'
                DexLabel{
                    id: arb_ov_volume
                    x: (parent.width / 4) - (width / 2)
                    anchors.top: parent.bottom
                    anchors.topMargin: 10
                    text: qsTr("Volume")
                    font: DexTypo.body1
                    color: 'white'
                }
                DexLabel{
                    id: arb_ov_vol_avg
                    x: (parent.width * 0.65) - (width / 2)
                    anchors.top: parent.bottom
                    anchors.topMargin: 10
                    text: "Avg.%"
                    font: DexTypo.body1
                    color: 'white'
                }
                DexLabel{
                    id: arb_ov_vol_target
                    //x: (parent.width * 0.82) - (width / 2)
                    anchors.right: parent.right
                    anchors.top: parent.bottom
                    anchors.topMargin: 10
                    text: qsTr("Target%")
                    font: DexTypo.body1
                    color: 'white'
                }
            }
            DexLabel{
                //width: parent.width * 0.18
                //x: (parent.width * 0.92) - (width / 2)
                horizontalAlignment: Text.AlignRight
                anchors.right: arb_ov_main_switch.left
                anchors.rightMargin: 8
                anchors.verticalCenter: arb_ov_main_switch.verticalCenter
                text: qsTr("All Bots")
                font: DexTypo.body1
            }
            DefaultSwitch {
                id: arb_ov_main_switch
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 4
                anchors.topMargin: 8
                checked: true
                //onCheckedChanged:
                //Component.onDestruction:
            }
            Rectangle {
                color: DexTheme.foregroundColor
                opacity: .2
                width: parent.width - 20
                height: 1.5
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }
        }
        DefaultListView {
            id: arb_ov_list
            width: parent.width
            height: parent.height - 76
            anchors.bottom: parent.bottom
            model: mdlist
            delegate: DexRectangle {
                //id: rectangle
                width: arb_ov_list.width
                height: 40
                radius: 0
                border.width: 0
                colorAnimation: false
                color: arb_ov_list_hover.containsMouse? DexTheme.buttonColorHovered : 'transparent'
                MouseArea {
                    id: arb_ov_list_hover
                    hoverEnabled: true
                    anchors.fill: parent
                }
                Item{
                    id: arb_ov_list_id_anchor
                    width: arb_ov_id_text.width
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }
                DexLabel{
                    //x: 16
                    anchors.horizontalCenter: arb_ov_list_id_anchor.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: index + 1
                    font: DexTypo.body1
                }
                DefaultImage {
                    width: 32
                    height: 32
                    y: 4
                    x: arb_ov_coinA_txt.x - 32
                    source: General.image_path + "kucoin.png"
                }
                DefaultImage {
                    width: 32
                    height: 32
                    y: 4
                    x: arb_ov_coinA_txt.x + 20
                    source: General.coin_icons_path + modelData.toLowerCase() + ".png"
                }
                DexLabel{
                    anchors.right: arb_ov_list_coinA_anchor.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 12
                    text: "12345"
                    font: DexTypo.body1
                }
                DexLabel{
                    id: arb_ov_list_coinA_anchor
                    x: arb_ov_coinA_txt.x + arb_ov_coinA_mid.x
                    anchors.verticalCenter: parent.verticalCenter
                    text: "/"
                    font: DexTypo.body1
                }
                DexLabel{
                    anchors.left: arb_ov_list_coinA_anchor.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 12
                    text: "12345"
                    font: DexTypo.body1
                }
                DefaultImage {
                    width: 32
                    height: 32
                    y: 4
                    x: arb_ov_coinB_txt.x + 20
                    source: General.coin_icons_path + modelData.toLowerCase() + ".png"
                }
                DexLabel{
                    anchors.right: arb_ov_list_coinB_anchor.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 12
                    text: "12345"
                    font: DexTypo.body1
                }
                DexLabel{
                    id: arb_ov_list_coinB_anchor
                    x: arb_ov_coinB_txt.x + arb_ov_coinB_mid.x
                    anchors.verticalCenter: parent.verticalCenter
                    text: "/"
                    font: DexTypo.body1
                }
                DexLabel{
                    anchors.left: arb_ov_list_coinB_anchor.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 12
                    text: "12345"
                    font: DexTypo.body1
                }
                DexLabel{
                    anchors.right: arb_ov_list_volume_anchor.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 12
                    text: "12345"
                    font: DexTypo.body1
                }
                DexLabel{
                    id: arb_ov_list_volume_anchor
                    x: arb_ov_24hr_txt.x + arb_ov_volume.x + 30
                    anchors.verticalCenter: parent.verticalCenter
                    text: "/"
                    font: DexTypo.body1
                }
                DexLabel{
                    anchors.left: arb_ov_list_volume_anchor.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 12
                    text: "12345"
                    font: DexTypo.body1
                }
                Item{
                    id: arb_ov_list_avg_anchor
                    x: arb_ov_24hr_txt.x + arb_ov_vol_avg.x + 32
                }
                DexLabel{
                    anchors.horizontalCenter: arb_ov_list_avg_anchor.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "67%"
                    font: DexTypo.body1
                }
                Item{
                    id: arb_ov_list_target_anchor
                    x: arb_ov_24hr_txt.x + arb_ov_vol_target.x + 40
                }
                DexLabel{
                    anchors.horizontalCenter: arb_ov_list_target_anchor.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    text: "34%"
                    font: DexTypo.body1
                }
                DexAppButton{
                    id: arb_ov_list_edit
                    width: 32
                    height: 32
                    y: 4
                    anchors.right: parent.right
                    anchors.rightMargin: 126
                    color: DexTheme.iconButtonColor
                    //foregroundColor: DexTheme.iconButtonForegroundColor
                    opacity: containsMouse ? .7 : 1
                    ToolTip.delay: 500
                    ToolTip.timeout: 5000
                    ToolTip.visible: containsMouse
                    ToolTip.text: "Edit"
                    //onClicked: _subHistoryRoot.displayFilter = !_subHistoryRoot.displayFilter
                    Image{
                        width: 28
                        height: 28
                        anchors.centerIn: parent
                        source: General.image_path + "menu-settings-white.svg"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: parent.color = 'steelblue'
                    }
                }
                DexAppButton{
                    id: arb_ov_list_stats
                    width: 32
                    height: 32
                    y: 4
                    anchors.right: parent.right
                    anchors.rightMargin: 86
                    color: DexTheme.iconButtonColor
                    //foregroundColor: DexTheme.iconButtonForegroundColor
                    opacity: containsMouse ? .7 : 1
                    ToolTip.delay: 500
                    ToolTip.timeout: 5000
                    ToolTip.visible: containsMouse
                    ToolTip.text: "Stats"
                    //onClicked: _subHistoryRoot.displayFilter = !_subHistoryRoot.displayFilter
                    Image{
                        width: 32
                        height: 32
                        anchors.centerIn: parent
                        source: General.image_path + "icon-stats.png"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: parent.color = 'steelblue'
                    }
                }
                DefaultSwitch {
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: 4
                    checked: true
                    //onCheckedChanged:
                    //Component.onDestruction:
                }
                Rectangle {
                    color: DexTheme.foregroundColor
                    opacity: .2
                    width: parent.width - 20
                    height: 1.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                }
            }
        }
    }
    DexAppButton {
        id: new_bot
        enabled: bot_logic.inCreateBot || bot_logic.inBotStats ? false : true
        visible: bot_logic.inCreateBot || bot_logic.inBotStats ? false : true
        width: 180
        height: 50
        radius: 16
        anchors.horizontalCenter: arb_overview_panel.horizontalCenter
        anchors.top: arb_overview_panel.bottom
        anchors.topMargin: 20
        text: qsTr("NEW BOT")
        font.pixelSize: Style.textSize
        onClicked: openCreateBot()
    }
}
