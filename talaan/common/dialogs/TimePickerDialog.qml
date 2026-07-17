import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import ".." as Common

BasePickerDialog {
    id: timePicker

    property alias hour: p.hour
    property alias minute: p.minute
    property alias fullDate: p.fullDate

    Common.TimePicker {
        id: p
        width: parent.width
        height: parent.height
    }
}
