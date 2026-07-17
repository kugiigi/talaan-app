.import QtQuick.LocalStorage 2.12 as Sql


// Open database for transactions
function openDB() {
    var db = null
    if (db !== null)
        return

    db = Sql.LocalStorage.openDatabaseSync("talaan.kugiigi", "1.0",
                                           "applciation's backend data", 100000)

    return db
}

//update database
function update(txtStatement) {
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql(txtStatement)
    })
}

//select data from database
function select(txtStatement, bindValues) {
    var db = openDB()
    var rs = null
    var arrResult = []
    
    if (bindValues) {
        try {
            db.transaction(function (tx) {
                if (bindValues) {
                    rs = tx.executeSql(txtStatement,bindValues)
                }else{
                    rs = tx.executeSql(txtStatement)
                }


                arrResult.length = rs.rows.length

                for (var i = 0; i < rs.rows.length; i++) {
                    //add new row in the array
                    arrResult[i] = []

                    //assign values to the array
                    arrResult[i] = rs.rows.item(i)
                }
            })
        } catch (err) {
            console.log("Select: " + txtStatement)
            console.log("Bind: " + bindValues)
            console.log("Error message: " + err)
        }
    }

    return arrResult
}

//insert data to database
function insert(txtStatement) {
    var db = openDB()

    db.transaction(function (tx) {
        if (txtStatement.constructor === Array) {
            for (var i = 0; i < txtStatement.length; i++) {
                tx.executeSql(txtStatement[i])
            }
        } else {
            tx.executeSql(txtStatement)
        }
    })
}

/*************Extra functions*************/
function processTextForGLOB (text) {
    if (text.indexOf("*") > -1 || text.indexOf("?") > -1) {
        return " "
    }

    return ["*", text, "*"].join("")
}

function processTextForLIKE (text) {
    if (text.indexOf("_") > -1 || text.indexOf("%") > -1) {
        return " "
    }

    return ["%", text, "%"].join("")
}


/*************Meta data functions*************/

//Create initial data
function createInitialData() {
    createMetaTables()
    createInitialCategoryData()
}

//Create meta tables
function createMetaTables() {
    let _db = openDB()

    _db.transaction(function (tx) {
        tx.executeSql("CREATE TABLE IF NOT EXISTS `CHECKLIST` (`id` INTEGER PRIMARY KEY AUTOINCREMENT,`name` TEXT,`descr` TEXT,`category` TEXT \
                        , `creation_dt` TEXT,`completion_dt`	TEXT,`status` TEXT DEFAULT 'incomplete',`target_dt` TEXT)");
        tx.executeSql("CREATE TABLE IF NOT EXISTS `CATEGORY` (`name` TEXT,`descr` TEXT, `icon` TEXT DEFAULT 'default')");
        tx.executeSql("CREATE TABLE IF NOT EXISTS `ITEMS` (`checklist_id` INTEGER, `checklist` TEXT,`name` TEXT,`comments` TEXT,`status` INTEGER DEFAULT '0')");
    })
}

function createInitialCategoryData(intProfileId) {
    let _db = openDB();

    _db.transaction(function (tx) {
        let _categories = tx.executeSql('SELECT * FROM categories')
        let _txtSqlStatement = "INSERT INTO categories VALUES(?, ?, ?)"

        if (_categories.rows.length === 0) {
            if (_categories.rows.length === 0) {
                let _categoriesData = [
                    [i18n.tr("Food"), i18n.tr("Personal checklists"), "cornflowerblue"]
                    , [i18n.tr("Work"), i18n.tr("Work-related checklists"), "orangered"]
                    , [i18n.tr("Others"), i18n.tr("Other checklists"), "darkslategrey"]
                ]
                
                let _length = _categoriesData.length

                for (let i = 0; i < _length; i++) {
                    let _bindValues = []
                    _bindValues = _categoriesData[i]

                    tx.executeSql(_txtSqlStatement, _bindValues)
                }
            }
        }
    })
}

//Clean Saved data
function cleanSaved(){
    let _db = openDB();

    _db.transaction(function (tx) {
        tx.executeSql('UPDATE checklist set target_dt = "" WHERE status = "saved" and target_dt <> ""');
        tx.executeSql('UPDATE checklist set completion_dt = "" WHERE status = "saved" and completion_dt <> ""');
    })
}

//Clean Normal Lists
function cleanNormalLists(){
    let _db = openDB();

    _db.transaction(function (tx) {
        tx.executeSql('UPDATE checklist set target_dt = "" WHERE status = "normal" and target_dt <> ""');
    })
}

// Apparently doesn't work since it uses WebSQL :(
function enableForeignKeys() {
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql("PRAGMA foreign_keys = ON")
    })
}

//Checks current database user version
function checkUserVersion() {
    var db = openDB()
    var rs = null
    var currentDataBaseVersion

    db.transaction(function (tx) {
        rs = tx.executeSql('PRAGMA user_version')
        currentDataBaseVersion = rs.rows.item(0).user_version
    })

    return currentDataBaseVersion
}

//increments database user version
function upgradeUserVersion() {
    let _db = openDB()
    let _rs = null
    let _currentDataBaseVersion
    let _newDataBaseVersion

    _db.transaction(function (tx) {
        _rs = tx.executeSql('PRAGMA user_version')
        _currentDataBaseVersion = _rs.rows.item(0).user_version
        _newDataBaseVersion = _currentDataBaseVersion + 1
        tx.executeSql("PRAGMA user_version = " + _newDataBaseVersion)
    })
}

//Execute Needed Database upgrades
function databaseUpgrade(currentVersion) {
    if (currentVersion < 1) {
        executeUserVersion1()
    }
    if (currentVersion < 2) {
        executeUserVersion2()
    }
    if (currentVersion < 3) {
        executeUserVersion3()
    }
    if (currentVersion < 4) {
        executeUserVersion4()
    }
    if (currentVersion > 3) {
        enableForeignKeys()
    }
}

//Database Changes for User Version 1
function executeUserVersion1() {
    let _db = openDB()
    _db.transaction(function (tx) {
        tx.executeSql('ALTER TABLE items ADD COLUMN priority TEXT DEFAULT Normal');
    });

    console.log("Database Upgraded to 1")
    upgradeUserVersion()
}

//Database Changes for User Version 2
// Version 0.70
function executeUserVersion2() {
    let _db = openDB()
    _db.transaction(function (tx) {
        tx.executeSql('UPDATE checklist SET status = "saved" WHERE status = "favorited"');
        tx.executeSql('ALTER TABLE checklist ADD COLUMN favorite INTEGER DEFAULT 0');
    });

    console.log("Database Upgraded to 2")
    upgradeUserVersion()
}

//Database Changes for User Version 3
// Version 0.80
function executeUserVersion3() {
    let _db = openDB()
    _db.transaction(function (tx) {
        tx.executeSql('ALTER TABLE checklist ADD COLUMN continual INTEGER DEFAULT 0');
    });

    console.log("Database Upgraded to 3")
    upgradeUserVersion()
}

//Database Changes for User Version 4
// Version 3.0 (Rewrite)
function executeUserVersion4() {
    updateDatesToUTC() // Update all dates to UTC
    alterMetaTablesForVersion4() // Modify and recreate tables
    createMetaViews() // Create views

    console.log("Database Upgraded to 4")
    upgradeUserVersion()
}

// Update all old data to UTC since the new logic stores everything in UTC and display them in localtime
function updateDatesToUTC() {
    let _db = openDB()

    _db.transaction(function (tx) {
        tx.executeSql(
            "UPDATE checklist SET creation_dt = strftime('%Y-%m-%d %H:%M:%f', creation_dt, 'utc'), completion_dt = strftime('%Y-%m-%d %H:%M:%f', completion_dt, 'utc') \
                , target_dt = strftime('%Y-%m-%d %H:%M:%f', target_dt, 'utc')")
    })
}

