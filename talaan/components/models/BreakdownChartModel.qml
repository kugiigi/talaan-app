import QtQuick 2.12
import "../../common" as Common
import "../../library/functions.js" as Functions

Common.BaseListModel {
    id: baseValuesModel

    property string dataID
    property var modelFunction

    Component.onCompleted: refresh()

    function refresh() {
        fillData(modelFunction(dataID))
    }

    function getFromDate() {
        let _range
        switch (dataID) {
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
        return Functions.getLastDay(dataID)
    }
}
