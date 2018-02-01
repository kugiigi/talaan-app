.import QtQuick.LocalStorage 2.0 as Sql
.import "../common/ProcessFunc.js" as Process
.import "../common/MetaData.js" as MetaProcess

//property var db: null
    //var db = null;
function openDB() {
    var db  = null;
    if(db !== null) return;

    // db = LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
    db = Sql.LocalStorage.openDatabaseSync("tagatuos-app", "0.1", "your personal accountant", 100000);
    return db;
        }

function loadSetting(txtSettingsCode){
    var db = openDB();
    var rs = null;
    var txtSettingsValue = ""

    db.transaction(function(tx){
    rs = tx.executeSql('SELECT value from settings where id = ? ', [txtSettingsCode]);
    txtSettingsValue = rs.rows.item(0).value;
    });

    return txtSettingsValue;
}

function saveSetting(txtSettingsCode,txtSettingsValue){
    var db = openDB();
    var rs = null;

    db.transaction(function(tx){
    tx.executeSql('UPDATE settings SET value = ? WHERE id = ?', [txtSettingsValue,txtSettingsCode]);
    });

}

function getStatus(txtCategory)//function to get the category's availbale statuses
{
    var db = openDB();
    var rs = null;
    var strStatus = "";
    db.transaction(function(tx){
        rs = tx.executeSql('SELECT status from category where category = ?', [txtCategory]);
        strStatus = rs.rows.item(0).status;
    });
    return strStatus
}

function setStatus(txtStatus,txtrowid)
{
    var db = openDB();
    db.transaction(function(tx){
        tx.executeSql('UPDATE items SET status = ? WHERE ROWID = ?', [txtStatus,txtrowid]);
        //console.log("status changed!!!");
    });
}

function saveItem(category, date, descr,descrlong,value,status) {
    var db = openDB();
    if(value ==="")
    {
        value = 0.0;
    }

    db.transaction(function(tx){
        tx.executeSql('INSERT OR REPLACE INTO items VALUES(?, ?, ?, ?, ?, ?)', [category, date, descr,descrlong,value,status]);
        //console.log(category + date + descr + descrlong + value);
    });
}


function updateItem(date, descr,descrlong,value, rowid) {
    var db = openDB();
    if(value ==="")
    {
        value = 0.0;
    }

    db.transaction(function(tx){
        tx.executeSql('UPDATE items SET date = ?,descr = ?, descrlong = ?, value = ? WHERE ROWID = ?', [date, descr,descrlong,value,rowid]);
    });
}

function deleteItem(rowid)
{
    var db = openDB();

    db.transaction(function(tx){
        tx.executeSql('DELETE FROM items where ROWID = ?', [rowid]);
        //console.log("deleted!!!" + rowid) ;
    });
}

