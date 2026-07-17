import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Suru 2.2
import "../.." as Components
import "../../../common" as Common
import "../../../common/dialogs" as Dialogs
import "../../../common/listitems" as ListItems
import "../../../library/functions.js" as Functions

Dialogs.BasePopup {
    id: criteriaPopup

    property string activeCategory
    property string sort
    property string scope
    property string order
    property date dateValue
    property bool coloredCategory

    signal select(string selectedCategory, date selectedDate, string selectedSort, string selectedScope, string selectedOrder, bool selectedColoredCategory)

    maximumWidth: Suru.units.gu(60)
    maximumHeight: Suru.units.gu(70)
    standardButtons: Dialog.Ok | Dialog.Cancel

    onAccepted: {
        select(activeCategory, dateValue, sort, scope, order, coloredCategory)
    }

    header: Item {
        height: Suru.units.gu(7)

        Common.BaseButton {
            id: dateButton

            leftPadding: Suru.units.gu(1.5)
            rightPadding: leftPadding
            bottomPadding: leftPadding
            topPadding: leftPadding
            anchors.centerIn: parent
            focusPolicy: Qt.StrongFocus

            Suru.textLevel: Suru.HeadingTwo
            display: AbstractButton.TextOnly
            text: Functions.formatDate(criteriaPopup.dateValue, "ddd, MMMM DD, YYYY")

            onClicked: {
                highlighted = true
                var popup = datePickerComponent.createObject(detailedListPage, { dateTime: criteriaPopup.dateValue })
                popup.accepted.connect(function() {
                    criteriaPopup.dateValue = popup.selectedDate
                })
                popup.closed.connect(function() {
                    dateButton.highlighted = false
                })
                popup.open();
            }
        }
    }

    Component {
        id: datePickerComponent
        Dialogs.DatePickerDialog {}
    }

    ButtonGroup {
        id: criteriaGroup
    }

    Flickable {
        anchors {
            fill: parent
            margins: Suru.units.gu(2)
            topMargin: Suru.units.gu(1)
        }
        topMargin: Suru.units.gu(1)
        bottomMargin: Suru.units.gu(2)

        clip: true
        boundsBehavior: Flickable.DragOverBounds
        boundsMovement: Flickable.StopAtBounds
        contentHeight: layout.height

        ColumnLayout {
            id: layout

            spacing: Suru.units.gu(2)
            anchors {
                left: parent.left
                right: parent.right
            }

            ColumnLayout {
                Layout.leftMargin: Suru.units.gu(2)
                Layout.rightMargin: Suru.units.gu(2)
                spacing: Suru.units.gu(1)

                Label {
                    Layout.fillWidth: true

                    Suru.textLevel: Suru.Paragraph
                    text: i18n.tr("View by")
                }

                ComboBox {
                    Layout.fillWidth: true
                    implicitHeight: Suru.units.gu(5)

                    model: [
                        { value: "day", text: i18n.tr("Day") }
                        , { value: "week", text: i18n.tr("Week") }
                        , { value: "month", text: i18n.tr("Month") }
                    ]
                    textRole: "text"
                    font.pixelSize: Suru.units.gu(2)
                    currentIndex: model.findIndex((element) => element.value == criteriaPopup.scope)

                    onCurrentIndexChanged: criteriaPopup.scope = model[currentIndex].value
                }
            }

            ColumnLayout {
                Layout.leftMargin: Suru.units.gu(2)
                Layout.rightMargin: Suru.units.gu(2)
                spacing: Suru.units.gu(1)

                Label {
                    Layout.fillWidth: true

                    Suru.textLevel: Suru.Paragraph
                    text: i18n.tr("Sort by")
                }

                ComboBox {
                    Layout.fillWidth: true
                    implicitHeight: Suru.units.gu(5)

                    model: [
                        { value: "category", text: i18n.tr("Category") }
                        , { value: "date", text: i18n.tr("Date") }
                    ]
                    textRole: "text"
                    font.pixelSize: Suru.units.gu(2)
                    currentIndex: model.findIndex((element) => element.value == criteriaPopup.sort)

                    onCurrentIndexChanged: criteriaPopup.sort = model[currentIndex].value
                }
            }

            ColumnLayout {
                Layout.leftMargin: Suru.units.gu(2)
                Layout.rightMargin: Suru.units.gu(2)
                spacing: Suru.units.gu(1)

                Label {
                    Layout.fillWidth: true

                    Suru.textLevel: Suru.Paragraph
                    text: i18n.tr("Date order")
                }

                ComboBox {
                    Layout.fillWidth: true
                    implicitHeight: Suru.units.gu(5)

                    model: [
                        { value: "asc", text: i18n.tr("Ascending") }
                        , { value: "desc", text: i18n.tr("Descending") }
                    ]
                    textRole: "text"
                    font.pixelSize: Suru.units.gu(2)
                    currentIndex: model.findIndex((element) => element.value == criteriaPopup.order)

                    onCurrentIndexChanged: criteriaPopup.order = model[currentIndex].value
                }
            }

            ColumnLayout {
                spacing: Suru.units.gu(1)

                ListItems.BaseCheckBoxDelegate {
                    id: coloredCategoryCheckbox

                    Layout.fillWidth: true

                    Suru.textLevel: Suru.HeadingThree
                    checkBoxPosition: ListItems.BaseCheckBoxDelegate.Position.Left
                    alignment: Qt.AlignLeft
                    text: i18n.tr("Display colored category")
                    checkState: Qt.UnChecked

                    Binding {
                        target: coloredCategoryCheckbox
                        property: "checkState"
                        value: criteriaPopup.coloredCategory ? Qt.Checked : Qt.UnChecked
                    }

                    onCheckedChanged: criteriaPopup.coloredCategory = checked
                }

                ListItems.BaseCheckBoxDelegate {
                    id: filterCheckbox

                    Layout.fillWidth: true

                    Suru.textLevel: Suru.HeadingThree
                    checkBoxPosition: ListItems.BaseCheckBoxDelegate.Position.Left
                    alignment: Qt.AlignLeft
                    text: i18n.tr("Filter by category")
                    checkState: Qt.UnChecked

                    Binding {
                        target: filterCheckbox
                        property: "checkState"
                        value: criteriaPopup.activeCategory == "all" ? Qt.UnChecked : Qt.Checked
                    }

                    onCheckedChanged: {
                        if (!checked) {
                            criteriaPopup.activeCategory = "all"
                        } else {
                            if (filterCategory.currentIndex > -1) {
                                criteriaPopup.activeCategory = filterCategory.model.get(filterCategory.currentIndex).category_name
                            } else {
                                criteriaPopup.activeCategory = filterCategory.model.get(0).category_name
                            }
                        }
                    }
                }

                ComboBox {
                    id: filterCategory

                    Layout.fillWidth: true
                    Layout.leftMargin: Suru.units.gu(4)
                    Layout.rightMargin: Suru.units.gu(2)
                    implicitHeight: Suru.units.gu(6)

                    visible: filterCheckbox.checked
                    model: mainView.mainModels.categoriesModel
                    textRole: "category_name"
                    font.pixelSize: Suru.units.gu(2.5)

                    onCurrentIndexChanged: {
                        let _item = model.get(currentIndex)
                        if (_item) {
                            criteriaPopup.activeCategory = _item.category_name
                        } else {
                            criteriaPopup.activeCategory = "all"
                        }
                    }

                    Binding {
                        target: filterCategory
                        property: "currentIndex"
                        value: filterCategory.model.find(criteriaPopup.activeCategory, "category_name")
                    }
                }
            }
        }
    }
}
