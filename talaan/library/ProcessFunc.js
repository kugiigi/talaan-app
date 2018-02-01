.import "../library/moment.js"  as Moment

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

function getToday() {
    //get current date
    var today = new Date()
    var dd = today.getDate()
    var mm = today.getMonth() + 1 //January is 0!
    var yyyy = today.getFullYear()

    if (dd < 10) {
        dd = '0' + dd
    }

    if (mm < 10) {
        mm = '0' + mm
    }

    today = yyyy + '/' + mm + '/' + dd

    return today.toString()
}


//convert to english format and make history specific labels such as Today and Yesterday
function historyDate(petsa){
if(petsa !== null){
    var today
    var yesterday
    var tomorrow
    var dtPetsa
    var engPetsa

    dtPetsa = new Date(dateFormat(1,petsa));

    today = new Date(getToday())

    yesterday = new Date(getToday());
    yesterday.setDate(yesterday.getDate()-1);

    tomorrow = new Date(getToday());
    tomorrow.setDate(tomorrow.getDate()+1);

//+ should be used as a prefix to correctly use === when comparing dates
    if(+dtPetsa === +today){
     engPetsa = "Today"

    }else if(+dtPetsa === +yesterday){
       engPetsa = "Yesterday"
    }else if(+dtPetsa === +tomorrow){
        engPetsa = "Tomorrow"
     }else{
        engPetsa = dateFormat(2,petsa);
    }

}
return engPetsa
}


//Converts dates into user friendly format when necessary
function relativeDate(petsa, format, mode){
if(petsa !== null){
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
    var dtPetsa
    var engPetsa

    dtPetsa = Moment.moment(petsa)

    today = Moment.moment()
    yesterday = Moment.moment().subtract(1, 'day')
    tomorrow = Moment.moment().add(1, 'day')

//    WORKAROUND: add/minus one day until isBetween inclusivity is supported in the version of moment.js used.
    lastWeekFirstDay = Moment.moment().subtract(1, 'week').startOf('week')//.subtract(1,'day')
    lastWeekLastDay = Moment.moment().subtract(1, 'week').endOf('week')//.add(1,'day')
    lastMonthFirstDay = Moment.moment().subtract(1, 'month').startOf('month')//.subtract(1,'day')
    lastMonthLastDay = Moment.moment().subtract(1, 'month').endOf('month')//.add(1,'day')
    nextWeekFirstDay = Moment.moment().add(1, 'week').startOf('week')//.subtract(1,'day')
    nextWeekLastDay = Moment.moment().add(1, 'week').endOf('week')//.add(1,'day')
    nextMonthFirstDay = Moment.moment().add(1, 'month').startOf('month')//.subtract(1,'day')
    nextMonthLastDay = Moment.moment().add(1, 'month').endOf('month')//.add(1,'day')
    thisMonthFirstDay = Moment.moment().startOf('month')
    thisMonthLastDay = Moment.moment().endOf('month')
    thisWeekFirstDay = Moment.moment().startOf('week')
    thisWeekLastDay = Moment.moment().endOf('week')

    //console.log(dtPetsa + " - " + yesterday)
    switch(true){
    case dtPetsa.isSame(today,'day'):
        engPetsa = i18n.tr("Today")
        break
    case dtPetsa.isSame(yesterday,'day'):
        engPetsa = i18n.tr("Yesterday")
        break
    case dtPetsa.isSame(tomorrow,'day'):
        engPetsa = i18n.tr("Tomorrow")
        break
    case dtPetsa.isBetween(thisWeekFirstDay,thisWeekLastDay,'day',[]) && mode === "Advanced":
        engPetsa = i18n.tr("On ") + dtPetsa.format("dddd")
        break
    case dtPetsa.isBetween(lastWeekFirstDay,lastWeekLastDay,'day',[]) && mode === "Advanced":
        engPetsa = i18n.tr("Last Week")
        break
    case dtPetsa.isBetween(nextWeekFirstDay,nextWeekLastDay,'day',[]) && mode === "Advanced":
        engPetsa = i18n.tr("Next Week")
        break
    case dtPetsa.isBetween(lastMonthFirstDay,lastMonthLastDay,'day',[]) && mode === "Advanced":
        engPetsa = i18n.tr("Last Month")
        break
    case dtPetsa.isBetween(nextMonthFirstDay,nextMonthLastDay,'day',[]) && mode === "Advanced":
        engPetsa = i18n.tr("Next Month")
        break
    case dtPetsa.isBetween(thisMonthFirstDay,thisMonthLastDay,'day',[]) && mode === "Advanced":
        engPetsa = i18n.tr("This Month")
        break
    case dtPetsa.isSameOrBefore(lastMonthFirstDay,'day') && mode === "Advanced":
        engPetsa = i18n.tr("Older")
        break
    case dtPetsa.isSameOrAfter(nextMonthLastDay,'day') && mode === "Advanced":
        engPetsa = i18n.tr("In The Future")
        break
    default:
        engPetsa = Qt.formatDate(petsa,format)
        break
    }
}
return engPetsa
}

