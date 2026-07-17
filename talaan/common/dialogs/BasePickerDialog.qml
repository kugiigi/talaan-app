import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2

Dialog {
    id: basePickerDialog

    property int maxSize: Math.min(parent.width, parent.height)
    property int size: Math.min(maxSize, Suru.units.gu(50))

    onClosed: destroy()
    parent: ApplicationWindow.overlay
    modal: true
    width: size
    height: size //+ Suru.units.gu(10)
    x: (parent.width - width) / 2
    y: parent.width >= Suru.units.gu(90) ? (parent.height - height) / 2 : (parent.height - height)

    standardButtons: Dialog.Ok | Dialog.Cancel
}
