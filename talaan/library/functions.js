.import "external/moment.mjs" as Moment
.import "external/accounting.js" as Accounting
.import "Currencies.js" as Currencies

const moment = Moment.mom();

String.prototype.replaceAt = function (index, character) {
    return this.substr(0, index) + character + this.substr(index + 1)
}

String.prototype.bindValues = function (charBind, arrValues) {
    var intCurSearchIndex = 0
    var intCurIndex
    var txtNewString = this

    for (var i = 0; i < arrValues.length; i++) {
        intCurIndex = txtNewString.indexOf(charBind, 0)
        txtNewString = txtNewString.replaceAt(intCurIndex, arrValues[i])
    }
    return txtNewString
}


function elideText(inputText, charLimit) {
    let elideString = "..."
    charLimit = charLimit ? charLimit : 20
    let returnValue = inputText

    if (returnValue.length > charLimit) {
        returnValue = returnValue.substring(0, charLimit) + elideString
    }

    return returnValue
}

function elideMidText(inputText, charLimit) {
    let elideString = "..."
    charLimit = charLimit ? charLimit : 20
    let returnValue = inputText

    if (returnValue.length > charLimit) {
        let sideCharLimit = Math.floor((charLimit - elideString.length) / 2)
        let extraFirstChar = (charLimit - elideString.length) % 2
        let firstChars = returnValue.substring(0, sideCharLimit + extraFirstChar)
        let lastChars = returnValue.substring(returnValue.length - sideCharLimit)
        returnValue = firstChars + elideString + lastChars
    }

    return returnValue
}

function bulletText(inputText, customBullet) {
    let bulletChar = customBullet ? customBullet : "•"

    return "%1 %2".arg(bulletChar).arg(inputText)
}

function bulletTextArray(inputTextArray, customBullet) {
    let bulletChar = customBullet ? customBullet : "•"

    return bulletText(inputTextArray.join("%1%2 ".arg("\n").arg(bulletChar)), customBullet)
}

function scrollToView(item, flickable, topMargin=0,  bottomMargin=0) {
    let _mappedY
    let _itemHeightY
    let _currentViewport
    let _intendedContentY
    let _maxContentY

    _mappedY = item.mapToItem(flickable.contentItem, 0, 0).y
    _itemHeightY = _mappedY + item.height
    _currentViewport = flickable.contentY - flickable.originY + flickable.height - flickable.bottomMargin + flickable.topMargin

    //~ console.log("_mappedY: " + _mappedY)
    //~ console.log("_itemHeightY: " + _itemHeightY)
    //~ console.log("_currentViewport: " + _currentViewport)
    if (_itemHeightY > _currentViewport) {
        _maxContentY = flickable.contentHeight - flickable.height + flickable.bottomMargin
        _intendedContentY = _itemHeightY - flickable.height + item.height + flickable.bottomMargin + bottomMargin

        if (_intendedContentY > _maxContentY) {
            //~ console.log("maxContentY")
            flickable.contentY = _maxContentY
        } else {
            //~ console.log("intendedContentY")
            flickable.contentY = _intendedContentY
        }
    } else if (_mappedY < flickable.contentY) {
        //~ console.log("compute")
        flickable.contentY = _mappedY - topMargin - flickable.topMargin
    }

    //~ console.log("Final:" + flickable.contentY)
}

function round_number(num, dec) {
    return Math.round(num * Math.pow(10, dec)) / Math.pow(10, dec);
}

function formatToPercentage(value) {
    return i18n.tr("%1 %2").arg(round_number(value * 100, 2)).arg("%")
}

function formatDateForDB(petsa) {
    return formatDate(petsa, "YYYY-MM-DD HH:mm:ss.SSS")
}

function formatDate(petsa, format) {
    return moment(petsa).format(format)
}

function getUTCToday() {
    //get current date
    var today = moment.utc(new Date()).format("YYYY-MM-DD HH:mm:ss.SSS")

    return today.toString()
}

function getToday() {
    //get current date
    var today = moment(new Date()).format("YYYY-MM-DD HH:mm:ss.SSS")

    return today.toString()
}

