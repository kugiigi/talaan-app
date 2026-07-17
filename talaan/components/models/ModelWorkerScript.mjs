import { mom } from "../../library/external/moment.mjs"

var moment = mom();

WorkerScript.onMessage = function (msg) {
    let result

    if (msg.model) {
        msg.model.clear()
    }

    switch (msg.modelId) {
        case "Lists":
            for (let i = 0; i < msg.result.length; i++) {
                let _intId = msg.result[i].id
                let _txtName = msg.result[i].name
                let _txtDescr = msg.result[i].descr
                let _txtType = msg.result[i].type
                let _txtCategory = msg.result[i].category_name
                let _txtCreationDt = msg.result[i].creation_dt
                let _txtFormattedCreationDt = _txtCreationDt ? formatDateForItem(_txtCreationDt, "month", "category") : ""
                let _txtModifiedDt = msg.result[i].modified_dt
                let _txtFormattedModifiedDt = _txtModifiedDt ? formatDateForItem(_txtModifiedDt, "month", "category") : ""
                let _txtCompletionDt = msg.result[i].completion_dt
                let _txtFormattedCompletionDt = _txtCompletionDt ? formatDateForItem(_txtCompletionDt, "month", "category") : ""
                let _txtTargetDt = msg.result[i].target_dt
                let _txtFormattedTargetDt = _txtTargetDt ? formatDateForItem(_txtTargetDt, "month", "category") : ""
                let _intStatus = msg.result[i].status
                let _intFavorite = msg.result[i].favorite
                let _intItemCount = msg.result[i].item_count
                let _intCheckedCount = msg.result[i].checked_count

                let _arrItemData = {
                    list_id: _intId,
                    name: _txtName,
                    description: _txtDescr,
                    type: _txtType,
                    category_name: _txtCategory,
                    creation_dt: _txtCreationDt,
                    formatted_creation_dt: _txtFormattedCreationDt,
                    modified_dt: _txtModifiedDt,
                    formatted_modified_dt: _txtFormattedModifiedDt,
                    completion_dt: _txtCompletionDt,
                    formatted_completion_dt: _txtFormattedCompletionDt,
                    target_dt: _txtTargetDt,
                    formatted_target_dt: _txtFormattedTargetDt,
                    status: _intStatus,
                    favorite: _intFavorite,
                    item_count: _intItemCount,
                    checked_count: _intCheckedCount,
                }

                msg.model.append(_arrItemData)
            }
            break;
        case "ListItems":
            for (let i = 0; i < msg.result.length; i++) {
                let _txtName = msg.result[i].name
                let _txtComments = msg.result[i].comments
                let _intStatus = msg.result[i].status
                let _intPriority = msg.result[i].priority

                let _arrItemData = {
                    name: _txtName,
                    comments: _txtComments,
                    status: _intStatus,
                    priority: _intPriority,
                }

                msg.model.append(_arrItemData)
            }
            break;
        case "Categories":
            for (let i = 0; i < msg.result.length; i++) {
                let txtName = msg.result[i].category_name
                let txtDescr = msg.result[i].descr
                let txtIcon = msg.result[i].icon
                let txtColor = msg.result[i].color
                msg.model.append({
                                     category_name: txtName,
                                     value: txtName, // For category combo box
                                     descr: txtDescr,
                                     icon: txtIcon,
                                     colorValue: txtColor
                                 })
            }
            break
        case "QuickExpenses":
            for (let i = 0; i < msg.result.length; i++) {
                let txtID = msg.result[i].quick_id
                let txtCategoryName = msg.result[i].category_name
                let txtName = msg.result[i].name
                let txtDescr = msg.result[i].descr
                let txtValue = msg.result[i].value

                msg.model.append({
                                     quickID: txtID
                                     , categoryName: txtCategoryName
                                     , name: txtName
                                     , description: txtDescr
                                     , value: txtValue
                                 })
            }
            break;
        case "HistoryEntry":
            for (let i = 0; i < msg.result.length; i++) {
                let txtName = msg.result[i].name
                let txtCategoryName = msg.result[i].category_name
                let txtDescr = msg.result[i].descr
                let txtValue = msg.result[i].value
                let realTravelValue = msg.result[i].travel_value
                let realRate = msg.result[i].rate
                let txtHomeCur = msg.result[i].home_currency
                let txtTravelCur = msg.result[i].travel_currency

                msg.model.append({
                                     name: txtName
                                     , categoryName: txtCategoryName
                                     , description: txtDescr
                                     , value: txtValue
                                     , rate: realRate
                                     , home_currency: txtHomeCur
                                     , travel_currency: txtTravelCur
                                     , travel_value: realTravelValue
                                 })
            }
            break;
        case "TodayBreakdownChart":
        case "ThisWeekBreakdownChart":
        case "ThisMonthBreakdownChart":
        case "ThisYearBreakdownChart":
        case "RecentBreakdownChart":
            let _data = []

            for (let i = 0; i < msg.result.length; i++) {
                _data = [] // Reset first

                for (let h = 0; h < msg.result[i].length; h++) {
                    _data.push({ label: msg.result[i][h].category_name, value: msg.result[i][h].total, color: msg.result[i][h].color })
                }

                msg.model.append( { data: _data } )
            }
            break;
        case "Detailed_1":
        case "Detailed_2":
        case "Detailed_3":
        case "SearchExpense":
            let total = 0
            let scope = msg.properties && msg.properties.scope ? msg.properties.scope : ""
            let sort = msg.properties && msg.properties.sort ? msg.properties.sort : ""
            let order = msg.properties && msg.properties.order ? msg.properties.order : ""
            const travelTotals = []
            const highest = []
            const lowest = []

            for (let i = 0; i < msg.result.length; i++) {
                let intID = msg.result[i].expense_id
                let txtCategory = msg.result[i].category_name
                let realTotal = msg.result[i].group_total ? msg.result[i].group_total : 0
                let realTravelTotal = msg.result[i].group_travel_total ? msg.result[i].group_travel_total : 0
                let txtName = msg.result[i].name
                let txtDescr = msg.result[i].descr
                let txtDateValue = msg.result[i].entry_date
                let txtDate = formatDateForItem(txtDateValue, scope, sort)
                let realValue = msg.result[i].value
                let realTravelValue = msg.result[i].travel_value
                let realRate = msg.result[i].rate
                let txtHomeCur = msg.result[i].home_currency
                let txtTravelCur = msg.result[i].travel_currency

                let groupName = txtCategory
                if (sort == "date") {
                    groupName = formatDateForSection(txtDateValue, scope)
                }

                let currentExpenseId = intID
                let prevExpenseId = 0
                let currentTravelCurrency = txtTravelCur
                let prevTravelCurrency = ""
                let currentItemData = {
                    expense_id: intID,
                    category_name: txtCategory,
                    group_total: realTotal,
                    group_travel_total: realTravelTotal,
                    group_id: [groupName, realTotal, realTravelTotal].join("|"),
                    name: txtName,
                    descr: txtDescr,
                    entry_date: txtDateValue,
                    entry_date_relative: txtDate,
                    value: realValue,
                    rate: realRate,
                    home_currency: txtHomeCur,
                    travel_currency: txtTravelCur,
                    travel_value: realTravelValue
                }

                if (msg.modelId !== "SearchExpense") {
                    if (currentExpenseId !== prevExpenseId) {
                        total += realValue

                        // Get add to total of the same travel currency
                        if (txtTravelCur) {
                            let _foundIndex = travelTotals.findIndex((element) => element.currency == txtTravelCur)
                            if (_foundIndex > -1) {
                                travelTotals[_foundIndex].total += realTravelValue
                            } else {
                                travelTotals.push( { "currency": txtTravelCur, "total": realTravelValue } )
                            }
                        }

                        if (highest.length > 0) {
                            if (realValue >= highest[0].value) {
                                if (realValue > highest[0].value) {
                                    highest.length = 0
                                }

                                highest.push(currentItemData)
                            }
                        } else {
                            highest.push(currentItemData)
                        }

                        if (lowest.length > 0) {
                            if (realValue <= lowest[0].value) {
                                if (realValue < lowest[0].value) {
                                    lowest.length = 0
                                }

                                lowest.push(currentItemData)
                            }
                        } else {
                            lowest.push(currentItemData)
                        }
                    }
                }

                prevExpenseId = currentExpenseId
                prevTravelCurrency = currentTravelCurrency

                msg.model.append(currentItemData)
            }

            if (msg.modelId !== "SearchExpense") {
                result = []

                switch (scope) {
                    case "day":
                    default:
                        result.push( { value_type: "TOTAL", data: total } )

                        for (let i = 0; i < travelTotals.length; i++) {
                            result.push( { value_type: "TRAVEL_TOTAL", data: travelTotals[i].total, currency: travelTotals[i].currency } )
                        }

                        result.push( { value_type: "HIGHEST", data: highest } )
                        result.push( { value_type: "LOWEST", data: lowest } )
                        break
                }
            }

            break;
        case "ThisWeekTrendChart":
        case "RecentTrendChart":
        case "ThisMonthTrendChart":
        case "ThisYearTrendChart":

            let datasets
            let arrDatasets = []
            let arrData = []
            let arrCurrentLabels = []
            let arrPreviousLabels = []
            let chartData
            let realCurrentTotal = 0
            let realPreviousTotal = 0
            let realCurrentAverage = 0
            let realPreviousAverage = 0

            if (msg.properties.data.length > 1) {

                switch (msg.properties.type) {
                case "LINE":

                    for (let h = 0; h < msg.properties.data.length; h++) {
                        let arrAvg = []
                        let averageDataset
                        let total = 0
                        let average = 0
                        let intTotal = 0
                        let txtLabel = ""
                        let _series = msg.properties.data[h]
                        let _hasData = false
                        let _isCurrent = h == 0

                        arrData = []

                        for (let i = 0; i < _series.length; i++) {
                            let _itemTotal = _series[i].total
                            if (_itemTotal > 0) {
                                _hasData = true
                            }
                            total = total + _itemTotal
                        }

                        average = Math.round((total / _series.length) * 100) / 100

                        if (_isCurrent) {
                            realCurrentTotal = total
                            realCurrentAverage = average
                        } else {
                            realPreviousTotal = total
                            realPreviousAverage = average
                        }

                        for (let i = 0; i < _series.length; i++) {
                            intTotal = _series[i].total

                            txtLabel = _series[i].label

                            switch (msg.properties.dateMode) {
                                case "month":
                                    txtLabel = moment().month(parseInt(txtLabel) - 1).format("MMM")
                                    break
                                case "week":
                                     txtLabel = "Week " + txtLabel
                                    break
                                case "day":
                                    let _dateMoment = moment(txtLabel)
                                    let _date = _dateMoment.date()
                                    let _dayName = _dateMoment.format('ddd')

                                    if (msg.modelId == "ThisWeekTrendChart" || msg.modelId == "RecentTrendChart") {
                                        txtLabel = _dayName
                                    } else if (msg.modelId == "ThisMonthTrendChart") {
                                        txtLabel = _date
                                    } else {
                                        txtLabel = _date  + "-" + _dayName
                                    }
                                    break
                            }

                            if (_isCurrent) {
                                arrCurrentLabels.push(txtLabel)
                            } else {
                                arrPreviousLabels.push(txtLabel)
                            }
                            arrData.push(Math.round(intTotal * 100) / 100)
                            arrAvg.push(average)
                        }

                        datasets = {
                            hasData: _hasData,
                            fillColor: "rgba(220,220,220,0.5)",
                            strokeColor: "rgba(220,220,220,1)",
                            pointColor: _hasData ? "rgba(220,220,220,1)" : "transparent",
                            pointStrokeColor: _hasData ? "#ffffff" : "transparent",
                            data: arrData
                        }

                        arrDatasets.push(datasets)

                        averageDataset = {
                            hasData: _hasData,
                            fillColor: "transparent",
                            strokeColor: _hasData ? _isCurrent ? "lightsalmon" : "green" : "transparent",
                            pointColor: "transparent",
                            pointStrokeColor: "transparent",
                            data: arrAvg
                        }

                        arrDatasets.push(averageDataset)
                    }

                    chartData = {
                        labels: arrCurrentLabels
                        , currentLabels: arrCurrentLabels
                        , previousLabels: arrPreviousLabels
                        , currentTotal: realCurrentTotal
                        , previousTotal: realPreviousTotal
                        , currentAverage: realCurrentAverage
                        , previousAverage: realPreviousAverage
                        , datasets: arrDatasets
                    }

                    break
                case "PIE":
                    total = 0

                    for (i = 0; i < msg.properties.data.length; i++) {
                            total = total + msg.properties.data[i].value
                    }


                    for (i = 0; i < msg.properties.data.length; i++) {
                        datasets = {
                            value: msg.properties.data[i].value
                            ,color: msg.properties.data[i].color
                            ,category: msg.properties.data[i].category
                            ,percentage: Math.round(((msg.properties.data[i].value / total) * 100) * 100) / 100
                        }

                        arrDatasets.push(datasets)
                    }

                    chartData = arrDatasets

                    break
                }
            } else {
                chartData = null
            }

            result = chartData

            break
    }

    if (msg.model) {
        msg.model.sync() // updates the changes to the list
        msg.model.clear() //clear model after sync to remove from memory (assumption only :))
    }

    WorkerScript.sendMessage({
                                 modelId: msg.modelId
                                ,result: result
                             })
}



