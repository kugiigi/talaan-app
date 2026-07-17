import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common" as Common
import "../../../common/listitems" as ListItems
import "../../../library/functions.js" as Functions

ColumnLayout {
    id: rateField

    property var settingsObject
    property var model
    property alias text: valueTextField.text
    property bool focused: valueTextField.activeFocus
    property bool isLoading: false
    property bool isUpdated: Functions.isToday(settingsObject.exchangeRateDate) ? true : false

    signal dataFetched(bool status)

    function updateRate(forceUpdate) {
        if (!isLoading) {
            let _ratesData = model.data
            if (_ratesData && !forceUpdate) {
                let base = settingsObject.travelCurrency
                let destination = settingsObject.currentCurrency

                valueTextField.text = (1 / _ratesData.rates[base]) * _ratesData.rates[destination];
                dataFetched(true)
            } else {
                isLoading = true;
                model.fetchLatestJSON(setRateText);
            }
        }
    }

    function setRateText(isSuccess) {
        let _ratesData = model.data
        if (isSuccess) {
            let base = settingsObject.travelCurrency
            let destination = settingsObject.currentCurrency

            if (_ratesData.rates[base] && _ratesData.rates[destination]) {
                valueTextField.text = (1 / _ratesData.rates[base]) * _ratesData.rates[destination]
                settingsObject.fetchExchangeRate = true
                dataFetched(true)
            } else {
                dataFetched(false)
            }
        } else {
            if (!_ratesData) {
                settingsObject.fetchExchangeRate = false
            }
            dataFetched(false)
        }

        isLoading = false;
    }

    Label {
        id: valueLabel

        Layout.fillWidth: true
        Layout.margins: Suru.units.gu(1)
        Suru.textLevel: Suru.HeadingThree
        text: i18n.tr("Exchange Rate")
    }

    ListItems.BaseCheckBoxDelegate {
        id: checkboxItem

        Layout.fillWidth: true

        text: i18n.tr("Use exchange rate data from online")
        checkBoxPosition: ListItems.BaseCheckBoxDelegate.Position.Left

        onCheckedChanged: {
            rateField.settingsObject.fetchExchangeRate = checked
            if (rateField.settingsObject.fetchExchangeRate) {
                rateField.updateRate(false)
            }
        }
        
        Binding {
            target: checkboxItem
            property: "checked"
            value: rateField.settingsObject.fetchExchangeRate
        }
        rightPadding: indicator.width + Suru.units.gu(1)
        indicator: Common.HelpButton {
            text: i18n.tr("Fetch exchange rate data from OpenExchangeRates.org and use the, for storing the converted expense values")

            anchors {
                top: parent.top
                bottom: parent.bottom
                margins: Suru.units.gu(1)
                right: parent.right
            }
        }
    }

    RowLayout {
        id: textRateRow

        Layout.fillWidth: true
        Layout.margins: Suru.units.gu(1)

        spacing: Suru.units.gu(1)

        TextField {
            id: valueTextField

            Layout.fillWidth: true

            rightPadding: convertedValueLabel.visible ? convertedValueLabel.width : Suru.units.gu(1.5)
            placeholderText: "1.00"
            font.pixelSize: Suru.units.gu(2)
            horizontalAlignment: TextInput.AlignHCenter
            wrapMode: TextInput.WordWrap
            selectByMouse: true
            inputMethodHints: Qt.ImhDigitsOnly
            text: rateField.settingsObject.exchangeRate
            enabled: !rateField.settingsObject.fetchExchangeRate

            onTextChanged: {
                if (text) {
                    rateField.settingsObject.exchangeRate = parseFloat(text)
                } else {
                    rateField.settingsObject.exchangeRate = 0
                }
            }

            Item {
                anchors.fill: parent
                
                Label {
                    id: currencySymbolLabel

                    Suru.textLevel: Suru.HeadingThree
                    text: rateField.settingsObject.currentCurrencySymbol
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
                    text: i18n.tr("= 1 %1").arg(rateField.settingsObject.travelCurrency)
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

        BusyIndicator {
            Layout.preferredHeight: valueTextField.height * 0.9
            Layout.preferredWidth: valueTextField.height * 0.9
            running: visible
            visible: rateField.isLoading
        }

        Common.BaseButton {
            id: refreshButton

            visible: rateField.settingsObject.fetchExchangeRate && !rateField.isLoading
            display: Button.IconOnly
            icon.name: "reload"
            onClicked: rateField.updateRate(true)
        }
    }

    Label {
        id: asofLabel

        Layout.fillWidth: true
        Layout.leftMargin: Suru.units.gu(1)
        Layout.rightMargin: Suru.units.gu(1)

        Suru.textLevel: Suru.Caption
        Suru.highlightType: rateField.isUpdated ? Suru.InformationHighlight : Suru.NegativeHighlight
        visible: settingsObject.fetchExchangeRate
        text: i18n.tr("Exchange rate data as of: %1").arg(Functions.relativeDate(rateField.settingsObject.exchangeRateDate, "MMMM d, YYYY", "Basic"))
        verticalAlignment: Text.AlignVCenter
        color: rateField.isUpdated ? Suru.foregroundColor : Suru.highlightColor
    }
}
