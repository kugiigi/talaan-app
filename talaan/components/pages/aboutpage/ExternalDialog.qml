import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3 as UT
import QtQuick.Layouts 1.12
import "../../../common" as Common
import "../../../common/dialogs" as Dialogs

Dialogs.DialogWithContents {
    id: externalDialog

    property string externalURL

    signal cancel

    destroyOnClose: true
    title: i18n.tr("Open external link")
    onAccepted: {
        Qt.openUrlExternally(externalURL)
    }

    onCancel: close()

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.Paragraph
        text: i18n.tr("You are about to open an external link. Do you wish to continue?")
        wrapMode: Text.WordWrap
    }

    Label {
        Layout.fillWidth: true
        Suru.textLevel: Suru.Caption
        text: externalURL
        elide: Text.ElideRight
        maximumLineCount: 2
        wrapMode: Text.Wrap
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Suru.units.gu(2)

        UT.Button {
            Layout.fillWidth: true
            text: i18n.tr("Open")
            color: theme.palette.normal.positive

            onClicked: externalDialog.accept()
        }

        UT.Button {
            Layout.fillWidth: true
            enabled: visible
            text: i18n.tr("Cancel")
            color: Suru.neutralColor

            onClicked: externalDialog.cancel()
        }
    }
}
