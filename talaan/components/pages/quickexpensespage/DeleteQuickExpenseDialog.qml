import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common/dialogs" as Dialogs
import "../.." as Components
import "../../../library/functions.js" as Functions

Dialogs.DialogWithContents {
    id: deleteQuickExpenseDialog

    property Components.ExpenseData expenseData

    signal proceed
    signal cancel

    destroyOnClose: true

    title: i18n.tr("Delete Quick Expense")

    onProceed: close()
    onCancel: close()

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.Paragraph
        text: i18n.tr("Are you sure you want to delete this quick expense?")
        wrapMode: Text.WordWrap
    }

    RowLayout {
        Label {
            Layout.fillWidth: true
            Suru.textLevel: Suru.HeadingThree
            visible: text.trim() !== ""
            text: deleteQuickExpenseDialog.expenseData ? deleteQuickExpenseDialog.expenseData.name : ""
            wrapMode: Text.WordWrap
        }

        Components.ColoredLabel {
            Layout.alignment: Qt.AlignRight
            visible: text.trim() !== ""
            Suru.textLevel: Suru.HeadingThree
            horizontalAlignment: Text.AlignHCenter
            text: deleteQuickExpenseDialog.expenseData ? Functions.formatMoney(deleteQuickExpenseDialog.expenseData.value, deleteQuickExpenseDialog.expenseData.travelData.homeCur)
                            : ""
            wrapMode: Text.WordWrap
            role: "value"
        }
    }

    Label {
        Layout.fillWidth: true
        visible: text.trim() !== ""
        Suru.textLevel: Suru.Paragraph
        text: deleteQuickExpenseDialog.expenseData ? deleteQuickExpenseDialog.expenseData.description : ""
        wrapMode: Text.WordWrap
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Suru.units.gu(2)

        UT.Button {
            Layout.fillWidth: true
            text: i18n.tr("Delete")
            color: mainView.uitkColors.normal.negative

            onClicked: deleteQuickExpenseDialog.proceed()
        }

        UT.Button {
            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Cancel")
            color: Suru.neutralColor

            onClicked: deleteQuickExpenseDialog.cancel()
        }
    }
}
