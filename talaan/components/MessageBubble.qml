import QtQuick 2.4
import Ubuntu.Components 1.3
//import QtGraphicalEffects 1.0

Item {
    id: mainContainer
    property string message
    property double fontSize
    property color bgColor: UbuntuColors.warmGrey
    property int showDuration: 2000
    property alias notifyLoaderItem: notifyLoader.item
    property alias internalAnchors: mainContainer.anchors
    property int startPosition: 0
    property real heightLimit: units.gu(15)
    property int endPosition: (parent.width / 2) + units.gu(1)
    property int bubbleWidth: parent.width <= units.gu(
                                  50) ? parent.width - units.gu(
                                            2) : units.gu(40)
    property bool isShown

    z: 100
    height: units.gu(10) //notifyLoader.item !== null ? units.gu(10) : notifyLoader.item.frameShape.height


    function showNotification(txtMessage, txtColor) {
        if (showDuration !== 0) {
            durationTimer.restart()
        }
        notifyLoader.sourceComponent = undefined
        message = (txtMessage === "") ? message : txtMessage
        bgColor = txtColor
        notifyLoader.sourceComponent = notificationUI

        /*Workaround on the issue of TextArea.autosize not properly working on loaders*/
        notifyLoader.item.messageLabel.text = message
        mainContainer.height = notifyLoader.item.frameShape.height
    }
    function hideNotification() {
        //only execute if the notification bubble is visible
        if (isShown) {
            notifyLoaderItem.closingAnimation.running = true
            durationTimer.stop()
            isShown = false
        }
    }

    onIsShownChanged: {
        if (isShown) {
            //console.log("naforceactivefocus")
            notifyLoader.item.messageLabel.forceActiveFocus()
            notifyLoader.item.messageLabel.cursorVisible = false
        }
    }

    Loader {
        id: notifyLoader
        anchors.fill: parent
        onLoaded: {
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
            property alias frameShape: frameShape
            property bool isOpen: false
            property bool isOpening: false
            property bool isClosing: false
            property bool textFocused: false

            UbuntuNumberAnimation on x {
                id: openingAnimation
                from: startPosition
                to: endPosition
                duration: UbuntuAnimation.BriskDuration
                easing: UbuntuAnimation.StandardEasing
                onRunningChanged: {
                    if (!running) {
                        isShown = true
                    }
                }
            }

            UbuntuNumberAnimation on opacity {
                id: closingAnimation
                from: 1
                to: 0
                duration: UbuntuAnimation.SlowDuration
                easing: UbuntuAnimation.StandardEasing
                running: false

                onRunningChanged: {
                    if (!running) {
                        isOpen = false
                        //isShown = false
                        parent.sourceComponent = undefined
                    } else {
                        isClosing = true
                    }
                }
            }

            Rectangle {
                id: frameShape
                color: bgColor === "" ? "black" : bgColor
                anchors.top: parent.top
                anchors.left: parent.left
                height: {
                    if (heightLimit > 0) {
                        if (messageLabel.height > heightLimit) {
                            heightLimit
                        } else {
                            messageLabel.height
                        }
                    } else {
                        messageLabel.height
                    }
                }
                width: bubbleWidth
            }
            MouseArea {
                id: mouseComment
                anchors.fill: frameShape
                onClicked: hideNotification()
            }

            Item {
                id: sideShadow
                z: -1

                anchors {
                    left: frameShape.right
                    bottom: frameShape.bottom
                    top: frameShape.top
                    leftMargin: units.gu(-0.5)
                }
                width: units.gu(1.2)

                Rectangle {
                    id: horizGradient
                    width: parent.height
                    height: parent.width
                    radius: units.gu(0.5)
                    anchors.centerIn: parent
                    rotation: 270
                    gradient: Gradient {
                        GradientStop {
                            position: 0.0
                            color: bgColor //Qt.rgba(0, 0, 0, 0.1)
                        }
                        GradientStop {
                            position: 1.0
                            color: "transparent"
                        }
                    }
                }
            }

            Rectangle {
                z: -1
                id: btmshadow
                radius: units.gu(0.5)
                anchors {
                    left: frameShape.left
                    right: frameShape.right
                    top: frameShape.bottom
                    topMargin: units.gu(-0.5)
                }
                height: units.gu(1.2)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: bgColor /*Qt.rgba(0, 0, 0, 0.1)*/
                    }
                    GradientStop {
                        position: 1.0
                        color: "transparent"
                    }
                }
            }
            ScrollView {
                anchors {
                    fill: frameShape
                }

                Flickable {
                    id: messageFlickable
                    boundsBehavior: Flickable.DragAndOvershootBounds
                    interactive: true
                    contentHeight: messageLabel.contentHeight + units.gu(2)

                    //anchors.fill: parent
                    TextArea {
                        id: messageLabel
                        //text: message
                        font.pixelSize: fontSize
                        //anchors.fill: parent
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                        }
                        autoSize: true
                        readOnly: true
                        maximumLineCount: 0
                        //cursorVisible: selectedText.length > 0 ? true : false
                        verticalAlignment: TextEdit.AlignVCenter
                        wrapMode: TextEdit.WordWrap

                        /*Workaround for bug when autoSize is true, the line count is 1 and the font is too big.
                                            text is clipped horizontally*/
                        Component.onCompleted: {
                            text = "'\n"
                            text = ""
                        }

                        onActiveFocusChanged: {
                            if (!activeFocus && isShown) {
                                hideNotification()
                                //console.log("nawala focus: " + " at " + isShown)
                            } else {

                                //console.log("nagfocus: " + " at " + isShown)
                            }
                        }
                        onSelectedTextChanged: {
                            if (selectedText.length > 0) {
                                cursorVisible = true
                            }
                        }
                    }
                }
            }
        }
    }
}
