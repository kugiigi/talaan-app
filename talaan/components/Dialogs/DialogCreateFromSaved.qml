import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import "../../library/ProcessFunc.js" as Process

Dialog {
    id: dialogue
    property string checklistName
    property ListModel categoriesModel
    property string targetDate
    property string category

    title: i18n.tr("New Checklist")

    signal proceed(string name, string category, string targetDate)

    onVisibleChanged: {
        if (visible) {
            mainView.listItems.modelCategories.getCategories()
            optionCategory.selectSpecific(category)
            textName.text = checklistName
        }
    }

    Label {
        id: nameLabel
        text: i18n.tr("Checklist Name")
        verticalAlignment: Text.AlignVCenter
    }

    TextField {
        id: textName
        placeholderText: i18n.tr("Enter checklist name")
        hasClearButton: true
    }

    OptionSelector {
        id: optionCategory
        text: i18n.tr("Category")
        model: categoriesModel
        containerHeight: itemHeight * 3
        delegate: optionCategoryDelegate

        function selectSpecific(selectedCategory) {
            var intCurCat = -1
            var i = 0
            while (selectedCategory !== model.get(i).categoryname
                   && i != model.count - 1) {
                i++
            }
            intCurCat = i
            selectedIndex = intCurCat
            currentlyExpanded = false
        }
    }
    Component {
        id: optionCategoryDelegate
        OptionSelectorDelegate {
            text: categoryname
        }
    }

//    Label {
//        id: targetLabel
//        text: i18n.tr("Target Date?")
//        verticalAlignment: Text.AlignVCenter
//    }

    ListItem{
        id: targetLabel
        divider.visible: false

        onClicked: {
            switchTarget.checked = !switchTarget.checked
            if(switchTarget.checked){
                targetDtAction.trigger()
            }
        }


        ListItemLayout{
            title.text: i18n.tr("Target Date?")

            CheckBox {
                id: switchTarget
                checked: false

                SlotsLayout.position: SlotsLayout.Trailing
                onCheckedChanged: {
                    if (checked === true) {
                        targetDtAction.trigger()
                    }
                }
            }
        }
    }

    ListItem {
        id: targetDtListItem
        divider.visible: false
        visible: switchTarget.checked
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
        onClicked: {
            switchTarget.checked = !switchTarget.checked
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
            property date date: new Date()
            property bool highlighted: false
            property alias mouseArea: mouseArea

            height: units.gu(3)
            text: Qt.formatDateTime(date, "ddd, MMMM d, yyyy")
            visible: switchTarget.checked
            color: Theme.palette.normal.foregroundText
            fontSizeMode: Text.HorizontalFit
            fontSize: "medium"
            minimumPixelSize: units.gu(2)
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            anchors {
                left: parent.left
                leftMargin: units.gu(3)
                right: parent.right
                rightMargin: units.gu(1)
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
            text: i18n.tr("OK")
            color: theme.palette.normal.positive
            width: parent.width * 0.45
            onClicked: {
                keyboard.target.commit()
                var selectedCategory = optionCategory.model.get(
                            optionCategory.selectedIndex).categoryname
                var target_date = switchTarget.checked ? Process.dateFormat(
                                                             0,
                                                             targetDtLabel.date) : ""
                dialogue.proceed(textName.text, selectedCategory, target_date)
                PopupUtils.close(dialogue)
            }
        }
    }
}
