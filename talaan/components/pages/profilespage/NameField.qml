import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common" as Common
import "../.." as Components

ColumnLayout {
    id: root

    property Common.BaseFlickable flickable
    property alias text: textName.text

    spacing: Suru.units.gu(1)

    function focusTextField(){
        textName.forceActiveFocus()
    }

    Label {
        id: nameLabel

        Layout.fillWidth: true
        Suru.textLevel: Suru.HeadingThree
        text: i18n.tr("Display Name")
        color: Suru.foregroundColor
    }

    TextField {
        id: textName

        Layout.fillWidth: true
        placeholderText: i18n.tr("Enter profile name ")
        wrapMode: TextInput.WordWrap
        selectByMouse: true

        Keys.onUpPressed: console.log("Do not remove focus")
        Keys.onDownPressed: focusScrollConnections.focusNext()

        Components.FocusScrollConnections {
            id: focusScrollConnections

            target: textName
            flickable: root.flickable
        }
    }

}
