import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes.Ambiance 1.3
import Ubuntu.Components.Popups 1.3
//import Ubuntu.Components.Pickers 1.3
import "../library/DataProcess.js" as DataProcess
import "../components"
import "../components/Common/ColorPicker"
import "../library"
import "../library/ProcessFunc.js" as Process

Page {
    id: pageAddCategory

    property string mode
    property string category_name
    property string description
    property color categoryColor: "white"
    readonly property color textColor: switch (settings.currentTheme) {
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

    signal cancel
    signal saved

    header: PageHeader {
        title: pageAddCategory.mode === "add" ? i18n.tr(
                                                    "Add New Category") : i18n.tr(
                                                    "Edit Category - " + category_name)
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

    onActiveChanged: {
        if (active === true) {
            if (mainView.listItems.modelCategories.count === 0) {
                mainView.listItems.modelCategories.getCategories()
            }

            mainView.listItems.modelCategories.isListOnly = false
            //textName.forceActiveFocus()

            //loads data when in edit mode
            if (mode === "edit") {
                textName.text = category_name
                textareaDescr.text = description
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

            Label {
                id: nameLabel
                text: i18n.tr("Name:")
                color: pageAddCategory.textColor
                anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                }
            }

            TextField {
                id: textName
                placeholderText: i18n.tr("Enter Category name")
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
                id: descrLabel
                text: i18n.tr("Description:")
                color: pageAddCategory.textColor
                anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                }
            }
            TextArea {
                id: textareaDescr
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
            Label {
                id: colorLabel
                text: i18n.tr("Color:")
                color: pageAddCategory.textColor
                anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
                }
            }
            ColorPicker {
                id: colorPicker
                width: units.gu(20)
                height: units.gu(4)
                selectedColor: categoryColor === "default" ? "white" : categoryColor
                anchors {
                    left: parent.left
                    leftMargin: units.gu(2)
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
            text: i18n.tr("Cancel")
            activeFocusOnPress: false
            anchors {
                left: parent.left
                leftMargin: units.gu(2)
                verticalCenter: parent.verticalCenter
            }
            onClicked: {
                pageAddCategory.cancel()
            }
        }
        Button {
            text: pageAddCategory.mode === "add" ? i18n.tr(
                                                       "Add") : i18n.tr("Save")
            activeFocusOnPress: false
            color: UbuntuColors.green
            anchors {
                right: parent.right
                rightMargin: units.gu(2)
                verticalCenter: parent.verticalCenter
            }
            onClicked: {
                /*Commits the OSK*/
                keyboard.target.commit()

                var txtName = textName.text
                var txtDescr = textareaDescr.text
                var txtColor = colorPicker.selectedColor //categoryIcon;

                if (Process.checkRequired([txtName]) === false) {
                    textName.forceActiveFocus()
                } else if (txtName !== category_name
                           && DataProcess.categoryExist(txtName) === true) {
                    PopupUtils.open(dialog)
                } else {
                    switch (mode) {
                    case "edit":
                        DataProcess.updateCategory(category_name, txtName,
                                                   txtDescr, txtColor)
                        mainView.notification.showNotification(
                                    "Category successfully saved",
                                    theme.palette.normal.positive)
                        break
                    case "add":
                        DataProcess.saveCategory(txtName, txtDescr, txtColor)
                        mainView.notification.showNotification(
                                    "Category successfully added",
                                    theme.palette.normal.positive)
                        break
                    }

                    mainView.listItems.modelCategories.getCategories()
                    //checkEmpty()
                    pageAddCategory.saved()
                    try {
                        pageAddChecklist.createdCategory = txtName
                    } catch (err) {


                        //                        console.log("not from add checklist page")
                    }
                }
            }
        }
    }
    Component {
        id: dialog
        Dialog {
            id: dialogue
            title: "Category Already Exist!"
            text: "That category already exist. Please choose a different name."
            Button {
                text: "OK"
                onClicked: PopupUtils.close(dialogue)
            }
        }
    }
    Connections {
        id: keyboard
        target: Qt.inputMethod
    }
}
