import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common" as Common
import "../.." as Components
import "../../../library/ApplicationFunctions.js" as AppFunctions

ColumnLayout {
    id: root

    property Common.BaseFlickable flickable
    property alias text: textName.text
    property bool isColoredText: false
    property string currencySymbol

    spacing: Suru.units.gu(1)

    Label {
        id: nameLabel

        Layout.fillWidth: true
        Suru.textLevel: Suru.HeadingThree
        text: i18n.tr("Value")
        color: Suru.foregroundColor
    }

    TextField {
        id: textName

        Layout.fillWidth: true
        Suru.highlightType: isColoredText ? Suru.PositiveHighlight : Suru.InformationHighlight
        color: isColoredText ? Suru.highlightColor : Suru.foregroundColor
        placeholderText: AppFunctions.formatMoney(0, true)
        horizontalAlignment: TextInput.AlignHCenter
        wrapMode: TextInput.WordWrap
        selectByMouse: true
        inputMethodHints: Qt.ImhDigitsOnly
        validator: DoubleValidator {
            decimals: 6
        }

        Keys.onUpPressed: focusScrollConnections.focusPrevious()
        Keys.onDownPressed: focusScrollConnections.focusNext()

        onActiveFocusChanged: {
            if (activeFocus) {
                selectAll()
            }
        }

        Components.FocusScrollConnections {
            id: focusScrollConnections

            target: textName
            flickable: root.flickable
        }

        Item {
            anchors.fill: parent
            
            Label {
                id: currencySymbolLabel

                Suru.textLevel: Suru.HeadingThree
                text: root.currencySymbol
                color: Suru.secondaryForegroundColor
                anchors {
                    left: parent.left
                    leftMargin: Suru.units.gu(2)
                    verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
