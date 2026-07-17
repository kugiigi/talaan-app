import QtQuick 2.12
import QtQuick.Controls.Suru 2.2
import "../../common" as Common
import "../../library/functions.js" as Functions

Common.BaseListModel {
    id: root

    property var modelData
    property var modelFunction

    // Current values if data was loaded
    property string chartType
    property string chartRange
    property string chartMode
    property string chartCategories
    property string chartFromDate
    property string chartToDate

    Component.onCompleted: refresh()

    function refresh() {
        if (chartType && chartRange && chartMode) {
            load(chartType, chartRange, chartMode, chartCategories, chartFromDate, chartToDate)
        }
    }

    function load(type, range, mode, categories, fromDate, toDate) {
        let _arrResult = []
        chartType = type
        chartRange = range
        chartMode = mode
        chartCategories = categories
        chartFromDate = fromDate
        chartToDate = toDate

        loadingStatus = "Loading"

        switch(type){
            case "LINE":
                _arrResult = modelFunction(range, mode, categories, fromDate, toDate)
                break
        }

        properties = {
            type: type,
            data: _arrResult,
            dateMode: mode,
            dateRange: range,
            fromDate: fromDate,
            toDate: toDate,
        }

        fillData(_arrResult)
    }

    function getFromDate() {
        let _range
        switch (chartRange) {
            case "today":
                _range = "yesterday"
                break
            case "thisweek":
                _range = "lastweek"
                break
            case "thismonth":
                _range = "lastmonth"
                break
            case "thisyear":
                _range = "lastyear"
                break
            case "recent":
                _range = "previousrecent"
                break
        }

        return Functions.getFirstDay(_range)
    }

    function getToDate() {
        return Functions.getLastDay(chartRange)
    }
}
