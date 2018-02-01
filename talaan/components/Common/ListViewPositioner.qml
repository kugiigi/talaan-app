import QtQuick 2.4
import Ubuntu.Components 1.3

Rectangle {
    id: root

    property string mode: "Down"
    property bool hide: false
    readonly property color bgColor: switch(settings.currentTheme){
                                     case "Default":
                                         theme.palette.normal.overlay
                                         break;
                                     case "Ambiance":
                                         theme.palette.normal.backgroundSecondaryText
                                         break;
                                     case "SuruDark":
                                         theme.palette.normal.overlay
                                         break;
                                     default:
                                         theme.palette.normal.overlay
                                     }

    height: units.gu(8)
    width: height
    radius: height
    color: bgColor
    visible: opacity != 0
    opacity: {
        if (!root.hide) {
            if (root.mode === "Up") {
                root.parent.visibleArea.yPosition
                        + root.parent.visibleArea.heightRatio > 0.10 ? 1 : 0
            } else {
                root.parent.visibleArea.yPosition
                        + root.parent.visibleArea.heightRatio < 0.95 ? 1 : 0
            }
        } else {
            0
        }
    }

    anchors {
        right: parent.right
        rightMargin: units.gu(3)
        bottom: parent.bottom
        bottomMargin: units.gu(5)
    }

    Connections {
        id: parentFlickable
        target: root.parent

        onVerticalVelocityChanged: {
            if(target.verticalVelocity === 0){
                timer.start()
            }else{
                timer.stop()
                root.hide = false
                if (target.verticalVelocity < 0) {
                    root.mode = "Up"
                } else{
                    root.mode = "Down"
                }
            }
        }
    }

//    Behavior on opacity {
//        UbuntuNumberAnimation {
//            easing.type: Easing.OutCubic
//            duration: UbuntuAnimation.SlowDuration
//        }
//    }

    Behavior on color {
        ColorAnimation {
            easing: UbuntuAnimation.StandardEasing
            duration: UbuntuAnimation.BriskDuration
        }
    }

    Icon {
        id: icon
        anchors.centerIn: root
        height: root.height / 2
        width: height
        name: mode === "Up" ? "up" : mode === "Down" ? "down" : ""
    }

    MouseArea {
        id: mouseArea
        anchors.fill: root
        onClicked: {
            timer.start()
            if (mode === "Up") {
                root.parent.positionViewAtBeginning()
            } else {
                root.parent.positionViewAtEnd()
            }
        }

        onPressedChanged: {
            if (pressed) {
                root.color = "#3A000000" //UbuntuColors.blue //"#4A3D1400"
            } else {
                root.color = bgColor
            }
        }
    }

    Timer {
        id: timer
        interval: 1000
        running: true
        onTriggered: {
            //root.opacity = 0
            root.hide = true
        }
    }
}
