import QtQuick 2.4
import Lomiri.Components 1.3

Item {
    id: mainContainer
    property string message
    property color bgColor: LomiriColors.warmGrey
    property int showDuration: 3000
    property alias notifyLoaderItem: notifyLoader.item
    property alias internalAnchors: mainContainer.anchors
    property real bubbleOffset: units.gu(2)

    z: 100
    height: units.gu(10)

    function showNotification(txtMessage, txtColor) {
        if (showDuration !== 0) {
            durationTimer.restart()
        }
        notifyLoader.sourceComponent = undefined
        message = (txtMessage === "") ? message : txtMessage
        bgColor = txtColor
        //showDuration = (intDuration === null) ? showDuration : intDuration
        notifyLoader.sourceComponent = notificationUI
        notifyLoader.item.forceActiveFocus()
    }

    anchors {
        top: parent.top
        //bottom: parent.bottom
        horizontalCenter: parent.horizontalCenter
        margins: units.gu(2)
    }

    Loader {
        id: notifyLoader
        anchors.fill: parent
        onLoaded: {

            //wraps notification text when length is longer than the page.
            if (notifyLoaderItem.messageLabel.width > parent.parent.width) {
                notifyLoaderItem.messageLabel.anchors.left
                        = notifyLoaderItem.messageLabel.parent.left
                notifyLoaderItem.messageLabel.anchors.right
                        = notifyLoaderItem.messageLabel.parent.right
                notifyLoaderItem.messageLabel.anchors.horizontalCenter = undefined
                parent.anchors.horizontalCenter = undefined
                parent.anchors.left = parent.parent.left
                parent.anchors.right = parent.parent.right
            } else {
                notifyLoaderItem.messageLabel.anchors.left = undefined
                notifyLoaderItem.messageLabel.anchors.right = undefined
                parent.anchors.left = undefined
                parent.anchors.right = undefined
                parent.anchors.horizontalCenter = parent.parent.horizontalCenter
                notifyLoaderItem.messageLabel.anchors.horizontalCenter
                        = notifyLoaderItem.messageLabel.parent.horizontalCenter
            } /*var mapped = listWithActions.mapToItem(commentBubble,
                                                                   commentBubble.x,
                                                                                                                          commentBubble.y)*/
            if (showDuration !== 0) {
                durationTimer.start()
            }
        }
    }
    Timer {
        id: durationTimer
        interval: showDuration
        onTriggered: {
            notifyLoaderItem.closingAnimation.running = true
        }
    }

    Component {
        id: notificationUI
        Item {
            //property color bgColor
            id: notificationItem
            property alias closingAnimation: closingAnimation
            property alias messageLabel: messageLabel
            property bool isOpen: false
            property bool isOpening: false
            property bool isClosing: false

            LomiriNumberAnimation on y {
                id: openingAnimation

                from: 0 //parent === null ? 0 : parent.height
                to: bubbleOffset //units.gu(5)//parent === null ? 1 : parent.height - (frameShape.height * 2)
                duration: LomiriAnimation.BriskDuration //SnapDuration
                easing: LomiriAnimation.StandardEasing
            }

            LomiriNumberAnimation on opacity {
                id: closingAnimation
                from: 1
                to: 0
                duration: LomiriAnimation.SlowDuration
                easing: LomiriAnimation.StandardEasing
                running: false

                onRunningChanged: {
                    if (!running) {
                        isOpen = false
                        parent.sourceComponent = null
                    } else {
                        isClosing = true
                    }
                }
            }
            Rectangle {
                id: frameShape
                color: bgColor === "" ? "black" : bgColor
                //anchors.fill: parent
                anchors.centerIn: parent
                height: messageLabel.height + units.gu(2)
                width: messageLabel.width + units.gu(4) + units.gu(message.length)
                opacity: 0.9
                radius: units.gu(10)
            }
            Label {
                id: messageLabel
                text: message
                color: LomiriColors.porcelain
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }
        }
    }
}
