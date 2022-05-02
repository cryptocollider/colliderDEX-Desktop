import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import QtWebChannel 1.0
import QtWebEngine 1.7

import Qaterial 1.0 as Qaterial

import "../Components"
import "../Constants"
import "../Screens"

Item {
    id: discordWeb
    anchors.fill: parent
    visible: dashboard.currentPage === Dashboard.PageType.Discord ? true : false

    WebEngineView {
        anchors.fill: parent
        settings.pluginsEnabled: true
        url: dashboard.openedDisc ? "https://discord.com/invite/Uq9bpKN" : ""
    }
}
