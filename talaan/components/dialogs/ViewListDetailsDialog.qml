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
    id: viewListDetailsDialog

    readonly property bool isChecklist: listData && (listData.type == "checklist" || listData.type == "endless")
    readonly property bool isEndless: listData && listData.type == "endless"
    readonly property bool isCompleted: listData && listData.status == 1
    readonly property bool hasCompletionDate: listData && listData.completionDate !== ""
    readonly property bool itemIsArchived: (!isChecklist && hasCompletionDate) || (isChecklist && hasCompletionDate && !isCompleted)
    readonly property bool thereAreUncheckedItems: listData && listData.checkedCount < listData.itemCount
    property Components.ListData listData

    destroyOnClose: true
    title: isChecklist ? i18n.tr("Checklist Details") : i18n.tr("List Details")

    RowLayout {
        Components.ColoredLabel {
            Layout.fillWidth: true

            Suru.textLevel: Suru.Paragraph
            text: viewListDetailsDialog.listData ? viewListDetailsDialog.listData.categoryName : ""
            wrapMode: Text.WordWrap
            role: "category"
        }

        Label {
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignRight
            Suru.textLevel: Suru.Paragraph
            visible: text.trim() !== ""
            text: {
                if (viewListDetailsDialog.listData) {
                    switch (true) {
                        case viewListDetailsDialog.isChecklist && !viewListDetailsDialog.isEndless && viewListDetailsDialog.isCompleted:
                            return i18n.tr("Completed Checklist")
                        case viewListDetailsDialog.isChecklist && !viewListDetailsDialog.isEndless && !viewListDetailsDialog.isCompleted:
                            return i18n.tr("Incomplete Checklist")
                        case viewListDetailsDialog.isEndless && viewListDetailsDialog.isCompleted:
                            return i18n.tr("Completed Endless Checklist")
                        case viewListDetailsDialog.isEndless && !viewListDetailsDialog.isCompleted:
                            return i18n.tr("Incomplete Endless Checklist")
                        case viewListDetailsDialog.isChecklist && !viewListDetailsDialog.isEndless && viewListDetailsDialog.itemIsArchived:
                            return i18n.tr("Archived Checklist")
                        case viewListDetailsDialog.isChecklist && viewListDetailsDialog.isEndless && viewListDetailsDialog.itemIsArchived:
                            return i18n.tr("Archived Endless Checklist")
                        case !viewListDetailsDialog.isChecklist && viewListDetailsDialog.itemIsArchived:
                            return i18n.tr("Archived List")
                        case !viewListDetailsDialog.isChecklist && !viewListDetailsDialog.itemIsArchived:
                            return i18n.tr("List")
                    }
                } else {
                    return ""
                }
            }
            wrapMode: Text.WordWrap
        }
    }

    ColumnLayout {
        RowLayout {
            Label {
                Layout.fillWidth: true
                Suru.textLevel: Suru.HeadingTwo
                text: viewListDetailsDialog.listData ? viewListDetailsDialog.listData.listName : "<%1>".arg(i18n.tr("Blank name"))
                wrapMode: Text.WordWrap
            }

            Components.ColoredLabel {
                Layout.alignment: Qt.AlignRight
                visible: text.trim() !== ""
                Suru.textLevel: Suru.HeadingThree
                horizontalAlignment: Text.AlignHCenter
                text: {
                    if (viewListDetailsDialog.listData) {
                        if (viewListDetailsDialog.isChecklist) {
                            return i18n.tr("%1 / %2").arg(viewListDetailsDialog.listData.checkedCount).arg(viewListDetailsDialog.listData.itemCount)
                        } else {
                            return viewListDetailsDialog.listData.itemCount
                        }
                    } else {
                        return ""
                    }
                }
                wrapMode: Text.WordWrap
                role: "value"
            }
        }

        Label {
            Layout.fillWidth: true
            visible: text.trim() !== ""
            Suru.textLevel: Suru.Paragraph
            text: viewListDetailsDialog.listData ? viewListDetailsDialog.listData.description : "<%1>".arg(i18n.tr("Blank description"))
            wrapMode: Text.WordWrap
        }
    }

    ColumnLayout {
        RowLayout {
            Label {
                Layout.fillWidth: true
                Suru.textLevel: Suru.Small
                text: i18n.tr("Creation date:")
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Suru.textLevel: Suru.Small
                text: viewListDetailsDialog.listData 
                                && viewListDetailsDialog.listData.creationDate ? Functions.relativeTime(viewListDetailsDialog.listData.creationDate)
                                                                    : i18n.tr("None")
                wrapMode: Text.WordWrap
            }
        }

        RowLayout {
            Label {
                Layout.fillWidth: true
                Suru.textLevel: Suru.Small
                text: i18n.tr("Last modified date:")
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Suru.textLevel: Suru.Small
                text: viewListDetailsDialog.listData
                                && viewListDetailsDialog.listData.modifiedDate ? Functions.relativeTime(viewListDetailsDialog.listData.modifiedDate)
                                                                    : i18n.tr("None")
                wrapMode: Text.WordWrap
            }
        }

        RowLayout {
            Label {
                Layout.fillWidth: true
                Suru.textLevel: Suru.Small
                text: i18n.tr("Target date:")
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Suru.textLevel: Suru.Small
                text: viewListDetailsDialog.listData
                                && viewListDetailsDialog.listData.targetDate ? Functions.relativeTime(viewListDetailsDialog.listData.targetDate)
                                                                    : i18n.tr("None")
                wrapMode: Text.WordWrap
            }
        }

        RowLayout {
            Label {
                Layout.fillWidth: true
                Suru.textLevel: Suru.Small
                text: i18n.tr("Completion date:")
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignRight
                Suru.textLevel: Suru.Small
                text: viewListDetailsDialog.listData
                                && viewListDetailsDialog.listData.completionDate ? Functions.relativeTime(viewListDetailsDialog.listData.completionDate)
                                                                    : i18n.tr("None")
                wrapMode: Text.WordWrap
            }
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Suru.units.gu(2)

        UT.Button {
            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Close")
            color: Suru.neutralColor

            onClicked: viewListDetailsDialog.close()
        }
    }
}
