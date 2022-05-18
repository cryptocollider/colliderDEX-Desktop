import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import "../../Components"
import App 1.0
import Dex.Themes 1.0 as Dex

SetupPage
{
    signal logged()

    readonly property string current_status: API.app.wallet_mgr.initial_loading_status

    onCurrent_statusChanged: if (current_status === "enabling_coins") logged()

    back_image_path: General.image_path + "final-background.gif"
    image_scale: 1.0
    image_path: General.image_path + "login-setup-final.png"
    image_margin: 2
    backgroundColor: 'transparent'

    content: ColumnLayout
    {
        DefaultBusyIndicator
        {
            Layout.preferredHeight: 100
            Layout.preferredWidth: 100
            Layout.alignment: Qt.AlignHCenter
            Layout.leftMargin: -15
            Layout.rightMargin: Layout.leftMargin * 0.75
            scale: 0.8
        }

        DefaultText
        {
            text_value: qsTr("Loading, please wait")
            Layout.bottomMargin: 10
        }

        DefaultText
        {
            Layout.alignment: Qt.AlignHCenter
            text_value: (current_status === "initializing_mm2" ? qsTr("Initializing MM2") :
                current_status === "enabling_coins" ? qsTr("Enabling assets") : qsTr("Getting ready")) + "..."
        }
    }
}
