import QtQuick 2.12
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3

QQC2.Menu {
    id: menuActions

    property alias model: instantiator.model
    property bool isBottom: false

    bottomMargin: Suru.units.gu(3)

    function openBottom() {
        y = Qt.binding( function() { return parent ? parent.height - height : 0 } )
        isBottom = true
        open()
    }

    function openTop() {
        y = 0
        isBottom = false
        open()
    }

    onCountChanged: if (count == 0) close()

    Instantiator {
        id: instantiator

        QQC2.MenuItem {
            text: modelData ? modelData.text : ""
            visible: modelData && modelData.enabled && modelData.visible
            onTriggered: {
                menuActions.close()
                modelData.trigger(isBottom, this)
            }

            height: visible ? units.gu(6) : 0
            icon.name: modelData ? modelData.iconName : ""
            icon.color: Suru.foregroundColor
            icon.width: units.gu(2)
            icon.height: units.gu(2)
        }
        onObjectAdded: menuActions.insertItem(index, object)
        onObjectRemoved: menuActions.removeItem(object)
    }
}
