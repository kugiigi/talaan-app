import QtQuick 2.4
import Lomiri.Components 1.3

Item {
    id: root

    property string iconName
    property string iconSource
    property bool positiveAction
    property bool actionVisible

    signal trigger


    Icon {
        id: actionIcon
        name: iconName
        source: iconSource
        anchors.fill: root
        color: switch (settings.currentTheme) {
               case "Default":
                   highlighted ? positiveAction ? theme.palette.highlighted.raised : theme.palette.normal.negative : theme.palette.normal.foreground
                   break
               case "System":
               case "Ambiance":
                   highlighted ? positiveAction ? theme.palette.highlighted.overlayText : theme.palette.normal.negative : theme.palette.normal.overlay
                   break
               case "SuruDark":
                   highlighted ? positiveAction ? theme.palette.highlighted.raised : theme.palette.normal.negative : theme.palette.normal.overlay
                   break
               default:
                   highlighted ? positiveAction ? theme.palette.highlighted.raised : theme.palette.normal.negative : theme.palette.normal.foreground
               }
        visible: actionVisible

        property bool highlighted: false

        MouseArea {
            anchors.fill: parent

            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onContainsMouseChanged: {
                if (containsMouse) {
                    actionIcon.highlighted = true
                } else {
                    actionIcon.highlighted = false
                }
            }
            onClicked: {
                trigger()
            }
        }
    }
}
