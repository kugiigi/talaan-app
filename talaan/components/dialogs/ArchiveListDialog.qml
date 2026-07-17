import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import ".." as Components
import "../../common/dialogs" as Dialogs
import "../../library/functions.js" as Functions

Dialogs.DialogWithContents {
    id: archiveListDialog

    readonly property bool isChecklist: listData && (listData.type == "checklist" || listData.type == "endless")
    readonly property bool isCompleted: listData && listData.status == 1
    readonly property bool hasCompletionDate: listData && listData.completionDate !== ""
    readonly property bool itemIsArchived: (!isChecklist && hasCompletionDate) || (isChecklist && hasCompletionDate && !isCompleted)
    property Components.ListData listData

    signal proceed
    signal cancel

    destroyOnClose: true

    title: {
        if (isChecklist) {
            if (itemIsArchived) {
                return i18n.tr("Unarchive Checklist")
            } else {
                return i18n.tr("Archive Checklist")
            }
        } else {
            if (itemIsArchived) {
                return i18n.tr("Unarchive List")
            } else {
                return i18n.tr("Archive List")
            }
        }
    }

    onProceed: close()
    onCancel: close()

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.Paragraph
        text: {
            if (isChecklist) {
                if (itemIsArchived) {
                    return i18n.tr("Are you sure you want to unarchive this checklist?")
                } else {
                    return i18n.tr("Are you sure you want to archive this checklist?")
                }
            } else {
                if (itemIsArchived) {
                    return i18n.tr("Are you sure you want to unarchive this list?")
                } else {
                    return i18n.tr("Are you sure you want to archive this list?")
                }
            }
        }
        wrapMode: Text.WordWrap
    }

    ColumnLayout {
        RowLayout {
            Label {
                Layout.fillWidth: true
                Suru.textLevel: Suru.HeadingThree
                visible: text.trim() !== ""
                text: archiveListDialog.listData ? archiveListDialog.listData.listName : ""
                wrapMode: Text.WordWrap
            }

            Components.ColoredLabel {
                Layout.alignment: Qt.AlignRight
                visible: text.trim() !== ""
                Suru.textLevel: Suru.HeadingThree
                horizontalAlignment: Text.AlignHCenter
                text: archiveListDialog.listData ? i18n.tr("%1 / %2").arg(archiveListDialog.listData.checkedCount).arg(archiveListDialog.listData.itemCount)
                                : ""
                wrapMode: Text.WordWrap
                role: "value"
            }
        }

        Label {
            Layout.fillWidth: true
            visible: text.trim() !== ""
            Suru.textLevel: Suru.Paragraph
            text: archiveListDialog.listData ? archiveListDialog.listData.description : ""
            wrapMode: Text.WordWrap
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Suru.units.gu(2)

        UT.Button {
            id: archiveButton

            Layout.fillWidth: true
            enabled: visible
            text: archiveListDialog.itemIsArchived ? i18n.tr("Unarchive") : i18n.tr("Archive")
            color: Suru.tertiaryForegroundColor

            onClicked: archiveListDialog.proceed()
        }

        UT.Button {
            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Cancel")
            color: Suru.neutralColor

            onClicked: archiveListDialog.cancel()
        }
    }
}