/*Functions*/
const round = (number, decimalPlaces) => {
    const factorOfTen = Math.pow(10, decimalPlaces)
    return Math.round(number * factorOfTen) / factorOfTen
}

function formatValue(format, sequence, value) {
    return format.replace("%" + sequence, value)
}

function formatDateForSection(petsa, scope) {
    let engPetsa
    let defaultFormat = "ddd, MMM DD, YYYY"

    if (petsa !== null) {
        let dtPetsa = moment(petsa)
        let _tagString = ""
        let comparisonValues = getDateComparisonValues(petsa)

        switch (scope) {
            case "day":
                engPetsa = dtPetsa.format("hh:mm a")
                break
            case "week":
            case "month":
                switch (true) {
                    case dtPetsa.isSame(comparisonValues.today,'day'):
                        _tagString = "Today"
                        break
                    case dtPetsa.isSame(comparisonValues.yesterday,'day'):
                        _tagString = "Yesterday"
                        break
                    case dtPetsa.isSame(comparisonValues.tomorrow,'day'):
                        _tagString = "Tomorrow"
                        break
                }

                if (dtPetsa.isSameOrBefore(comparisonValues.endOfLastYear, 'day')
                        || dtPetsa.isAfter(comparisonValues.endOfThisYear, 'day')) {
                    engPetsa = dtPetsa.format("ddd, MMM DD, YYYY")
                } else {
                    if (_tagString) {
                        engPetsa = ("%1 (%2)").arg(dtPetsa.format("ddd, MMM DD")).arg(_tagString)
                    } else {
                        engPetsa = dtPetsa.format("ddd, MMM DD")
                    }
                }
                break
            default:
                engPetsa = dtPetsa.format(defaultFormat)
        }
    }

    return engPetsa
}

