import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common" as Common
import "../.." as Components

ColumnLayout {
    id: root

    property Common.BaseFlickable flickable
    property alias text: textareaDescr.text

    spacing: Suru.units.gu(1)

    Label {
        id: descrLabel

        Layout.fillWidth: true

        Suru.textLevel: Suru.HeadingThree
        text: i18n.tr("Description")
        color: Suru.foregroundColor
    }

    TextArea {
        id: textareaDescr

        Layout.fillWidth: true

        wrapMode: TextInput.WordWrap
        selectByMouse: true
        placeholderText: i18n.tr("Add description (optional)")

        Keys.onPressed: {
            if (event.key == Qt.Key_Backspace && text == "") {
                focusScrollConnections.focusPrevious()
            }
        }

        Components.FocusScrollConnections {
            id: focusScrollConnections

            target: textareaDescr
            flickable: root.flickable
            enableAcceptedFocus: false
        }
    }

}
