import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import ".." as Components
import "../../common/dialogs" as Dialogs
import "../../library/functions.js" as Functions

Dialogs.DialogWithContents {
    id: deleteListDialog

    readonly property bool isChecklist: listData && (listData.type == "checklist" || listData.type == "endless")
    readonly property bool isCompleted: listData && listData.status == 1
    readonly property bool hasCompletionDate: listData && listData.completionDate !== ""
    readonly property bool itemIsArchived: (!isChecklist && hasCompletionDate) || (isChecklist && hasCompletionDate && !isCompleted)
    property Components.ListData listData

    signal proceed
    signal archive
    signal cancel

    destroyOnClose: true

    title: isChecklist ? i18n.tr("Delete Checklist") : i18n.tr("Delete List")

    onProceed: close()
    onArchive: close()
    onCancel: close()

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.Paragraph
        text: deleteListDialog.isChecklist ? i18n.tr("Are you sure you want to permanently delete this checklist?") : i18n.tr("Are you sure you want to permanently delete this list?")
        wrapMode: Text.WordWrap
    }

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.Caption
        text: i18n.tr("You can archive instead so you can still view it in the future as well as revert back.")
        wrapMode: Text.WordWrap
        visible: archiveButton.visible
    }

    ColumnLayout {
        RowLayout {
            Label {
                Layout.fillWidth: true
                Suru.textLevel: Suru.HeadingThree
                visible: text.trim() !== ""
                text: deleteListDialog.listData ? deleteListDialog.listData.listName : ""
                wrapMode: Text.WordWrap
            }

            Components.ColoredLabel {
                Layout.alignment: Qt.AlignRight
                visible: text.trim() !== ""
                Suru.textLevel: Suru.HeadingThree
                horizontalAlignment: Text.AlignHCenter
                text: deleteListDialog.listData ? i18n.tr("%1 / %2").arg(deleteListDialog.listData.checkedCount).arg(deleteListDialog.listData.itemCount)
                                : ""
                wrapMode: Text.WordWrap
                role: "value"
            }
        }

        Label {
            Layout.fillWidth: true
            visible: text.trim() !== ""
            Suru.textLevel: Suru.Paragraph
            text: deleteListDialog.listData ? deleteListDialog.listData.description : ""
            wrapMode: Text.WordWrap
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Suru.units.gu(2)

        UT.Button {
            Layout.fillWidth: true
            text: i18n.tr("Delete")
            color: theme.palette.normal.negative

            onClicked: deleteListDialog.proceed()
        }

        UT.Button {
            id: archiveButton

            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Archive")
            color: Suru.tertiaryForegroundColor
            visible: !deleteListDialog.itemIsArchived

            onClicked: deleteListDialog.archive()
        }

        UT.Button {
            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Cancel")
            color: Suru.neutralColor

            onClicked: deleteListDialog.cancel()
        }
    }
}
