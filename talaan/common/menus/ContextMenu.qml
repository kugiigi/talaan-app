import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3 as UT


Menu {
    id: contextMenu
    
    property alias actions: instantiator.model
    property var listView
    property var itemProperties

    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

    onClosed: {
        if (listView) {
            listView.currentIndex = -1
        }
    }

    function popupMenu(parentItem, mouseX, mouseY, properties) {
        itemProperties = properties
        contextMenu.popup(parentItem, mouseX, mouseY)
    }

    Instantiator {
        id: instantiator

        delegate: Loader {
            sourceComponent: modelData.separator ? separatorComponent : menuItemComponent

            Component {
                id: separatorComponent

                MenuSeparator {
                    topPadding: Suru.units.gu(1)
                    bottomPadding: Suru.units.gu(1)
                }
            }

            Component {
                id: menuItemComponent

                MenuItem {
                    id: menuItem

                    text: modelData ? modelData.text : ""
                    height: modelData.visible ? Suru.units.gu(6) : 0
                    visible: modelData.visible
                    leftPadding: iconMenu.implicitWidth + (iconMenu.anchors.leftMargin * 2)

                    onTriggered: {
                        contextMenu.close()
                        modelData.trigger(false, menuItem)
                    }

                    indicator: UT.Icon {
                         id: iconMenu

                         implicitWidth: name ? Suru.units.gu(3) : 0
                         implicitHeight: implicitWidth
                         anchors.left: parent.left
                         anchors.leftMargin: Suru.units.gu(1)
                         anchors.verticalCenter: parent.verticalCenter
                         name: modelData ? modelData.iconName : ""
                         color: Suru.foregroundColor
                     }
                }
            }
        }

        onObjectAdded: contextMenu.addItem(object)
        onObjectRemoved: contextMenu.removeItem(object)
    }
}
