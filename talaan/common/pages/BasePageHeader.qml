import QtQuick 2.12
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import Lomiri.Components 1.3
import QtGraphicalEffects 1.12
import ".." as Common
import "../menus" as Menus
import "pageheader"

QQC2.ToolBar {
    id: pageHeader

    readonly property real defaultHeight: units.gu(6)
    readonly property real maxHeight:  parent.height * 0.4
    readonly property real expansionThreshold: maxHeight * 0.10
    readonly property HeaderTitleGroupedProperties customTitleItem: HeaderTitleGroupedProperties {
        sourceComponent: null
        hideOnExpand: true
        fillHeight: false
        fillWidth: true
        alignment: Qt.AlignCenter
    }
    readonly property int leftVisibleActionsCount: leftHeaderActions.visibleActionsCount
    readonly property int rightVisibleActionsCount: rightHeaderActions.visibleActionsCount
    readonly property Common.BaseAction leftVisibleAction: leftHeaderActions.firstVisibleAction
    readonly property Common.BaseAction rightVisibleAction: rightHeaderActions.firstVisibleAction

    property string title
    property var leftActions
    property var rightActions
    property Item currentItem
    property bool enableDropShadow: false
    property bool expanded: false
    property bool expandable: false
    property bool showDivider: true
    readonly property bool allowOverflowRight: currentItem && currentItem.hasOwnProperty("allowRightOverflow")
                                               && currentItem.allowRightOverflow
    property alias rightOverflowThreshold: rightHeaderActions.overflowThreshold

    //WORKAROUND: Label "HorizontalFit" still uses the height of the unadjusted font size.
    implicitHeight: defaultHeight

    background: Rectangle {
        implicitHeight: Suru.units.gu(6)
        color: Suru.backgroundColor

        Rectangle {
            anchors { left: parent.left; right: parent.right }
            anchors.top: pageHeader.position == QQC2.ToolBar.Header ? parent.bottom : undefined
            anchors.bottom: pageHeader.position == QQC2.ToolBar.Footer ? parent.top : undefined
            height: Suru.units.dp(1)
            color: Suru.neutralColor
            visible: pageHeader.showDivider
        }
        
        layer.enabled: pageHeader.enableDropShadow
        layer.effect: DropShadow {
            readonly property color shadowColor: Suru.foregroundColor

            cached: true
            verticalOffset: 10
            radius: (samples - 1) * 0.5
            samples: 25
            color: Qt.hsla(shadowColor.hslHue, shadowColor.hslSaturation, shadowColor.hslLightness, 0.2)
            source: pageHeader.background
        }
    }


    function triggerRightFromBottom() {
        if (rightVisibleActionsCount > 0) {
            if (rightVisibleActionsCount === 1) {
                rightHeaderActions.triggerFirstVisibleItem()
            } else {
                menuComponent.createObject(pageHeader.currentItem).showToTheRight()
            }
        }
    }

    function triggerLeftFromBottom() {
        if (leftVisibleActionsCount > 0) {
            if (leftVisibleActionsCount === 1) {
                leftHeaderActions.triggerFirstVisibleItem()
            } else {
                menuComponent.createObject(pageHeader.currentItem).showToTheLeft()
            }
        }
    }

    function resetHeight() {
        if (expanded) {
            expandAnimation.restart()
        } else {
            collapseAnimation.restart()
        }
    }

    function expand() {
        expanded = true
    }

    function collapse() {
        expanded = false
    }

    onExpandableChanged: if (!expandable) expanded = false
    onExpandedChanged: {
        if (expanded) {
            expandAnimation.restart()
        } else {
            collapseAnimation.restart()
        }
    }

    LomiriNumberAnimation on height {
        id: expandAnimation

        running: false
        to: maxHeight
        duration: LomiriAnimation.SnapDuration
    }

    LomiriNumberAnimation on height {
        id: collapseAnimation

        running: false
        to: defaultHeight
        duration: LomiriAnimation.SnapDuration
    }

    ColumnLayout {
        anchors.fill: parent

        HeaderTitle {
            id: expandedHeaderTitle

            Layout.fillWidth: true
            Layout.fillHeight: true
            Suru.textLevel: Suru.HeadingOne
            horizontalAlignment: Text.AlignHCenter
            text: pageHeader.currentItem && pageHeader.currentItem.title ? pageHeader.currentItem.title : pageHeader.title
            opacity: pageHeader.height - pageHeader.defaultHeight < pageHeader.maxHeight * 0.2 ? 0
                                : 1 - ((pageHeader.maxHeight - pageHeader.height) / ((pageHeader.maxHeight * 0.8) - pageHeader.defaultHeight))
            visible: opacity > 0
            Behavior on opacity { LomiriNumberAnimation { duration: LomiriAnimation.SnapDuration } }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignBottom

            spacing: units.gu(1)

            HeaderActions {
                id: leftHeaderActions

                Layout.fillWidth: false
                Layout.preferredHeight: pageHeader.defaultHeight
                Layout.alignment: Qt.AlignBottom
                model: pageHeader.leftActions
                currentItem: pageHeader.currentItem
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: pageHeader.customTitleItem.fillHeight
                Layout.preferredHeight: customTitleItemLoader.height
                Layout.alignment: {
                    if (pageHeader.customTitleItem.alignment & Qt.AlignBottom) {
                            return Qt.AlignBottom
                    } else if (pageHeader.customTitleItem.alignment & Qt.AlignTop) {
                        return Qt.AlignTop
                    } else {
                        return Qt.AlignVCenter
                    }
                }

                Loader {
                    id: customTitleItemLoader

                    anchors {
                        top: pageHeader.customTitleItem.fillHeight || pageHeader.customTitleItem.alignment & Qt.AlignTop
                                    ? parent.top : undefined
                        bottom: pageHeader.customTitleItem.fillHeight || pageHeader.customTitleItem.alignment & Qt.AlignBottom
                                    ? parent.bottom : undefined
                        horizontalCenter: !pageHeader.customTitleItem.fillWidth
                                        && (pageHeader.customTitleItem.alignment & Qt.AlignHCenter
                                                || pageHeader.customTitleItem.alignment & Qt.AlignCenter) ? parent.horizontalCenter : undefined
                        verticalCenter: !pageHeader.customTitleItem.fillHeight
                                        && (pageHeader.customTitleItem.alignment & Qt.AlignVCenter
                                                || pageHeader.customTitleItem.alignment & Qt.AlignCenter) ? parent.verticalCenter : undefined
                        left: pageHeader.customTitleItem.fillWidth || pageHeader.customTitleItem.alignment & Qt.AlignLeft
                                    ? parent.left : undefined
                        right: pageHeader.customTitleItem.fillWidth || pageHeader.customTitleItem.alignment & Qt.AlignRight ? parent.right : undefined
                    }

                    active: true
                    asynchronous: true
                    sourceComponent: pageHeader.customTitleItem.sourceComponent
                    opacity: pageHeader.expanded && pageHeader.customTitleItem.hideOnExpand ? 0 : 1
                    Behavior on opacity { LomiriNumberAnimation {} }
                }
            }

            HeaderTitle {
                id: headerTitle

                Layout.fillWidth: true
                Suru.textLevel: pageHeader.expanded ? Suru.HeadingOne : Suru.HeadingTwo
                text: pageHeader.currentItem && pageHeader.currentItem.title ? pageHeader.currentItem.title : ""
                opacity: customTitleItemLoader.item ? 0
                                                    : pageHeader.height == pageHeader.defaultHeight ? 1 
                                                                : expandedHeaderTitle.opacity > 0.2 ? 0 : 0.5 - expandedHeaderTitle.opacity
                visible: opacity > 0 || (pageHeader.expanded && !customTitleItemLoader.item)
                Behavior on opacity { LomiriNumberAnimation { duration: LomiriAnimation.SnapDuration } }
            }

            HeaderActions {
                id: rightHeaderActions

                Layout.fillWidth: false
                Layout.preferredHeight: pageHeader.defaultHeight
                Layout.alignment: Qt.AlignBottom
                model: pageHeader.rightActions
                currentItem: pageHeader.currentItem
                allowOverflow: pageHeader.allowOverflowRight
                buttonDisplay: QQC2.AbstractButton.TextUnderIcon
            }
        }
    }

    Component {
        id: menuComponent

        Menus.VerticalMenuActions {
            id: bottomMenu

            readonly property real edgMargin: units.gu(2)
            readonly property real wideWidth: units.gu(40)
            readonly property real narrowWidth: parent.width * 0.9
            readonly property bool isWideLayout: parent.width > wideWidth * 1.5

            implicitWidth: isWideLayout ? wideWidth : narrowWidth
            modal: true

            function showToTheRight() {
                x = Qt.binding( function() { return parent ? isWideLayout ? parent.width - width - edgMargin : (parent.width / 2) - (width / 2)
                                                           : 0 } )
                transformOrigin = QQC2.Menu.BottomRight
                model = pageHeader.rightActions
                openBottom()
            }

            function showToTheLeft() {
                x = Qt.binding( function() { return parent ? isWideLayout ? edgMargin : (parent.width / 2) - (width / 2)
                                                           : 0 } )
                transformOrigin = QQC2.Menu.BottomLeft
                model = pageHeader.leftActions
                openBottom()
            }
        }
    }
}
