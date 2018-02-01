.import "../library/DBUtilities.js" as DB
.import "../library/ProcessFunc.js" as Process
.import QtQuick.LocalStorage 2.0 as Sql

//open database for transactions
function openDB() {
    var db = null
    if (db !== null)
        return

    // db = LocalStorage.openDatabaseSync(identifier, version, description, estimated_size, callback(db))
    db = Sql.LocalStorage.openDatabaseSync("talaan.kugiigi", "1.0",
                                              "applciation's backend data", 100000)

    return db
}



function saveChecklist(txtName, txtDescr, txtCategory,txtCreationDt, txtTargetDt, txtListType, intContinual) {
    var txtSaveStatement;
    var db = openDB()
    var rs = null
    var newID
    var newChecklist

    txtSaveStatement = 'INSERT INTO CHECKLIST(name,descr,category,creation_dt,target_dt, status, continual) VALUES(?,?,?,?,?,?,?)';
    //txtSaveStatement = txtSaveStatement.bindValues("?",[txtName,txtDescr,txtCategory,txtCreationDt]);

    db.transaction(function (tx) {
           tx.executeSql(txtSaveStatement,[txtName,txtDescr,txtCategory,txtCreationDt,txtTargetDt,txtListType, intContinual]);
           rs = tx.executeSql("SELECT MAX(id) as id FROM CHECKLIST");
           newID = rs.rows.item(0).id;
           newChecklist = {
            id: newID,
             checklist: txtName,
             descr: txtDescr,
            category: txtCategory,
            creation_dt: txtCreationDt,
            completion_dt: null,
            status: txtListType,
            target_dt: txtTargetDt,
            continual: intContinual,
            completed: 0,
            total: 0
         };
    })

    return newChecklist

}

function saveCategory(txtName,txtDescr,txtIcon) {
    var txtSaveStatement;
    var db = openDB()
    txtSaveStatement = 'INSERT INTO CATEGORY(name,descr,icon) VALUES(?,?,?)';

    db.transaction(function (tx) {
           tx.executeSql(txtSaveStatement,[txtName,txtDescr,txtIcon]);
    })

}

function markSavedChecklist(txtID,boolIncludeComments) {
    var txtSavedStatement, txtItemsStatement;
    var db = openDB()
    txtSavedStatement = 'INSERT INTO checklist (name, descr, category, creation_dt, completion_dt,status, target_dt) SELECT name, descr, category, CURRENT_TIMESTAMP, "","saved", "" FROM checklist WHERE id = ?';
    if(boolIncludeComments){
        txtItemsStatement = 'INSERT INTO items (checklist_id, checklist, name, comments, status) SELECT (SELECT MAX(id) FROM checklist), checklist, name, comments, 0 FROM items WHERE checklist_id = ?';
    }else{
        txtItemsStatement = "INSERT INTO items (checklist_id, checklist, name, comments, status) SELECT (SELECT MAX(id) FROM checklist), checklist, name, '', 0 FROM items WHERE checklist_id = ?";
    }

    db.transaction(function (tx) {
        tx.executeSql(txtSavedStatement,[txtID]);
        tx.executeSql(txtItemsStatement,[txtID]);
    })

}