function alterMetaTablesForVersion4() {
    var db = openDB()

    db.transaction(function (tx) {

        /* Recreate categories first so checklist can be recreated successfully */

        // Make category name as primary key, rename "name" to "category_name"
        tx.executeSql(
                    "CREATE TABLE IF NOT EXISTS `categories_new` (`category_name` TEXT NOT NULL,`descr` TEXT,`icon` TEXT DEFAULT 'default', \
                        `color`	TEXT DEFAULT 'white')")
                        
        tx.executeSql("INSERT INTO categories_new(category_name, descr, icon, color) SELECT name, descr, '', icon FROM category")
        tx.executeSql("DROP TABLE category")
        tx.executeSql("ALTER TABLE categories_new RENAME TO categories")

        // Add modified_dt and type, rename "name" to "category_name", changed "status" to integer
        // type = checklist | list | template | endless
        // status = 0 | 1 (Incomplete | Complete)
        tx.executeSql(
                    "CREATE TABLE IF NOT EXISTS `checklist_new` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `descr` TEXT \
                        , `type` TEXT DEFAULT 'checklist', `category_name` TEXT NOT NULL  DEFAULT " + i18n.tr("Uncategorized") + 
                        ", `creation_dt` TEXT, `modified_dt` TEXT, `completion_dt` TEXT, `target_dt` TEXT, `status` INTEGER DEFAULT 0 \
                        , favorite INTEGER DEFAULT 0 \
                        , FOREIGN KEY (category_name) REFERENCES categories (category_name) ON UPDATE CASCADE ON DELETE RESTRICT)")

        // Set "checklist_id" as foreign key 
        tx.executeSql("CREATE TABLE IF NOT EXISTS `items_new` (`name` TEXT, `checklist_id` INTEGER,`comments` TEXT, `status` INTEGER DEFAULT 0 \
                        , priority INTEGER DEFAULT 0 \
                        , FOREIGN KEY (checklist_id) REFERENCES checklist (id) ON UPDATE CASCADE ON DELETE CASCADE)");
        
        tx.executeSql("INSERT INTO checklist_new(id, name, descr, type, category_name, creation_dt, modified_dt, completion_dt, target_dt, status, favorite) \
                            SELECT id, name, descr \
                                    , CASE \
                                        WHEN (status = 'complete' OR status = 'incomplete') \
                                            AND continual = 0 \
                                                THEN 'checklist' \
                                        WHEN (status = 'complete' OR status = 'incomplete') \
                                            AND continual = 1 \
                                                THEN 'endless' \
                                        WHEN status = 'normal' THEN 'list' \
                                        WHEN status = 'saved' THEN 'template' \
                                    END \
                                    , category, creation_dt, creation_dt, completion_dt, target_dt \
                                    , CASE status \
                                        WHEN 'complete' THEN 1 \
                                        WHEN 'incomplete' THEN 0 \
                                        WHEN 'normal' THEN 0 \
                                        WHEN 'saved' THEN 0 \
                                    END \
                                    , favorite \
                            FROM checklist")

        //~ tx.executeSql("INSERT INTO items_new(name, checklist_id, comments, priority, status) SELECT name, checklist_id, comments, priority, status FROM items")
        tx.executeSql("INSERT INTO items_new(name, checklist_id, comments, priority, status) \
                        SELECT name, checklist_id, comments \
                                , CASE priority \
                                    WHEN 'High' THEN 1 \
                                    WHEN 'Normal' THEN 0 \
                                  END \
                                , status FROM items")

        tx.executeSql("DROP TABLE checklist")
        tx.executeSql("DROP TABLE items")

        tx.executeSql("ALTER TABLE checklist_new RENAME TO checklist")
        tx.executeSql("ALTER TABLE items_new RENAME TO items")
    })
}

function createMetaViews() {
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql("DROP VIEW IF EXISTS activelists_vw")
        tx.executeSql("DROP VIEW IF EXISTS archivedlists_vw")

        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS activelists_vw AS SELECT a.id, a.name, a.descr, a.type, a.category_name, \
                        IFNULL(strftime('%Y-%m-%d %H:%M:%f', a.creation_dt, 'localtime'), '') AS creation_dt \
                        , IFNULL(strftime('%Y-%m-%d %H:%M:%f', a.modified_dt, 'localtime'), '') AS modified_dt \
                        , IFNULL(strftime('%Y-%m-%d %H:%M:%f', a.completion_dt, 'localtime'), '') AS completion_dt \
                        , IFNULL(strftime('%Y-%m-%d %H:%M:%f', a.target_dt, 'localtime'), '') AS target_dt, a.status, a.favorite \
                        , count(b.name) AS item_count, total(CASE WHEN b.status = 0 OR b.status IS NULL THEN 0 ELSE 1 END) AS checked_count \
                        FROM checklist a LEFT OUTER JOIN items b ON a.id = b.checklist_id \
                        WHERE (a.type = 'checklist' OR a.type = 'list' OR a.type = 'endless') \
                        AND a.completion_dt ISNULL \
                        AND a.status = 0 \
                        GROUP BY a.id,  a.name, a.descr, a.type, a.category_name, creation_dt, completion_dt, modified_dt, target_dt, a.status, a.favorite")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS archivedlists_vw AS SELECT a.id, a.name, a.descr, a.type, a.category_name, \
                        IFNULL(strftime('%Y-%m-%d %H:%M:%f', a.creation_dt, 'localtime'), '') AS creation_dt \
                        , IFNULL(strftime('%Y-%m-%d %H:%M:%f', a.modified_dt, 'localtime'), '') AS modified_dt \
                        , IFNULL(strftime('%Y-%m-%d %H:%M:%f', a.completion_dt, 'localtime'), '') AS completion_dt \
                        , IFNULL(strftime('%Y-%m-%d %H:%M:%f', a.target_dt, 'localtime'), '') AS target_dt, a.status, a.favorite \
                        , count(b.name) AS item_count, total(CASE WHEN b.status = 0 OR b.status IS NULL THEN 0 ELSE 1 END) AS checked_count \
                        FROM checklist a LEFT OUTER JOIN items b ON a.id = b.checklist_id \
                        WHERE (a.type = 'checklist' OR a.type = 'list' OR a.type = 'endless') \
                        AND a.completion_dt NOTNULL \
                        GROUP BY a.id,  a.name, a.descr, a.type, a.category_name, creation_dt, completion_dt, modified_dt, target_dt, a.status, a.favorite")
    })
}

function addNewList(listData) {
    let _txtSaveStatement
    let _db = openDB()
    let _rs = null
    let _success
    let _errorMsg
    let _result

    let _txtName = listData.name
    let _txtDescr = listData.description
    let _txtType = listData.type
    let _txtCategory = listData.category
    let _txtCreationDt = listData.creationDt
    let _txtModifiedDt = listData.modifiedDt
    let _txtCompletionDt = listData.completionDt
    let _txtTargetDt = listData.targetDt
    let _intStatus = listData.status
    let _intFavorite = listData.favorite

    _txtSaveStatement = 'INSERT INTO checklist(name, descr, type, category_name, creation_dt ,modified_dt, completion_dt, target_dt, status, favorite) \
                        VALUES(?, ?, ?, ?, strftime("%Y-%m-%d %H:%M:%f", ?, "utc"), strftime("%Y-%m-%d %H:%M:%f", ?, "utc"), strftime("%Y-%m-%d %H:%M:%f", ?, "utc") \
                                , strftime("%Y-%m-%d %H:%M:%f", ?, "utc"), ?, ?)'

    try {
        _db.transaction(function (tx) {
            let _arrBindValues = [_txtName, _txtDescr, _txtType, _txtCategory, _txtCreationDt, _txtModifiedDt
                                        , _txtCompletionDt, _txtTargetDt, _intStatus, _intFavorite]
            tx.executeSql(_txtSaveStatement, _arrBindValues)
        })

        _success = true
    } catch (err) {
        console.log("Database error: " + err)
        _errorMsg = err
        _success = false
    }

    _result = { "success": _success, "error": _errorMsg }

    return _result
}

function saveListAsTemplate(listId, includeComments) {
    let _txtListStatement
    let _txtItemsStatement
    let _db = openDB()
    let _rs = null
    let _success
    let _errorMsg
    let _result

    _txtListStatement = "INSERT INTO checklist(name, descr, type, category_name, creation_dt ,modified_dt, completion_dt, target_dt, status, favorite) \
                            SELECT name, descr, 'template', category_name, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, '', '', 0, 0 \
                            FROM checklist WHERE id = ?"

    if (includeComments) {
        _txtItemsStatement = 'INSERT INTO items (name, checklist_id, comments, status, priority) SELECT name, (SELECT MAX(id) FROM checklist), comments, 0, priority FROM items WHERE checklist_id = ?';
    } else {
        _txtItemsStatement = "INSERT INTO items (name, checklist_id, comments, status, priority) SELECT name, (SELECT MAX(id) FROM checklist), '', 0, priority FROM items WHERE checklist_id = ?";
    }

    try {
        _db.transaction(function (tx) {
            tx.executeSql(_txtListStatement, [listId])
            tx.executeSql(_txtItemsStatement, [listId])
        })

        _success = true
    } catch (err) {
        console.log("Database error: " + err)
        _errorMsg = err
        _success = false
    }

    _result = { "success": _success, "error": _errorMsg }

    return _result
}

