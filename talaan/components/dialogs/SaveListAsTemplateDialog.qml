import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import ".." as Components
import "../../common/dialogs" as Dialogs
import "../../library/functions.js" as Functions

Dialogs.DialogWithContents {
    id: saveListAsTemplateDialog

    readonly property bool isChecklist: listData && (listData.type == "checklist" || listData.type == "endless")
    readonly property bool isCompleted: listData && listData.status == 1
    readonly property bool hasCompletionDate: listData && listData.completionDate !== ""
    readonly property bool itemIsArchived: (!isChecklist && hasCompletionDate) || (isChecklist && hasCompletionDate && !isCompleted)
    property Components.ListData listData

    signal proceed
    signal cancel

    destroyOnClose: true

    title: i18n.tr("Save checklist as template")

    onProceed: close()
    onCancel: close()

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.Paragraph
        text: i18n.tr("Are you sure you want to save this checklist as a quick template?")
        wrapMode: Text.WordWrap
    }

    ColumnLayout {
        RowLayout {
            Label {
                Layout.fillWidth: true
                Suru.textLevel: Suru.HeadingThree
                visible: text.trim() !== ""
                text: saveListAsTemplateDialog.listData ? saveListAsTemplateDialog.listData.listName : ""
                wrapMode: Text.WordWrap
            }

            Components.ColoredLabel {
                Layout.alignment: Qt.AlignRight
                visible: text.trim() !== ""
                Suru.textLevel: Suru.HeadingThree
                horizontalAlignment: Text.AlignHCenter
                text: saveListAsTemplateDialog.listData ? i18n.tr("%1 / %2").arg(saveListAsTemplateDialog.listData.checkedCount).arg(saveListAsTemplateDialog.listData.itemCount)
                                : ""
                wrapMode: Text.WordWrap
                role: "value"
            }
        }

        Label {
            Layout.fillWidth: true
            visible: text.trim() !== ""
            Suru.textLevel: Suru.Paragraph
            text: saveListAsTemplateDialog.listData ? saveListAsTemplateDialog.listData.description : ""
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
            text: i18n.tr("Save as template")
            color: Suru.tertiaryForegroundColor

            onClicked: saveListAsTemplateDialog.proceed()
        }

        UT.Button {
            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Cancel")
            color: Suru.neutralColor

            onClicked: saveListAsTemplateDialog.cancel()
        }
    }
}
