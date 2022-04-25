import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import Qaterial 1.0 as Qaterial

import "../Constants"
import App 1.0
import "../Components"
import "../Screens"

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
        isWallet: true
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

//    SidebarLine {
//        dashboard_index: idx_dashboard_addressbook
//        text_value: sidebar.expanded? qsTr("Address Book") : ""
//        image: General.image_path + "menu-news-white.svg"
//        Layout.fillWidth: true
//        SidebarTooltip {
//            text_value: qsTr("Address Book")
//        }
//    }

//    SidebarLine {
//        section_enabled: false
//        dashboard_index: idx_dashboard_fiat_ramp
//        text_value: sidebar.expanded ? qsTr("Fiat") : ""
//        image: General.image_path + "bill.svg"
//        Layout.fillWidth: true

//        SidebarTooltip { text_value: qsTr("Fiat") }

//        DexTooltip
//        {
//            enabled: false
//            id: fiat_coming_soon
//            visible: parent.mouse_area.containsMouse
//            contentItem: DexRectangle
//            {
//                DexLabel { text: qsTr("Coming soon !"); anchors.centerIn: parent }
//            }
//        }
//    }

    SidebarLine {
        section_enabled: false
        dashboard_index: idx_dashboard_arb_bots
        text_value: sidebar.expanded ? qsTr("Arb Bots") : ""
        image: General.image_path + "bill.svg"
        Layout.fillWidth: true

        SidebarTooltip { text_value: qsTr("Arb Bots") }

        DexTooltip
        {
            enabled: false
            id: arb_coming_soon
            visible: parent.mouse_area.containsMouse
            contentItem: DexRectangle
            {
                DexLabel { text: qsTr("Coming soon !"); anchors.centerIn: parent }
            }
        }
    }

    //creates a sidebar tab in order (so it sits below fiat tab)
    SidebarLine {
        dashboard_index: idx_dashboard_games
        text_value: sidebar.expanded? qsTr("Games") : ""
        image: General.inColliderApp && dashboard.current_page === idx_dashboard_games ? General.image_path + "menu-games-exit.svg" : General.image_path + "menu-games-white.svg"
        isCollider: true
        Layout.fillWidth: true
        SidebarTooltip {
            text_value: qsTr("Games")
        }
    }

    SidebarLine {
        //section_enabled: dashboard.hasCoinSight ? true : false
        dashboard_index: idx_dashboard_coin_sight
        text_value: sidebar.expanded ? qsTr("coinSight") : ""
        image: General.image_path + "menu-games-white.svg"
        isCoinSight: true
        Layout.fillWidth: true

        SidebarTooltip {
            text_value: qsTr("coinSight")
        }

        DexTooltip
        {
            enabled: false
            id: has_coinSight
            visible: parent.mouse_area.containsMouse
            contentItem: DexRectangle
            {
                DexLabel { text: qsTr("100 CLC Required!"); anchors.centerIn: parent }
            }
        }
    }

    SidebarLine {
        dashboard_index: idx_dashboard_collider_discord
        text_value: sidebar.expanded? qsTr("Discord") : ""
        image: General.image_path + "menu-discord-white.svg"
        Layout.fillWidth: true
        SidebarTooltip {
            text_value: qsTr("Discord")
        }
    }
}
