import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import "../../library/ProcessFunc.js" as Process

Dialog {
    id: dialogue
    property date date: new Date()

    title: i18n.tr("New Reminder")

    signal proceed(string title, date customDate, string reminder, bool silent)

    TextField {
        id: textTitle
        placeholderText: itemsPage.currentChecklist
        hasClearButton: true
    }

    OptionSelector {
        id: optionReminder
        //text: i18n.tr("Reminder")
        containerHeight: itemHeight * 3
        model: listmodelReminder
        enabled: itemsPage.currentTargetDate === "" ? false : true
        delegate: optionReminderDelegate

        property bool customSelected: false

        function selectSpecific(selectedReminder) {
            var intCurCat = -1
            var i = 0
            while (selectedReminder !== model.get(i).value
                   && i != model.count - 1) {
                i++
            }
            intCurCat = i
            selectedIndex = intCurCat
            currentlyExpanded = false
        }

        onSelectedIndexChanged: {
            var selectedReminder = model.get(selectedIndex).value
            console.log("nagchange: " + selectedReminder)
            if (selectedReminder === "Custom") {
                customSelected = true
            } else {
                customSelected = false
            }
        }

        Component.onCompleted: {
            console.log("naspecify")
            if(!enabled){
                selectSpecific("Custom")
            }
        }
    }
    Component {
        id: optionReminderDelegate
        OptionSelectorDelegate {
            text: name
        }
    }
    ListModel {
        id: listmodelReminder
        ListElement {
            name: "On Target Date"
            value: "OnTarget"
        }
        ListElement {
            name: "Custom"
            value: "Custom"
        }
        ListElement {
            name: "1 hour"
            value: "OneHours"
        }
        ListElement {
            name: "2 hours"
            value: "TwoHour"
        }
        ListElement {
            name: "1 day"
            value: "OneDay"
        }
        ListElement {
            name: "2 days"
            value: "TwoDay"
        }
        ListElement {
            name: "1 week"
            value: "OneWeek"
        }
        ListElement {
            name: "2 weeks"
            value: "TwoWeek"
        }
        ListElement {
            name: "1 month"
            value: "OneMonth"
        }
        ListElement {
            name: "2 months"
            value: "TwoMonth"
        }
    }


    //    Label {
    //        id: targetLabel
    //        text: i18n.tr("Reminder Date & Time")
    //        verticalAlignment: Text.AlignVCenter
    //    }
    ListItem {
        id: targetDtListItem

        visible: optionReminder.customSelected
        divider.visible: false
        height: units.gu(4)
        highlightColor: switch(settings.currentTheme){
                        case "Default":
                            "#2D371300"
                            break;
                        case "Ambiance":
                            theme.palette.highlighted.background
                            break;
                        case "SuruDark":
                            theme.palette.highlighted.background
                            break;
                        default:
                            "#2D371300"
                        }
        anchors {
            left: parent.left
            right: parent.right
        }

        Action {
            id: targetDtAction
            onTriggered: {
                targetDtListItem.color = targetDtListItem.highlightColor
                var datePicker = PickerPanel.openDatePicker(targetDtLabel,
                                                            "date",
                                                            "Years|Months|Days")
                var datePickerClosed = function () {
                    targetDtListItem.color = "transparent"
                }

                datePicker.closed.connect(datePickerClosed)
            }
        }
        Label {
            id: targetDtLabel
            property bool highlighted: false
            property alias mouseArea: mouseArea
            property date date: new Date()

            height: units.gu(3)
            text: Qt.formatDateTime(date, "ddd, MMMM d, yyyy")
            color: Theme.palette.normal.foregroundText
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors {
                left: parent.left
                //leftMargin: units.gu(3)
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            Rectangle {
                z: -1
                anchors.fill: parent
                color: targetDtLabel.highlighted ? Theme.palette.selected.background : "Transparent"
            }
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                z: 1
                onClicked: {
                    targetDtAction.trigger()
                }
            }
        }
    }


    //    Label {
    //        id: targetTimeLabel
    //        text: i18n.tr("Reminder Time")
    //        verticalAlignment: Text.AlignVCenter
    //    }
    ListItem {
        id: targetTimeListItem

        divider.visible: false
        height: units.gu(4)
        highlightColor: switch(settings.currentTheme){
                        case "Default":
                            "#2D371300"
                            break;
                        case "Ambiance":
                            theme.palette.highlighted.background
                            break;
                        case "SuruDark":
                            theme.palette.highlighted.background
                            break;
                        default:
                            "#2D371300"
                        }
        visible: targetDtListItem.visible
        anchors {
            left: parent.left
            right: parent.right
        }

        Action {
            id: targetTimeAction
            onTriggered: {
                targetTimeListItem.color = targetTimeListItem.highlightColor
                var datePicker = PickerPanel.openDatePicker(targetTimeLabel,
                                                            "date",
                                                            "Hours|Minutes")
                var datePickerClosed = function () {
                    targetTimeListItem.color = "transparent"
                }

                datePicker.closed.connect(datePickerClosed)
            }
        }
        Label {
            id: targetTimeLabel
            property date date//: new Date();
            property bool highlighted: false
            property alias mouseAreaTime: mouseAreaTime

            height: units.gu(3)
            text: Qt.formatDateTime(date, "hh:mm AP")
            color: Theme.palette.normal.foregroundText
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }

            onVisibleChanged: {
                if(visible){
                    date = new Date(Process.getToday())
                }
            }

            Rectangle {
                z: -1
                anchors.fill: parent
                color: targetTimeLabel.highlighted ? Theme.palette.selected.background : "Transparent"
            }
            MouseArea {
                id: mouseAreaTime
                anchors.fill: parent
                z: 1
                onClicked: {
                    targetTimeAction.trigger()
                }
            }
        }
    }

    Row {
        id: rowSilent
        spacing: units.gu(1)
        CheckBox {
            id: checkSilent
            checked: false
        }
        Label {
            text: i18n.tr("Silent Reminder")
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    checkSilent.checked = !checkSilent.checked
                }
            }
        }
    }

    Row {
        id: buttonsRow
        spacing: width * 0.1

        Button {
            color: theme.palette.normal.negative
            width: parent.width * 0.45
            text: i18n.tr("Cancel")
            onClicked: {
                PopupUtils.close(dialogue)
            }
        }
        Button {
            text: i18n.tr("Save")
            color: theme.palette.normal.positive
            width: parent.width * 0.45
            onClicked: {
                var selectedReminder = optionReminder.model.get(
                            optionReminder.selectedIndex).value
                var newDate
                // = new Date()
                if (optionReminder.customSelected) {
                    newDate = targetDtLabel.date
                    newDate.setHours(targetTimeLabel.date.getHours())
                    newDate.setMinutes(targetTimeLabel.date.getMinutes())
                }

                dialogue.proceed(textTitle.text, newDate, selectedReminder,
                                 checkSilent.checked)
                PopupUtils.close(dialogue)
            }
        }
    }
}
