import QtQuick 2.4
import Ubuntu.Components 1.3

MouseArea {
    id: hoverArea

    z: -1
    anchors.fill: parent
    acceptedButtons: Qt.NoButton
    hoverEnabled: true

    property list<Action> rightActionsList
    property list<Action> leftActionsList
    property string actionsPosition: "Middle-Left"
    property bool alreadyHighlighted: false

    onContainsMouseChanged: {
        if (containsMouse) {
            loader.active = true
        } else {
            loader.active = false
        }
    }

    Loader {
        id: loader
        anchors.fill: parent
        visible: status == Loader.Ready
        asynchronous: true
        active: false
        sourceComponent: componentHighlight
    }

    Component {
        id: componentHighlight
        ListViewHighlight {
            id: highlightRec
            color: switch (settings.currentTheme) {
                   case "Default":
                       alreadyHighlighted ? "transparent" : "#1A371300"
                       break
                   case "Ambiance":
                       alreadyHighlighted ? "transparent" : theme.palette.highlighted.background
                       break
                   case "SuruDark":
                       alreadyHighlighted ? "transparent" : theme.palette.highlighted.background
                       break
                   default:
                       alreadyHighlighted ? "transparent" : "#1A371300"
                   }

            Row {
                id: rightActionsRow

                spacing: units.gu(1)
                anchors {
                    topMargin: units.gu(1)
                    top: actionsPosition.search(
                             "Top") === -1 ? undefined : parent.top
                    right: actionsPosition.search(
                               "Right") === -1 ? undefined : parent.right
                    rightMargin: units.gu(3)
                    verticalCenter: actionsPosition.search(
                                        "Middle") === -1 ? undefined : parent.verticalCenter
                    left: actionsPosition.search(
                              "Left") === -1 ? undefined : parent.left
                    leftMargin: units.gu(3)
                    bottom: actionsPosition.search(
                                "Bottom") === -1 ? undefined : parent.bottom
                    bottomMargin: units.gu(3)
                }

                Repeater {
                    id: rightActions

                    model: rightActionsList
                    ActionsHover {
                        id: rightAction
                        iconName: modelData.iconName
                        iconSource: modelData.iconSource
                        height: highlightRec.height * 0.2
                        width: height
                        positiveAction: true
                        actionVisible: modelData.visible
                        visible: modelData.visible

                        onTrigger: {
                            modelData.trigger()
                        }
                    }
                }

                Repeater {
                    id: leftActions

                    model: leftActionsList
                    ActionsHover {
                        id: leftAction
                        iconName: modelData.iconName
                        iconSource: modelData.iconSource
                        height: modelData.visible ? highlightRec.height * 0.2 : 0
                        width: height
                        positiveAction: false
                        actionVisible: modelData.visible
                        visible: modelData.visible

                        onTrigger: {
                            modelData.trigger()
                        }
                    }
                }
            }
        }
    }
}
