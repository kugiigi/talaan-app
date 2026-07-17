import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import ".." as Common

BasePickerDialog {
    id: datePickerDialog

    property alias dateTime: datePicker.baseDate
    property alias selectedDate: datePicker.selectedDate

    Common.DatePicker {
        id: datePicker

        anchors.fill: parent
    }
}