function createNewFromSaved(txtID, checklistName,category, target_dt) {
    var txtSavedStatement, txtItemsStatement, txtSelectStatement;
    var db = openDB()
    var rs = null
    //var newID
    var newChecklist

    txtSavedStatement = 'INSERT INTO checklist (name, descr, category, creation_dt, completion_dt,status, target_dt) SELECT ?, descr, ?, CURRENT_TIMESTAMP, "","incomplete", ? FROM checklist WHERE id = ?';
    txtItemsStatement = 'INSERT INTO items (checklist_id, checklist, name, comments, status) SELECT (SELECT MAX(id) FROM checklist), checklist, name, comments, 0 FROM items WHERE checklist_id = ?';
    txtSelectStatement = 'SELECT a.id, a.name, a.descr, a.category, a.creation_dt, a.completion_dt, a.status, a.target_dt, a.continual, count(b.name) as total FROM CHECKLIST a LEFT OUTER JOIN items b ON a.id = b.checklist_id WHERE a.id = (SELECT MAX(id) as id FROM CHECKLIST) GROUP BY a.category, a.id, a.name, a.descr, a.creation_dt, a.completion_dt, a.status, a.target_dt, a.favorite, a.continual'
    db.transaction(function (tx) {
        tx.executeSql(txtSavedStatement,[checklistName,category,target_dt,txtID]);
        tx.executeSql(txtItemsStatement,[txtID]);
        //newID = rs.rows.item(0).id;
        rs = tx.executeSql(txtSelectStatement);
        newChecklist = {
         id: rs.rows.item(0).id,
          checklist: rs.rows.item(0).name,
          descr: rs.rows.item(0).descr,
         category: rs.rows.item(0).category,
         creation_dt: rs.rows.item(0).creation_dt,
         completion_dt: rs.rows.item(0).completion_dt,
         status: rs.rows.item(0).status,
         target_dt: rs.rows.item(0).target_dt,
         continual: rs.rows.item(0).continual,
         completed: 0,
         total: rs.rows.item(0).total
      };
    })

    return newChecklist

}



function categoryExist(category){
    var db = openDB();
    var rs = null;
    var exists;

    db.transaction(function (tx) {
        rs = tx.executeSql("SELECT * FROM category WHERE name = ?",[category]);

            exists = rs.rows.length === 0 ? false:true;

    })

    return exists;
}

function checklistExist(category,name){
    var db = openDB();
    var rs = null;
    var exists;

    db.transaction(function (tx) {
        rs = tx.executeSql("SELECT * FROM checklist WHERE category = ? AND name = ? and status<>'complete'",[category,name]);

            exists = rs.rows.length === 0 ? false:true;

    })

    return exists;
}

function itemExist(checklistid,name){
    var db = openDB();
    var rs = null;
    var exists;

    db.transaction(function (tx) {
        rs = tx.executeSql("SELECT * FROM items WHERE checklist_id = ? AND name = ?",[checklistid,name]);

            exists = rs.rows.length === 0 ? false:true;

    })

    return exists;
}

function saveItem(checklistid,txtChecklist,txtName, txtComment) {
    var txtSaveStatement;
    var db = openDB()
    txtSaveStatement = 'INSERT INTO items(checklist_id,checklist,name,comments) VALUES(?,?,?,?)';

    db.transaction(function (tx) {
           tx.executeSql(txtSaveStatement,[checklistid,txtChecklist,txtName,txtComment]);
    })

}

function getDBChecklists(statement,binds){
    var db = openDB()
    var arrResults = [];
    var rs = null

    db.transaction(function (tx) {
        //console.log(statement)
        //console.log(binds)
        if(binds!== undefined){
            rs = tx.executeSql(statement,binds);
        }else{
            rs = tx.executeSql(statement);
        }

        arrResults.length = rs.rows.length

        for (var i = 0; i < rs.rows.length; i++) {
            //add new row in the array
            arrResults[i] = []

            //assign values to the array
            arrResults[i] = rs.rows.item(i)
        }
    })

    return arrResults;
}

function getDBChecklist(checklistid){
    var db = openDB()
    var arrResults = [];
    var rs = null

    db.transaction(function (tx) {
        rs = tx.executeSql("SELECT * FROM checklist WHERE id = ?",[checklistid]);
        arrResults.length = rs.rows.length

        for (var i = 0; i < rs.rows.length; i++) {
            //add new row in the array
            arrResults[i] = []

            //assign values to the array
            arrResults[i] = rs.rows.item(i)
        }
    })

    return arrResults;
}