function getItems(txtmode,txtcategory,txtDate,txtSearch) {
    var db = openDB();
    var total = 0;
    var arrItems = [];
    var strWhere = "";
    var strOrder = "";
    var strSearch = "";
    var arrParameters = [];

    db.transaction(function(tx) {
        var rs = null;
        var rstotal = null;


        switch(txtmode){

        case "paid":
            strWhere = 'and status = "Paid"';
            strOrder = ' ORDER BY date, descr;';
            arrParameters = [txtcategory];
        break;

        case "unpaid":
            strWhere = 'and status = "Unpaid"';
            strOrder = ' ORDER BY date, descr;';
            arrParameters = [txtcategory];
        break;

        case "all":
            strWhere = 'ORDER BY date, descr;';
            arrParameters = [txtcategory];
        break;

        case ("day"):
        case ("day?"):
            strWhere = 'and date(date) = date(?)';
            strOrder = ' ORDER BY descr;';
            arrParameters = [txtcategory,txtDate];
        break;
        case "week":
        case "week?":
            //workaround when selected date is Sunday
            var dateNew = new Date(Process.dateFormat(1,txtDate));
            dateNew.setDate(dateNew.getDate() + 1);
            txtDate = Process.dateFormat(0,dateNew);

            strWhere = 'and date(date) between DATE(date(?), "weekday 0", "-7 days") and DATE(date(?), "weekday 0", "-1 days")';
            strOrder = ' ORDER BY date(date),descr;';
            arrParameters = [txtcategory,txtDate,txtDate];
            //strWhere = 'WHERE category = ? and date(date) > DATE(?, "weekday 0", "-7 days") ORDER BY date(date),descr;'; --> to start from Monday
        break;
        case "month":
        case "month?":
            strWhere = 'and date(date) between date(?,"start of month") and date(?,"start of month","+1 month","-1 day")';
            strOrder = ' ORDER BY date(date),descr;';
            arrParameters = [txtcategory,txtDate,txtDate];
        break;

        default:
            arrParameters = [txtcategory];
        break;
        }

        if(txtSearch){
            txtSearch = "%" + txtSearch + "%";
            strSearch = ' AND descr like ?' ;
            strWhere = strWhere + strSearch;
            arrParameters.push(txtSearch);
        }

        //console.log("paramters" + arrParameters[0] + arrParameters[1] + txtcategory);

        //Get items
        rs = tx.executeSql('SELECT *,rowid FROM items WHERE category=? ' + strWhere + strOrder, arrParameters);

        arrItems.length = rs.rows.length;
        //console.log("lenght" + rs.rows.length + 'SELECT *,rowid FROM items WHERE category=?  ' + strWhere);
        for(var i = 0; i < rs.rows.length; i++) {
           //add new row in the array
           arrItems[i] = [];

           //assigne values to the array
           arrItems[i][0] = rs.rows.item(i).category;
           arrItems[i][1] = rs.rows.item(i).date;
           arrItems[i][2] = rs.rows.item(i).descr;
           arrItems[i][3] = rs.rows.item(i).descrlong;
           arrItems[i][4] = rs.rows.item(i).value;
           arrItems[i][5] = rs.rows.item(i).status;
           arrItems[i][6] = rs.rows.item(i).rowid;
           }

         if(rs.rows.length === 0)
         {
             arrItems.length = 0;
         }

         //Get Total
         rstotal = tx.executeSql('SELECT total(value) as total FROM items WHERE category=? ' + strWhere, arrParameters);
         total = rstotal.rows.item(0).total;

    });
return {items: arrItems,
        total: total
    };
}

//function to get total for a day
function getDayTotal(txtcategory,txtDate,txtStatus)
{
     var db = openDB();
     var realTotal;


    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT total(value) as total FROM items WHERE category=? and date(date) = date(?) and status = ?;', [txtcategory,txtDate,txtStatus]);
        realTotal = rs.rows.item(0).total;
    });

    return realTotal
}

//function to retrieve all categories (category name only)
function getCatgories() {
    var db = openDB();
    var arrCategory = [];
    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT category FROM category;');
        for(var i = 0; i < rs.rows.length; i++) {
            arrCategory[i] = rs.rows.item(i).category;
           }
    });
    return arrCategory;
}

function doSearch(txtcategory,txtString)
{
    var db = openDB();
    var arrResult = [];
    var txtBeginString;
    var txtContainString;

    txtBeginString = txtString + "%";
    txtContainString = "%" + txtString + "%";

    db.transaction(function(tx) {
        var rs = tx.executeSql('SELECT descr,count(*) as total FROM items where category = ? and (descr like ? or descr like ? ) group by descr order by total desc limit 4', [txtcategory,txtBeginString,txtContainString]);
        for(var i = 0; i < rs.rows.length; i++) {
            arrResult[i] = rs.rows.item(i).descr;
           }
    });
        //console.log("DB array count" + arrResult.length)
    return arrResult;
}

function changeCatLanguage(txtLangFrom, txtLangTo)
{
     var db = openDB();
     var txtFrom;
     var txtTo;

   var arrCategories =  getCatgories();

    db.transaction(function(tx){

       for(var i = 0; i < arrCategories.length; i++) {
           txtFrom = arrCategories[i];
          txtTo = Process.getTranslation(arrCategories[i])
        tx.executeSql('UPDATE items SET category = ? WHERE category = ?', [txtTo,txtFrom]);
        tx.executeSql('UPDATE category SET category = ? WHERE category = ?', [txtTo,txtFrom]);
        }
    });

}
