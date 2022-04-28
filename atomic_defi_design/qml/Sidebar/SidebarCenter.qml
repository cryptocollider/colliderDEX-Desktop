import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import Qaterial 1.0 as Qaterial

import "../Constants"
import "../Components"

ColumnLayout {
    id: window_layout

    transformOrigin: Item.Center
    spacing: 0

    SidebarLine {
        dashboard_index: idx_dashboard_portfolio
        text_value:sidebar.expanded? qsTr("Dashboard") : ""
        image: General.image_path + "menu-assets-portfolio.svg"
        Layout.fillWidth: true
        separator: false
        SidebarTooltip {
            text_value: qsTr("Dashboard")
        }

    }

    SidebarLine {
        dashboard_index: idx_dashboard_wallet
        text_value: sidebar.expanded? qsTr("Wallet") : ""
        image: General.image_path + "menu-assets-white.svg"
        Layout.fillWidth: true
        SidebarTooltip {
            text_value: qsTr("Wallet")
        }
    }

    SidebarLine {
        id: dex_line
        section_enabled: !is_dex_banned
        dashboard_index: idx_dashboard_exchange
        text_value: sidebar.expanded? qsTr("DEX") : ""
        image: General.image_path + "menu-exchange-white.svg"
        Layout.fillWidth: true
        SidebarTooltip {
            text_value: qsTr("DEX")
        }

        DefaultTooltip {
            visible: dex_line.mouse_area.containsMouse && !dex_line.section_enabled

            contentItem: ColumnLayout {
                DefaultText {
                    text_value: qsTr("DEX features are not allowed in %1", "COUNTRY").arg(API.app.ip_checker.ip_country)
                    font.pixelSize: Style.textSizeSmall4
                }
            }
        }
    }

    SidebarLine {
        dashboard_index: idx_dashboard_addressbook
        text_value: sidebar.expanded? qsTr("Address Book") : ""
        image: General.image_path + "menu-news-white.svg"
        Layout.fillWidth: true
        SidebarTooltip {
            text_value: qsTr("Address Book")
        }
    }

    SidebarLine {
        section_enabled: false
        dashboard_index: idx_dashboard_fiat_ramp
        text_value: sidebar.expanded ? qsTr("Fiat") : ""
        image: General.image_path + "bill.svg"
        Layout.fillWidth: true
        SidebarTooltip {
            text_value: qsTr("Fiat")
        }

        DefaultTooltip {
            enabled: false
            id: fiat_coming_soon
            text: qsTr("Coming soon !")
            visible: parent.mouse_area.containsMouse
        }
    }

    //creates a sidebar tab in order (so it sits below fiat tab)
    SidebarLine {
        section_enabled: false
        dashboard_index: idx_dashboard_games
        text_value: sidebar.expanded? qsTr("Games") : ""
        image: General.image_path + "menu-games-white.svg"
        Layout.fillWidth: true
        SidebarTooltip {
            text_value: qsTr("Games")
        }

        DefaultTooltip {
            enabled: false
            id: games_coming_soon
            text: qsTr("Coming soon !")
            visible: parent.mouse_area.containsMouse
        }
    }

//    SidebarLine {
//        dashboard_index: idx_dashboard_news
//        text_value: qsTr("News")
//        image: General.image_path + "menu-news-white.svg"
//        Layout.fillWidth: true
//    }

//    SidebarLine {
//        dashboard_index: idx_dashboard_dapps
//        text_value: qsTr("Dapps")
//        image: General.image_path + "menu-dapp-white.svg"
//        Layout.fillWidth: true
//    }
}
