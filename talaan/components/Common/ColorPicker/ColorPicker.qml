import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

UbuntuShape {
    id: root

    property color selectedColor: "blue"

    color: theme.palette.normal.base

    Rectangle {
        id: recColor
        color: selectedColor
        width: root.width - units.gu(1.5)
        height: root.height - units.gu(1.5)
        anchors {
            centerIn: root
        }
    }

    MouseArea {
        anchors.fill: root
        onClicked: {
            PopupUtils.open(colorPickerPopoverComponent, root)
        }
    }

    Component {
        id: colorPickerPopoverComponent
        Popover {
            id: popover

            autoClose: true

            //contentHeight: colorPickerPopup.height
            contentWidth: colorPickerPopup.width /*{
                                        if(root.parent.width > (colorPickerPopup.cellWidth * colorPickerPopup.maxColumns)){
                                                                                        colorPickerPopup.width
                                                                                                                                                        }else{
                                                                                                                                                                                                                                            root.parent.width
                                                                                                                                                                                                                                                                                                                                                }
                                                                                                                                                                                                                                                                                                                                                                                                                                                                }*/

            //root.parent.width > (colorPickerPopup.cellWidth * colorPickerPopup.maxColumns) ? colorPickerPopup.width : root.parent.width
            ColorPickerPopup {
                id: colorPickerPopup

                maxRows: 4
                maxColumns: 7
                backgroundColor: theme.palette.normal.overlay //"#3D1400"
                selectedColor: root.selectedColor
                onSelectedColorChanged: {
                    root.selectedColor = selectedColor
                }

                Component.onCompleted: {
                    {
                        if (root.parent.width < colorPickerPopup.width) {
                            var newColumn = Math.floor(
                                        (root.parent.width / colorPickerPopup.cellWidth))
                            maxColumns = newColumn >= 1 ? newColumn : 1
                        } else {
                            root.parent.width
                        }
                    }
                }

                onSelected: {
                    PopupUtils.close(popover)
                }
            }
        }
    }
}
