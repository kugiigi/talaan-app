import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3 as UT
import ".." as Common

Item {
    id: itemDelegate

    property real maximumWidth: Suru.units.gu(6)
    property alias iconName: iconItem.name
    property real preferredWidth: Suru.units.gu(5)
    property bool highlighted: false

    z: highlighted ? 2 : 1
    scale: highlighted ? 1.3 : 1

    Behavior on scale { NumberAnimation { duration: Suru.animations.FastDuration } }

    onHighlightedChanged: {
        if (highlighted) {
            delayHaptics.restart()
        } else {
            delayHaptics.stop()
        }
    }

    Timer {
        id: delayHaptics

        running: false
        interval: 100
        onTriggered: {
            if (itemDelegate.highlighted) {
                Common.Haptics.playSubtle()
            }
        }
    }

    Rectangle {
        id: bgRec

        color: highlighted ? theme.palette.highlighted.foreground : theme.palette.normal.foreground
        radius: width / 2
        width: Math.min(parent.width, itemDelegate.maximumWidth)
        height: width
        anchors.centerIn: parent

        Behavior on color { ColorAnimation { duration: Suru.animations.FastDuration } }
    }

    UT.Icon {
        id: iconItem

        anchors.centerIn: bgRec
        height: bgRec.height * 0.5
        width: height
        color: highlighted ? theme.palette.normal.activity : theme.palette.normal.foregroundText

        Behavior on color { ColorAnimation { duration: Suru.animations.FastDuration } }
    }
}
