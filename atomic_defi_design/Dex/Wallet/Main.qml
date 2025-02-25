// Qt Imports
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtCharts 2.3
import QtWebEngine 1.8
import QtGraphicalEffects 1.0

import Qaterial 1.0 as Qaterial

// Project Imports
import "../Components"
import "../Constants"
import App 1.0
import "../Screens"
import "../Exchange/Trade"
import Dex.Themes 1.0 as Dex

// Right side, main
Item
{
    id: root
    property alias send_modal: send_modal
    readonly property int layout_margin: 20
    readonly property string headerTitleColor: Style.colorText2
    readonly property string headerTitleFont: Style.textSizeMid1
    readonly property string headerTextColor: Dex.CurrentTheme.foregroundColor
    readonly property string headerTextFont: Style.textSize
    readonly property string headerSmallTitleFont: Style.textSizeSmall4
    readonly property string headerSmallFont: Style.textSizeSmall2

    function loadingPercentage(remaining) {
        return General.formatPercent((100 * (1 - parseFloat(remaining)/parseFloat(current_ticker_infos.current_block))).toFixed(3), false)
    }

    readonly property var transactions_mdl: api_wallet_page.transactions_mdl

    Layout.fillHeight: true
    Layout.fillWidth: true

    ColumnLayout
    {
        id: wallet_layout

        width: parent.width
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: layout_margin
        anchors.bottom: parent.bottom

        spacing: 20

        // Balance box
        InnerBackground
        {
            id: balance_box

            Layout.fillWidth: true
            Layout.preferredHeight: 100
            Layout.leftMargin: layout_margin
            Layout.rightMargin: layout_margin

            RowLayout
            {
                anchors.fill: parent

                RowLayout
                {
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.topMargin: 10
                    Layout.bottomMargin: Layout.topMargin
                    Layout.leftMargin: 20
                    Layout.rightMargin: Layout.leftMargin
                    spacing: 5

                    // Icon & Full name
                    ColumnLayout
                    {
                        DefaultImage
                        {
                            id: icon_img
                            Layout.bottomMargin: 0
                            source: General.coinIcon(api_wallet_page.ticker)
                            Layout.preferredHeight: 60
                            Layout.preferredWidth: Layout.preferredHeight
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        }

                        DexLabel
                        {
                            id: ticker_name
                            Layout.topMargin: 0
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            text_value: api_wallet_page.ticker // current_ticker_infos.name
                            font.pixelSize: headerTextFont
                            color: headerTextColor
                        }
                    }

                    Item { Layout.fillWidth: true }

                    // Ticker and crypto / fiat amount
                    ColumnLayout
                    {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        spacing: 2

                        DexLabel
                        {
                            id: balance_title
                            Layout.alignment: Qt.AlignHCenter
                            text_value: current_ticker_infos.name + " Balance" // "Wallet Balance"
                            font.pixelSize: headerTitleFont
                            color: headerTitleColor
                        }

                        DexLabel
                        {
                            id: name_value
                            Layout.alignment: Qt.AlignHCenter
                            text_value: General.formatCrypto("", current_ticker_infos.balance, "", current_ticker_infos.fiat_amount, API.app.settings_pg.current_currency)
                            font.pixelSize: headerTextFont
                            color: headerTextColor
                            privacy: true
                        }
                    }

                    Item { Layout.fillWidth: true }

                    VerticalLine
                    {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.rightMargin: 0
                        Layout.preferredHeight: parent.height * 0.6
                    }

                    Item { Layout.fillWidth: true }

                    ColumnLayout
                    {
                        visible: false //current_ticker_infos.segwit_supported
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        spacing: 2
                        DexLabel
                        {
                            text_value: qsTr("Segwit")
                            Layout.alignment: Qt.AlignLeft
                            font.pixelSize: headerTitleFont
                            color: headerTitleColor
                        }
                        DefaultSwitch
                        {
                            id: segwitSwitch
                            Layout.alignment: Qt.AlignVCenter
                            onToggled:
                            {
                                if(parseFloat(current_ticker_infos.balance) > 0) {
                                     Qaterial.DialogManager.showDialog({
                                        title: qsTr("Confirmation"),
                                        text:  qsTr("Do you want to send your %1 funds to %2 wallet first?").arg(current_ticker_infos.is_segwit_on ? "segwit" : "legacy").arg(!current_ticker_infos.is_segwit_on ? "segwit" : "legacy"),
                                        standardButtons: Dialog.Yes | Dialog.No,
                                        onAccepted: function() {
                                            var address = API.app.wallet_pg.switch_address_mode(!current_ticker_infos.is_segwit_on);
                                            if (address != current_ticker_infos.address && address != "") {
                                                send_modal.open()
                                                send_modal.item.address_field.text = address
                                                send_modal.item.max_mount.checked = true
                                                send_modal.item.segwit = true
                                                send_modal.item.segwit_callback = function () {
                                                    if(send_modal.item.segwit_success) {
                                                        API.app.wallet_pg.post_switch_address_mode(!current_ticker_infos.is_segwit_on)
                                                        Qaterial.DialogManager.showDialog({
                                                            title: qsTr("Success"),
                                                            text: qsTr("Your transaction is send, may take some time to arrive")
                                                        })
                                                    } else {
                                                        segwitSwitch.checked = current_ticker_infos.is_segwit_on
                                                    }
                                                }
                                            }
                                        },
                                        onRejected: function () {
                                            app.segwit_on = true
                                            API.app.wallet_pg.post_switch_address_mode(!current_ticker_infos.is_segwit_on)
                                        }
                                    })

                                } else {
                                    app.segwit_on = true
                                    API.app.wallet_pg.post_switch_address_mode(!current_ticker_infos.is_segwit_on)
                                }
                            }
                        }
                    }

                    Connections
                    {
                        target: API.app.wallet_pg
                        function onTickerInfosChanged() {
                            if (segwitSwitch.checked != current_ticker_infos.is_segwit_on) {
                                segwitSwitch.checked = current_ticker_infos.is_segwit_on
                            }
                        }
                    }

                    // Price
                    ColumnLayout
                    {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10

                        spacing: 5
                        DexLabel
                        {
                            id: price
                            text_value: qsTr("Price")
                            Layout.alignment: Qt.AlignHCenter
                            color: headerTitleColor
                            font.pixelSize: headerTitleFont
                        }

                        DexLabel
                        {
                            text_value:
                            {
                                const v = General.formatFiat('', current_ticker_infos.current_currency_ticker_price, API.app.settings_pg.current_currency)
                                return current_ticker_infos.current_currency_ticker_price == 0 ? 'N/A' : v
                            }
                            Layout.alignment: Qt.AlignHCenter
                            font.pixelSize: headerTextFont
                            color: headerTextColor
                        }
                    }

                    // 24hr change
                    ColumnLayout
                    {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10

                        spacing: 5
                        DexLabel
                        {
                            id: change_24hr
                            text_value: qsTr("Change 24hr")
                            Layout.alignment: Qt.AlignHCenter
                            color: headerTitleColor
                            font.pixelSize: headerTitleFont
                        }

                        DexLabel
                        {
                            id: change_24hr_value
                            Layout.alignment: Qt.AlignHCenter
                            text_value:
                            {
                                const v = parseFloat(current_ticker_infos.change_24h)
                                return v === 0 ? 'N/A' : General.formatPercent(v)
                            }
                            font.pixelSize: headerTextFont
                            color: change_24hr_value.text_value == "N/A" ? headerTextColor : DexTheme.getValueColor(current_ticker_infos.change_24h)
                        }
                    }

                    // Porfolio %
                    ColumnLayout
                    {
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        Layout.leftMargin: 10
                        Layout.rightMargin: 10

                        spacing: 5
                        DexLabel
                        {
                            id: portfolio_title
                            text_value: qsTr("Porfolio")
                            Layout.alignment: Qt.AlignHCenter
                            color: headerTitleColor
                            font.pixelSize: headerTitleFont
                        }

                        DexLabel
                        {
                            Layout.alignment: Qt.AlignHCenter
                            text_value:
                            {
                                const fiat_amount = parseFloat(current_ticker_infos.fiat_amount)
                                const portfolio_balance = parseFloat(API.app.portfolio_pg.balance_fiat_all)
                                if(fiat_amount <= 0 || portfolio_balance <= 0) return "N/A"
                                return General.formatPercent((100 * fiat_amount/portfolio_balance).toFixed(2), false)
                            }
                            font.pixelSize: headerTextFont
                            color: headerTextColor
                        }
                    }

                    Item { Layout.fillWidth: true }

                    VerticalLine
                    {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.rightMargin: 0
                        Layout.preferredHeight: parent.height * 0.6
                        visible: General.coinContractAddress(api_wallet_page.ticker) !== ""
                    }

                    Item {
                        Layout.fillWidth: true
                        visible: General.coinContractAddress(api_wallet_page.ticker) !== ""
                    }

                    // Contract address
                    ColumnLayout
                    {
                        visible: General.coinContractAddress(api_wallet_page.ticker) !== ""
                        RowLayout
                        {
                            Layout.alignment: Qt.AlignLeft
                            id: contract_title_row_layout
                            DefaultImage
                            {
                                id: protocol_img
                                source: General.platformIcon(General.coinPlatform(api_wallet_page.ticker))
                                Layout.preferredHeight: 18
                                Layout.preferredWidth: Layout.preferredHeight
                            }
                            DexLabel
                            {
                                id: contract_address_title
                                text_value: General.coinPlatform(api_wallet_page.ticker) + qsTr(" Contract Address")
                                font.pixelSize: headerSmallTitleFont
                                color: headerTitleColor
                            }
                        }

                        RowLayout
                        {
                            Layout.topMargin: 0
                            Layout.bottomMargin: 0
                            Layout.alignment: Qt.AlignLeft
                            Layout.preferredHeight: General.coinContractAddress(api_wallet_page.ticker) ? headerSmallFont : 0
                            visible: General.coinContractAddress(api_wallet_page.ticker) !== ""
                            DexLabel
                            {
                                id: contract_address
                                text_value: General.coinContractAddress(api_wallet_page.ticker)
                                Layout.preferredWidth: contract_title_row_layout.width - headerTextFont
                                font: DexTypo.monoSpace
                                color: headerTextColor
                                elide: Text.ElideMiddle
                                wrapMode: Text.NoWrap
                            }
                            Qaterial.Icon {
                                size: headerTextFont
                                icon: Qaterial.Icons.linkVariant
                                color: contract_linkArea.containsMouse ? headerTextColor : headerTitleColor
                                visible: General.contractURL(api_wallet_page.ticker) != ""
                                DexMouseArea {
                                    id: contract_linkArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    onClicked: {
                                        Qt.openUrlExternally(General.contractURL(api_wallet_page.ticker))
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Buttons
        RowLayout
        {
            Layout.leftMargin: layout_margin
            Layout.rightMargin: layout_margin
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            spacing: 25

            Item
            {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 48

                // Send Button
                DexAppButton
                {
                    enabled: API.app.wallet_pg.send_available && !General.autoPlaying && General.apCanThrow

                    anchors.fill: parent
                    radius: 18

                    label.text: qsTr("Send")
                    label.font.pixelSize: 16
                    content.anchors.left: content.parent.left
                    content.anchors.leftMargin: enabled ? 23 : 48

                    onClicked:
                    {
                        if (API.app.wallet_pg.current_ticker_fees_coin_enabled) send_modal.open()
                        else enable_fees_coin_modal.open()
                    }

                    Arrow
                    {
                        id: arrow_send
                        up: true
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 19
                    }
                }

                // Send button error icon
                DefaultAlertIcon
                {
                    visible: API.app.wallet_pg.send_availability_state !== ""
                    tooltipText: API.app.wallet_pg.send_availability_state
                }
            }

            ModalLoader
            {
                id: send_modal
                sourceComponent: SendModal {}
            }

            Component
            {
                id: enable_fees_coin_comp
                MultipageModal
                {
                    id: root
                    width: 300
                    MultipageModalContent
                    {
                        titleText: qsTr("Enable %1 ?").arg(coin_to_enable_ticker)
                        RowLayout
                        {
                            Layout.fillWidth: true
                            DefaultButton
                            {
                                Layout.fillWidth: true
                                text: qsTr("Yes")
                                onClicked:
                                {
                                    if (API.app.enable_coin(coin_to_enable_ticker) === false)
                                    {
                                        enable_fees_coin_failed_modal.open()
                                    }
                                    close()
                                }
                            }
                            DefaultButton
                            {
                                Layout.fillWidth: true
                                text: qsTr("No")
                                onClicked: close()
                            }
                        }
                    }
                }
            }

            ModalLoader
            {
                property string coin_to_enable_ticker: API.app.wallet_pg.ticker_infos.fee_ticker
                id: enable_fees_coin_modal
                sourceComponent: enable_fees_coin_comp
            }

            ModalLoader
            {
                id: enable_fees_coin_failed_modal
                sourceComponent: CannotEnableCoinModal { coin_to_enable_ticker: API.app.wallet_pg.ticker_infos.fee_ticker }
            }

            // Receive Button
            DexAppButton
            {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 48
                radius: 18

                label.text: qsTr("Receive")
                label.font.pixelSize: 16
                content.anchors.left: content.parent.left
                content.anchors.leftMargin: 23

                onClicked: receive_modal.open()

                Arrow
                {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: arrow_send.anchors.rightMargin
                    up: false
                }
            }

            ModalLoader
            {
                id: receive_modal
                sourceComponent: ReceiveModal {}
            }

            // Swap Button
            Item
            {
                visible: !is_dex_banned
                Layout.preferredWidth: 180
                Layout.preferredHeight: 48

                DexAppButton
                {
                    enabled: !API.app.portfolio_pg.global_cfg_mdl.get_coin_info(api_wallet_page.ticker).is_wallet_only
                    anchors.fill: parent
                    radius: 18

                    // Inner text.
                    label.text: qsTr("Swap")
                    label.font.pixelSize: 16
                    content.anchors.left: content.parent.left
                    content.anchors.leftMargin: enabled ? 23 : 48

                    onClicked: onClickedSwap()

                    Row
                    {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: arrow_send.anchors.rightMargin
                        spacing: 2

                        Arrow
                        {
                            up: true
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Arrow
                        {
                            up: false
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                }

                // Swap button error icon
                DefaultAlertIcon
                {
                    visible: API.app.portfolio_pg.global_cfg_mdl.get_coin_info(api_wallet_page.ticker).is_wallet_only
                    tooltipText: api_wallet_page.ticker + qsTr(" is wallet only")
                }
            }

            // Addressbook button
            Item
            {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 48

                Item { Layout.fillWidth: true }

                DexAppButton
                {
                    text: qsTr("Address Book")
                    radius: 18
                    font.pixelSize: 16
                    anchors.fill: parent
                    onClicked: dashboard.switchPage(Dashboard.PageType.Addressbook);
                }
            }

            Item { Layout.fillWidth: true }

            // Rewards Button
            Item
            {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 48
                visible: current_ticker_infos.is_claimable && !API.app.is_pin_cfg_enabled()

                Item { Layout.fillWidth: true }

                DexAppButton
                {
                    text: qsTr("Rewards")
                    radius: 18
                    font.pixelSize: 16
                    anchors.fill: parent
                    enabled: parseFloat(current_ticker_infos.balance) > 0
                    onClicked:
                    {
                        claimRewardsModal.open()
                        claimRewardsModal.item.prepareClaimRewards()
                    }
                }

                ModalLoader
                {
                    id: claimRewardsModal
                    sourceComponent: ClaimRewardsModal {}
                }
            }

            // Faucet Button
            Item
            {
                Layout.preferredWidth: 180
                Layout.preferredHeight: 48
                visible: enabled && current_ticker_infos.is_smartchain_test_coin

                DexAppButton
                {
                    text: qsTr("Faucet")
                    radius: 18
                    font.pixelSize: 16
                    anchors.fill: parent
                    onClicked: api_wallet_page.claim_faucet()
                }
            }

            Component.onCompleted: api_wallet_page.claimingFaucetRpcDataChanged.connect(onClaimFaucetRpcResultChanged)
            Component.onDestruction: api_wallet_page.claimingFaucetRpcDataChanged.disconnect(onClaimFaucetRpcResultChanged)
            function onClaimFaucetRpcResultChanged() { claimFaucetResultModal.open() }

            ModalLoader
            {
                id: claimFaucetResultModal
                sourceComponent: ClaimFaucetResultModal {}
            }

            // Public Key button
            Item
            {
                Layout.minimumWidth: 160
                Layout.maximumWidth: 180
                Layout.fillWidth: true
                Layout.preferredHeight: 48

                visible: current_ticker_infos.name === "Tokel"

                DexAppButton
                {
                    text: qsTr("Public Key")
                    radius: 18
                    font.pixelSize: 16
                    anchors.fill: parent
                    onClicked:
                    {
                        API.app.settings_pg.fetchPublicKey()
                        publicKeyModal.open()
                    }
                }

                ModalLoader
                {
                    id: publicKeyModal
                    sourceComponent: MultipageModal
                    {
                        MultipageModalContent
                        {
                            titleText: qsTr("Public Key")

                            DefaultBusyIndicator
                            {
                                Layout.alignment: Qt.AlignCenter

                                visible: API.app.settings_pg.fetchingPublicKey
                                enabled: visible
                            }

                            RowLayout
                            {
                                Layout.fillWidth: true

                                DefaultText
                                {
                                    Layout.fillWidth: true
                                    visible: !API.app.settings_pg.fetchingPublicKey
                                    text: API.app.settings_pg.publicKey
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                }

                                Qaterial.RawMaterialButton
                                {
                                    backgroundImplicitWidth: 40
                                    backgroundImplicitHeight: 30
                                    backgroundColor: "transparent"
                                    icon.source: Qaterial.Icons.contentCopy
                                    icon.color: Dex.CurrentTheme.foregroundColor
                                    onClicked:
                                    {
                                        API.qt_utilities.copy_text_to_clipboard(API.app.settings_pg.publicKey)
                                        app.notifyCopy(qsTr("Public Key"), qsTr("Copied to Clipboard"))
                                    }
                                }
                            }

                            Image
                            {
                                visible: !API.app.settings_pg.fetchingPublicKey

                                Layout.topMargin: 20
                                Layout.alignment: Qt.AlignHCenter

                                sourceSize.width: 300
                                sourceSize.height: 300
                                source: API.qt_utilities.get_qrcode_svg_from_string(API.app.settings_pg.publicKey)
                            }
                        }
                    }
                }
            }
        }

        // Price Graph
        InnerBackground
        {
            visible: false
            id: price_graph_bg

            property bool ticker_supported: false
            readonly property bool is_fetching: webEngineView.loadProgress < 100
            property var ticker: api_wallet_page.ticker

            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: layout_margin
            Layout.rightMargin: layout_margin
            Layout.bottomMargin: -parent.spacing * 0.5
            Layout.preferredHeight: wallet.height * 0.6

            radius: 18

            onTickerChanged: loadChart()

            function loadChart()
            {
                const pair = atomic_qt_utilities.retrieve_main_ticker(ticker) + "/" + atomic_qt_utilities.retrieve_main_ticker(API.app.settings_pg.current_currency)
                const pair_reversed = atomic_qt_utilities.retrieve_main_ticker(API.app.settings_pg.current_currency) + "/" + atomic_qt_utilities.retrieve_main_ticker(ticker)
                const pair_usd = atomic_qt_utilities.retrieve_main_ticker(ticker) + "/" + "USD"
                const pair_usd_reversed = "USD" + "/" + atomic_qt_utilities.retrieve_main_ticker(ticker)
                const pair_busd = atomic_qt_utilities.retrieve_main_ticker(ticker) + "/" + "BUSD"
                const pair_busd_reversed = "BUSD" + "/" + atomic_qt_utilities.retrieve_main_ticker(ticker)

                // Normal pair
                let symbol = General.supported_pairs[pair]
                if (!symbol) {
                    console.warn("Symbol not found for", pair)
                    symbol = General.supported_pairs[pair_reversed]
                }

                // Reversed pair
                if (!symbol) {
                    console.warn("Symbol not found for", pair_reversed)
                    symbol = General.supported_pairs[pair_usd]
                }

                // Pair with USD
                if (!symbol) {
                    console.warn("Symbol not found for", pair_usd)
                    symbol = General.supported_pairs[pair_usd_reversed]
                }

                // Reversed pair with USD
                if (!symbol) {
                    console.warn("Symbol not found for", pair_usd_reversed)
                    symbol = General.supported_pairs[pair_busd]
                }

                // Pair with BUSD
                if (!symbol) {
                    console.warn("Symbol not found for", pair_busd)
                    symbol = General.supported_pairs[pair_busd_reversed]
                }

                // Reversed pair with BUSD
                if (!symbol) {
                    console.warn("Symbol not found for", pair_busd_reversed)
                    console.warn("No chart for", ticker)
                    ticker_supported = false
                    return
                }

                ticker_supported = true

                console.debug("Wallet: Loading chart for %1".arg(symbol))

//                webEngineView.loadHtml(`<style>
//                                        body { margin: 0; background: %1 }
//                                        </style>
//                                        <!-- TradingView Widget BEGIN -->
//                                        <div class="tradingview-widget-container">
//                                          <div class="tradingview-widget-container__widget"></div>
//                                          <script type="text/javascript" src="https://s3.tradingview.com/external-embedding/embed-widget-mini-symbol-overview.js" async>
//                                          {
//                                              "symbol": "${symbol}",
//                                              "width": "100%",
//                                              "height": "100%",
//                                              "locale": "en",
//                                              "dateRange": "1D",
//                                              "colorTheme": "dark",
//                                              "trendLineColor": "%2",
//                                              "isTransparent": true,
//                                              "autosize": false,
//                                              "largeChartUrl": ""
//                                          }
//                                          </script>
//                                        </div>
//                                        <!-- TradingView Widget END -->`.arg(Dex.CurrentTheme.floatingBackgroundColor).arg(Dex.CurrentTheme.textSelectionColor))
            }

            WebEngineView
            {
                id: webEngineView
                anchors.fill: parent
                visible: parent.ticker_supported && !loading
            }

            Connections
            {
                target: Dex.CurrentTheme
                function onThemeChanged()
                {
                    loadChart();
                }
            }

            RowLayout
            {
                visible: !webEngineView.visible && parent.ticker_supported
                anchors.centerIn: parent

                DefaultBusyIndicator
                {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.leftMargin: -15
                    Layout.rightMargin: Layout.leftMargin*0.75
                    scale: 0.5
                }

                DexLabel
                {
                    text_value: qsTr("Loading market data") + "..."
                }
            }

            DexLabel
            {
                visible: !parent.ticker_supported
                text_value: qsTr("There is no chart data for this ticker yet")
                anchors.centerIn: parent
            }
        }

        Rectangle {
            id: transactions_bg
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: layout_margin
            Layout.rightMargin: layout_margin
            Layout.bottomMargin: !fetching_text_row.visible ? layout_margin : undefined

            implicitHeight: wallet.height*0.54

            color: Dex.CurrentTheme.floatingBackgroundColor
            radius: 22

            ClipRRect
            {
                radius: parent.radius
                width: transactions_bg.width
                height: transactions_bg.height

                DexRectangle
                {
                    anchors.fill: parent
                    gradient: Gradient
                    {
                        orientation: Gradient.Vertical
                        GradientStop { position: 0.001; color: Dex.CurrentTheme.innerBackgroundColor }
                        GradientStop { position: 1; color: Dex.CurrentTheme.backgroundColor }
                    }
                }

                DefaultText
                {
                    anchors.centerIn: parent
                    visible: current_ticker_infos.tx_state !== "InProgress" && transactions_mdl.length === 0
                    text_value: api_wallet_page.tx_fetching_busy ? (qsTr("Refreshing") + "...") : qsTr("No transactions")
                    font.pixelSize: Style.textSize
                }

                Transactions
                {
                    width: parent.width
                    height: parent.height
                    model: transactions_mdl.proxy_mdl
                }
            }
        }

        RowLayout
        {
            id: fetching_text_row
            visible: api_wallet_page.tx_fetching_busy
            Layout.preferredHeight: fetching_text.font.pixelSize * 1.5

            Layout.topMargin: -layout_margin*0.5
            Layout.bottomMargin: layout_margin*0.5

            Layout.alignment: Qt.AlignHCenter
            spacing: 10
            DefaultBusyIndicator
            {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: Style.textSizeSmall3
                Layout.preferredHeight: Layout.preferredWidth
            }

            DefaultText
            {
                id: fetching_text
                Layout.alignment: Qt.AlignVCenter
                text_value: qsTr("Fetching transactions") + "..."
                font.pixelSize: Style.textSizeSmall3
            }
        }

        implicitHeight: Math.min(contentItem.childrenRect.height, wallet.height*0.5)
    }
}
