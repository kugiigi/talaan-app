import QtQuick 2.12
import "../library/Currencies.js" as Currencies

QtObject {
    id: currency

    readonly property var currencyData: Currencies.currency(currencyID)
    property string currencyID: mainView.settings.currentCurrency
    property string symbol: currencyData.symbol
    property string decimal: currencyData.decimal
    property string thousand: currencyData.thousand
    property int precision: currencyData.precision
    property string format: currencyData.format
}
