import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../.." as Components
import "../../../common" as Common
import "../../../common/dialogs" as Dialogs
import "../../../library/functions.js" as Functions
import "../../../common/listitems" as ListItems

ColumnLayout {
    id: dateField
  
    property alias checkState: dateCheckBox.checkState
    property date dateValue: new Date()
    property bool showToggle: true
    readonly property bool checked: checkState == Qt.Checked

    spacing: Suru.units.gu(2)

    ListItems.BaseCheckBoxDelegate {
        id: dateCheckBox

        Layout.fillWidth: true
        Layout.preferredHeight: Suru.units.gu(6)

        alignment: Qt.AlignLeft
        label.font.pixelSize: Suru.units.gu(2)
        text: i18n.tr("Use current date and time")
        checkState: Qt.Checked
        checkBoxPosition: ListItems.BaseCheckBoxDelegate.Position.Left
        visible: dateField.showToggle
    }

    RowLayout {
        Layout.fillWidth: true

        spacing: Suru.units.gu(1)
        visible: dateField.checkState == Qt.Unchecked

        ListItems.BaseItemDelegate {
            id: dateButton
      
            Layout.fillWidth: true
            Layout.preferredHeight: Suru.units.gu(6)

            focusPolicy: Qt.StrongFocus

            contentItem: Components.ColoredLabel {
                font.pixelSize: Suru.units.gu(2)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: Functions.formatDate(dateField.dateValue, "ddd, MMMM DD, YYYY")
                font.italic: true
                role: "date"
            }

            onClicked: {
                highlighted = true
                var popup = datePickerComponent.createObject(mainView.mainPage, { dateTime: dateField.dateValue })
                popup.accepted.connect(function() {
                    dateField.dateValue = popup.selectedDate
                })
                popup.closed.connect(function() {
                    dateButton.highlighted = false
                })
                popup.open();
            }
        }

        ListItems.BaseItemDelegate {
            id: timeButton
      
            property date currentDate: new Date()

            Layout.fillWidth: true
            Layout.preferredHeight: Suru.units.gu(6)

            focusPolicy: Qt.StrongFocus
            
            contentItem: Components.ColoredLabel {
                font.pixelSize: Suru.units.gu(2)
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: Functions.formatDate(dateField.dateValue, "hh:mm A")
                font.italic: true
                role: "date"
            }
                          
            onClicked: {
                highlighted = true
                var popup = timePickerComponent.createObject(mainView.mainPage
                                                    , { hour: dateField.dateValue.getHours()
                                                    , minute: dateField.dateValue.getMinutes()
                                                    , fullDate: dateField.dateValue
                                                      } )
                popup.accepted.connect(function() {
                    var date = new Date(dateField.dateValue)
                    date.setHours(popup.hour);
                    date.setMinutes(popup.minute)
                    dateField.dateValue = date;
                })
                popup.closed.connect(function() {
                    timeButton.highlighted = false
                })
                popup.open();
            }
        }
    }

    Component {
        id: datePickerComponent
        Dialogs.DatePickerDialog {}
    }

    Component {
        id: timePickerComponent
        Dialogs.TimePickerDialog{}
    }
}
