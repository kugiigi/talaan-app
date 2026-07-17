import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common/dialogs" as Dialogs

Dialogs.DialogWithContents {
    id: deleteCategoryDialog

    property string categoryName
    property string categoryDescription

    signal proceed
    signal cancel

    destroyOnClose: true

    title: i18n.tr("Delete Category")

    onProceed: close()
    onCancel: close()

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.Paragraph
        text: i18n.tr("Are you sure you want to delete this category?")
        wrapMode: Text.WordWrap
    }

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.HeadingThree
        visible: text.trim() !== ""
        text: deleteCategoryDialog.categoryName
        wrapMode: Text.WordWrap
    }

    Label {
        Layout.fillWidth: true
        visible: text.trim() !== ""
        Suru.textLevel: Suru.Paragraph
        text: deleteCategoryDialog.categoryDescription
        wrapMode: Text.WordWrap
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Suru.units.gu(2)

        UT.Button {
            Layout.fillWidth: true
            text: i18n.tr("Delete")
            color: mainView.uitkColors.normal.negative

            onClicked: deleteCategoryDialog.proceed()
        }

        UT.Button {
            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Cancel")
            color: Suru.neutralColor

            onClicked: deleteCategoryDialog.cancel()
        }
    }
}