function formatDateForItem(petsa, scope, sort) {
    let engPetsa
    let defaultFormat = "ddd, MMM DD, YYYY"

    if (petsa !== null) {
        let dtPetsa = moment(petsa)
        let _tagString = ""
        let comparisonValues = getDateComparisonValues(petsa)

        switch (scope) {
            case "day":
                engPetsa = dtPetsa.format("hh:mm a")
                break
            case "week":
            case "month":
                switch (true) {
                    case dtPetsa.isSame(comparisonValues.today,'day'):
                        _tagString = "Today"
                        break
                    case dtPetsa.isSame(comparisonValues.yesterday,'day'):
                        _tagString = "Yesterday"
                        break
                    case dtPetsa.isSame(comparisonValues.tomorrow,'day'):
                        _tagString = "Tomorrow"
                        break
                }

                if (sort == "date") {
                    engPetsa = dtPetsa.format("hh:mm a")
                } else {
                    if (dtPetsa.isSameOrBefore(comparisonValues.endOfLastYear, 'day')
                            || dtPetsa.isAfter(comparisonValues.endOfThisYear, 'day')) {
                        engPetsa = dtPetsa.format("ddd, MMM DD, YYYY")
                    } else {
                        if (_tagString) {
                            engPetsa = ("%1 (%2)").arg(dtPetsa.format("ddd, MMM DD")).arg(_tagString)
                        } else {
                            engPetsa = dtPetsa.format("ddd, MMM DD")
                        }
                    }
                }
                break
            default:
                engPetsa = dtPetsa.format(defaultFormat)
        }
    }

    return engPetsa
}

