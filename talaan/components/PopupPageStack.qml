import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import "../common" as Common
import "../common/dialogs" as Dialogs
import "../common/pages" as PageComponents

Dialogs.BasePopup {
    id: popupPageStack

    readonly property real preferredWidthInWide: Suru.units.gu(60)
    readonly property real preferredHeightInWide: parent.height - verticalMargin
    readonly property real maximumHeightInWide: Suru.units.gu(150)
    readonly property bool isWideLayout: parent.width >= preferredWidthInWide * 1.5 && parent.height > Suru.units.gu(60)
    readonly property real defaultPadding: isWideLayout ? Suru.units.gu(0.2) : 0
    readonly property real verticalMargin: Suru.units.gu(7)
    readonly property alias pageHeader: pageStack.pageHeader

    maximumWidth: isWideLayout ? preferredWidthInWide : parent.width
    maximumHeight: isWideLayout ? Math.min(preferredHeightInWide, maximumHeightInWide) : parent.height
    preferredHeight: parent.height
    y: isWideLayout ? verticalMargin : (parent.height - height) / 2

    topPadding: defaultPadding
    bottomPadding: defaultPadding
    leftPadding: defaultPadding
    rightPadding: defaultPadding

    function openInPage(item, properties, operation = StackView.Transition) {
        pageStack.replace(item, properties, operation)
        open()
    }

    PageComponents.BasePageStack {
        id: pageStack

        anchors.fill: parent
        focus: true
        isWideLayout: popupPageStack.isWideLayout
        enableShortcuts: true
        enableBottomGestureHint: !mainView.settings.hideBottomHint
        enableHeaderPullDown: mainView.settings.headerPullDown
        enableBottomSideSwipe: mainView.settings.sideSwipe
        enableDirectActions: mainView.settings.directActions
        enableDirectActionsDelay: mainView.settings.quickActionEnableDelay
        enableBottomQuickSwipe: mainView.settings.quickSideSwipe
        enableHorizontalSwipe: mainView.settings.horizontalSwipe
        enableHorizontalDirectActions: mainView.settings.horizontalDirectActions
        horizontalDirectActionsSensitivity: mainView.settings.horizontalDirectActionsSensitivity
        bottomGestureAreaHeight: mainView.settings.bottomGesturesAreaHeight
        directActionsHeight: mainView.settings.quickActionsHeight

        defaultLeftActions: [ closeAction ]
        
        Common.BaseAction {
            id: closeAction

            text: popupPageStack.isWideLayout ? i18n.tr("Close") : i18n.tr("Back")
            iconName: popupPageStack.isWideLayout ? "close" : "back"
            shortcut: popupPageStack.isWideLayout ? StandardKey.Cancel : StandardKey.Back
            enabled: visible

            onTrigger: popupPageStack.close()
        }
    }
}