function getDBCategories(statement){
    var db = openDB()
    var arrResults = [];
    var rs = null

    db.transaction(function (tx) {
        rs = tx.executeSql(statement);
        arrResults.length = rs.rows.length

        for (var i = 0; i < rs.rows.length; i++) {
            //add new row in the array
            arrResults[i] = []

            //assign values to the array
            arrResults[i] = rs.rows.item(i)
        }
    })

    return arrResults;
}

function getTargets(){
    var db = openDB();
    var rs = null;
    var arrResults = [];

    db.transaction(function (tx) {
        rs = tx.executeSql("SELECT id, name, target_dt, (CASE WHEN target_dt < date('now','localtime') THEN 1 ELSE 0 END) overdue FROM checklist WHERE target_dt <> '' AND status = 'incomplete' ORDER BY target_dt");
        arrResults.length = rs.rows.length

        for (var i = 0; i < rs.rows.length; i++) {
            //add new row in the array
            arrResults[i] = []

            //assign values to the array
            arrResults[i] = rs.rows.item(i)
        }
    })

    return arrResults;
}

function deleteChecklist(checklistid){
    var txtDeleteStatement,txtDeleteItemsStatement;
    var db = openDB()

    txtDeleteStatement = 'DELETE FROM CHECKLIST WHERE id = ?';
    txtDeleteItemsStatement = 'DELETE FROM ITEMS WHERE checklist_id = ?';

    db.transaction(function (tx) {
        tx.executeSql(txtDeleteItemsStatement,[checklistid]);
        tx.executeSql(txtDeleteStatement,[checklistid]);
    })
}

function deleteCategory(txtCategory){
    var txtDeleteStatement,txtUpdateChecklistsStatement;
    var txtNewCategory = "Uncategorized";
    var db = openDB()

    txtDeleteStatement = 'DELETE FROM CATEGORY WHERE name = ?';
    txtUpdateChecklistsStatement = 'UPDATE CHECKLIST SET category = ? WHERE category = ?';

    db.transaction(function (tx) {
        tx.executeSql(txtUpdateChecklistsStatement,[txtNewCategory,txtCategory]);
        tx.executeSql(txtDeleteStatement,[txtCategory]);
    })
}

function deleteItem(checklistid,txtName){
    var txtDeleteStatement;
    var db = openDB()

    txtDeleteStatement = 'DELETE FROM ITEMS WHERE checklist_id = ? AND name = ?';

    db.transaction(function (tx) {
        tx.executeSql(txtDeleteStatement,[checklistid,txtName]);
    })
}

function getDBItems(checklistid,status, filter, sort){
    var db = openDB()
    var arrResults = [];
    var rs = null
    var txtSelectStatement
    var txtAdditionalStatement
    var txtOrderStatement


    txtAdditionalStatement = " AND (name LIKE ? OR comments LIKE ?)"

    switch(sort){
    /*Alphabetic Ascending*/
    case 0:
        txtOrderStatement = " ORDER BY name ASC"
        break
    /*Alphabetic Descending*/
    case 1:
        txtOrderStatement = " ORDER BY name DESC"
        break
    /*No sort*/
    default:
        txtOrderStatement = ""
        break
    }

    filter = '%' + filter + '%'

    db.transaction(function (tx) {
        if(status !== null){

            txtSelectStatement = "SELECT name, comments, status, priority FROM ITEMS WHERE checklist_id = ? and status = ?"
            if(filter!== ""){
                rs = tx.executeSql(txtSelectStatement + txtAdditionalStatement + txtOrderStatement,[checklistid,status,filter,filter]);
            }else{
                rs = tx.executeSql(txtSelectStatement + txtOrderStatement,[checklistid,status]);
            }
        }else{
            txtSelectStatement = "SELECT name, comments, status, priority FROM ITEMS WHERE checklist_id = ?"
            if(filter!== ""){
                rs = tx.executeSql(txtSelectStatement + txtAdditionalStatement + txtOrderStatement,[checklistid,filter,filter]);
            }else{
                rs = tx.executeSql(txtSelectStatement + txtOrderStatement,[checklistid]);
            }
        }

        arrResults.length = rs.rows.length

        for (var i = 0; i < rs.rows.length; i++) {
            //add new row in the array
            arrResults[i] = []

            //assign values to the array
            arrResults[i] = rs.rows.item(i)
        }
    })
 return arrResults;
}