//Converts dates into user friendly format when necessary
function relativeDate(petsa, format, mode){
    if(petsa !== null){
        var dtPetsa
        var engPetsa
    
        dtPetsa = moment(petsa)
    
        var comparisonValues = getDateComparisonValues(petsa)
    
    
        switch(true){
        case dtPetsa.isSame(comparisonValues.today,'day'):
            engPetsa = "Today"
            break
        case dtPetsa.isSame(comparisonValues.yesterday,'day'):
            engPetsa = "Yesterday"
            break
        case dtPetsa.isSame(comparisonValues.tomorrow,'day'):
            engPetsa = "Tomorrow"
            break
        case dtPetsa.isBetween(comparisonValues.thisWeekFirstDay,comparisonValues.thisWeekLastDay,'day',[]) && mode === "Advanced":
            engPetsa = "On " + dtPetsa.format("dddd")
            break
        case dtPetsa.isBetween(comparisonValues.lastWeekFirstDay,comparisonValues.lastWeekLastDay,'day',[]) && mode === "Advanced":
            engPetsa = "Last Week"
            break
        case dtPetsa.isBetween(comparisonValues.nextWeekFirstDay,comparisonValues.nextWeekLastDay,'day',[]) && mode === "Advanced":
            engPetsa = "Next Week"
            break
        case dtPetsa.isBetween(comparisonValues.lastMonthFirstDay,comparisonValues.lastMonthLastDay,'day',[]) && mode === "Advanced":
            engPetsa = "Last Month"
            break
        case dtPetsa.isBetween(comparisonValues.nextMonthFirstDay,comparisonValues.nextMonthLastDay,'day',[]) && mode === "Advanced":
            engPetsa = "Next Month"
            break
        case dtPetsa.isBetween(comparisonValues.thisMonthFirstDay,comparisonValues.thisMonthLastDay,'day',[]) && mode === "Advanced":
            engPetsa = "This Month"
            break
        case dtPetsa.isSameOrBefore(comparisonValues.lastMonthFirstDay,'day') && mode === "Advanced":
            engPetsa = "Older"
            break
        case dtPetsa.isSameOrAfter(comparisonValues.nextMonthLastDay,'day') && mode === "Advanced":
            engPetsa = "In The Future"
            break
        default:
            engPetsa = Qt.formatDate(petsa,format)
            break
        }
    }
    return engPetsa
}