function convertDBToDate(petsa) {
    return moment(petsa, "YYYY-MM-DD HH:mm:ss.SSS").toDate();
}

function isToday(petsa) {
    let dtPetsa = moment(petsa)
    let today = moment(new Date())

    return dtPetsa.isSame(today,'day')
}

function isThisWeek(petsa) {
    let dtPetsa = moment(petsa)
    let thisWeekStart = moment(new Date()).startOf("week")
    let thisWeekEnd = moment(new Date()).endOf("week")
    
    return dtPetsa.isBetween(thisWeekStart,thisWeekEnd,'day',[])
}

function isThisMonth(petsa) {
    let dtPetsa = moment(petsa)
    let thisMonthStart = moment(new Date()).startOf("month")
    let thisMonthEnd = moment(new Date()).endOf("month")

    return dtPetsa.isBetween(thisMonthStart,thisMonthEnd,'day',[])
}

function addDays(petsa, days, toDBString = false) {
    let _momentDate = moment(petsa)
    _momentDate.add(days, 'day')
    if (toDBString) {
        return _momentDate.format("YYYY-MM-DD HH:mm:ss.SSS")
    } else {
        return _momentDate.toDate()
    }
}

function addMonths(petsa, months, toDBString = false) {
    let _momentDate = moment(petsa)
    _momentDate.add(months, 'month')
    if (toDBString) {
        return _momentDate.format("YYYY-MM-DD HH:mm:ss.SSS")
    } else {
        return _momentDate.toDate()
    }
}

function cleanExpenseValue(value) {
    return value.replace(/,/g, "")
}

function checkIfWithinDateRange(inputDate, fromDate, toDate) {
    let _inputDateMom = moment(inputDate)
    let _fromDateMom = moment(fromDate)
    let _toDateMom = moment(toDate)

    return _inputDateMom.isBetween(_fromDateMom, _toDateMom,'day',[])
}

function getFirstDay(txtRange, txtDate) {
    let _date

    if (txtDate) {
        _date = moment(txtDate)
    } else {
        _date = moment()
    }

    let _result = _date

    switch (txtRange) {
        case "today":
            _result = _date
            break
        case "yesterday":
            _result = _date.subtract(1, 'day')
            break
        case "tomorrow":
            _result = _date.add(1, 'day')
            break
        case "thisweek":
            _result = _date.startOf('week')
            break
        case "lastweek":
            _result = _date.subtract(1, 'week').startOf('week')
            break
        case "nextweek":
            _result = _date.add(1, 'week').startOf('week')
            break
        case "thismonth":
            _result = _date.startOf('month')
            break
        case "lastmonth":
            _result = _date.subtract(1, 'month').startOf('month')
            break
        case "nextmonth":
            _result = _date.add(1, 'month').startOf('month')
            break
        case "thisyear":
            _result = _date.startOf('year')
            break
        case "lastyear":
            _result = _date.subtract(1, 'year').startOf('year')
            break
        case "nextyear":
            _result = _date.add(1, 'year').startOf('year')
            break
        case "recent":
            _result = _date.subtract(6, 'day')
            break
        case "previousrecent":
            _result = _date.subtract(13, 'day')
            break
        case "week":
            _result = _date.startOf('week')
            break
        case "month":
            _result = _date.startOf('month')
            break
        case "year":
            _result = _date.startOf('year')
            break
    }

    return _result.format("YYYY-MM-DD HH:mm:ss")
}