function updateList(listData) {
    let _txtUpdateStatement
    let _db = openDB()
    let _rs = null
    let _success
    let _errorMsg
    let _result

    let _txtId = listData.listId
    let _txtName = listData.name
    let _txtDescr = listData.description
    let _txtType = listData.type
    let _txtCategory = listData.category
    let _txtModifiedDt = listData.modifiedDt
    let _txtTargetDt = listData.targetDt
    let _intStatus = listData.status

    //~ _txtUpdateStatement = 'UPDATE expenses SET category_name = ?, name = ?, descr = ?, date = strftime("%Y-%m-%d %H:%M:%f", ?, "utc"), value = ? WHERE expense_id = ?'
    _txtUpdateStatement = 'UPDATE checklist SET name = ?, descr = ?, type = ?, category_name = ?, modified_dt = strftime("%Y-%m-%d %H:%M:%f", ?, "utc") \
                            , target_dt = strftime("%Y-%m-%d %H:%M:%f", ?, "utc"), status = ? WHERE id = ?'

    try {
        _db.transaction(function (tx) {
            let _arrBindValues = [_txtName, _txtDescr, _txtType, _txtCategory, _txtModifiedDt, _txtTargetDt, _intStatus]
            tx.executeSql(_txtUpdateStatement, _arrBindValues)
        })

        _success = true
    } catch (err) {
        console.log("Database error: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg, "oldEntryDate": _oldEntryDate}
    
    return _result
}

function deleteList(listId) {
    let _txtSqlStatement
    let _db = openDB()
    let _success
    let _errorMsg
    let _result

    try {
        _db.transaction(function (tx) {
            _txtSqlStatement = "DELETE FROM checklist WHERE id = ?"
            tx.executeSql(_txtSqlStatement, [listId])
        })

        _success = true

        let _itemDeletionResult = deleteListItems(listId)
        _success = _itemDeletionResult.success
    } catch (err) {
        console.log("Error message: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg}

    return _result
}

function deleteListItems(listId) {
    let _txtSqlStatement
    let _db = openDB()
    let _success
    let _errorMsg
    let _result

    try {
        _db.transaction(function (tx) {
            _txtSqlStatement = "DELETE FROM items WHERE checklist_id = ?"
            tx.executeSql(_txtSqlStatement, [listId])
        })

        _success = true
    } catch (err) {
        console.log("Error message: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg}

    return _result
}

function updateListFavorite(id, setAsFavorite) {
    let _db = openDB()
    let _intFavorite = setAsFavorite ? 1 : 0
    let _success
    let _errorMsg
    let _result

    try {
        _db.transaction(function (tx) {
            tx.executeSql("UPDATE checklist SET favorite = ? WHERE id = ?", [_intFavorite, id])
        })

        _success = true
    } catch (err) {
        console.log("Error message: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg}

    return _result
}

function setListCompletionDt(listId, setToBlank=false) {
    let _db = openDB()
    let _success
    let _errorMsg
    let _result
    let _txtUpdateStatement

    if (setToBlank) {
        _txtUpdateStatement = "UPDATE checklist SET completion_dt = '' WHERE id = ?"
    } else {
        _txtUpdateStatement = "UPDATE checklist SET completion_dt = CURRENT_TIMESTAMP WHERE id = ?"
    }

    try {
        _db.transaction(function (tx) {
            tx.executeSql(_txtUpdateStatement, [listId])
        })

        _success = true
    } catch (err) {
        console.log("Error message: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg}

    return _result
}

function updateListStatus(id, setAsComplete=false, skipUnchecked=false) {
    let _db = openDB()
    let _success
    let _errorMsg
    let _result
    let _txtUpdateStatement
    let _newItemsStatus = skipUnchecked ? 2 : 1 // Skip unchecked items or set them as complete

    try {
        _db.transaction(function (tx) {
            if (setAsComplete) {
                tx.executeSql("UPDATE checklist SET status = ?, completion_dt = DATETIME('now') WHERE id = ?", [1, id])
                tx.executeSql("UPDATE items SET status = ? WHERE checklist_id = ? AND status = 0", [_newItemsStatus, id])
            } else {
                tx.executeSql("UPDATE checklist SET status = ?, completion_dt = NULL WHERE id = ?", [0, id])
            }
        })

        _success = true
    } catch (err) {
        console.log("Error message: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg}

    return _result
}

function getActiveLists() {
    let _db = openDB()
    let _arrResults = []
    let _rs = null
    let _txtSqlStatement = ""

    _db.transaction(function (tx) {
        _txtSqlStatement = "SELECT * FROM activelists_vw"

        _rs = tx.executeSql(_txtSqlStatement)
        _arrResults.length = _rs.rows.length

        for (let i = 0; i < _rs.rows.length; i++) {
            _arrResults[i] = _rs.rows.item(i)
        }
    })

    return _arrResults
}

function getArchivedLists() {
    let _db = openDB()
    let _arrResults = []
    let _rs = null
    let _txtSqlStatement = ""

    _db.transaction(function (tx) {
        _txtSqlStatement = "SELECT * FROM archivedlists_vw"

        _rs = tx.executeSql(_txtSqlStatement)
        _arrResults.length = _rs.rows.length

        for (let i = 0; i < _rs.rows.length; i++) {
            _arrResults[i] = _rs.rows.item(i)
        }
    })

    return _arrResults
}

function getListItems(listId, intSort, boolPriorityFirst) {
    let _db = openDB()
    let _arrResults = []
    let _rs = null
    let _txtSqlStatement = ""
    let _txtOrderStatement = ""

    switch(intSort){
    /*Alphabetic Ascending*/
    case 1:
        _txtOrderStatement = "ORDER BY %1 name ASC"
        break
    /*Alphabetic Descending*/
    case 2:
        _txtOrderStatement = "ORDER BY %1 name DESC"
        break
    /*No sort*/
    default:
        _txtOrderStatement = ""
        break
    }

    if (boolPriorityFirst) {
        if (_txtOrderStatement === "") {
            _txtOrderStatement = "ORDER BY priority DESC"
        } else {
            _txtOrderStatement = _txtOrderStatement.arg("priority DESC,")
        }
    } else {
        if (_txtOrderStatement !== "") {
            _txtOrderStatement = _txtOrderStatement.arg("")
        }
    }

    _db.transaction(function (tx) {
        _txtSqlStatement = "SELECT name, comments, status, priority FROM items WHERE checklist_id = ?"
        _txtSqlStatement = [_txtSqlStatement, _txtOrderStatement].join(" ")
        console.log(_txtSqlStatement + " - " + listId)
        _rs = tx.executeSql(_txtSqlStatement, [ listId ])
        _arrResults.length = _rs.rows.length

        for (let i = 0; i < _rs.rows.length; i++) {
            _arrResults[i] = _rs.rows.item(i)
        }
    })

    return _arrResults
}

function updateListItemStatus(listId, txtName, intStatus) {
    let _db = openDB()
    let _success
    let _errorMsg
    let _result
    let _txtUpdateStatement

    try {
        _db.transaction(function (tx) {
            tx.executeSql("UPDATE items SET status = ? WHERE checklist_id = ? AND name = ?", [intStatus, listId, txtName])
        })

        _success = true
    } catch (err) {
        console.log("Error message: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg}

    return _result
}

function getCategories() {
    var db = openDB()
    var arrResults = []
    var rs = null
    var txtSelectStatement = ""

    txtSelectStatement = "SELECT category_name, descr, icon, color FROM categories ORDER BY category_name"

    db.transaction(function (tx) {
        rs = tx.executeSql(txtSelectStatement)

        arrResults.length = rs.rows.length

        for (var i = 0; i < rs.rows.length; i++) {
            arrResults[i] = rs.rows.item(i)
        }
    })
    return arrResults
}

function addCategory(txtName, txtDescr, txtIcon, txtColor) {
    let _txtSaveStatement
    let _db = openDB()
    let _result
    let _success = false
    let _errorMsg = ""
    
    let _existsResult = checkCategoryIfExists(txtName)
    let _colorExistsResult = checkCategoryColorIfExists(txtName, txtColor)

    _txtSaveStatement = 'INSERT INTO categories(category_name,descr,icon,color) VALUES(?,?,?,?)'

    if (_existsResult.success && !_existsResult.exists && _colorExistsResult.success && !_colorExistsResult.exists) {
        try {
            _db.transaction(function (tx) {
                tx.executeSql(_txtSaveStatement, [txtName, txtDescr, txtIcon, txtColor])
            })

            _success = true
        } catch (err) {
            console.log("Database error: " + err)
            _errorMsg = err
            _success = false
        }
    } else {
        _success = false
    }

    _result = { "success": _success, "error": _errorMsg, "nameExists": _existsResult.exists, "colorExists": _colorExistsResult.exists }

    return _result
}

function updateCategory(txtName, txtNewName, txtDescr, txtIcon, txtColor) {
    let _db = openDB()
    let _result
    let _success = false
    let _errorMsg = ""
    let _nameExists = false
    let _colorExists = false

    if (txtNewName !== txtName) {
        let _existsResult = checkCategoryIfExists(txtNewName)
        _nameExists = _existsResult.success && _existsResult.exists
    }

    let _colorExistsResult = checkCategoryColorIfExists(txtName, txtColor)
    _colorExists = _colorExistsResult.success && _colorExistsResult.exists

    if (!_nameExists && !_colorExists) {
        try {
            _db.transaction(function (tx) {
                tx.executeSql(
                            "UPDATE categories SET category_name = ?, descr = ?, icon = ?, color= ? WHERE category_name = ?",
                      [txtNewName, txtDescr, txtIcon, txtColor, txtName])
                tx.executeSql("UPDATE expenses SET category_name = ? WHERE category_name = ?",
                      [txtNewName, txtName])
                tx.executeSql("UPDATE quick_expenses SET category_name = ? WHERE category_name = ?",
                      [txtNewName, txtName])
            })

            _success = true
        } catch (err) {
            console.log("Database error: " + err)
            _errorMsg = err
            _success = false
        }
    } else {
        _success = false
    }

    _result = { "success": _success, "error": _errorMsg, "nameExists": _nameExists, "colorExists": _colorExists }

    return _result
}

function checkCategoryIfExists(txtCategory) {
    let _db = openDB()
    let _rs = null
    let _result
    let _success = false
    let _errorMsg = ""
    let _exists = false

    try {
        _db.transaction(function (tx) {
            _rs = tx.executeSql("SELECT * FROM categories WHERE category_name = ?", [txtCategory])
            _exists = _rs.rows.length > 0
        })

        _success = true
    } catch (err) {
        console.log("Database error: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg, "exists": _exists}

    return _result
}

function checkCategoryColorIfExists(txtCategory, txtColor) {
    let _db = openDB()
    let _rs = null
    let _result
    let _success = false
    let _errorMsg = ""
    let _exists = false

    try {
        _db.transaction(function (tx) {
            _rs = tx.executeSql("SELECT * FROM categories WHERE category_name != ? AND color = ?", [txtCategory, txtColor])
            _exists = _rs.rows.length > 0
        })

        _success = true
    } catch (err) {
        console.log("Database error: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg, "exists": _exists}

    return _result
}

function deleteCategory(txtCategory) {
    let _txtDeleteStatement, _txtUpdateExpensesStatement
    let _txtNewCategory = "Uncategorized"
    let _db = openDB()
    let _result
    let _success = false
    let _errorMsg = ""
    let _hasData = false

    _hasData = checkCategoryData(txtCategory)

    if (!_hasData) {
        _txtDeleteStatement = 'DELETE FROM categories WHERE category_name = ?'

        try {
            _db.transaction(function (tx) {
                tx.executeSql(_txtDeleteStatement, [txtCategory])
            })

            _success = true
        } catch (err) {
            console.log("Database error: " + err)
            _errorMsg = err
            _success = false
        }
    }

    _result = { "success": _success, "error": _errorMsg, "hasData": _hasData }

    return _result
}

// Check if category has checklist data
function checkCategoryData(txtCategory) {
    let _db = openDB()
    let _rs = null
    let _exists

    _db.transaction(function (tx) {
        _rs = tx.executeSql("SELECT 1 FROM checklist WHERE category_name = ?", [txtCategory])

        _exists = _rs.rows.length === 0 ? false : true
    })

    return _exists
}
/*-----------------------------Tagatuos Area----------------------------*/



function createReportsRecord(){
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql(
                    "CREATE TABLE IF NOT EXISTS `reports` (`report_id` INTEGER PRIMARY KEY AUTOINCREMENT,`creator` TEXT DEFAULT 'user',`report_name` TEXT,`type` TEXT DEFAULT 'LINE',`date_range` TEXT DEFAULT 'This Month',`date_mode` TEXT DEFAULT 'Day',`filter` TEXT,`exceptions` TEXT,`date1` TEXT,`date2` TEXT)")
    })


}

function createQuickRecord(){
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql(
                    "CREATE TABLE IF NOT EXISTS `quick_expenses` (`quick_id` INTEGER PRIMARY KEY AUTOINCREMENT, `category_name`	TEXT, `name` TEXT, `descr` TEXT, `value` REAL);")
    })

}



function createCurrenciesRecord(){
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql(
                     "CREATE TABLE IF NOT EXISTS `currencies` (`currency_code`	TEXT,`description`	TEXT,`symbol`	TEXT,`decimal`	TEXT,`thousand`	TEXT,`precision`	INTEGER,`format`	TEXT,PRIMARY KEY(currency_code));")
    })

}


function createTravelRecord(){
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql(
                     "CREATE TABLE `travel_expenses` (`expense_id`	INTEGER,`home_currency`	TEXT,`travel_currency`	TEXT,`rate`	REAL, `value` REAL,PRIMARY KEY(expense_id));")
    })
}


function createProfilesRecord() {
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql(
                    "CREATE TABLE IF NOT EXISTS `profiles` (`profile_id`	INTEGER PRIMARY KEY AUTOINCREMENT \
                    ,`active` INTEGER NOT NULL CHECK (`active` IN (0, 1)), `display_name` TEXT \
                    , `enable_overlay` INTEGER NOT NULL CHECK (`enable_overlay` IN (0, 1)), `overlay_color` TEXT \
                    , `overlay_opacity` REAL)")
        tx.executeSql(
                        'INSERT INTO profiles ("active", "display_name", "enable_overlay", "overlay_color", "overlay_opacity") VALUES(1, ?, ?, ?, ?)'
                                    ,[ i18n.tr("Default"), 0, "blue", 0.2])
    })
}



function alterMetaViewsForVersion4() {
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql("DROP VIEW IF EXISTS expenses_today")
        tx.executeSql("DROP VIEW IF EXISTS expenses_yesterday")
        tx.executeSql("DROP VIEW IF EXISTS expenses_thisweek")
        tx.executeSql("DROP VIEW IF EXISTS expenses_thismonth")
        tx.executeSql("DROP VIEW IF EXISTS expenses_recent")
        tx.executeSql("DROP VIEW IF EXISTS expenses_lastweek")
        tx.executeSql("DROP VIEW IF EXISTS expenses_lastmonth")
        tx.executeSql("DROP VIEW IF EXISTS expenses_vw")

        // New views for trend charts
        tx.executeSql("DROP VIEW IF EXISTS datelist_weeksOfThisYear")
        tx.executeSql("DROP VIEW IF EXISTS datelist_weeksOfLastYear")
        tx.executeSql("DROP VIEW IF EXISTS datelist_monthsOfYear")
        tx.executeSql("DROP VIEW IF EXISTS datelist_daysOfWeek")
        tx.executeSql("DROP VIEW IF EXISTS datelist_daysOfRecent")
        tx.executeSql("DROP VIEW IF EXISTS datelist_daysOfPreviousRecent")
        tx.executeSql("DROP VIEW IF EXISTS datelist_weeksOfThisMonth")
        tx.executeSql("DROP VIEW IF EXISTS datelist_weeksOfLastMonth")
        tx.executeSql("DROP VIEW IF EXISTS datelist_daysOfThisMonth")
        tx.executeSql("DROP VIEW IF EXISTS datelist_daysOfLastMonth")


        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_vw AS SELECT a.profile_id, a.expense_id, a.category_name, a.name, a.descr, a.date, a.value \
                    , IFNULL(b.home_currency, '') as home_currency, IFNULL(b.travel_currency, '') as travel_currency \
                    , IFNULL(b.rate, 0) as 'rate', IFNULL(b.value, 0) as 'travel_value' \
                    FROM expenses a LEFT OUTER JOIN travel_expenses b USING(expense_id)")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_today AS SELECT profile_id, expense_id, category_name, name, descr, date, value \
                    , home_currency, travel_currency, rate, travel_value \
                    FROM expenses_vw \
                    WHERE date(date,'localtime') = date('now','localtime')")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_yesterday AS SELECT profile_id, expense_id, category_name, name, descr, date, value \
                    , home_currency, travel_currency, rate, travel_value \
                    FROM expenses_vw \
                    WHERE date(date,'localtime') = date('now','localtime','-1 day')")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_thisweek AS SELECT profile_id, expense_id, category_name, name, descr, date, value \
                    , home_currency, travel_currency, rate, travel_value \
                    FROM expenses_vw \
                    WHERE date(date,'localtime') BETWEEN date('now','localtime','weekday 6','-6 days') AND date('now','localtime','weekday 6')")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_thismonth AS SELECT profile_id, expense_id, category_name, name, descr, date, value \
                    , home_currency, travel_currency, rate, travel_value \
                    FROM expenses_vw \
                    WHERE date(date,'localtime') BETWEEN date('now', 'localtime', 'start of month')  AND date('now','localtime','start of month','+1 month','-1 day')")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_recent AS SELECT profile_id, expense_id, category_name, name, descr, date, value \
                    , home_currency, travel_currency, rate, travel_value \
                    FROM expenses_vw \
                    WHERE date(date,'localtime') BETWEEN date('now','localtime','-6 day') AND date('now','localtime')")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_previousrecent AS SELECT profile_id, expense_id, category_name, name, descr, date, value \
                    , home_currency, travel_currency, rate, travel_value \
                    FROM expenses_vw \
                    WHERE date(date,'localtime') BETWEEN date('now','localtime','-13 day') AND date('now','localtime','-7 day')")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_lastweek AS SELECT profile_id, expense_id, category_name, name, descr, date, value \
                    , home_currency, travel_currency, rate, travel_value \
                    FROM expenses_vw \
                    WHERE date(date,'localtime') BETWEEN date('now','localtime','weekday 6', '-13 days') AND date('now','localtime','weekday 6', '-7 days')")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_lastmonth AS SELECT profile_id, expense_id, category_name, name, descr, date, value \
                    , home_currency, travel_currency, rate, travel_value \
                    FROM expenses_vw \
                    WHERE date(date,'localtime') BETWEEN date('now','localtime','start of month','-1 month') AND date('now','localtime','start of month','-1 day')")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_thisyear AS SELECT profile_id, expense_id, category_name, name, descr, date, value \
                    , home_currency, travel_currency, rate, travel_value \
                    FROM expenses_vw \
                    WHERE date(date,'localtime') BETWEEN date('now', 'localtime', 'start of year')  AND date('now','localtime','start of year','+1 year','-1 day')")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS expenses_lastyear AS SELECT profile_id, expense_id, category_name, name, descr, date, value \
                    , home_currency, travel_currency, rate, travel_value \
                    FROM expenses_vw \
                    WHERE date(date,'localtime') BETWEEN date('now','localtime','start of year','-1 year') AND date('now','localtime','start of year','-1 day')")

        // Date List Views for Charts
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_weeksOfThisYear AS WITH RECURSIVE rec AS ( \
                                SELECT date('now', 'localtime', 'start of year') AS dt, date('now','start of year','+1 year','-1 day') AS last_dt \
                                UNION ALL SELECT date(dt, 'localtime', '+7 day'), last_dt FROM rec WHERE dt < date(last_dt, '-6 day') \
                            ) \
                            SELECT strftime('%W', dt) AS week_num, dt AS date FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_weeksOfLastYear AS WITH RECURSIVE rec AS ( \
                                SELECT date('now','localtime','start of year','-1 year') as dt, date('now','localtime','start of year','-1 day') AS last_dt \
                                UNION ALL SELECT date(dt, 'localtime', '+7 day'), last_dt FROM rec WHERE dt < date(last_dt, '-6 day') \
                            ) \
                            SELECT strftime('%W', dt) AS week_num, dt AS date FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_monthsOfYear AS WITH RECURSIVE rec AS ( \
                                SELECT 1 AS month_num \
                                UNION ALL SELECT month_num + 1 FROM rec WHERE month_num < 12 \
                            ) \
                            SELECT PRINTF('%02d', month_num) AS month_num FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_daysOfWeek AS WITH RECURSIVE rec AS ( \
                                SELECT 0 AS day_num \
                                UNION ALL SELECT day_num + 1 FROM rec WHERE day_num < 6 \
                            ) \
                            SELECT cast(day_num as text) AS day_num FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_daysOfRecent AS WITH RECURSIVE rec AS ( \
                                SELECT date('now','localtime','-6 day') AS dt, date('now','localtime') AS last_dt \
                                UNION ALL SELECT date(dt, 'localtime', '+1 day'), last_dt FROM rec WHERE dt < last_dt \
                            ) \
                            SELECT strftime('%w', dt) as day_num, dt as date FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_daysOfPreviousRecent AS WITH RECURSIVE rec AS ( \
                                SELECT date('now','localtime','-13 day') AS dt, date('now','localtime','-7 day') AS last_dt \
                                UNION ALL SELECT date(dt, 'localtime', '+1 day'), last_dt FROM rec WHERE dt < last_dt \
                            ) \
                            SELECT strftime('%w', dt) as day_num, dt as date FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_weeksOfThisMonth AS WITH RECURSIVE rec AS ( \
                                SELECT date('now', 'localtime', 'start of month') AS dt, date('now','localtime','start of month','+1 month','-1 day') AS last_dt \
                                UNION ALL SELECT date(dt, 'localtime', '+7 day'), last_dt FROM rec WHERE dt < date(last_dt, '-6 day') \
                            ) \
                            SELECT strftime('%W', dt) AS week_num, dt AS date FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_weeksOfLastMonth AS WITH RECURSIVE rec AS ( \
                                SELECT date('now','localtime','start of month','-1 month') AS dt, date('now','localtime','start of month','-1 day') AS last_dt \
                                UNION ALL SELECT date(dt, 'localtime', '+7 day'), last_dt FROM rec WHERE dt < date(last_dt, '-6 day') \
                            ) \
                            SELECT strftime('%W', dt) AS week_num, dt AS date FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_daysOfThisMonth AS WITH RECURSIVE rec AS ( \
                                SELECT date('now', 'localtime', 'start of month') AS dt, date('now','localtime','start of month','+1 month','-1 day') AS last_dt \
                                UNION ALL SELECT date(dt, 'localtime', '+1 day'), last_dt FROM rec WHERE dt < last_dt \
                            ) \
                            SELECT strftime('%d', dt) AS day_num, dt AS date FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_daysOfLastMonth AS WITH RECURSIVE rec AS ( \
                                SELECT date('now','localtime','start of month','-1 month') AS dt, date('now','localtime','start of month','-1 day') AS last_dt \
                                UNION ALL SELECT date(dt, 'localtime', '+1 day'), last_dt FROM rec WHERE dt < last_dt \
                            ) \
                            SELECT strftime('%d', dt) AS day_num, dt AS date FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_daysOfThisWeek AS WITH RECURSIVE rec AS ( \
                                SELECT date('now','localtime','weekday 6','-6 days') AS dt, date('now','localtime','weekday 6') AS last_dt \
                                UNION ALL SELECT date(dt, 'localtime', '+1 day'), last_dt FROM rec WHERE dt < last_dt \
                            ) \
                            SELECT strftime('%w', dt) AS day_num, dt AS date FROM rec")
        tx.executeSql(
                    "CREATE VIEW IF NOT EXISTS datelist_daysOfLastWeek AS WITH RECURSIVE rec AS ( \
                                SELECT date('now','localtime','weekday 6', '-13 days') AS dt, date('now','localtime','weekday 6', '-7 days') AS last_dt \
                                UNION ALL SELECT date(dt, 'localtime', '+1 day'), last_dt FROM rec WHERE dt < last_dt \
                            ) \
                            SELECT strftime('%w', dt) AS day_num, dt AS date FROM rec")
    })
}


/*************Main Data functions*************/
function getProfiles() {
    var db = openDB()
    var arrResults = []
    var rs = null

    db.transaction(function (tx) {
        rs = tx.executeSql("SELECT * FROM profiles where active = 1 order by display_name asc")
        arrResults.length = rs.rows.length

        for (var i = 0; i < rs.rows.length; i++) {
            arrResults[i] = rs.rows.item(i)
        }
    })

    return arrResults
}

function checkProfileIfExist(txtDisplayName) {
    var db = openDB()
    var rs = null
    var exists

    db.transaction(function (tx) {
        rs = tx.executeSql("SELECT * FROM profiles WHERE active = 1 and display_name = ?", [txtDisplayName])

        exists = rs.rows.length === 0 ? false : true
    })

    return exists
}

function newProfile(txtDisplayName, boolEnableOverlay, txtOverlayColor = "blue", txtOverlayOpacity = 0.2) {
    let _txtSaveStatement
    let _db = openDB()
    let _rs = null
    let _result
    let _success = false
    let _errorMsg = ""

    let _existsResult = checkProfileIfExist(txtDisplayName)

    // Do not save when opacity is too big
    let _saveOverlayOpacity = txtOverlayOpacity > 0.6 ? 0.6 : txtOverlayOpacity

    _txtSaveStatement = 'INSERT INTO profiles(active, display_name, enable_overlay, overlay_color, overlay_opacity) VALUES(1, ?, ?, ?, ?)'

    if (!_existsResult) {
        try {
            _db.transaction(function (tx) {
                tx.executeSql(_txtSaveStatement, [txtDisplayName, boolEnableOverlay, txtOverlayColor, _saveOverlayOpacity])

                // Intialize profile data such as Categories
                _rs = tx.executeSql("SELECT MAX(profile_id) as id FROM profiles")
                let _newID = _rs.rows.item(0).id
                createInitialProfielData(_newID)
            })

            _success = true
        } catch (err) {
            console.log("Database error: " + err)
            _errorMsg = err
            _success = false
        }
    } else {
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg, "exists": _existsResult}

    return _result
}

function editProfile(intProfileId, txtDisplayName, txtNewDisplayName, boolEnableOverlay, txtOverlayColor = "blue", txtOverlayOpacity = 0.2) {
    let _db = openDB()
    let _txtSaveStatement = ""
    let _result
    let _success = false
    let _errorMsg = ""
    let _exists = false

    if (txtNewDisplayName !== txtDisplayName) {
        let _existsResult = checkProfileIfExist(txtDisplayName)
        _exists = _existsResult.success && _existsResult.exists
    }

    // Do not save when opacity is too big
    let _saveOverlayOpacity = txtOverlayOpacity > 0.6 ? 0.6 : txtOverlayOpacity

    _txtSaveStatement = "UPDATE profiles SET display_name = ?, enable_overlay = ?, overlay_color = ?, overlay_opacity = ? WHERE profile_id = ?"

    if (!_exists) {
        try {
            _db.transaction(function (tx) {
                tx.executeSql(_txtSaveStatement, [ txtNewDisplayName, boolEnableOverlay, txtOverlayColor, _saveOverlayOpacity, intProfileId ])
            })

            _success = true
        } catch (err) {
            console.log("Database error: " + err)
            _errorMsg = err
            _success = false
        }
    } else {
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg, "exists": _exists}

    return _result
}

function deleteProfile(intProfileId) {
    let _txtSqlStatement = ""
    let _db = openDB()
    let _success
    let _errorMsg
    let _result

    // FIXME: Deactivate a profile if it has expense data until proper archiving is implemented
    if (checkProfileData(intProfileId)) {
        _txtSqlStatement = 'UPDATE profiles set active = 0 WHERE profile_id = ?'
    } else {
        _txtSqlStatement = 'DELETE FROM profiles WHERE profile_id = ?'
        deleteProfileCategories(intProfileId)
        deleteProfileQuickExpenses(intProfileId)
    }

    try {
        _db.transaction(function (tx) {
            tx.executeSql(_txtSqlStatement, [intProfileId])
        })

        _success = true
    } catch (err) {
        console.log("Database error: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg}
    
    return _result
}

// Check if profile has expense data
function checkProfileData(intProfileId) {
    let _db = openDB()
    let _rs = null
    let _exists

    _db.transaction(function (tx) {
        _rs = tx.executeSql("SELECT 1 FROM expenses WHERE profile_id = ?", [intProfileId])

        _exists = _rs.rows.length === 0 ? false : true
    })

    return _exists
}

function deleteProfileCategories(intProfileId) {
    let _db = openDB()

    _db.transaction(function (tx) {
        tx.executeSql("DELETE FROM categories WHERE profile_id = ?", [intProfileId])
    })
}

function deleteProfileQuickExpenses(intProfileId) {
    let _db = openDB()

    _db.transaction(function (tx) {
        tx.executeSql("DELETE FROM quick_expenses WHERE profile_id = ?", [intProfileId])
    })
}

function getCurrencies() {
    let _db = openDB()
    let _arrResults = []
    let _rs = null
    let _txtSelectStatement = ""

    _txtSelectStatement = "SELECT * FROM currencies"

    _db.transaction(function (tx) {
        _rs = tx.executeSql(_txtSelectStatement)

        _arrResults.length = _rs.rows.length

        for (let i = 0; i < _rs.rows.length; i++) {
            _arrResults[i] = _rs.rows.item(i)
        }
    })

    return _arrResults
}

function getDateWithData(forward, intProfileId, txtCategory, txtDateBase, txtScope) {
    let _db = openDB()
    let _rs = null
    let _txtSelectStatement
    let _txtWhereStatement
    let _txtFullStatement
    let _arrArgs = []
    let _lastDate

    _db.transaction(function (tx) {
        _txtWhereStatement = "WHERE profile_id = ?"

        if (forward) {
            _txtSelectStatement = "SELECT min((strftime('%Y-%m-%d %H:%M:%f', date, 'localtime'))) as entry_date"
            switch (txtScope) {
                case "week":
                    _txtWhereStatement = _txtWhereStatement + " AND  date(date, 'localtime') > date(?,'weekday 6')"
                    break
                case "month":
                    _txtWhereStatement = _txtWhereStatement + " AND  date(date, 'localtime') > date(?,'start of month','+1 month','-1 day')"
                    break
                case "day":
                default:
                    _txtWhereStatement = _txtWhereStatement + " AND date(date, 'localtime') > date(?)"
            }
        } else {
            _txtSelectStatement = "SELECT max((strftime('%Y-%m-%d %H:%M:%f', date, 'localtime'))) as entry_date"

            switch (txtScope) {
                case "week":
                    _txtWhereStatement = _txtWhereStatement + " AND  date(date, 'localtime') <  date(?,'weekday 6','-6 days')"
                    break
                case "month":
                    _txtWhereStatement = _txtWhereStatement + " AND  date(date, 'localtime') < date(?,'start of month')"
                    break
                case "day":
                default:
                    _txtWhereStatement = _txtWhereStatement + " AND date(date, 'localtime') < date(?)"
            }
        }

        _txtSelectStatement = _txtSelectStatement + " FROM expenses_vw"

        if (txtCategory !== "all") {
            _txtWhereStatement = _txtWhereStatement + " AND category_name = ?"
            _arrArgs = [intProfileId, txtDateBase, txtCategory]
        } else {
            _arrArgs = [intProfileId, txtDateBase]
        }

        _txtFullStatement = [_txtSelectStatement, _txtWhereStatement].join(" ")
        _rs = tx.executeSql(_txtFullStatement, _arrArgs)
        _lastDate = _rs.rows.item(0).entry_date
    })

    return _lastDate
}

function getCategoryBreakdown(intProfileId, txtRange, txtFromDate, txtToDate) {
    let _db = openDB()
    let _arrResults = []
    let _rs = null
    let _txtStatement = ""
    let _txtSelectStatement = ""
    let _txtFromStatement = ""
    let _txtWhereStatement = ""
    let _txtGroupStatement = ""
    let _txtFromRecord = ""
    let _isCustom = false

    _txtSelectStatement = "SELECT expense.category_name, TOTAL(expense.value) as total, IFNULL(category.color, 'black') as color"
    _txtWhereStatement = "WHERE expense.profile_id = ?"
    _txtGroupStatement = "GROUP BY expense.category_name"

    switch (txtRange) {
        case "today":
            _txtFromRecord = "expenses_today"
            break
        case "yesterday":
            _txtFromRecord = "expenses_yesterday"
            break
        case "thisweek":
            _txtFromRecord = "expenses_thisweek"
            break
        case "lastweek":
            _txtFromRecord = "expenses_lastweek"
            break
        case "recent":
            _txtFromRecord = "expenses_recent"
            break
        case "previousrecent":
            _txtFromRecord = "expenses_previousrecent"
            break
        case "thismonth":
            _txtFromRecord = "expenses_thismonth"
            break
        case "lastmonth":
            _txtFromRecord = "expenses_lastmonth"
            break
        case "thisyear":
            _txtFromRecord = "expenses_thisyear"
            break
        case "lastyear":
            _txtFromRecord = "expenses_lastyear"
            break
        default:
            _txtFromRecord = "expenses_vw"
            _txtWhereStatement = [_txtWhereStatement, "AND date(date, 'localtime') BETWEEN date(?,'localtime') AND date(?,'localtime')"].join(" ")
            _isCustom = true
            break
    }

    _txtFromStatement = "FROM " + _txtFromRecord + " expense LEFT OUTER JOIN categories category USING(profile_id, category_name)"

    _txtStatement = [_txtSelectStatement, _txtFromStatement, _txtWhereStatement, _txtGroupStatement].join(" ")

    _db.transaction(function (tx) {
        if (_isCustom) {
            _rs = tx.executeSql(_txtStatement, [intProfileId, txtFromDate, txtToDate])
        } else {
            _rs = tx.executeSql(_txtStatement, [intProfileId])
        }

        _arrResults.length = _rs.rows.length

        for (let i = 0; i < _rs.rows.length; i++) {
            _arrResults[i] = _rs.rows.item(i)
        }
    })

    return _arrResults
}

function getExpenseTrend(intProfileId, txtRange, txtMode, arrCategories, txtFromDate, txtToDate) {
    let _db = openDB()
    let _arrResults = []
    let _rs = null
    let _txtFullStatement = ""
    let _txtSelectStatement = ""
    let _txtSelectLabel = ""
    let _txtFromStatement = ""
    let _txtMainRecord = ""
    let _txtDateListRecord = ""
    let _txtWhereStatement = ""
    let _txtExtraWhereStatement = ""
    let _txtCategoryWhereStatement = ""
    let _txtGroupStatement = ""
    let _txtOrderStatement = ""
    let _isCustom = false

    _txtWhereStatement = "ON profile_id = ?"
    _txtGroupStatement = "GROUP BY label"
    _txtOrderStatement = "ORDER BY label ASC"

    switch (txtMode) {
        case "day":
            _txtSelectLabel = "datelist.date"
            if (txtRange == "thismonth" || txtRange == "lastmonth") {
                _txtExtraWhereStatement = "AND strftime('%d', date(expense.date, 'localtime')) = datelist.day_num"
            } else {
                _txtExtraWhereStatement = "AND strftime('%w', date(expense.date, 'localtime')) = datelist.day_num"
            }
            break
        case "week":
            if (txtRange == "thismonth" || txtRange == "lastmonth") {
                _txtSelectLabel = "ROW_NUMBER() OVER(ORDER BY datelist.date)"
                _txtGroupStatement = "GROUP BY strftime('%W', datelist.date)"
            } else {
                _txtSelectLabel = "strftime('%W', datelist.date)"
            }
            _txtExtraWhereStatement = "AND strftime('%W', date(expense.date, 'localtime')) = datelist.week_num"
            break
        case "month":
            _txtSelectLabel = "datelist.month_num"
            _txtExtraWhereStatement = "AND strftime('%m', date(expense.date, 'localtime')) = datelist.month_num"
            break
        default:
            _txtSelectLabel = "strftime(?, date)"
            break
    }

    switch (txtRange) {
        case "today":
            _txtMainRecord = "expenses_today"
            break
        case "yesterday":
            _txtMainRecord = "expenses_yesterday"
            break
        case "thisweek":
            _txtMainRecord = "expenses_thisweek"
            _txtDateListRecord = "datelist_daysOfThisWeek"
            break
        case "lastweek":
            _txtMainRecord = "expenses_lastweek"
            _txtDateListRecord = "datelist_daysOfLastWeek"
            break
        case "recent":
            _txtMainRecord = "expenses_recent"
            _txtDateListRecord = "datelist_daysOfRecent"
            break
        case "previousrecent":
            _txtMainRecord = "expenses_previousrecent"
            _txtDateListRecord = "datelist_daysOfPreviousRecent"
            break
        case "thismonth":
            _txtMainRecord = "expenses_thismonth"
            if (txtMode =="day") {
                _txtDateListRecord = "datelist_daysOfThisMonth"
            } else if (txtMode =="week") {
                _txtDateListRecord = "datelist_weeksOfThisMonth"
            }
            break
        case "lastmonth":
            _txtMainRecord = "expenses_lastmonth"
            if (txtMode =="day") {
                _txtDateListRecord = "datelist_daysOfLastMonth"
            } else if (txtMode =="week") {
                _txtDateListRecord = "datelist_weeksOfLastMonth"
            }
            break
        case "thisyear":
            _txtMainRecord = "expenses_thisyear"
            if (txtMode =="week") {
                _txtDateListRecord = "datelist_weeksOfThisYear"
            } else if (txtMode =="month") {
                _txtDateListRecord = "datelist_monthsOfYear"
            }
            break
        case "lastyear":
            _txtMainRecord = "expenses_lastyear"
            if (txtMode =="week") {
                _txtDateListRecord = "datelist_weeksOfLastYear"
            } else if (txtMode =="month") {
                _txtDateListRecord = "datelist_monthsOfYear"
            }
            break
        default:
            _txtMainRecord = "expenses_vw"
            // TODO: Properly implement custom date range
            _txtWhereStatement = [_txtWhereStatement, "AND date(date, 'localtime') BETWEEN date(?,'localtime') AND date(?,'localtime')"].join(" ")
            _isCustom = true
            break
    }

    _txtSelectStatement = 'SELECT ' + _txtSelectLabel + ' as label, TOTAL(value) as total'
    _txtFromStatement = ["FROM", _txtDateListRecord, "datelist LEFT OUTER JOIN", _txtMainRecord, "expense"].join(" ")

    if (arrCategories && arrCategories.length > 0) {
        _txtCategoryWhereStatement = "AND ("
        for (let i= 0; i < arrCategories.length; i++) {
            if (i == 0) {
                _txtCategoryWhereStatement = _txtCategoryWhereStatement + "expense.category_name = " + "'" + arrCategories[i] + "'"
            } else {
                _txtCategoryWhereStatement = _txtCategoryWhereStatement + " OR expense.category_name = " + "'" + arrCategories[i] + "'"
            }
        }
        _txtCategoryWhereStatement = _txtCategoryWhereStatement + ")"
    }

    _txtFullStatement = [_txtSelectStatement, _txtFromStatement
                                , _txtWhereStatement, _txtExtraWhereStatement, _txtCategoryWhereStatement
                                , _txtGroupStatement, _txtOrderStatement].join(" ")

    //~ console.log(_txtFullStatement)
    _db.transaction(function (tx) {
        if (_isCustom) {
            _rs = tx.executeSql(_txtFullStatement, [intProfileId, fromDate, toDate])
        } else {
            _rs = tx.executeSql(_txtFullStatement, intProfileId)
        }

        _arrResults.length = _rs.rows.length

        for (let i = 0; i < _rs.rows.length; i++) {
            _arrResults[i] = _rs.rows.item(i)
        }
    })

    return _arrResults
}

function getTopExpenses(intProfileId, txtSearchText, intLimit=10) {
    let db = openDB()
    let arrResults = []
    let rs = null
    let txtFullStatement = ""
    let txtSelectStatement = ""
    let txtFromStatement = ""
    let txtWhereStatement = ""
    let txtOrderStatement = ""
    let txtGroupStatement = ""
    let txtLimitStatement = ""

    txtSelectStatement = "SELECT name, category_name, value, COUNT(*) as count"
    txtFromStatement = "FROM expenses_vw"
    txtWhereStatement = "WHERE profile_id = ? AND name LIKE ?"
    txtGroupStatement = "GROUP BY name, category_name, value"
    txtOrderStatement = "ORDER BY count desc"
    txtLimitStatement = "LIMIT ?"
    txtFullStatement = [txtSelectStatement, txtFromStatement, txtWhereStatement, txtGroupStatement, txtOrderStatement, txtLimitStatement].join(" ")
    //console.log(txtSelectStatement)
    db.transaction(function (tx) {
        if (txtSearchText) {
            let wildcard = "%" + txtSearchText + "%"
            rs = tx.executeSql(txtFullStatement, [intProfileId, wildcard, intLimit])
        } else {
            rs = tx.executeSql(txtFullStatement, [intProfileId, intLimit])
        }

        arrResults.length = rs.rows.length

        for (let i = 0; i < rs.rows.length; i++) {
            arrResults[i] = rs.rows.item(i)
        }
    })

    return arrResults
}

function getHistoryExpenses(intProfileId, txtSearchText, intLimit=10) {
    let db = openDB()
    let arrResults = []
    let rs = null
    let txtFullStatement = ""
    let txtSelectStatement = ""
    let txtFromStatement = ""
    let txtLimitStatement = ""

    // List items that match the name before descr
    txtSelectStatement = "SELECT DISTINCT name, category_name, descr, value, home_currency, travel_currency, rate, travel_value"
    txtFromStatement = "FROM ( \
                        SELECT name, category_name, descr, value, date, home_currency, travel_currency, rate, travel_value, 1 as score \
                        FROM expenses_vw \
                        WHERE profile_id = ? \
                        AND (UPPER(name) LIKE UPPER(?) \
                        OR name GLOB ?) \
                        GROUP BY name, category_name, descr, value \
                        UNION \
                        SELECT name, category_name, descr, value, date, home_currency, travel_currency, rate, travel_value, 0 as score \
                        FROM expenses_vw \
                        WHERE profile_id = ? \
                        AND (UPPER(descr) LIKE UPPER(?) \
                        OR descr GLOB ?) \
                        GROUP BY name, category_name, descr, value \
                        ORDER BY score desc, date DESC \
                        )"
    txtLimitStatement = "LIMIT ?"
    txtFullStatement = [txtSelectStatement, txtFromStatement, txtLimitStatement].join(" ")
    //console.log(txtSelectStatement)
    db.transaction(function (tx) {
        let _likeText = processTextForLIKE(txtSearchText)
        let _globText = processTextForGLOB(txtSearchText)
        rs = tx.executeSql(txtFullStatement, [intProfileId, _likeText, _globText, intProfileId, _likeText, _globText, intLimit])

        arrResults.length = rs.rows.length

        for (let i = 0; i < rs.rows.length; i++) {
            arrResults[i] = rs.rows.item(i)
        }
    })

    return arrResults
}

function searchExpenses(intProfileId, txtSearchText, intLimit=10, txtSort ="desc") {
    let arrResults = []

    if (txtSearchText.trim() !== "") {
        let db = openDB()
        let rs = null
        let txtFullStatement = ""
        let txtSelectStatement = ""
        let txtFromStatement = ""
        let txtWhereStatement = ""
        let txtOrderStatement = ""
        let txtLimitStatement = ""
        let txtFullSearchTextGLOB = processTextForGLOB(txtSearchText)
        let txtFullSearchTextLIKE = processTextForLIKE(txtSearchText)
        let arrBindValues = [txtFullSearchTextGLOB, txtFullSearchTextGLOB, txtFullSearchTextLIKE, txtFullSearchTextLIKE]
        let txtSortBy = txtSort == "asc" ? "ASC" : "DESC"

        txtSelectStatement = "SELECT expense_id, category_name, name, descr, strftime('%Y-%m-%d %H:%M:%f', date, 'localtime') as entry_date \
                                , value, home_currency, travel_currency, rate, travel_value \
                                , CASE WHEN name GLOB ? THEN 1 \
                                     WHEN descr GLOB ? THEN 2 \
                                     WHEN name LIKE ? THEN 3 \
                                     WHEN descr LIKE ? THEN 4"

        let _arrSearchTerms = txtSearchText.split(" ")

        for (let i = 0; i < _arrSearchTerms.length; i++) {
            let _term = _arrSearchTerms[i]
            // Continue counting the score from 4 then continue from 8
            let _score = (4 * (i + 1)) + 1
            txtSelectStatement = txtSelectStatement + " WHEN name GLOB ? THEN " + _score
            txtSelectStatement = txtSelectStatement + " WHEN descr GLOB ? THEN " + (_score + 1)
            txtSelectStatement = txtSelectStatement + " WHEN name LIKE ? THEN " + (_score + 2)
            txtSelectStatement = txtSelectStatement + " WHEN descr LIKE ? THEN " + (_score + 3)
            
            let _txtTermGLOB = processTextForGLOB(_term)
            let _txtTermLIKE = processTextForLIKE(_term)
            arrBindValues.push(_txtTermGLOB, _txtTermGLOB, _txtTermLIKE, _txtTermLIKE)
        }

        txtSelectStatement = txtSelectStatement + " END as score"

        arrBindValues.push(intProfileId)

        txtFromStatement = "FROM expenses_vw"
        txtWhereStatement = "WHERE profile_id = ? AND ("

        for (let i = 0; i < _arrSearchTerms.length; i++) {
            let _term = _arrSearchTerms[i]

            if (i == 0) {
                txtWhereStatement = txtWhereStatement + "name GLOB ?"
            } else {
                txtWhereStatement = txtWhereStatement + " OR name GLOB ?"
            }
            txtWhereStatement = txtWhereStatement + " OR descr GLOB ?"
            txtWhereStatement = txtWhereStatement + " OR name LIKE ?"
            txtWhereStatement = txtWhereStatement + " OR descr LIKE ?"

            let _txtTermGLOB = processTextForGLOB(_term)
            let _txtTermLIKE = processTextForLIKE(_term)
            arrBindValues.push(_txtTermGLOB, _txtTermGLOB, _txtTermLIKE, _txtTermLIKE)
        }
        txtWhereStatement = txtWhereStatement + ")"
        txtOrderStatement = "ORDER BY score ASC, entry_date " + txtSortBy
        txtLimitStatement = "LIMIT ?"
        arrBindValues.push(intLimit)
        txtFullStatement = [txtSelectStatement, txtFromStatement, txtWhereStatement, txtOrderStatement, txtLimitStatement].join(" ")
        //~ console.log(txtFullStatement)
        //~ console.log(JSON.stringify(arrBindValues))
        db.transaction(function (tx) {
            rs = tx.executeSql(txtFullStatement, arrBindValues)

            arrResults.length = rs.rows.length

            for (let i = 0; i < rs.rows.length; i++) {
                arrResults[i] = rs.rows.item(i)
            }
        })
    }

    return arrResults
}



function addTravelData(id, travelData) {
    let txtSaveStatement
    let db = openDB()
    let rs = null

    let _txtHomeCurrency = travelData.homeCur
    let _txtTravelCurrency = travelData.travelCur
    let _realRate = travelData.rate
    let _realValue = travelData.value

    txtSaveStatement = 'INSERT INTO travel_expenses (expense_id, home_currency, travel_currency, rate, value) VALUES(?, ?, ?, ?, ?)'

    db.transaction(function (tx) {
        tx.executeSql(txtSaveStatement,
                      [id, _txtHomeCurrency, _txtTravelCurrency, _realRate, _realValue])
    })
}

function updateTravelExpense(id, travelData) {
    let _db = openDB()

    let _homeCur = travelData.homeCur
    let _travelCur = travelData.travelCur
    let _rate = travelData.rate
    let _value = travelData.value

    _db.transaction(function (tx) {
        tx.executeSql(
                    "UPDATE travel_expenses SET home_currency = ?, travel_currency = ?, rate = ?, value = ? WHERE expense_id = ?",
                    [_homeCur, _travelCur, _rate, _value, id])
    })
}

function getQuickExpenses(intProfileId, txtSearchText) {
    let db = openDB()
    let arrResults = []
    let rs = null
    let txtSelectStatement = ""
    let txtWhereStatement = "WHERE profile_id = ?"
    let txtWhereStatement2 = ""
    let txtOrderStatement = ""

    txtOrderStatement = "ORDER BY name asc"

    txtSelectStatement = 'SELECT quick_id, category_name, name, descr, value FROM quick_expenses'
    if(txtSearchText){
        txtWhereStatement2 = "AND (category_name LIKE ? OR name LIKE ? OR descr LIKE ?)"
    }

    txtSelectStatement = [txtSelectStatement, txtWhereStatement, txtWhereStatement2, txtOrderStatement].join(" ")
    //~ console.log(txtSelectStatement)
    db.transaction(function (tx) {
        if (txtSearchText) {
            let wildcard = "%" + txtSearchText + "%"
            rs = tx.executeSql(txtSelectStatement, [intProfileId, wildcard, wildcard, wildcard])
        } else {
            rs = tx.executeSql(txtSelectStatement, [intProfileId])
        }

        arrResults.length = rs.rows.length

        for (let i = 0; i < rs.rows.length; i++) {
            arrResults[i] = rs.rows.item(i)
        }
    })

    return arrResults
}

function addQuickExpense(intProfileId, expenseData) {
    let _db = openDB()
    let _rs = null
    let _success
    let _errorMsg
    let _result

    let _txtSaveStatement = 'INSERT INTO quick_expenses(profile_id, category_name, name, descr, value) VALUES(?,?,?,?,?)'

    let _txtName = expenseData.name
    let _txtCategory = expenseData.category
    let _txtDescr = expenseData.description
    let _realValue = expenseData.value

    let _existsResult = checkIfQuickExpenseExists(intProfileId, expenseData)

    if (_existsResult.success && !_existsResult.exists) {
        try {
            _db.transaction(function (tx) {
                tx.executeSql(_txtSaveStatement, [intProfileId, _txtCategory, _txtName, _txtDescr, _realValue])
            })

            _success = true
        } catch (err) {
            console.log("Database error: " + err)
            _errorMsg = err
            _success = false
        }
    } else {
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg, "exists": _existsResult.exists}
    
    return _result
}

function editQuickExpense(intProfileId, quickData) {
    let _db = openDB()
    let _rs = null
    let _success
    let _errorMsg
    let _result

    let _txtSaveStatement = 'UPDATE quick_expenses SET category_name = ?, name = ? , descr = ?, value = ? WHERE profile_id = ? AND quick_id = ?'

    let _txtID = quickData.id
    let _txtName = quickData.name
    let _txtCategory = quickData.category
    let _txtDescr = quickData.description
    let _realValue = quickData.value

    let _existsResult = checkIfQuickExpenseExists(intProfileId, quickData)

    if (_existsResult.success && !_existsResult.exists) {
        try {
            _db.transaction(function (tx) {
                tx.executeSql(_txtSaveStatement, [_txtCategory, _txtName, _txtDescr, _realValue, intProfileId, _txtID])
            })

            _success = true
        } catch (err) {
            console.log("Database error: " + err)
            _errorMsg = err
            _success = false
        }
    } else {
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg, "exists": _existsResult.exists}
    
    return _result
}

function deleteQuickExpense(intProfileId, txtID) {
    let _db = openDB()
    let _rs = null
    let _success
    let _errorMsg
    let _result
    let _txtDeleteStatement = 'DELETE FROM quick_expenses WHERE profile_id = ? AND quick_id = ?'

    try {
        _db.transaction(function (tx) {
            tx.executeSql(_txtDeleteStatement, [intProfileId, txtID])
        })

        _success = true
    } catch (err) {
        console.log("Database error: " + err)
        _errorMsg = err
        _success = false
    }

    _result = { "success": _success, "error": _errorMsg }
    
    return _result
}

function checkIfQuickExpenseExists(intProfileId, expenseData) {
    let _db = openDB()
    let _rs = null
    let _success
    let _errorMsg
    let _result
    let _exists = false

    let _txtSelectStatement = 'SELECT 1 FROM quick_expenses WHERE profile_id = ? AND category_name = ? AND name = ? AND descr = ? AND value = ?'

    let _txtName = expenseData.name
    let _txtCategory = expenseData.category
    let _txtDescr = expenseData.description
    let _realValue = expenseData.value

    try {
        _db.transaction(function (tx) {
            _rs = tx.executeSql(_txtSelectStatement, [intProfileId, _txtCategory, _txtName, _txtDescr, _realValue])
            _exists = _rs.rows.length > 0
        })

        _success = true
    } catch (err) {
        console.log("Database error: " + err)
        _errorMsg = err
        _success = false
    }

    _result = {"success": _success, "error": _errorMsg, "exists": _exists}
    
    return _result
}

function deleteTravelExpense(txtExpenseID) {
    var txtDeleteStatement
    var db = openDB()

    txtDeleteStatement = 'DELETE FROM travel_expenses WHERE expense_id = ?'

    db.transaction(function (tx) {
        tx.executeSql(txtDeleteStatement, [txtExpenseID])
    })
}
