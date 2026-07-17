import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import Lomiri.Components 1.3 as UT
import "." as Local
import ".." as Common

Item {
    id: bottomHorizontalSwipe

    readonly property alias swipeHandler: horizontalSwipeHandler

    property alias enabled: horizontalSwipeHandler.enabled
    property alias gestureAreaHeight: horizontalSwipeHandler.height
    property alias gestureAreaWidth: horizontalSwipeHandler.width
    property var leftActions
    property var rightActions
    property alias stageTrigger: horizontalSwipeHandler.stageTrigger
    property alias leftActionIconName: leftAction.iconName
    property alias rightActionIconName: rightAction.iconName
    property alias leftActionText: leftAction.text
    property alias rightActionText: rightAction.text

    property bool enableDirectActions: false
    property bool leftActionEnabled: false
    property bool rightActionEnabled: false
    property bool isWideLayout: false
    property real selectionSensitivity: 0.5 // 0.1 to 1.0 - high to low sensitivity

    signal rightSwipe
    signal leftSwipe

    QtObject {
        id: internal

        readonly property real stagePixelValue: horizontalSwipeHandler.getStagePixelValue(bottomHorizontalSwipe.stageTrigger - 1)
        readonly property real maxActionsWidth: Suru.units.gu(50)
        readonly property real actionsMargin: Suru.units.gu(3)
    }

    Common.BaseAction {
        id: leftAction

        onTrigger: bottomHorizontalSwipe.rightSwipe()
    }

    Common.BaseAction {
        id: rightAction

        onTrigger: bottomHorizontalSwipe.leftSwipe()
    }

    Local.HorizontalSwipeActions {
        id: leftActionsRow

        model: bottomHorizontalSwipe.enableDirectActions ? bottomHorizontalSwipe.leftActions : [ leftAction ]
        width: bottomHorizontalSwipe.isWideLayout ? internal.maxActionsWidth : parent.width - (internal.actionsMargin * 2)
        alignment: Qt.AlignCenter
        edge: HorizontalSwipeActions.Edge.Left
        shown: horizontalSwipeHandler.isTriggerReady && horizontalSwipeHandler.distance > 0 && bottomHorizontalSwipe.rightActionEnabled
        currentIndex: Math.min(Math.round(Math.abs(horizontalSwipeHandler.distance - internal.stagePixelValue)
                                                / (itemRegionWidth * bottomHorizontalSwipe.selectionSensitivity))
                                    , visibleActionsCount - 1)
        anchors {
            left: parent.left
            leftMargin: internal.actionsMargin
            verticalCenter: parent.verticalCenter
        }
    }

    Local.HorizontalSwipeActions {
        id: rightActionsRow

        model: bottomHorizontalSwipe.enableDirectActions ? bottomHorizontalSwipe.rightActions : [ rightAction ]
        width: bottomHorizontalSwipe.isWideLayout ? internal.maxActionsWidth : parent.width - (internal.actionsMargin * 2)
        alignment: Qt.AlignCenter
        edge: HorizontalSwipeActions.Edge.Right
        shown: horizontalSwipeHandler.isTriggerReady && horizontalSwipeHandler.distance < 0 && bottomHorizontalSwipe.leftActionEnabled
        currentIndex: Math.max(Math.round(visibleActionsCount - (Math.abs(horizontalSwipeHandler.distance + internal.stagePixelValue)
                                                            / (itemRegionWidth * bottomHorizontalSwipe.selectionSensitivity)))
                                        , 0)
        anchors {
            right: parent.right
            rightMargin: internal.actionsMargin
            verticalCenter: parent.verticalCenter
        }
    }

    Local.SwipeGestureHandler {
        id: horizontalSwipeHandler

        readonly property bool isTriggerReady: dragging && stage >= stageTrigger
        property int stageTrigger: 2

        direction: UT.SwipeArea.Horizontal
        width: parent.width
        height: Suru.units.gu(2)

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }

        onPressedChanged: if (pressed) Common.Haptics.playSubtle()

        onIsTriggerReadyChanged: {
            if (!isTriggerReady) {
                Common.Haptics.playSubtle()
            }
        }

        onDraggingChanged: {
            if (!dragging) {
                if (leftActionsRow.shown && leftActionsRow.highlightedItem) {
                    leftActionsRow.highlightedItem.trigger()
                }

                if (rightActionsRow.shown && rightActionsRow.highlightedItem) {
                    rightActionsRow.highlightedItem.trigger()
                }
            }
        }
    }
}