function getLastDay(txtRange, txtDate) {
    let _date

    if (txtDate) {
        _date = moment(txtDate)
    } else {
        _date = moment()
    }

    let _result = _date

    switch (txtRange) {
        case "today":
            _result = _date
            break
        case "yesterday":
            _result = _date.subtract(1, 'day')
            break
        case "tomorrow":
            _result = _date.add(1, 'day')
            break
        case "thisweek":
            _result = _date.endOf('week')
            break
        case "lastweek":
            _result = _date.subtract(1, 'week').endOf('week')
            break
        case "nextweek":
            _result = _date.add(1, 'week').endOf('week')
            break
        case "thismonth":
            _result = _date.endOf('month')
            break
        case "lastmonth":
            _result = _date.subtract(1, 'month').endOf('month')
            break
        case "nextmonth":
            _result = _date.add(1, 'month').endOf('month')
            break
        case "thisyear":
            _result = _date.endOf('year')
            break
        case "lastyear":
            _result = _date.subtract(1, 'year').endOf('year')
            break
        case "nextyear":
            _result = _date.add(1, 'year').endOf('year')
            break
        case "recent":
            _result = _date
            break
        case "previousrecent":
            _result = _date.subtract(7, 'day')
            break
        case "week":
            _result = _date.endOf('week')
            break
        case "month":
            _result = _date.endOf('month')
            break
        case "year":
            _result = _date.endOf('year')
            break
    }

    return _result.format("YYYY-MM-DD HH:mm:ss")
}

function formatMoney(value, currency, options) {
    var formattedMoney

    var finalOptions

    if (options) {
        finalOptions = options
    }else{
        finalOptions = Currencies.currency(currency)
    }

    formattedMoney = Accounting.accounting.formatMoney(value, finalOptions);

    return formattedMoney;
}

function relativeTime(petsa, format) {
    const defaultFormat = "ddd, MMM DD hh:mm A"
    var formatToUse = format ? format : defaultFormat
    
    if(petsa !== null){
    
        var dtPetsa
        var engPetsa
        var formattedDate
        var timeFormat = "hh:mm A"
    
        dtPetsa = moment(petsa)
    
        var comparisonValues = getDateComparisonValues(petsa)

        switch(true){
            case dtPetsa.isSame(comparisonValues.today,'day'):
                engPetsa = dtPetsa.format(timeFormat)
                break;
            case dtPetsa.isSame(comparisonValues.yesterday,'day'):
                engPetsa = i18n.tr("Yesterday") + ", " + dtPetsa.format(timeFormat)
                break;
            case dtPetsa.isBetween(comparisonValues.thisWeekFirstDay,comparisonValues.thisWeekLastDay,'day',[]):
                engPetsa = dtPetsa.format("dddd")
                break;
            case dtPetsa.isSameOrBefore(comparisonValues.endOfLastYear, 'day'):
                engPetsa = dtPetsa.format("ddd, MMM DD, YYYY hh:mm A")
                break;
            default:
                engPetsa = dtPetsa.format(formatToUse)
                break;
        }
    }
    return engPetsa
}


