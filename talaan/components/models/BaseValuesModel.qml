import QtQuick 2.12
import "../../common" as Common
import "../../library/functions.js" as Functions

Common.BaseListModel {
    id: baseValuesModel

    property var summaryValues

    // Current values if data was loaded
    property string category
    property string fromDate
    property string toDate
    property string scope
    property string sort
    property string order

    function refresh() {
        if (fromDate && toDate) {
            load(category, scope, fromDate, toDate, sort, order)
        }
    }

    function load(categoryName, inputScope, dateFrom, dateTo, sortBy, orderBy) {
        if (inputScope == "custom") {
            fromDate = dateFrom
            toDate = dateTo
        } else {
            fromDate = Functions.getFirstDay(inputScope, dateFrom)
            toDate = Functions.getLastDay(inputScope, dateFrom)
        }

        category = categoryName
        scope = inputScope
        sort = sortBy
        order = orderBy

        properties = {
            scope: scope,
            sort: sort,
            order: order,
        }
        fillData(mainView.expenses.detailedData(categoryName, scope, dateFrom, dateTo, sortBy, orderBy))
    }
}
