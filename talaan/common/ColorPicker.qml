import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import "listitems" as ListItems
import "dialogs" as Dialogs

ListItems.BaseItemDelegate {
    id: root

    property color selectedColor: "blue"

    contentItem: Rectangle {
        id: recColor
        implicitHeight: Suru.units.gu(5)

        color: selectedColor
        radius: root.radius - root.padding
    }

    onClicked: {
        let _popup = colorPickerPopupComponent.createObject(mainView.mainSurface, { selectedColor: root.selectedColor })
        _popup.colorSelected.connect(function(selectedColor) {
            root.selectedColor = selectedColor
        })

        _popup.openPopup()
    }

    Component {
        id: colorPickerPopupComponent

        Dialogs.BasePopup {
            id: colorPickerPopup

            property alias selectedColor: popup.selectedColor

            signal colorSelected(color selectedColor)

            ColorPickerPopup {
                id: popup

                anchors.fill: parent

                onColorSelected: {
                    colorPickerPopup.colorSelected(selectedColor)
                    colorPickerPopup.close()
                }
            }
        }
    }
}
