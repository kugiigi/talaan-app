import QtQuick 2.4
import Lomiri.Components 1.3


Panel {
    id: panel
    align: Qt.AlignLeft
    animate: true
    hintSize: 0
    hideTimeout: 7000
    locked: true

    width: parent.width >= units.gu(60) ? units.gu(30) : parent.width * 0.7

    property alias navigationFlickable: itemFlickable.children

    function toggle() {
        if (opened) {
            close()
            console.log("close panel")
        } else {
            open()
            console.log("open panel")
        }
    }

    onNavigationFlickableChanged: {
        connectionsLoader.active = true
    }

    Item {
        id: itemFlickable
        anchors.fill: parent
    }

    Loader {
        id: connectionsLoader

        active: false
        asynchronous: true
        sourceComponent: connectionsComponent

        visible: status == Loader.Ready
    }

    Component {
        id: connectionsComponent
        Connections {
            target: itemFlickable.childAt(0, 0)
            onItemSelected: {
                console.log("panel close")
                close()
            }
        }
    }

    Item {
        id: sideShadow
        property alias gradient: horizGradient.gradient
        property bool rightToLeft: false

        visible: panel.opened
        anchors {
            left: parent.right
            bottom: parent.bottom
            top: parent.top
        }
        width: units.gu(0.8)

        Rectangle {
            id: horizGradient
            width: parent.height
            height: parent.width
            anchors.centerIn: parent
            rotation: 270 //rightToLeft ? 90 : 270
            gradient: Gradient {
                GradientStop {
                    position: 0.0
                    color: Qt.rgba(0, 0, 0, 0.1)
                }
                GradientStop {
                    position: 1.0
                    color: "transparent"
                }
            }
        }
    }

    InverseMouseArea {
        enabled: panel.opened
        anchors.fill: parent
        onClicked: {
            close()
        }
    }
}