function formatDateForNavigation(petsa, scope) {
    let engPetsa
    let defaultFormat = "ddd, MMM DD"

    if (petsa !== null) {
        let _tagString = ""
        let dtPetsa = moment(petsa)
        let formattedDate    
        let comparisonValues = getDateComparisonValues(petsa)

        formattedDate = dtPetsa.format(defaultFormat)
        
        switch (scope) {
            case "day":
                switch (true) {
                    case dtPetsa.isSame(comparisonValues.today,'day'):
                        _tagString = i18n.tr("Today")
                        break
                    case dtPetsa.isSame(comparisonValues.yesterday,'day'):
                        _tagString = i18n.tr("Yesterday")
                        break
                    case dtPetsa.isSame(comparisonValues.tomorrow,'day'):
                        _tagString = i18n.tr("Tomorrow")
                        break
                    case dtPetsa.isSameOrBefore(comparisonValues.endOfLastYear, 'day')
                            || dtPetsa.isAfter(comparisonValues.endOfThisYear, 'day'):
                        formattedDate = dtPetsa.format("ddd, MMM DD, YYYY")
                        break
                    default:
                        formattedDate = dtPetsa.format("ddd, MMM DD")
                }
                if (_tagString) {
                    engPetsa = i18n.tr("%1 (%2)").arg(formattedDate).arg(_tagString)
                } else {
                    engPetsa = formattedDate
                }
                break
            case "week":
                let _weekStart = moment(petsa).startOf('week')
                let _weekEnd = moment(petsa).endOf('week')
                let _weekStartMonth = moment(_weekStart).startOf("month")
                let _weekEndMonth = moment(_weekEnd).startOf("month")
                let _fromString = _weekStart.format("MMM DD")
                let _toString = ""
                let _endIsSameMonth = _weekStartMonth.isSame(_weekEndMonth)

                switch (true) {
                    case _weekStart.isBetween(comparisonValues.thisWeekFirstDay,comparisonValues.thisWeekLastDay,'day',[]):
                        _tagString = i18n.tr("This Week")
                        break
                    case _weekStart.isBetween(comparisonValues.lastWeekFirstDay,comparisonValues.lastWeekLastDay,'day',[]):
                        _tagString = i18n.tr("Last Week")
                        break
                    case _weekStart.isBetween(comparisonValues.nextWeekFirstDay,comparisonValues.nextWeekLastDay,'day',[]):
                        _tagString = i18n.tr("Next Week")
                        break
                    default:
                        _tagString = ""
                }

                if (_weekEnd.isSameOrBefore(comparisonValues.endOfLastYear, 'day')
                        || _weekEnd.isAfter(comparisonValues.endOfThisYear, 'day')) {
                    if (_endIsSameMonth) {
                        _toString = _weekEnd.format("DD, YYYY")
                    } else {
                        _toString = _weekEnd.format("MMM DD, YYYY")
                    }
                } else {
                    if (_endIsSameMonth) {
                        _toString = _weekEnd.format("DD")
                    } else {
                        _toString = _weekEnd.format("MMM DD")
                    }
                }

                if (_tagString) {
                    engPetsa = i18n.tr("%1 - %2 (%3)").arg(_fromString).arg(_toString).arg(_tagString)
                } else {
                    engPetsa = i18n.tr("%1 - %2").arg(_fromString).arg(_toString)
                }

                break
            case "month":
                switch (true) {
                    case dtPetsa.isBetween(comparisonValues.lastMonthFirstDay,comparisonValues.lastMonthLastDay,'day',[]):
                        engPetsa = i18n.tr("%1 (Last Month)").arg(dtPetsa.format("MMMM"))
                        break
                    case dtPetsa.isBetween(comparisonValues.nextMonthFirstDay,comparisonValues.nextMonthLastDay,'day',[]):
                        engPetsa = i18n.tr("%1 (Next Month)").arg(dtPetsa.format("MMMM"))
                        break
                    case dtPetsa.isBetween(comparisonValues.thisMonthFirstDay,comparisonValues.thisMonthLastDay,'day',[]):
                        engPetsa = i18n.tr("%1 (This Month)").arg(dtPetsa.format("MMMM"))
                        break
                    case dtPetsa.isSameOrBefore(comparisonValues.endOfLastYear, 'day')
                                || dtPetsa.isAfter(comparisonValues.endOfThisYear, 'day'):
                        engPetsa = dtPetsa.format("MMMM YYYY")
                        break
                    default:
                        engPetsa = dtPetsa.format("MMMM")
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
    var defaultFormat = "ddd, MMM DD"
    var formatToUse = format ? format : defaultFormat

    if(petsa !== null){
    
        var dtPetsa
        var engPetsa
        var formattedDate
    
        dtPetsa = moment(petsa)
    
        var comparisonValues = getDateComparisonValues(petsa)
        formattedDate = " - " + dtPetsa.format(formatToUse)

        switch(true){
            case dtPetsa.isSame(comparisonValues.today,'day'):
                engPetsa = i18n.tr("Today") + formattedDate
                break
            case dtPetsa.isSame(comparisonValues.yesterday,'day'):
                engPetsa = i18n.tr("Yesterday") + formattedDate
                break
            case dtPetsa.isSame(comparisonValues.tomorrow,'day'):
                engPetsa = i18n.tr("Tomorrow") + formattedDate
                break
            case dtPetsa.isBetween(comparisonValues.thisWeekFirstDay,comparisonValues.thisWeekLastDay,'day',[]) && mode === "Advanced":
                engPetsa = i18n.tr("On ") + dtPetsa.format("dddd")
                break
            case dtPetsa.isBetween(comparisonValues.lastWeekFirstDay,comparisonValues.lastWeekLastDay,'day',[]) && mode === "Advanced":
                engPetsa = i18n.tr("Last Week")
                break
            case dtPetsa.isBetween(comparisonValues.nextWeekFirstDay,comparisonValues.nextWeekLastDay,'day',[]) && mode === "Advanced":
                engPetsa = i18n.tr("Next Week")
                break
            case dtPetsa.isBetween(comparisonValues.lastMonthFirstDay,comparisonValues.lastMonthLastDay,'day',[]) && mode === "Advanced":
                engPetsa = i18n.tr("Last Month")
                break
            case dtPetsa.isBetween(comparisonValues.nextMonthFirstDay,comparisonValues.nextMonthLastDay,'day',[]) && mode === "Advanced":
                engPetsa = i18n.tr("Next Month")
                break
            case dtPetsa.isBetween(comparisonValues.thisMonthFirstDay,comparisonValues.thisMonthLastDay,'day',[]) && mode === "Advanced":
                engPetsa = i18n.tr("This Month")
                break
            case dtPetsa.isSameOrBefore(comparisonValues.lastMonthFirstDay,'day') && mode === "Advanced":
                engPetsa = i18n.tr("Older")
                break
            case dtPetsa.isSameOrAfter(comparisonValues.nextMonthLastDay,'day') && mode === "Advanced":
                engPetsa = i18n.tr("In The Future")
                break
            case dtPetsa.isSameOrBefore(comparisonValues.endOfLastYear, 'day'):
                engPetsa = dtPetsa.format("ddd, MMM DD, YYYY")
                break;
            default:
                engPetsa = dtPetsa.format(formatToUse)
                break
        }
    }
    return engPetsa
}

//Group expenses by date
function groupDate(petsa){
    if(petsa !== null){
        var dtPetsa
        var engPetsa = []
        var result
    
        dtPetsa = moment(petsa)
    
        var comparisonValues = getDateComparisonValues(petsa)
    
    
        if(dtPetsa.isSame(comparisonValues.today,'day')){
            engPetsa.push("Today")
        }
        if(dtPetsa.isSame(comparisonValues.yesterday,'day')){
            engPetsa.push("Yesterday")
        }
        if(dtPetsa.isBetween(comparisonValues.thisWeekFirstDay,comparisonValues.thisWeekLastDay,'day',[])){
            engPetsa.push("This Week")
        }
        if(dtPetsa.isBetween(comparisonValues.lastWeekFirstDay,comparisonValues.lastWeekLastDay,'day',[])){
            engPetsa.push("Last Week")
        }
        if(dtPetsa.isBetween(comparisonValues.nextWeekFirstDay,comparisonValues.nextWeekLastDay,'day',[])){
            engPetsa.push("Next Week")
        }
        if(dtPetsa.isBetween(comparisonValues.lastMonthFirstDay,comparisonValues.lastMonthLastDay,'day',[])){
            engPetsa.push("Last Month")
        }
        if(dtPetsa.isBetween(comparisonValues.thisMonthFirstDay,comparisonValues.thisMonthLastDay,'day',[])){
            engPetsa.push("This Month")
        }
        if(dtPetsa.isBetween(comparisonValues.sevenDaysago,comparisonValues.today,'day',[])){
            engPetsa.push("Recent")
        }
    
        result = engPetsa.join(";")
    }
    return result
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

function formatDateCalendar(date) {
    var format = "ddd, MMM D"
    var format2 = "ddd, MMM D, YYYY"
    var currentYear = moment().format("YYYY")
    var result

    if( moment(date).format("YYYY") === currentYear){
        result = moment(date).format(format)
    }else{
        result = moment(date).format(format2)
    }

    return result
}

function getDateComparisonValuesFormat() {

    var format = "ddd, MMM D"
    var format2 = "ddd, MMM D, YYYY"
    var currentYear = moment().format("YYYY")

    var comparisonValues = getDateComparisonValues()
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
    var result = []


    today = moment(comparisonValues.today).format(format)
    if( moment(comparisonValues.yesterday).format("YYYY") === currentYear){
        yesterday = moment(comparisonValues.yesterday).format(format)
    }else{
        yesterday = moment(comparisonValues.yesterday).format(format2)
    }

    tomorrow = moment(comparisonValues.tomorrow).format(format)

    if( moment(comparisonValues.lastWeekFirstDay).format("YYYY") === currentYear){
        lastWeekFirstDay = moment(comparisonValues.lastWeekFirstDay).format(format)
    }else{
        lastWeekFirstDay = moment(comparisonValues.lastWeekFirstDay).format(format2)
    }

    if( moment(comparisonValues.lastWeekLastDay).format("YYYY") === currentYear){
        lastWeekLastDay = moment(comparisonValues.lastWeekLastDay).format(format)
    }else{
        lastWeekLastDay = moment(comparisonValues.lastWeekLastDay).format(format2)
    }

    if( moment(comparisonValues.lastMonthFirstDay).format("YYYY") === currentYear){
        lastMonthFirstDay = moment(comparisonValues.lastMonthFirstDay).format(format)
    }else{
        lastMonthFirstDay = moment(comparisonValues.lastMonthFirstDay).format(format2)
    }

    if( moment(comparisonValues.lastMonthLastDay).format("YYYY") === currentYear){
        lastMonthLastDay = moment(comparisonValues.lastMonthLastDay).format(format)
    }else{
        lastMonthLastDay = moment(comparisonValues.lastMonthLastDay).format(format2)
    }

    nextWeekFirstDay = moment(comparisonValues.nextWeekFirstDay).format(format)
    nextWeekLastDay = moment(comparisonValues.nextWeekLastDay).format(format)
    nextMonthFirstDay = moment(comparisonValues.nextMonthFirstDay).format(format)
    nextMonthLastDay = moment(comparisonValues.nextMonthLastDay).format(format)

    thisMonthFirstDay = moment(comparisonValues.thisMonthFirstDay).format(format)
    thisMonthLastDay = moment(comparisonValues.thisMonthLastDay).format(format)

    if( moment(comparisonValues.thisWeekFirstDay).format("YYYY") === currentYear){
        thisWeekFirstDay = moment(comparisonValues.thisWeekFirstDay).format(format)
    }else{
        thisWeekFirstDay = moment(comparisonValues.thisWeekFirstDay).format(format2)
    }

    if( moment(comparisonValues.thisWeekLastDay).format("YYYY") === currentYear){
        thisWeekLastDay = moment(comparisonValues.thisWeekLastDay).format(format)
    }else{
        thisWeekLastDay = moment(comparisonValues.thisWeekLastDay).format(format2)
    }

    if( moment(comparisonValues.sevenDaysago).format("YYYY") === currentYear){
        sevenDaysago = moment(comparisonValues.sevenDaysago).format(format)
    }else{
        sevenDaysago = moment(comparisonValues.sevenDaysago).format(format2)
    }


    result ={
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
                    sevenDaysago: sevenDaysago
                }

    return result;

}

function getNextDate(calendarMode, date) {

    var newDate = moment(date)

    switch(calendarMode){
    case "day":
        newDate.add(1, 'day')
        break
    case "week":
        newDate.add(1, 'week')
        break
    case "month":
        newDate.add(1, 'month')
        break
    case "custom":
        newDate.add(1, 'day')
        break
    }

    return newDate.format("YYYY-MM-DD HH:mm:ss.SSS")
}

function getPreviousDate(calendarMode, date) {

    var newDate = moment(date)

    switch(calendarMode){
    case "day":
        newDate.subtract(1, 'day')
        break
    case "week":
        newDate.subtract(1, 'week')
        break
    case "month":
        newDate.subtract(1, 'month')
        break
    case "custom":
        newDate.subtract(1, 'day')
        break
    }

    return newDate.format("YYYY-MM-DD HH:mm:ss.SSS")
}