//Gets date values for use in evaluating dates
function getDateComparisonValues(){
    var today
    var yesterday
    var tomorrow
    var lastWeekFirstDay
    var lastWeekLastDay
    var lastMonthFirstDay
    var lastMonthLastDay
    var nextWeekFirstDay
    var nextWeekLastDay
    var nextMonthFirstDay
    var nextMonthLastDay
    var thisMonthFirstDay
    var thisMonthLastDay
    var thisWeekFirstDay
    var thisWeekLastDay
    var sevenDaysago
    var startOfThisYear
    var endOfThisYear
    var endOfLastYear
    var result = []

    today = moment()
    yesterday = moment().subtract(1, 'day')
    tomorrow = moment().add(1, 'day')

        lastWeekFirstDay = moment().subtract(1, 'week').startOf('week')
        lastWeekLastDay = moment().subtract(1, 'week').endOf('week')
        lastMonthFirstDay = moment().subtract(1, 'month').startOf('month')
        lastMonthLastDay = moment().subtract(1, 'month').endOf('month')
        nextWeekFirstDay = moment().add(1, 'week').startOf('week')
        nextWeekLastDay = moment().add(1, 'week').endOf('week')
        nextMonthFirstDay = moment().add(1, 'month').startOf('month')
        nextMonthLastDay = moment().add(1, 'month').endOf('month')
        thisMonthFirstDay = moment().startOf('month')
        thisMonthLastDay = moment().endOf('month')
        thisWeekFirstDay = moment().startOf('week')
        thisWeekLastDay = moment().endOf('week')
        sevenDaysago = moment().subtract(7, 'day')
        endOfLastYear = moment().subtract(1, 'year').endOf('year')
        startOfThisYear = moment().startOf('year')
        endOfThisYear = moment().endOf('year')

    result = {
        today: today,
        yesterday: yesterday,
        tomorrow: tomorrow,
        lastWeekFirstDay: lastWeekFirstDay,
        lastWeekLastDay: lastWeekLastDay,
        lastMonthFirstDay: lastMonthFirstDay,
        lastMonthLastDay: lastMonthLastDay,
        nextWeekFirstDay: nextWeekFirstDay,
        nextWeekLastDay: nextWeekLastDay,
        nextMonthFirstDay: nextMonthFirstDay,
        nextMonthLastDay: nextMonthLastDay,
        thisMonthFirstDay: thisMonthFirstDay,
        thisMonthLastDay: thisMonthLastDay,
        thisWeekFirstDay: thisWeekFirstDay,
        thisWeekLastDay: thisWeekLastDay,
        sevenDaysago: sevenDaysago,
        startOfThisYear: startOfThisYear,
        endOfThisYear: endOfThisYear,
        endOfLastYear: endOfLastYear
    }

    return result;

}
