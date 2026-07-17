import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import "../.." as Components
import "../../../common" as Common
import "../../../library/ApplicationFunctions.js" as AppFunctions
import "../../../library/functions.js" as Functions

TextField {
    id: valueField

    readonly property bool highlighted: activeFocus
    property bool hasTravelData: false
    property bool processTravelData: false

    property Common.BaseFlickable flickable
    property alias convertedValue: convertedValueLabel.value // Home currency value when in travel mode
    property bool isColoredText: false
    property var travelData
    property var homeCurrencyData
    property var travelCurrencyData
    property bool isTravelMode: false

    color: isColoredText ? Suru.highlightColor : Suru.foregroundColor
    rightPadding: convertedValueLabel.visible ? convertedValueLabel.width : Suru.units.gu(1.5)
    placeholderText: AppFunctions.formatMoney(0, true)
    font.pixelSize: Suru.units.gu(3)
    horizontalAlignment: TextInput.AlignHCenter
    wrapMode: TextInput.WordWrap
    selectByMouse: true
    inputMethodHints: Qt.ImhDigitsOnly
    validator: DoubleValidator {
        decimals: isTravelMode ? travelCurrencyData.precision : homeCurrencyData.precision
    }

    Suru.highlightType: isColoredText ? Suru.PositiveHighlight : Suru.InformationHighlight

    Keys.onUpPressed: focusScrollConnections.focusPrevious()
    Keys.onDownPressed: focusScrollConnections.focusNext()

    onActiveFocusChanged: {
        if (activeFocus) {
            selectAll()
        }
    }

    onTextChanged: {
        if (processTravelData) {
            if (text !== "") {
                convertedValue = parseFloat(text) * travelData.rate
            } else {
                convertedValue = 0
            }
        }
    }

    Components.FocusScrollConnections {
        id: focusScrollConnections

        target: valueField
        flickable: valueField.flickable
    }

    background: Common.BaseBackgroundRectangle {
        control: valueField
        radius: Suru.units.gu(1)
        highlightColor: "transparent"
        
        Label {
            id: currencySymbolLabel

            Suru.textLevel: Suru.HeadingThree
            text: valueField.processTravelData ? valueField.travelCurrencyData.symbol : valueField.homeCurrencyData.symbol
            color: Suru.secondaryForegroundColor
            anchors {
                left: parent.left
                leftMargin: Suru.units.gu(2)
                verticalCenter: parent.verticalCenter
            }
        }

        Label {
            id: convertedValueLabel

            property real value

            Suru.textLevel: Suru.Small
            visible: valueField.processTravelData
            text: i18n.tr("= %1").arg(Functions.formatMoney(value, valueField.travelData.homeCur))
            color: Suru.tertiaryForegroundColor
            horizontalAlignment: Text.AlignRight
            anchors {
                right: parent.right
                rightMargin: Suru.units.gu(2)
                verticalCenter: parent.verticalCenter
            }
        }
    }
}
