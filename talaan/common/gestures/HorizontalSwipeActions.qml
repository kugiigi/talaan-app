import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import Lomiri.Components 1.3 as UT
import "." as Local

Item {
    id: actionsRow

    enum Edge {
        Left
        , Right
    }

    readonly property int visibleActionsCount: rowLayout.visibleChildren.length
    readonly property real itemPreferredWidth: (width - ((rowLayout.spacing * visibleActionsCount) - 1)) / visibleActionsCount
    readonly property real itemMaximumWidth: Suru.units.gu(6)
    readonly property real itemRegionWidth: visibleActionsCount > 0 ? rowLayout.width / visibleActionsCount : itemMaximumWidth
    readonly property var highlightedItem: internal.highlightedItem

    property alias model: actionsRepeater.model
    property int alignment: Qt.AlignHCenter
    property int currentIndex: 0
    property bool shown: false
    property int edge: HorizontalSwipeActions.Edge.Left

    visible: opacity > 0
    opacity: shown ? 1 : 0

    Behavior on opacity { NumberAnimation { duration: Suru.animations.FastDuration } }

    onHighlightedItemChanged: {
        if (highlightedItem) {
            delayShow.restart()
        } else {
            itemLabel.hideNow()
        }
    }

    onShownChanged: {
        if (!shown) {
            itemLabel.hideNow()
        }
    }

    RowLayout {
        id: rowLayout

        width: ((parent.width - (spacing * actionsRow.visibleActionsCount - 1)) / actionsRow.itemMaximumWidth) >= actionsRow.visibleActionsCount ? implicitWidth : parent.width
        anchors {
            horizontalCenter: parent.horizontalCenter
            horizontalCenterOffset: actionsRow.shown ? 0
                                            : actionsRow.edge == HorizontalSwipeActions.Edge.Left ? -(actionsRow.width / 2)
                                                            : actionsRow.width / 2
        }

        Behavior on anchors.horizontalCenterOffset {
            NumberAnimation {
                duration: Suru.animations.SnapDuration
            }
        }

        states: [
            State {
                name: "left"
                when: actionsRow.alignment == Qt.AlignLeft

                AnchorChanges {
                    target: rowLayout

                    anchors.left: parent.left
                    anchors.right: undefined
                    anchors.horizontalCenter: undefined
                }
            }
            , State {
                name: "right"
                when: actionsRow.alignment == Qt.AlignRight

                AnchorChanges {
                    target: rowLayout

                    anchors.left: undefined
                    anchors.right: parent.right
                    anchors.horizontalCenter: undefined
                }
            }
        ]

        Repeater {
            id: actionsRepeater

            visible: false
            delegate: Local.HorizontalSwipeActionDelegate {
                property string text: modelData.text

                Layout.alignment: actionsRow.alignment
                Layout.preferredWidth: preferredWidth
                Layout.preferredHeight: preferredWidth
                Layout.maximumWidth: maximumWidth
                Layout.maximumHeight: maximumWidth

                highlighted: rowLayout.visibleChildren[currentIndex] == this
                maximumWidth: actionsRow.itemMaximumWidth
                preferredWidth: actionsRow.itemPreferredWidth
                visible: modelData.visible && modelData.enabled
                iconName: modelData.iconName

                function trigger() {
                    modelData.trigger(this, false)
                }

                onHighlightedChanged: if (highlighted) internal.highlightedItem = this
            }
        }
    }
    
    Label {
        id: itemLabel

        property bool show: false

        Suru.textLevel: Suru.HeadingThree
        Suru.textStyle: Suru.TertiaryText
        horizontalAlignment: Text.AlignHCenter
        anchors {
            bottom: parent.top
            bottomMargin: Suru.units.gu(3)
            left: parent.left
            right: parent.right
            leftMargin: background.horizontalPadding
            rightMargin: background.horizontalPadding
        }
        states: [
            State {
                name: "left"
                when: actionsRow.alignment == Qt.AlignLeft
                AnchorChanges {
                    target: itemLabel
                    anchors.left: actionsRow.left
                    anchors.right: undefined
                }
            }
            , State {
                name: "right"
                when: actionsRow.alignment == Qt.AlignRight
                AnchorChanges {
                    target: itemLabel
                    anchors.left: undefined
                    anchors.right: actionsRow.right
                }
            }
        ]

        visible: opacity > 0
        opacity: show ? 1 : 0
        color: theme.palette.normal.foregroundText
        text: internal.highlightedItem ? internal.highlightedItem.text : ""
        wrapMode: Text.WordWrap

        background: Item {
            readonly property real horizontalPadding: Suru.units.gu(2)

            anchors {
                horizontalCenter: itemLabel.horizontalCenter
                left: actionsRow.alignment == Qt.AlignLeft ? parent.left : undefined
                right: actionsRow.alignment == Qt.AlignRight ? parent.right : undefined
                leftMargin: -horizontalPadding
                rightMargin: -horizontalPadding
                verticalCenter: parent.verticalCenter
            }
            width: itemLabel.contentWidth + horizontalPadding * 2
            height: itemLabel.contentHeight + Suru.units.gu(1)

            Rectangle {
                id: textBg

                radius: Suru.units.gu(2)
                anchors.fill: parent
                color: theme.palette.highlighted.foreground
            }
        }

        function hideNow() {
            show = false
            delayShow.stop()
        }

        Timer {
            id: delayShow
            running: false
            interval: 800
            onTriggered: itemLabel.show = internal.highlightedItem && internal.highlightedItem.highlighted
        }

        Behavior on opacity { NumberAnimation { duration: Suru.animations.BriskDuration } }
    }

    QtObject {
        id: internal

        property var highlightedItem
    }
}
