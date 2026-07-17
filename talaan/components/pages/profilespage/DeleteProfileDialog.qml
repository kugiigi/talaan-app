import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common/dialogs" as Dialogs

Dialogs.DialogWithContents {
    id: deleteProfileDialog

    property int profileID
    property string displayName

    signal proceed
    signal cancel

    destroyOnClose: true

    title: i18n.tr("Delete Profile")

    onProceed: close()
    onCancel: close()

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.Paragraph
        text: i18n.tr("Are you sure you want to delete this profile?")
        wrapMode: Text.WordWrap
    }

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.HeadingThree
        visible: text.trim() !== ""
        text: deleteProfileDialog.displayName
        wrapMode: Text.WordWrap
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Suru.units.gu(2)

        UT.Button {
            Layout.fillWidth: true
            text: i18n.tr("Delete")
            color: mainView.uitkColors.normal.negative

            onClicked: deleteProfileDialog.proceed()
        }

        UT.Button {
            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Cancel")
            color: Suru.neutralColor

            onClicked: deleteProfileDialog.cancel()
        }
    }
}