//format date for database insertion
function dateFormat(intMode, petsa) {

    var txtPetsa = ""
    var txtYear = ""
    var txtDay = ""
    var txtMonth = ""
    var txtHour = ""
    var txtMinute = ""
    var txtSecond = ""

    switch (intMode) {
    case 0:

        //Date to string for database
        txtDay = String(petsa.getDate())
        txtMonth = String(petsa.getMonth() + 1) //Months are zero based
        if (txtMonth.length === 1) {
            txtMonth = "0" + txtMonth
        }

        if (txtDay.length === 1) {
            txtDay = "0" + txtDay
        }

        txtYear = petsa.getFullYear()
        txtHour = "00" //petsa.getHours();
        txtMinute = "00" //petsa.getMinutes();
        txtSecond = "00" //petsa.getSeconds();
        txtPetsa = txtYear + "-" + txtMonth + "-" + txtDay + " " + txtHour + ":"
                + txtMinute + ":" + txtSecond + ".000"
        break
    case 1:
        //from database date to string for datepicker
        txtYear = petsa.substr(0, 4)
        txtMonth = petsa.substr(5, 2)
        txtDay = petsa.substr(8, 2)
        txtPetsa = txtYear + "/" + txtMonth + "/" + txtDay
        break
    case 2:
        //from database date to english format
        txtYear = petsa.substr(0, 4)
        txtMonth = petsa.substr(5, 2)
        txtDay = petsa.substr(8, 2)
        txtPetsa = getMonthName(
                    parseInt(txtMonth) - 1) + " " + txtDay + ", " + txtYear
        break
    }

    return txtPetsa.toString()
}

function getMonthName(intMonth) {
    var month = []
    month[0] = "January"
    month[1] = "February"
    month[2] = "March"
    month[3] = "April"
    month[4] = "May"
    month[5] = "June"
    month[6] = "July"
    month[7] = "August"
    month[8] = "September"
    month[9] = "October"
    month[10] = "November"
    month[11] = "December"

    return month[intMonth]
}

function getDayName(intDay) {
    var weekday = new Array(7)
    weekday[0] = "Sunday"
    weekday[1] = "Monday"
    weekday[2] = "Tuesday"
    weekday[3] = "Wednesday"
    weekday[4] = "Thursday"
    weekday[5] = "Friday"
    weekday[6] = "Saturday"

    return weekday[intDay]
}

function getCurrencySymbol(txtCurrency) {
    var txtSymbol = ""

    switch (txtCurrency) {
    case "US Dollar":
        txtSymbol = "$"
        break
    case "Philippines Peso":
        txtSymbol = "₱"
        break
    case "Euro":
        txtSymbol = "€"
        break
    case "Japan Yen":
        txtSymbol = "¥"
        break
    case "Korea Won":
        txtSymbol = "₩"
        break
    case "Indonesia Rupiah":
        txtSymbol = "Rp"
        break
    default:
        txtSymbol = "$"
        break
    }

    return txtSymbol
}

Date.prototype.addHours = function(h) {
   this.setTime(this.getTime() + (h*60*60*1000));
   return this;
}

