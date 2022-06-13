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
    id: create_arb
    anchors.fill: parent
    property bool createApi: false
    property var apiList: []

    function closeCreateBot(){
        bot_logic.inCreateBot = false;
    }

    function verifyApi(){
        if(create_bot_cexName.length > 0 && create_bot_secretKey.length > 0 && create_bot_apiKey.length > 0 && create_bot_passPhrase.text > 0){
            return true
        }else{
            return false
        }
    }

    function resetApi(){
        create_bot_cexName.text = "";
        create_bot_secretKey.text = "";
        create_bot_apiKey.text = "";
        create_bot_passPhrase.text = "";
        createApi = false;
    }

    DexLabel{
        anchors.horizontalCenter: create_bot_panel.horizontalCenter
        y: 20
        text: qsTr("Create Arbitration Bot")
        font: DexTypo.head4
        color: 'white'
    }
    DexRectangle{
        id: create_bot_panel
        width: parent.width - 30
        height: parent.height < 769 ? 510 : parent.height > 897 ? 640 : 509 + (parent.height - 767)
        x: 15
        y: 90
        Item{ //CEX
            id: create_bot_cexSelect
            width: 264
            height: 40
            y: 75
            anchors.left: create_bot_coinA.left
            anchors.leftMargin: -60
            DexLabel{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 20
                text: "CEX:"
                font: DexTypo.head6
                color: 'white'
            }
            DexComboBox {
                id: create_bot_cexSelect_combo
                anchors.right: parent.right
                anchors.top: parent.top
                width: 180
                height: 40
                //displayText: someObject.coinData === undefined ? "Loading.." : General.apHasSelected ? currentText : "Select a Coin"
                model: ["Kucoin"]
                delegate: ItemDelegate {
                    width: create_bot_cexSelect_combo.width
                    height: create_bot_cexSelect_combo.height
                    highlighted: create_bot_cexSelect_combo.highlightedIndex === index
                    DefaultImage {
                        width: 32
                        height: 32
                        x: 4
                        y: 4
                        source: General.image_path + modelData.toLowerCase() + ".png"
                    }
                    DexLabel {
                        width: 140
                        x: 40
                        horizontalAlignment: Text.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font: DexTypo.head6
                        text: modelData
                    }
                }
                contentItem: Text {
                    width: create_bot_cexSelect_combo.width
                    height: create_bot_cexSelect_combo.height
                    DefaultImage {
                        width: 32
                        height: 32
                        x: 2
                        y: 4
                        source: General.image_path + create_bot_cexSelect_combo.currentText.toLowerCase() + ".png"
                    }
                    DexLabel {
                        width: 140
                        x: 30
                        horizontalAlignment: Text.AlignHCenter
                        anchors.verticalCenter: parent.verticalCenter
                        font: DexTypo.head6
                        text: create_bot_cexSelect_combo.currentText
                    }
                }
//                onActivated: {
//                    setAutoTicker(currentText)
//                }
            }
        }
        Item{ //API SELECT
            id: create_bot_api_select
            width: 340
            height: 40
            y: 135
            anchors.left: create_bot_coinA.left
            anchors.leftMargin: -60
            DexLabel{
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                text: "API:"
                font: DexTypo.head6
                color: 'white'
            }
            DexComboBox{
                id: create_bot_api_select_combo
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.rightMargin: 100
                width: 180
                height: 40
                displayText: (bot_logic.apiCount > 0) ? currentText : "Create new API"
                model: (bot_logic.apiCount > 0) ? bot_logic.arbData.apiKucoin : null
//                onActivated: {
//                    setAutoTicker(currentText)
//                }
            }
            DexAppButton{
                enabled: createApi ? false : true
                visible: createApi ? false : true
                width: 40
                height: 40
                anchors.right: parent.right
                color: DexTheme.iconButtonColor
                //foregroundColor: DexTheme.iconButtonForegroundColor
                opacity: containsMouse ? .7 : 1
                ToolTip.delay: 500
                ToolTip.timeout: 5000
                ToolTip.visible: containsMouse
                ToolTip.text: "New"
                Image{
                    width: 40
                    height: 40
                    anchors.centerIn: parent
                    source: General.image_path + "icon-new.png"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: createApi = true
                }
            }
            DexAppButton{
                enabled: createApi ? false : (bot_logic.apiCount > 0) ? true : false
                visible: createApi ? false : (bot_logic.apiCount > 0) ? true : false
                width: 40
                height: 40
                anchors.right: parent.right
                anchors.rightMargin: 50
                color: DexTheme.iconButtonColor
                //foregroundColor: DexTheme.iconButtonForegroundColor
                opacity: containsMouse ? .7 : 1
                ToolTip.delay: 500
                ToolTip.timeout: 5000
                ToolTip.visible: containsMouse
                ToolTip.text: "Delete"
                Image{
                    width: 36
                    height: 36
                    anchors.centerIn: parent
                    source: General.image_path + "icon-delete.png"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        delete bot_logic.arbData.apiKucoin[create_bot_api_select_combo.currentText]
                        bot_logic.countApi()
                    }
                }
            }
//            DexAppButton{
//                enabled: createApi ? false : (bot_logic.apiCount > 0) ? true : false
//                visible: createApi ? false : (bot_logic.apiCount > 0) ? true : false
//                width: 40
//                height: 40
//                anchors.right: parent.right
//                anchors.rightMargin: 100
//                color: DexTheme.iconButtonColor
//                //foregroundColor: DexTheme.iconButtonForegroundColor
//                opacity: containsMouse ? .7 : 1
//                ToolTip.delay: 500
//                ToolTip.timeout: 5000
//                ToolTip.visible: containsMouse
//                ToolTip.text: "Edit"
//                Image{
//                    width: 36
//                    height: 36
//                    anchors.centerIn: parent
//                    source: General.image_path + "menu-settings-white.svg"
//                }
//                MouseArea{
//                    anchors.fill: parent
//                    onClicked: parent.color = 'steelblue'
//                }
//            }
            DexAppButton{
                enabled: createApi ? true : false
                visible: createApi ? true : false
                width: 40
                height: 40
                anchors.right: parent.right
                color: DexTheme.iconButtonColor
                //foregroundColor: DexTheme.iconButtonForegroundColor
                opacity: containsMouse ? .7 : 1
                ToolTip.delay: 500
                ToolTip.timeout: 5000
                ToolTip.visible: containsMouse
                ToolTip.text: "Cancel"
                Image{
                    width: 40
                    height: 40
                    anchors.centerIn: parent
                    source: General.image_path + "icon-cancel.png"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: resetApi()
                }
            }
            DexAppButton{
                enabled: createApi ? true : false
                visible: createApi ? true : false
                width: 40
                height: 40
                anchors.right: parent.right
                anchors.rightMargin: 50
                color: DexTheme.iconButtonColor
                //foregroundColor: DexTheme.iconButtonForegroundColor
                opacity: containsMouse ? .7 : 1
                ToolTip.delay: 500
                ToolTip.timeout: 5000
                ToolTip.visible: containsMouse
                ToolTip.text: "Accept"
                Image{
                    width: 40
                    height: 40
                    anchors.centerIn: parent
                    source: General.image_path + "icon-okay.png"
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        bot_logic.checkUserApi()
                        bot_logic.arbData.apiKucoin = Object.assign(bot_logic.arbData.apiKucoin, new bot_logic.createApi('first', "shhh", 54, "hushhh"))
                        resetApi()
                    }
                }
            }
        }
        Item{ //CEX NAME
            enabled: createApi ? true : false
            visible: createApi ? true : false
            width: 520
            height: 40
            y: 30
            x: 556 + width > (create_bot_coinB.x + create_bot_coinB.width) ? 556 : create_bot_coinB.x - (width - create_bot_coinB.width)
            DexLabel{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: create_bot_cexName.left
                anchors.rightMargin: 10
                text: "Name:"
                font: DexTypo.head6
                color: 'white'
            }
            TextField{
                id: create_bot_cexName
                anchors.right: parent.right
                anchors.top: parent.top
                width: 360
                height: 40
                font: Qt.font({
                    pixelSize: 14,
                    letterSpacing: 0.1,
                    family: "Ubuntu",
                    weight: Font.Light
                })
                //validator: RegularExpressionValidator { regularExpression: /(\d{1,7})([.,]\d{1,3})?$/ }
                color: 'white'
                maximumLength: 40
                background: DexRectangle {
                    color: "#252a4d"
                    border.color: create_bot_cexName.focus ? "#2B6680" : 'white'
                    border.width: 1
                    radius: 6
                }
                //onEditingFinished: validateMinBalance(text)
            }
        }
        Item{ //CEX SECRET KEY
            enabled: createApi ? true : false
            visible: createApi ? true : false
            width: 520
            height: 40
            y: 80
            x: 556 + width > (create_bot_coinB.x + create_bot_coinB.width) ? 556 : create_bot_coinB.x - (width - create_bot_coinB.width)
            DexLabel{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: create_bot_secretKey.left
                anchors.rightMargin: 10
                text: "Secret Key:"
                font: DexTypo.head6
                color: 'white'
            }
            TextField{
                id: create_bot_secretKey
                anchors.right: parent.right
                anchors.top: parent.top
                width: 360
                height: 40
                rightPadding: 36
                font: Qt.font({
                    pixelSize: 14,
                    letterSpacing: 0.1,
                    family: "Ubuntu",
                    weight: Font.Light
                })
                //validator: RegularExpressionValidator { regularExpression: /(\d{1,7})([.,]\d{1,3})?$/ }
                color: 'white'
                maximumLength: 37
                echoMode: TextField.Password
                background: DexRectangle {
                    color: "#252a4d"
                    border.color: create_bot_secretKey.focus ? "#2B6680" : 'white'
                    border.width: 1
                    radius: 6
                }
                //onEditingFinished: validateMinBalance(text)
                Qaterial.AppBarButton {
                    width: 40
                    height: 40
                    opacity: .8
                    icon {
                        source: create_bot_secretKey.echoMode === TextField.Password ? Qaterial.Icons.eyeOffOutline : Qaterial.Icons.eyeOutline
                        color: "#464f94"
                    }
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 0
                    }
                    onClicked: {
                        if (create_bot_secretKey.echoMode === TextField.Password) {
                            create_bot_secretKey.echoMode = TextField.Normal
                        } else {
                            create_bot_secretKey.echoMode = TextField.Password
                        }
                    }
                }
            }
        }
        Item{ //CEX API KEY
            enabled: createApi ? true : false
            visible: createApi ? true : false
            width: 520
            height: 40
            y: 130
            x: 556 + width > (create_bot_coinB.x + create_bot_coinB.width) ? 556 : create_bot_coinB.x - (width - create_bot_coinB.width)
            DexLabel{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: create_bot_apiKey.left
                anchors.rightMargin: 10
                text: "API Key:"
                font: DexTypo.head6
                color: 'white'
            }
            TextField{
                id: create_bot_apiKey
                anchors.right: parent.right
                anchors.top: parent.top
                width: 360
                height: 40
                rightPadding: 36
                font: Qt.font({
                    pixelSize: 14,
                    letterSpacing: 0.1,
                    family: "Ubuntu",
                    weight: Font.Light
                })
                //validator: RegularExpressionValidator { regularExpression: /(\d{1,7})([.,]\d{1,3})?$/ }
                color: 'white'
                maximumLength: 25
                echoMode: TextField.Password
                background: DexRectangle {
                    color: "#252a4d"
                    border.color: create_bot_apiKey.focus ? "#2B6680" : 'white'
                    border.width: 1
                    radius: 6
                }
                //onEditingFinished: validateMinBalance(text)
                Qaterial.AppBarButton {
                    width: 40
                    height: 40
                    opacity: .8
                    icon {
                        source: create_bot_apiKey.echoMode === TextField.Password ? Qaterial.Icons.eyeOffOutline : Qaterial.Icons.eyeOutline
                        color: "#464f94"
                    }
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 0
                    }
                    onClicked: {
                        if (create_bot_apiKey.echoMode === TextField.Password) {
                            create_bot_apiKey.echoMode = TextField.Normal
                        } else {
                            create_bot_apiKey.echoMode = TextField.Password
                        }
                    }
                }
            }
        }
        Item{ //CEX PASSPHRASE
            enabled: createApi ? true : false
            visible: createApi ? true : false
            width: 520
            height: 40
            y: 180
            x: 556 + width > (create_bot_coinB.x + create_bot_coinB.width) ? 556 : create_bot_coinB.x - (width - create_bot_coinB.width)
            DexLabel{
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: create_bot_passPhrase.left
                anchors.rightMargin: 10
                text: "Passphrase:"
                font: DexTypo.head6
                color: 'white'
            }
            TextField{
                id: create_bot_passPhrase
                anchors.right: parent.right
                anchors.top: parent.top
                width: 360
                height: 40
                rightPadding: 36
                font: Qt.font({
                    pixelSize: 14,
                    letterSpacing: 0.1,
                    family: "Ubuntu",
                    weight: Font.Light
                })
                //validator: RegularExpressionValidator { regularExpression: /(\d{1,7})([.,]\d{1,3})?$/ }
                color: 'white'
                maximumLength: 32
                echoMode: TextField.Password
                background: DexRectangle {
                    color: "#252a4d"
                    border.color: create_bot_passPhrase.focus ? "#2B6680" : 'white'
                    border.width: 1
                    radius: 6
                }
                //onEditingFinished: validateMinBalance(text)
                Qaterial.AppBarButton {
                    width: 40
                    height: 40
                    opacity: .8
                    icon {
                        source: create_bot_passPhrase.echoMode === TextField.Password ? Qaterial.Icons.eyeOffOutline : Qaterial.Icons.eyeOutline
                        color: "#464f94"
                    }
                    anchors {
                        verticalCenter: parent.verticalCenter
                        right: parent.right
                        rightMargin: 0
                    }
                    onClicked: {
                        if (create_bot_passPhrase.echoMode === TextField.Password) {
                            create_bot_passPhrase.echoMode = TextField.Normal
                        } else {
                            create_bot_passPhrase.echoMode = TextField.Password
                        }
                    }
                }
            }
        }
        Item{ //COIN A
            id: create_bot_coinA
            width: 300
            height: 100
            x: ((parent.width * 0.3) + 15) - (width / 2)
            y: parent.height * 0.5
            DexLabel{
                anchors.left: parent.left
                anchors.verticalCenter: create_bot_coinA_combo.verticalCenter
                text: "Coin A:"
                font: DexTypo.head5
                color: 'white'
            }
            DexComboBox {
                id: create_bot_coinA_combo
                anchors.right: parent.right
                anchors.top: parent.top
                width: 180
                height: 50
                //displayText: someObject.coinData === undefined ? "Loading.." : General.apHasSelected ? currentText : "Select a Coin"
                model: ["KMD", "RVN", "TKL", "VRSC", "XPM"]
                delegate: ItemDelegate {
                    width: create_bot_coinA_combo.width
                    height: create_bot_coinA_combo.height
                    highlighted: create_bot_coinA_combo.highlightedIndex === index
                    DefaultImage {
                        width: 32
                        height: 32
                        x: 4
                        y: 9
                        source: General.coin_icons_path + modelData.toLowerCase() + ".png"
                    }
                    DexLabel {
                        //Layout.alignment: Qt.AlignHCenter
                        width: 140
                        x: 40
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font: DexTypo.head6
                        text: modelData
                    }
                }
//                contentItem: Text {
//                    width: create_bot_coinA_combo.width
//                    height: create_bot_coinA_combo.height
//                    leftPadding: 0
//                    //rightPadding: create_bot_coinA_combo.indicator.width + create_bot_coinA_combo.spacing

//                    //text: create_bot_coinA_combo.displayText
//                    font: create_bot_coinA_combo.font
//                    color: create_bot_coinA_combo.pressed ? "#17a81a" : "#21be2b"
//                    //verticalAlignment: Text.AlignVCenter
//                    //elide: Text.ElideRight
//                    RowLayout {
//                        anchors.fill: parent
//                        DefaultImage {
//                            id: comboApContentImage
//                            //height: 32
//                            //x: 8
//                            //anchors.verticalCenter: parent.verticalCenter
//                            Layout.preferredHeight: 32
//                            Layout.leftMargin: 4
//                            source: General.apHasSelected ? General.coin_icons_path + "32" + create_bot_coinA_combo.currentText + ".png" : General.image_path + "menu-news-white.svg"
//                        }
//                        DexLabel {
//                            //Layout.alignment: Qt.AlignHCenter
//                            horizontalAlignment: Text.AlignHCenter
//                            text: qsTr(create_bot_coinA_combo.displayText)
//                        }
//                    }
//                }
//                onActivated: {
//                    setAutoTicker(currentText)
//                }
            }
            DexLabel{
                anchors.left: parent.left
                anchors.verticalCenter: create_bot_coinA_min.verticalCenter
                text: "Min Balance:"
                font: DexTypo.head6
                color: 'white'
            }
            TextField{
                id: create_bot_coinA_min
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                width: 150
                height: 40
                readOnly: false
                font: DexTypo.head6
                //validator: RegularExpressionValidator { regularExpression: /(\d{1,7})([.,]\d{1,3})?$/ }
                color: 'white'
                background: DexRectangle {
                    color: "#252a4d"
                    border.color: create_bot_coinA_min.focus ? "#2B6680" : 'white'
                    border.width: 1
                    radius: 6
                }
                placeholderText: "N/A"
                placeholderTextColor: 'white'
                //onEditingFinished: validateMinBalance(text)
            }
        }
        Item{ //COIN B
            id: create_bot_coinB
            width: 300
            height: 100
            x: ((parent.width * 0.7) - 15) - (width / 2)
            y: parent.height * 0.5
            DexLabel{
                anchors.left: parent.left
                anchors.verticalCenter: create_bot_coinB_combo.verticalCenter
                text: "Coin B:"
                font: DexTypo.head5
                color: 'white'
            }
            DexComboBox {
                id: create_bot_coinB_combo
                anchors.right: parent.right
                anchors.top: parent.top
                width: 180
                height: 50
                //displayText: someObject.coinData === undefined ? "Loading.." : General.apHasSelected ? currentText : "Select a Coin"
                model: ["KMD", "RVN", "TKL", "VRSC", "XPM"]
                delegate: ItemDelegate {
                    width: create_bot_coinB_combo.width
                    height: create_bot_coinB_combo.height
                    highlighted: create_bot_coinB_combo.highlightedIndex === index
                    DefaultImage {
                        width: 32
                        height: 32
                        x: 4
                        y: 9
                        source: General.coin_icons_path + modelData.toLowerCase() + ".png"
                    }
                    DexLabel {
                        //Layout.alignment: Qt.AlignHCenter
                        width: 140
                        x: 40
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font: DexTypo.head6
                        text: modelData
                    }
                }
//                contentItem: Text {
//                    width: create_bot_coinB_combo.width
//                    height: create_bot_coinB_combo.height
//                    leftPadding: 0
//                    //rightPadding: create_bot_coinB_combo.indicator.width + create_bot_coinB_combo.spacing

//                    //text: create_bot_coinB_combo.displayText
//                    font: create_bot_coinB_combo.font
//                    color: create_bot_coinB_combo.pressed ? "#17a81a" : "#21be2b"
//                    //verticalAlignment: Text.AlignVCenter
//                    //elide: Text.ElideRight
//                    RowLayout {
//                        anchors.fill: parent
//                        DefaultImage {
//                            id: comboApContentImage
//                            //height: 32
//                            //x: 8
//                            //anchors.verticalCenter: parent.verticalCenter
//                            Layout.preferredHeight: 32
//                            Layout.leftMargin: 4
//                            source: General.apHasSelected ? General.coin_icons_path + "32" + create_bot_coinB_combo.currentText + ".png" : General.image_path + "menu-news-white.svg"
//                        }
//                        DexLabel {
//                            //Layout.alignment: Qt.AlignHCenter
//                            horizontalAlignment: Text.AlignHCenter
//                            text: qsTr(create_bot_coinB_combo.displayText)
//                        }
//                    }
//                }
//                onActivated: {
//                    setAutoTicker(currentText)
//                }
            }
            DexLabel{
                anchors.left: parent.left
                anchors.verticalCenter: create_bot_coinB_min.verticalCenter
                text: "Min Balance:"
                font: DexTypo.head6
                color: 'white'
            }
            TextField{
                id: create_bot_coinB_min
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                width: 150
                height: 40
                readOnly: false
                font: DexTypo.head6
                //validator: RegularExpressionValidator { regularExpression: /(\d{1,7})([.,]\d{1,3})?$/ }
                color: 'white'
                background: DexRectangle {
                    color: "#252a4d"
                    border.color: create_bot_coinB_min.focus ? "#2B6680" : 'white'
                    border.width: 1
                    radius: 6
                }
                placeholderText: "N/A"
                placeholderTextColor: 'white'
                //onEditingFinished: validateMinBalance(text)
            }
        }
        Item{ //PROFIT TARGET & STATUS SWITCH
            width: 540
            height: 110
            x: ((parent.width * 0.5) + 15) - (width / 2)
            //y:  parent.height * 0.75
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            DexLabel{
                id: create_bot_target_text
                anchors.left: parent.left
                anchors.verticalCenter: create_bot_target_slider.verticalCenter
                text: "Profit Target:"
                font: DexTypo.head5
                color: 'white'
            }
            DexSlider{
                id: create_bot_target_slider
                anchors.right: parent.right
                anchors.top: parent.top
                width: 280
                height: 50
//                from: hasAutoAddress && hasEnoughBalance ? currentMinWager : 0.5
//                to: hasAutoAddress && hasEnoughBalance ? ((localSetAmount - (set_amount_slider.valueAt(set_amount_slider.position))) * 0.4) : 100
//                value: throwAmountValue
//                onMoved: slideThrowSize()
            }
            DexLabel{
                id: create_bot_status_text
                anchors.right: create_bot_target_text.right
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 14
                text: "Status:"
                font: DexTypo.head5
                color: 'white'
            }
            DefaultSwitch {
                anchors.horizontalCenter: create_bot_target_slider.horizontalCenter
                anchors.verticalCenter:  create_bot_status_text.verticalCenter
                width: 140
                height: 50
                //onCheckedChanged:
                //Component.onDestruction:
            }
        }
    }
    DexAppButton{
        id: create_bot_create
        enabled: true
        width: 180
        height: 50
        radius: 16
        anchors.horizontalCenter: create_bot_panel.horizontalCenter
        anchors.top: create_bot_panel.bottom
        anchors.topMargin: 20
        font.pixelSize: Style.textSize
        border.color: enabled ? Dex.CurrentTheme.accentColor : DexTheme.contentColorTopBold
        opacity: 1
        text: qsTr("CREATE BOT")
        //onClicked:
    }
    DexAppButton{
        id: create_bot_exit
        enabled: true
        width: 180
        height: 50
        radius: 16
        anchors.horizontalCenter: create_bot_panel.horizontalCenter
        anchors.top: create_bot_create.bottom
        anchors.topMargin: 20
        font.pixelSize: Style.textSize
        border.color: enabled ? Dex.CurrentTheme.accentColor : DexTheme.contentColorTopBold
        opacity: 1
        text: qsTr("BACK")
        onClicked: closeCreateBot()
    }
    DexLabel{
        x: 10
        anchors.top: create_bot_create.bottom
        anchors.topMargin: 20
        text: create_arb.height
        color: 'white'
    }
}