function updateItemStatus(checklistid,name,status){
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql("UPDATE ITEMS SET status = ? WHERE checklist_id = ? AND name = ?",[status,checklistid,name])
    })
}

function updateItem(checklistid,name, newname,comments){
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql("UPDATE ITEMS SET name = ?, comments = ? WHERE checklist_id = ? AND name = ?",[newname,comments,checklistid,name])
    })
}

function updateItemPriority(checklistid,name, newPriority){
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql("UPDATE ITEMS SET priority = ? WHERE checklist_id = ? AND name = ?",[newPriority, checklistid, name])
    })
}

function updateFavorite(checklistid, newFavoriteStatus){
    var db = openDB()

    var favorite = newFavoriteStatus ? 1 : 0

    db.transaction(function (tx) {
        tx.executeSql("UPDATE CHECKLIST SET favorite = ? WHERE id = ?",[favorite, checklistid])
    })
}

function updateChecklist(intID, txtListType, txtName, txtDescr, txtCategory, txtTargetDt, intContinual){
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql("UPDATE items SET checklist = ? WHERE checklist_id = ?",[txtName,intID])
        tx.executeSql("UPDATE checklist SET status = ?, name = ?, descr = ?, category = ?, target_dt = ?, continual = ? WHERE id = ?",[txtListType, txtName, txtDescr, txtCategory, txtTargetDt, intContinual, intID])
    })
}

function updateCategory(txtName,txtNewName, txtDescr,txtIcon){
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql("UPDATE checklist SET category = ? WHERE category = ?",[txtNewName,txtName])
        tx.executeSql("UPDATE category SET name = ?, descr = ?, icon = ? WHERE name = ?",[txtNewName, txtDescr, txtIcon, txtName])
    })
}

function updateChecklistComplete(intID){
    var db = openDB()
    var today = new Date(Process.getToday())
    var txtCompletionDt = Process.dateFormat(0, today)

    db.transaction(function (tx) {
        tx.executeSql("UPDATE checklist SET status = 'complete', completion_dt = ? WHERE id = ?",[txtCompletionDt,intID])
        tx.executeSql('UPDATE items SET status = 1 WHERE checklist_id = ? AND status = 0',intID);
    })
}

function updateChecklistIncomplete(intID){
    var db = openDB()
    var txtCompletionDt = null

    db.transaction(function (tx) {
        tx.executeSql("UPDATE checklist SET status = 'incomplete', completion_dt = ? WHERE id = ?",[txtCompletionDt,intID])
    })
}

//Uncheck all items
function uncheckAllItems(intID){
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql('UPDATE items SET status = 0 WHERE checklist_id = ? AND status <> 0',intID);
    })
}


