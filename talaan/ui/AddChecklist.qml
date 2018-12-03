import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes.Ambiance 1.3
import Ubuntu.Components.ListItems 1.0 as ListItemOld
import Ubuntu.Components.Popups 1.3
import Ubuntu.Components.Pickers 1.3
import "../library/DataProcess.js" as DataProcess
import "../components"
import "../library"
import "../library/ProcessFunc.js" as Process

Page {
    id: pageAddChecklist

    property string mode
    property string actionMode
    property int checklistID
    property string checklist
    property string description
    property string category
    property string targetDate
    property string createdCategory
    property string type
    property int continual

    signal cancel
    signal saved

    header: PageHeader {
        id: header
        title: {
            switch (true) {
            case mode === "talaan" && actionMode === "add":
                i18n.tr("Create New List")
                break
            case mode === "talaan" && actionMode === "edit":
                i18n.tr("Edit List - ") + checklist
                break
            case mode === "saved" && actionMode === "add":
                i18n.tr("Create New Saved List")
                break
            case mode === "saved" && actionMode === "edit":
                "Edit Saved List - " + checklist
                break
            default:
                i18n.tr("Create New List")
                break
            }
        }

        flickable: flickDialog
        StyleHints {
            backgroundColor: switch (settings.currentTheme) {
                             case "Default":
                                 "#3D1400"
                                 break
                             case "Ambiance":
                                 theme.palette.normal.background
                                 break
                             case "SuruDark":
                                 theme.palette.normal.foreground
                                 break
                             default:
                                 "#3D1400"
                             }
            dividerColor: UbuntuColors.slate
        }
    }

    onCreatedCategoryChanged: {
        categoryItemSelector.selectSpecific(createdCategory)
    }

    onActiveChanged: {
        if (active === true) {
            if (mainView.listItems.modelCategories.count === 0) {
                mainView.listItems.modelCategories.getCategories()
            }

            //Adds the 'Add new category'
            mainView.listItems.modelCategories.isListOnly = true

            categoryItemSelector.selectedIndex
                    = 2 //workaround for the issue on incorrect tem shown in the selector
            categoryItemSelector.selectedIndex = 1
            textName.forceActiveFocus()

            //loads data when in edit mode
            if (actionMode === "edit") {
                categoryItemSelector.selectSpecific(category)
                textName.text = checklist
                textareaDescr.text = description

                if (targetDate !== "") {
                    targetDtLabel.date = new Date(targetDate) //Process.dateFormat(1, targetDate)
                    switchTarget.checked = true
                }
            }

            btnCancel.action.shortcut = "Esc"
        } else {
            btnCancel.action.shortcut = undefined
        }
    }

    BottomEdge {
        id: bottomEdgePage

        hint {
            visible: false
            enabled: false
        }

        height: parent ? parent.height : 0
        enabled: false
        visible: false

        contentComponent: Item {
            id: pageContent
            implicitWidth: bottomEdgePage.width
            implicitHeight: bottomEdgePage.height
            children: bottomEdgePage._realPage
        }

        property var _realPage: null

        function commitWithProperties(properties) {
            _realPage.destroy()
            _realPage = addCategoryComponent.createObject(null, properties)
            commit()
        }

        Component.onCompleted: {
            _realPage = addCategoryComponent.createObject(null)
        }

        Component.onDestruction: {
            _realPage.destroy()
        }

        onCollapseCompleted: {
            _realPage.active = false
            _realPage.destroy()
            _realPage = addCategoryComponent.createObject(null)
        }

        onCommitCompleted: {
            _realPage.active = true
        }

        Component {
            id: addCategoryComponent
            AddCategory {
                id: addchecklistPage
                anchors.fill: parent
                onCancel: bottomEdgePage.collapse()
                onSaved: bottomEdgePage.collapse()
            }
        }
    }

    PageBackGround {
        id: pageBackground
        size: "Medium"
        bgColor: switch (settings.currentTheme) {
                 case "Default":
                     "#371300"
                     break
                 case "Ambiance":
                     theme.palette.normal.background
                     break
                 case "SuruDark":
                     theme.palette.normal.background
                     break
                 default:
                     theme.palette.normal.background
                 }
        bgOpacity: switch (settings.currentTheme) {
                   case "Default":
                       0.6
                       break
                   case "Ambiance":
                       1.0
                       break
                   case "SuruDark":
                       1.0
                       break
                   default:
                       0.6
                   }
    }
    Flickable {
        id: flickDialog
        boundsBehavior: Flickable.DragAndOvershootBounds
        contentHeight: columnContent.height + units.gu(1)
        interactive: true //keyboard.target.visible === true ? true : false

        anchors {
            left: parent.left
            right: parent.right
            bottom: controlsRec.top
            top: parent.top
            topMargin: units.gu(2)
            bottomMargin: units.gu(2)
        }

        flickableDirection: Flickable.VerticalFlick
        clip: true
        Column {
            id: columnContent

            spacing: units.gu(2)
            anchors {
                left: parent.left
                right: parent.right
            }

            Row {
                id: rowType
                spacing: units.gu(1)
                anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                }

                Label {
                    id: lblType
                    text: i18n.tr("Checklist")
                    color: switch (settings.currentTheme) {
                           case "Default":
                               "#3D1400"
                               break
                           case "Ambiance":
                               theme.palette.normal.backgroundText
                               break
                           case "SuruDark":
                               theme.palette.normal.backgroundText
                               break
                           default:
                               "#3D1400"
                           }
                    anchors.verticalCenter: parent.verticalCenter
                }
                CheckBox {
                    id: switchType
                    checked: type === "normal" ? false : true
                    enabled: type === "saved" ? false : true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label {
                    id: lblContinual
                    visible: switchType.checked
                    text: i18n.tr("Continual")
                    color: switch (settings.currentTheme) {
                           case "Default":
                               "#3D1400"
                               break
                           case "Ambiance":
                               theme.palette.normal.backgroundText
                               break
                           case "SuruDark":
                               theme.palette.normal.backgroundText
                               break
                           default:
                               "#3D1400"
                           }
                    anchors.verticalCenter: parent.verticalCenter
                }
                CheckBox {
                    id: switchContinual
                    visible: switchType.checked
                    checked: continual === 0 ? false : true
                    enabled: type === "saved" ? false : true
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Label {
                id: nameLabel
                text: i18n.tr("List Title:")
                color: switch (settings.currentTheme) {
                       case "Default":
                           "#3D1400"
                           break
                       case "Ambiance":
                           theme.palette.normal.backgroundText
                           break
                       case "SuruDark":
                           theme.palette.normal.backgroundText
                           break
                       default:
                           "#3D1400"
                       }
                anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                }
            }

            TextField {
                id: textName
                placeholderText: i18n.tr("Enter checklist name")
                hasClearButton: true
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                }

                style: TextFieldStyle {
                    //overlaySpacing: 0
                    //frameSpacing: 0
                    background: Item {
                    }
                    color: switch (settings.currentTheme) {
                           case "Default":
                               "white"
                               break
                           case "Ambiance":
                               theme.palette.normal.backgroundText
                               break
                           case "SuruDark":
                               theme.palette.normal.backgroundText
                               break
                           default:
                               "white"
                           }
                }
            }

            Label {
                id: categoryLabel
                text: i18n.tr("Category:")
                color: switch (settings.currentTheme) {
                       case "Default":
                           "#3D1400"
                           break
                       case "Ambiance":
                           theme.palette.normal.backgroundText
                           break
                       case "SuruDark":
                           theme.palette.normal.backgroundText
                           break
                       default:
                           "#3D1400"
                       }
                anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                }
            }

            Component {
                id: selectorDelegate
                OptionSelectorDelegate {
                    text: categoryname
                }
            }

            ListItemOld.ItemSelector {
                id: categoryItemSelector

                model: mainView.listItems.modelCategories

                function selectSpecific(selectCategory) {
                    var intCurCat = -1
                    var i = 0
                    while (selectCategory !== model.get(i).categoryname
                           && i != model.count - 1) {
                        i++
                    }
                    intCurCat = i
                    selectedIndex = intCurCat
                    currentlyExpanded = false
                }
                onSelectedIndexChanged: {
                    if (selectedIndex === 0) {
                        //workaround to push the new page after the selector's animation
                        workerWait.sendMessage({
                                                   duration: 400
                                               })
                    }
                }

                //property string selectedCategory:categoryItemSelector.model.get(categoryItemSelector.selectedIndex).name
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                }

                delegate: selectorDelegate

                WorkerScript {
                    id: workerWait
                    source: "../library/wait.js"

                    onMessage: bottomEdgePage.commitWithProperties({
                                                                       mode: "add"
                                                                       //actionMode: pageAddChecklist.actionMode,
                                                                       //mode: pageAddChecklist.mode
                                                                   })
                }
            }
            Label {
                id: descrLabel
                text: i18n.tr("Description:")
                color: switch (settings.currentTheme) {
                       case "Default":
                           "#3D1400"
                           break
                       case "Ambiance":
                           theme.palette.normal.backgroundText
                           break
                       case "SuruDark":
                           theme.palette.normal.backgroundText
                           break
                       default:
                           "#3D1400"
                       }
                anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                }
            }
            TextArea {
                id: textareaDescr
                //width: units.gu(20)
                height: textName.height + units.gu(1)
                autoSize: true
                contentWidth: units.gu(30)
                placeholderText: i18n.tr("Add description (optional)")
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: units.gu(2)
                    rightMargin: units.gu(2)
                }
                style: TextFieldStyle {
                    //overlaySpacing: 0
                    //frameSpacing: 0
                    background: Item {
                    }
                    color: switch (settings.currentTheme) {
                           case "Default":
                               "white"
                               break
                           case "Ambiance":
                               theme.palette.normal.backgroundText
                               break
                           case "SuruDark":
                               theme.palette.normal.backgroundText
                               break
                           default:
                               "white"
                           }
                }
            }

            ListItem {
                id: targetDtListItem
                divider.visible: false
                highlightColor: switch (settings.currentTheme) {
                                case "Default":
                                    "#2D371300"
                                    break
                                case "Ambiance":
                                    theme.palette.highlighted.background
                                    break
                                case "SuruDark":
                                    theme.palette.highlighted.background
                                    break
                                default:
                                    "#2D371300"
                                }
                visible: switchType.checked && pageAddChecklist.mode !== "saved"
                anchors {
                    left: parent.left
                    right: parent.right
                }
                onClicked: {
                    switchTarget.checked = !switchTarget.checked
                }

                Label {
                    id: targetLabel
                    text: i18n.tr("Target Date")
                    verticalAlignment: Text.AlignVCenter
                    color: switch (settings.currentTheme) {
                           case "Default":
                               "#3D1400"
                               break
                           case "Ambiance":
                               theme.palette.normal.backgroundText
                               break
                           case "SuruDark":
                               theme.palette.normal.backgroundText
                               break
                           default:
                               "#3D1400"
                           }
                    anchors {
                        left: parent.left
                        leftMargin: units.gu(2)
                        top: parent.top
                        bottom: parent.bottom
                    }
                }
                Action {
                    id: targetDtAction
                    onTriggered: {
                        targetDtListItem.color = targetDtListItem.highlightColor
                        var datePicker = PickerPanel.openDatePicker(
                                    targetDtLabel, "date", "Years|Months|Days")
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
                    text: Qt.formatDateTime(
                              date, "ddd, MMMM d, yyyy") //"dddd, MMMM d yyyy")
                    visible: switchTarget.checked
                    color: theme.palette.normal.foregroundText
                    fontSizeMode: Text.HorizontalFit
                    fontSize: "medium"
                    minimumPixelSize: units.gu(2)
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    anchors {
                        left: targetLabel.right
                        leftMargin: units.gu(1)
                        right: switchTarget.left
                        rightMargin: units.gu(1)
                        top: parent.top
                        bottom: parent.bottom
                    }
                    Rectangle {
                        z: -1
                        anchors.fill: parent
                        color: targetDtLabel.highlighted ? theme.palette.selected.background : "Transparent"
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

                CheckBox {
                    id: switchTarget
                    checked: false

                    anchors {
                        right: parent.right
                        rightMargin: units.gu(2)
                        verticalCenter: parent.verticalCenter
                    }
                    onCheckedChanged: {
                        if (checked === true
                                && pageAddChecklist.actionMode !== "edit") {
                            targetDtAction.trigger()
                            //                            PickerPanel.openDatePicker(targetDtLabel, "date",
                            //                                                       "Years|Months|Days")
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: controlsRec
        height: units.gu(6)
        color: switch (settings.currentTheme) {
               case "Default":
                   "#463030"
                   break
               case "Ambiance":
                   theme.palette.normal.foreground
                   break
               case "SuruDark":
                   theme.palette.normal.foreground
                   break
               default:
                   "#463030"
               }
        opacity: 0.7
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Button {
            id: btnCancel
            text: i18n.tr("Cancel")
            activeFocusOnPress: false
            anchors {
                left: parent.left
                leftMargin: units.gu(2)
                verticalCenter: parent.verticalCenter
            }
            action: Action {
                //shortcut: "Esc"
                onTriggered: {
                    pageAddChecklist.cancel()
                }
            }
        }
        Button {
            text: pageAddChecklist.actionMode === i18n.tr("add") ? i18n.tr("Create") : i18n.tr("Save")
            color: UbuntuColors.green
            activeFocusOnPress: false
            anchors {
                right: parent.right
                rightMargin: units.gu(2)
                verticalCenter: parent.verticalCenter
            }
            action: Action {
                //shortcut: "Ctrl+S"
                onTriggered: {

                    /*Commits the OSK*/
                    keyboard.target.commit()

                    var txtName = textName.text
                    var txtDescr = textareaDescr.text
                    var txtCategory = categoryItemSelector.model.get(
                                categoryItemSelector.selectedIndex).categoryname
                    var today = new Date(Process.getToday())

                    var txtCreationDt = Process.dateFormat(0, today)
                    var txtTargetDt = switchTarget.checked
                            && switchType.checked ? Process.dateFormat(
                                                        0,
                                                        targetDtLabel.date) : ""
                    var txtType = switchType.checked ? mode === "saved"
                                                       || type === "saved" ? "saved" : "incomplete" : "normal"
                    var intContinual = switchContinual.checked ? 1 : 0

                    if (Process.checkRequired([txtName]) === false) {
                        textName.forceActiveFocus()
                    } else if (txtName !== checklist
                               && DataProcess.checklistExist(
                                   txtCategory, txtName) === true) {
                        PopupUtils.open(dialog)
                    } else {
                        var newChecklist
                        switch (actionMode) {
                        case "edit":
                            DataProcess.updateChecklist(checklistID, txtType,
                                                        txtName, txtDescr,
                                                        txtCategory,
                                                        txtTargetDt,
                                                        intContinual)
                            mainView.notification.showNotification(
                                        i18n.tr("List successfully updated"),
                                        UbuntuColors.green)
                            break
                        case "add":
                            newChecklist = DataProcess.saveChecklist(
                                        txtName, txtDescr, txtCategory,
                                        txtCreationDt, txtTargetDt, txtType,
                                        intContinual)
                            mainView.notification.showNotification(
                                        i18n.tr("List successfully created"),
                                        UbuntuColors.green)
                            break
                        }
                        try {
                            loadChecklist()
                        } catch (err) {
                            console.log(err)
                        }
                        pageAddChecklist.saved()

                        if (actionMode === "add") {
                            itemsPageLoader.showItemsPage({
                                                              pageMode: mode === "talaan"
                                                                        && switchType.checked ? "talaan" : mode === "saved" ? "saved" : "normal",
                                                                                                                              currentCategory: newChecklist.category,
                                                                                                                              currentChecklist: newChecklist.checklist,
                                                                                                                              currentID: newChecklist.id,
                                                                                                                              currentStatus: newChecklist.status,
                                                                                                                              currentTotal: newChecklist.total,
                                                                                                                              currentDescr: newChecklist.descr,
                                                                                                                              currentContinual: newChecklist.continual
                                                          })
                        }
                    }
                }
            }
        }
    }
    Component {
        id: dialog
        Dialog {
            id: dialogue
            title: "List Already Exist!"
            text: i18n.tr("That list already exist in that category. You may change the name or move to another category.")
            Button {
                text: i18n.tr("OK")
                onClicked: PopupUtils.close(dialogue)
            }
        }
    }
    Connections {
        id: keyboard
        target: Qt.inputMethod
    }
}
