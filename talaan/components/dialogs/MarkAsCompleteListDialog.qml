import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import ".." as Components
import "../../common" as Common
import "../../common/dialogs" as Dialogs
import "../../common/listitems" as ListItems
import "../../library/functions.js" as Functions

Dialogs.DialogWithContents {
    id: markAsCompleteListDialog

    readonly property bool isChecklist: listData && (listData.type == "checklist" || listData.type == "endless")
    readonly property bool isCompleted: listData && listData.status == 1
    readonly property bool hasCompletionDate: listData && listData.completionDate !== ""
    readonly property bool itemIsArchived: (!isChecklist && hasCompletionDate) || (isChecklist && hasCompletionDate && !isCompleted)
    readonly property bool thereAreUncheckedItems: listData && listData.checkedCount < listData.itemCount
    property Components.ListData listData

    signal proceed(bool skipUnchecked)
    signal archive
    signal cancel

    destroyOnClose: true

    title: isCompleted ? i18n.tr("Revert checklist as incomplete") : i18n.tr("Mark checklist as completed")

    onProceed: close()
    onArchive: close()
    onCancel: close()

    Label {
        Layout.fillWidth: true
        visible: uncheckedItemsRadioButtons.visible
        Suru.textLevel: Suru.Paragraph
        text: i18n.tr("There are unchecked items in this checklist. Select how to handle them.")
        wrapMode: Text.WordWrap
    }

    ColumnLayout {
        id: uncheckedItemsRadioButtons

        visible: !markAsCompleteListDialog.isCompleted && markAsCompleteListDialog.thereAreUncheckedItems

        ButtonGroup {
            id: buttonGroup
        }

        Common.BaseRadioButton {
            id: checkAllRadioButton

            text: i18n.tr("Check all unchecked items")
            checked: true
            ButtonGroup.group: buttonGroup
        }

        Common.BaseRadioButton {
            id: skipAllRadioButton

            text: i18n.tr("Skip all unchecked items")
            ButtonGroup.group: buttonGroup
        }
    }

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.Caption
        text: i18n.tr("You can archive instead to retain the status of all unchecked items and still be able to remove it from the active checklists.")
        wrapMode: Text.WordWrap
        visible: archiveButton.visible
    }

    ColumnLayout {
        RowLayout {
            Label {
                Layout.fillWidth: true
                Suru.textLevel: Suru.HeadingThree
                visible: text.trim() !== ""
                text: markAsCompleteListDialog.listData ? markAsCompleteListDialog.listData.listName : ""
                wrapMode: Text.WordWrap
            }

            Components.ColoredLabel {
                Layout.alignment: Qt.AlignRight
                visible: text.trim() !== ""
                Suru.textLevel: Suru.HeadingThree
                horizontalAlignment: Text.AlignHCenter
                text: markAsCompleteListDialog.listData ? i18n.tr("%1 / %2").arg(markAsCompleteListDialog.listData.checkedCount).arg(markAsCompleteListDialog.listData.itemCount)
                                : ""
                wrapMode: Text.WordWrap
                role: "value"
            }
        }

        Label {
            Layout.fillWidth: true
            visible: text.trim() !== ""
            Suru.textLevel: Suru.Paragraph
            text: markAsCompleteListDialog.listData ? markAsCompleteListDialog.listData.description : ""
            wrapMode: Text.WordWrap
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Suru.units.gu(2)

        UT.Button {
            Layout.fillWidth: true
            text: markAsCompleteListDialog.isCompleted ? i18n.tr("Revert as incomplete") : i18n.tr("Mark as completed")
            color: theme.palette.normal.positive

            onClicked: markAsCompleteListDialog.proceed(skipAllRadioButton.checked)
        }

        UT.Button {
            id: archiveButton

            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Archive")
            color: Suru.tertiaryForegroundColor
            visible: !markAsCompleteListDialog.itemIsArchived && markAsCompleteListDialog.thereAreUncheckedItems
                        && !markAsCompleteListDialog.isCompleted

            onClicked: markAsCompleteListDialog.archive()
        }

        UT.Button {
            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Cancel")
            color: Suru.neutralColor

            onClicked: markAsCompleteListDialog.cancel()
        }
    }
}
