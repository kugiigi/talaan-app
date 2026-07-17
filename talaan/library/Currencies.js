.import "database.js" as DB
.import QtQuick.LocalStorage 2.0 as Sql


function currencies() {
    return DB.select("SELECT currency_code, description FROM currencies")
}

let currency = function (code) {
    let symbol = '₱'
    let descr = 'Philippines Piso'
    let decimal = '.'
    let thousand = ','
    let precision = 2
    let format = '%s%v'

    let arrResults = DB.select("SELECT * FROM currencies WHERE currency_code = ?", code)

    for (var i = 0; i < arrResults.length; i++) {
        symbol = arrResults[i].symbol
        descr = arrResults[i].description

        decimal = arrResults[i].decimal
        decimal = decimal ? decimal : "."

        thousand = arrResults[i].thousand
        thousand = thousand ? thousand : ","

        precision = arrResults[i].precision
        precision = precision !== "" ? Number(precision) : 2

        format = arrResults[i].format
        format = format ? format : "%s%v"
    }

    return { symbol: symbol, descr: descr, decimal: decimal, thousand: thousand, precision:precision, format: format }
}
