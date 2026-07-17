import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common/dialogs" as Dialogs

Dialogs.DialogWithContents {
    id: newCategoryDialog

    readonly property bool isAddMode: mode == "add"
    readonly property bool isEditMode: mode == "edit"

    property string mode: "add"
    property string categoryName
    property string categoryDescription
    property color categoryColor: "white"

    signal proceed(string categoryName, string newCategoryName, string categoryDescription, color categoryColor)
    signal cancel

    anchorToKeyboard: true
    destroyOnClose: true
    title: isAddMode ? i18n.tr("New Category") : i18n.tr("Edit Category")

    onAboutToShow: {
        if (isEditMode) {
            nameField.text = categoryName
            descriptionField.text = categoryDescription
            colorField.color = categoryColor
        }
    }

    onOpened: nameField.forceActiveFocus()

    onCancel: close()

    NameField {
        id: nameField

        Layout.fillWidth: true
        flickable: newCategoryDialog.flickable
    }

    DescriptionField {
        id: descriptionField

        Layout.fillWidth: true
        flickable: newCategoryDialog.flickable
    }

    ColorField {
        id: colorField

        Layout.fillWidth: true
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Suru.units.gu(2)

        UT.Button {
            Layout.fillWidth: true
            text: i18n.tr("Save")
            enabled: nameField.text.trim() !== ""
            color: mainView.uitkColors.normal.positive

            onClicked: {
                mainView.keyboard.commit()
                newCategoryDialog.proceed(categoryName, nameField.text, descriptionField.text, colorField.color)
            }
        }

        UT.Button {
            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Cancel")
            color: Suru.neutralColor

            onClicked: newCategoryDialog.cancel()
        }
    }
}