Date.prototype.subtractHours = function(h) {
   this.setTime(this.getTime() - (h*60*60*1000));
   return this;
}

Date.prototype.addDays = function (days) //function to add days to a date
{
    var dat = new Date(this.valueOf())
    dat.setDate(dat.getDate() + days)
    return dat
}

Date.prototype.subtractDays = function (days) //function to add days to a date
{
    var dat = new Date(this.valueOf())
    dat.setDate(dat.getDate() - days)
    return dat
}

Date.prototype.addWeeks = function(h) {
   this.setDate(this.getDate() + (7 * h));
   return this;
}

Date.prototype.subtractWeeks = function(h) {
   this.setDate(this.getDate() - (7 * h));
   return this;
}

Date.prototype.addMonths = function (month) //function to add month to a date
{
    var dat = new Date(this.valueOf())
    dat.setMonth(dat.getMonth() + month)
    return dat
}

Date.prototype.subtractMonths = function (month) //function to subtract month to a date
{
    var dat = new Date(this.valueOf())
    dat.setMonth(dat.getMonth() - month)
    return dat
}

function moveDate(mode, dateCode, txtdate) {

    dateCode = dateCode.replace('?', '') //to disregard specific or defaults
    txtdate = dateFormat(1, txtdate) //convert from database date to proper date
    var newDate = new Date(txtdate)

    if (mode === "previous") {
        switch (dateCode) {
        case "week":
            newDate = newDate.subtractDays(7)
            break
        case "day":
            newDate = newDate.subtractDays(1)
            break
        case "month":
            newDate = newDate.subtractMonths(1)
            break
        }
    } else if (mode === "next") {
        switch (dateCode) {
        case "week":
            newDate = newDate.addDays(7)
            break
        case "day":
            newDate = newDate.addDays(1)
            break
        case "month":
            newDate = newDate.addMonths(1)
            break
        }
    }

    return dateFormat(0, newDate)
}

//delay execution
function sleep(milliseconds) {
    var start = new Date().getTime()
    for (var i = 0; i < 1e7; i++) {
        if ((new Date().getTime() - start) > milliseconds) {
            break
        }
    }
}

Number.prototype.formatMoney = function (c, d, t) {
    var n = this, c = isNaN(
                c = Math.abs(
                    c)) ? 2 : c, d = d == undefined ? "." : d, t = t == undefined ? "," : t, s = n < 0 ? "-" : "", i = parseInt(n = Math.abs(+n || 0).toFixed(c)) + "", j = (j = i.length) > 3 ? j % 3 : 0
    return s + (j ? i.substr(0, j) + t : "") + i.substr(j).replace(
                /(\d{3})(?=\d)/g,
                "$1" + t) + (c ? d + Math.abs(n - i).toFixed(c).slice(2) : "")
}

function getTranslation(txtWord, txtLanguage) {
    var txtTranslated

    if (txtLanguage === "English") {
        switch (txtWord) {
        case "Gastos":
            txtTranslated = "Expense"
            break
        case "Kita":
            txtTranslated = "Income"
            break
        case "Utang":
            txtTranslated = "Debt"
            break
        case "Expense":
            txtTranslated = "Gastos"
            break
        case "Income":
            txtTranslated = "Kita"
            break
        case "Debt":
            txtTranslated = "Utang"
            break
        }
    } else if (txtLanguage === "German") {
        switch (txtWord) {
        case "Gastos":
            txtTranslated = "Ausgabe"
            break
        case "Kita":
            txtTranslated = "Einkommen"
            break
        case "Utang":
            txtTranslated = "Schuld"
            break
        case "Ausgabe":
            txtTranslated = "Gastos"
            break
        case "Einkommen":
            txtTranslated = "Kita"
            break
        case "Schuld":
            txtTranslated = "Utang"
            break
        }
    } else {
        txtTranslated = txtWord
    }

    return txtTranslated
}

function checkRequired(arrValues) {
    var boolPass = true;

    for (var i = 0; i < arrValues.length; i++) {
        if (arrValues[i].trim() === "") {
            boolPass = false;
        }
    }
    return boolPass
}
