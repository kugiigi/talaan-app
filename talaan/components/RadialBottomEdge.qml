import QtQuick 2.4
import Lomiri.Components 1.3

Item {
    id: root

    property int hintSize: units.gu(8)
    property color hintColor: Theme.palette.normal.overlay
    property string hintIconName: "view-grid-symbolic"
    property alias hintIconSource: hintIcon.source
    property color hintIconColor: LomiriColors.coolGrey
    property bool bottomEdgeEnabled: true
    property color bgColor: "black"
    property real bgOpacity: 0.7

    property string mode: "Always"
    property int semiHideOpacity: 50
    property int timeoutSeconds: 2

    property real expandedPosition: 0.6 * height
    property real collapsedPosition: height - hintSize / 2

    property list<RadialAction> actions
    property ListModel leadingActions
    property real actionButtonSize: units.gu(7)
    property real actionButtonDistance: 1.5 * hintSize

    anchors.fill: parent

    Component.onCompleted: {
        timeoutTimer.restart()
    }

    function collapse() {
        bottomEdgeHint.state = "collapsed"
        timeoutTimer.interval = timeoutSeconds * 1000
        switchToTimeout()
    }

    function expand() {
        bottomEdgeHint.state = "expanded"
        timeoutTimer.interval = (timeoutSeconds * 2) * 1000
        switchToNormal()
    }

    function switchToNormal() {
        root.opacity = 1
    }

    function switchToTimeout() {
        timeoutTimer.restart()
    }

    onModeChanged: {
        collapse()
        switchToNormal()
    }

    Behavior on opacity {
        LomiriNumberAnimation {
            easing.type: Easing.OutCubic
            duration: LomiriAnimation.SlowDuration
        }
    }

    Rectangle {
        id: bgVisual

        z: 1
        color: bgColor
        anchors.fill: parent
        visible: bottomEdgeHint.y !== collapsedPosition
        opacity: bgOpacity * (((root.height - bottomEdgeHint.y) / root.height) * 2)
        MouseArea {
            anchors.fill: parent
            enabled: bgVisual.visible
            onClicked: root.collapse()
            z: 1
        }
    }

    Rectangle {
        id: bottomEdgeHint

        color: hintColor
        width: hintSize
        height: width
        radius: width / 2
        visible: bottomEdgeEnabled
        opacity: 0.7

        anchors.horizontalCenter: parent.horizontalCenter
        y: collapsedPosition
        z: parent.z + 1

        Icon {
            id: hintIcon
            width: hintSize / 4
            height: width
            name: hintIconName
            color: hintIconColor
            anchors {
                centerIn: parent
                verticalCenterOffset: width * ((bottomEdgeHint.y - expandedPosition)
                                               / (expandedPosition - collapsedPosition))
            }
        }

        property real actionListDistance: -actionButtonDistance
                                          * ((bottomEdgeHint.y - collapsedPosition)
                                             / (collapsedPosition - expandedPosition))

        Repeater {
            id: actionList
            visible: false
            model: actions !== null ? actions : null
            delegate: Rectangle {
                id: actionDelegate
                visible: !modelData.hide
                opacity: (Math.abs(
                              collapsedPosition - bottomEdgeHint.y) / Math.abs(
                              collapsedPosition - expandedPosition))
                readonly property real radAngle: (index % actionList.count
                                                  * (360 / actionList.count)) * Math.PI / 180
                property real distance: bottomEdgeHint.actionListDistance

                z: -1
                width: actionButtonSize
                height: width
                radius: width / 2
                anchors.centerIn: parent
                color: modelData.backgroundColor
                transform: Translate {
                    x: distance * Math.sin(radAngle)
                    y: -distance * Math.cos(radAngle)
                }

                Behavior on color {
                    ColorAnimation {
                        easing.type: Easing.OutCubic
                        duration: LomiriAnimation.BriskDuration
                    }
                }

                Icon {
                    anchors.centerIn: parent
                    width: parent.width / 2
                    height: width
                    name: modelData.iconName
                    color: modelData.iconColor
                }

                MouseArea {
                    anchors.fill: parent
                    enabled: bottomEdgeHint.state === "expanded" ? true : false
                    hoverEnabled: true
                    onClicked: {
                        root.collapse()
                        modelData.triggered(null)
                    }
                    onContainsMouseChanged: {
                        if (containsMouse) {
                            root.switchToNormal()
                        } else {
                            root.switchToTimeout()
                        }
                    }
                    onPressedChanged: {
                        if (pressed) {
                            actionDelegate.color = "#3A000000"
                        } else {
                            actionDelegate.color = modelData.backgroundColor
                        }
                    }
                }
                Label {
                    id: labelTool
                    text: modelData.label
                    visible: text && bottomEdgeHint.state == "expanded"
                    color: "white"
                    font.bold: true
                    y: parent.y + parent.height + units.gu(1)
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }

        MouseArea {
            id: mouseArea

            property real previousY: -1
            property string dragDirection: "None"

            z: 1
            anchors.fill: parent
            visible: bottomEdgeEnabled
            hoverEnabled: true

            preventStealing: true
            drag {
                axis: Drag.YAxis
                target: bottomEdgeHint
                minimumY: expandedPosition
                maximumY: collapsedPosition
            }

            onReleased: {
                if ((dragDirection === "BottomToTop")
                        && bottomEdgeHint.y < collapsedPosition) {
                    root.expand()
                } else {
                    if (bottomEdgeHint.state === "collapsed") {
                        bottomEdgeHint.y = collapsedPosition
                    }
                    root.collapse()
                }
                previousY = -1
                dragDirection = "None"
            }

            onClicked: {
                if (bottomEdgeHint.y === collapsedPosition)
                    root.expand()
                else
                    root.collapse()
            }

            onPressed: {
                previousY = bottomEdgeHint.y
                actionList.visible = true
                bottomEdgeHint.opacity = 1
            }

            onMouseYChanged: {
                var yOffset = previousY - bottomEdgeHint.y
                if (Math.abs(yOffset) <= units.gu(2)) {
                    return
                }
                previousY = bottomEdgeHint.y
                dragDirection = yOffset > 0 ? "BottomToTop" : "TopToBottom"
            }
            onContainsMouseChanged: {
                if (containsMouse) {
                    root.switchToNormal()
                } else {
                    root.switchToTimeout()
                }
            }
        }

        state: "collapsed"
        states: [
            State {
                name: "collapsed"
                PropertyChanges {
                    target: bottomEdgeHint
                    y: collapsedPosition
                    opacity: 0.7
                }
            },
            State {
                name: "expanded"
                PropertyChanges {
                    target: bottomEdgeHint
                    y: expandedPosition
                    opacity: 1
                }
            },

            State {
                name: "floating"
                when: mouseArea.drag.active
                PropertyChanges {
                    target: bottomEdgeHint
                    opacity: 1
                }
            }
        ]

        transitions: [
            Transition {
                to: "expanded"
                SpringAnimation {
                    target: bottomEdgeHint
                    property: "y"
                    spring: 2
                    damping: 0.2
                }
            },

            Transition {
                to: "collapsed"
                SmoothedAnimation {
                    target: bottomEdgeHint
                    property: "y"
                    duration: LomiriAnimation.BriskDuration
                }
            }
        ]
    }

    Loader {
        id: backActionLoader

        property bool heightEnough: item === null ? false : root.height
                                                    < (item.y + actionButtonSize) ? false : true

        z: 100
        active: leadingActions === null ? false : leadingActions.count === 0 ? false : true

        state: root.height > units.gu(75) ? "middle" : "right"

        states: [
            State {
                name: "right"

                AnchorChanges {
                    target: backActionLoader
                    anchors.right: root.right
                    anchors.verticalCenter: bottomEdgeHint.verticalCenter
                    anchors.top: undefined
                    anchors.horizontalCenter: undefined
                }
                PropertyChanges {
                    target: backActionLoader
                    anchors.rightMargin: units.gu(1)
                    anchors.topMargin: 0
                }
            },
            State {
                name: "middle"

                AnchorChanges {
                    target: backActionLoader
                    anchors.right: undefined
                    anchors.verticalCenter: undefined
                    anchors.top: bottomEdgeHint.bottom
                    anchors.horizontalCenter: root.horizontalCenter
                }
                PropertyChanges {
                    target: backActionLoader
                    anchors.rightMargin: 0
                    anchors.topMargin: units.gu(5) + actionButtonDistance
                }
            }
        ]

        sourceComponent: backActionComponent
        asynchronous: true
        visible: status == Loader.Ready
    }

    Component {
        id: backActionComponent
        Rectangle {
            id: recBack
            visible: leadingActions.get(0).action.visible
            opacity: (Math.abs(collapsedPosition - bottomEdgeHint.y) / Math.abs(
                          collapsedPosition - expandedPosition))

            width: actionButtonSize
            height: width
            radius: width / 2

            color: switch (settings.currentTheme) {
                   case "Default":
                       theme.palette.normal.overlay
                       break
                   case "System":
                   case "Ambiance":
                       theme.palette.normal.foreground
                       break
                   case "SuruDark":
                       theme.palette.normal.overlay
                       break
                   default:
                       theme.palette.normal.overlay
                   }

            Behavior on color {
                ColorAnimation {
                    easing.type: Easing.OutCubic
                    duration: LomiriAnimation.BriskDuration
                }
            }

            Icon {
                anchors.centerIn: parent
                width: parent.width / 2
                height: width
                name: leadingActions.get(0).action.iconName
                color: switch (settings.currentTheme) {
                       case "Default":
                           LomiriColors.porcelain
                           break
                       case "System":
                       case "Ambiance":
                           theme.palette.normal.foregroundText
                           break
                       case "SuruDark":
                           theme.palette.normal.overlayText
                           break
                       default:
                           LomiriColors.porcelain
                       }
            }

            MouseArea {
                anchors.fill: parent
                enabled: bottomEdgeHint.state === "expanded" ? true : false
                hoverEnabled: true
                onClicked: {
                    leadingActions.get(0).action.trigger()
                    root.collapse()
                }
                onContainsMouseChanged: {
                    if (containsMouse) {
                        root.switchToNormal()
                    } else {
                        root.switchToTimeout()
                    }
                }

                onPressedChanged: {
                    if (pressed) {
                        recBack.color = "#3A000000"
                    } else {
                        switch (settings.currentTheme) {
                        case "Default":
                            recBack.color = theme.palette.normal.overlay
                            break
                        case "System":
                        case "Ambiance":
                            recBack.color = theme.palette.normal.foreground
                            break
                        case "SuruDark":
                            recBack.color = theme.palette.normal.overlay
                            break
                        default:
                            recBack.color = theme.palette.normal.overlay
                        }
                    }
                }
            }
        }
    }

    Timer {
        id: timeoutTimer
        interval: timeoutSeconds * 1000
        running: false
        onTriggered: {
            root.collapse()

            switch (root.mode) {
            case "Autohide":
                root.opacity = 0
                break
            case "Semihide":
                root.opacity = root.semiHideOpacity / 100
                break
            }
        }
    }
}