//Create meta tables
function createMetaTables(){
        var db = openDB();

    /*db.transaction(function (tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS `CHECKLIST` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,`name` TEXT,`descr` TEXT,`category` TEXT, `creation_dt` TEXT,`completion_dt`	TEXT,`status` TEXT DEFAULT 'incomplete',`target_dt` TEXT, `favorite` INTEGER DEFAULT '0', `continual` INTEGER DEFAULT '0')");
        tx.executeSql("CREATE TABLE IF NOT EXISTS `CATEGORY` (`name` TEXT,`descr` TEXT, `icon` TEXT DEFAULT 'default')");
        tx.executeSql("CREATE TABLE IF NOT EXISTS `ITEMS` (`checklist_id` INTEGER, `checklist` TEXT,`name` TEXT,`comments` TEXT,`status` INTEGER DEFAULT '0',`priority` TEXT DEFAULT 'Normal')");
    })*/

    db.transaction(function (tx) {
            tx.executeSql("CREATE TABLE IF NOT EXISTS `CHECKLIST` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,`name` TEXT,`descr` TEXT,`category` TEXT, `creation_dt` TEXT,`completion_dt`	TEXT,`status` TEXT DEFAULT 'incomplete',`target_dt` TEXT)");
            tx.executeSql("CREATE TABLE IF NOT EXISTS `CATEGORY` (`name` TEXT,`descr` TEXT, `icon` TEXT DEFAULT 'default')");
            tx.executeSql("CREATE TABLE IF NOT EXISTS `ITEMS` (`checklist_id` INTEGER, `checklist` TEXT,`name` TEXT,`comments` TEXT,`status` INTEGER DEFAULT '0')");
    })


}

//Initialize data for first time use
function initiateData(){
     var db = openDB();
    var categories  = DB.selectDB("SELECT * FROM CATEGORY");
if (categories.length === 0) {
    db.transaction(function (tx) {
        tx.executeSql('INSERT INTO CATEGORY VALUES("Personal", "Personal checklists","cornflowerblue")');
        tx.executeSql('INSERT INTO CATEGORY VALUES("Work", "Work-related checklists","orangered")');
        tx.executeSql('INSERT INTO CATEGORY VALUES("Others", "Other checklists","darkslategrey")');
    })
     };

}

function checkUserVersion(){
    var db = openDB();
    var rs = null;
    var currentDataBaseVersion

    db.transaction(function(tx){
        rs = tx.executeSql('PRAGMA user_version');
        currentDataBaseVersion = rs.rows.item(0).user_version
    });

    return currentDataBaseVersion;


}

function upgradeUserVersion(){
    var db = openDB();
    var rs = null;
    var currentDataBaseVersion
    var newDataBaseVersion

    db.transaction(function(tx){
        rs = tx.executeSql('PRAGMA user_version');
        currentDataBaseVersion = rs.rows.item(0).user_version
        newDataBaseVersion = currentDataBaseVersion + 1
        tx.executeSql("PRAGMA user_version = " + newDataBaseVersion);
    });

}

//Clear Hstory
function clearHistory(dateMode){
    var db = openDB();
    var days;

    switch(dateMode){
    case "year":
        days = "-365 day"
        break;
    case "month":
        days = "-30 day"
        break;
    case "week":
        days = "-7 day"
        break;
    default:
        days = "-365 day"
        break;

    }

    db.transaction(function (tx) {
        if(dateMode !== "all"){
            tx.executeSql('DELETE FROM items WHERE EXISTS (SELECT 1 FROM checklist chk WHERE chk.id = checklist_id AND chk.status = "complete" and chk.completion_dt <= date("now",?,"localtime"))',[days]);
            tx.executeSql('DELETE FROM checklist WHERE status = "complete" and completion_dt <= date("now",?,"localtime")',[days]);
        }else{
            tx.executeSql('DELETE FROM items WHERE EXISTS (SELECT 1 FROM checklist chk WHERE chk.id = checklist_id AND chk.status = "complete")');
            tx.executeSql('DELETE FROM checklist WHERE status = "complete"');
        }
    })
}


//Clean Saved data
function cleanSaved(){
    var db = openDB();

    db.transaction(function (tx) {
        tx.executeSql('UPDATE checklist set target_dt = "" WHERE status = "saved" and target_dt <> ""');
        tx.executeSql('UPDATE checklist set completion_dt = "" WHERE status = "saved" and completion_dt <> ""');
    })
}

//Clean Normal Lists
function cleanNormalLists(){
    var db = openDB();

    db.transaction(function (tx) {
        tx.executeSql('UPDATE checklist set target_dt = "" WHERE status = "normal" and target_dt <> ""');
    })
}
