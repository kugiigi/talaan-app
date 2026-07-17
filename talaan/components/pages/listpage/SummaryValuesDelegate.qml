import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3 as UT
import QtQuick.Layouts 1.12
import "../../../common" as Common
import "../.." as Components
import "../../../library/functions.js" as Functions
import "../../../library/ApplicationFunctions.js" as AppFunctions

Common.BaseButton {
    id: summaryValues

    readonly property bool multipleValues: valuesModel && valuesModel.length > 1 ? true : false
    readonly property var travelTotalArray: valuesModel ? valuesModel.filter(x => x.value_type == "TRAVEL_TOTAL") : []
    readonly property bool travelTotalCount: travelTotalArray.length
    // Indicates that current data only has one travel currency and would determine which total to display
    readonly property bool onlyOneTravelTotal: travelTotalCount == 1
    readonly property string theOnlyTravelCurrency: onlyOneTravelTotal ? travelTotalArray[0].currency : ""

    property alias valuesModel: valuesRepeater.model
    property bool isExpanded: false
    property bool isTravelMode: false
    property string currentTravelCurrency

    radius: Suru.units.gu(3)
    backgroundColor: Suru.secondaryBackgroundColor
    borderColor: Suru.secondaryBackgroundColor
    implicitHeight: content.height + Suru.units.gu(2)
    implicitWidth: content.width + Suru.units.gu(4)

    onClicked: {
        if (multipleValues) {
            isExpanded = !isExpanded
        }
    }
    
    onMultipleValuesChanged: {
        if (!multipleValues) {
            isExpanded = false
        }
    }

    // Formats the values
    function getFormattedValues(itemData) {
        let _formattedText = ""
        let _data = itemData.data
        let _currency = itemData.currency
        
        if (_data) {
            switch(itemData.value_type) {
                case "TOTAL":
                    _formattedText = AppFunctions.formatMoney(_data, false)
                    break;
                case "TRAVEL_TOTAL":
                    _formattedText = Functions.formatMoney(_data, _currency, null)
                    break;
                case "HIGHEST":
                case "LOWEST":
                    if (_data[0]) {
                        if (summaryValues.isTravelMode && summaryValues.onlyOneTravelTotal
                                        && _data[0].travel_currency == summaryValues.currentTravelCurrency) {
                            _formattedText = Functions.formatMoney(_data[0].travel_value, summaryValues.currentTravelCurrency, null)
                        } else {
                            _formattedText = AppFunctions.formatMoney(_data[0].value, false)
                        }
                    }
                    break;
                default:
                    _formattedText = _data
                    break;
            }
        }
        
        return _formattedText
    }

    function getValueTypeLabel(itemData) {
        let _formattedText = ""
        let _valueType = itemData.value_type
        let _currency = itemData.currency
        
        if (_valueType) {
            switch(_valueType) {
                case "TOTAL":
                    _formattedText = i18n.tr("Overall Total")
                    break;
                case "TRAVEL_TOTAL":
                    _formattedText = i18n.tr("Total (%1)").arg(_currency)
                    break;
                case "HIGHEST":
                    _formattedText = i18n.tr("Highest")
                    break;
                case "LOWEST":
                    _formattedText = i18n.tr("Lowest")
                    break;
                default:
                    _formattedText = ""
                    break;
            }
        }
        
        return _formattedText
    }

    ColumnLayout {
        id: content

        spacing: Suru.units.gu(1)

        anchors.centerIn: parent

        UT.Icon {
            id: expandIcon

            Layout.alignment: Qt.AlignCenter
            color: Suru.secondaryForegroundColor
            name: summaryValues.isExpanded ? "go-down" : "go-up"
            implicitWidth: Suru.units.gu(1.5)
            implicitHeight: implicitWidth
            visible: multipleValues
        }

        Repeater {
            id: valuesRepeater

            delegate: ColumnLayout {
                visible: {
                    if (summaryValues.isExpanded) {
                        return true
                    }

                    switch (modelData.value_type) {
                        case "TOTAL":
                            if (summaryValues.isTravelMode && summaryValues.onlyOneTravelTotal
                                    && summaryValues.theOnlyTravelCurrency == summaryValues.currentTravelCurrency) {
                                return false
                            }

                            return true
                        case "TRAVEL_TOTAL":
                            if (summaryValues.isTravelMode && summaryValues.onlyOneTravelTotal
                                        && modelData.currency == summaryValues.currentTravelCurrency) {
                                return true
                            }

                            return false
                        default:
                            return false
                    }
                }

                Components.ColoredLabel {
                    Layout.fillWidth: true

                    visible: summaryValues.isExpanded
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    
                    Suru.textLevel: Suru.HeadingThree
                    wrapMode: Text.WordWrap
                    text: getValueTypeLabel(modelData)
                }

                Components.ColoredLabel {
                    Layout.fillWidth: true

                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: Suru.units.gu(4)
                    font.weight: Font.DemiBold
                    wrapMode: Text.WordWrap
                    text: getFormattedValues(modelData)
                    role: "value"
                }
            }
        }
    }
}
