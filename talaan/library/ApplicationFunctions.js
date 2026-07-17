/*
  This library contains functions used within Tagatuos app.
  This includes functions that execute functions from ProcessFunc.js
  with some parameters predetermined using app specific variable such as
  setting values (i.e. current currency).


*/

.import "functions.js" as Functions


function formatMoney(value, noSymbol) {
    var options = {
        symbol : noSymbol ? "" : mainView.settings.currentCurrencySymbol,
        decimal : mainView.settings.currentCurrencyDecimal,
        thousand: mainView.settings.currentCurrencyThousand,
        precision : mainView.settings.currentCurrencyPrecision,
        format: mainView.settings.currentCurrencyFormat
    };
    return Functions.formatMoney(value, mainView.settings.currentCurrency,options)

}

function formatMoneyTravel(value, noSymbol) {
    var options = {
        symbol : noSymbol ? "" : mainView.settings.travelCurrencySymbol,
        decimal : mainView.settings.travelCurrencyDecimal,
        thousand: mainView.settings.travelCurrencyThousand,
        precision : mainView.settings.travelCurrencyPrecision,
        format: mainView.settings.travelCurrencyFormat
    };
    return Functions.formatMoney(value, mainView.settings.travelCurrency,options)

}

function getCategoryColor(category) {
    let _color = mainView.mainModels.categoriesModel.getColor(category)

    if (!_color) {
        _color = "black"
    }
    return _color
}

function getContrastYIQ(hexcolor){
    let rgb = hexToRgb(hexcolor)
    let r = rgb.r
    let g = rgb.g
    let b = rgb.b

    let yiq = ((r*299)+(g*587)+(b*114))/1000;
    return (yiq >= 128)
}

function hexToRgb(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? {
        r: parseInt(result[1], 16),
        g: parseInt(result[2], 16),
        b: parseInt(result[3], 16)
    } : null;
}


