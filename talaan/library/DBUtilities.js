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

//update database
function updateDB(txtStatement) {
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql(txtStatement)
    })
}

//select data from database
function selectDB(txtStatement) {
    var db = openDB()
    var rs = null
    var arrResult = []

    db.transaction(function (tx) {
        rs = tx.executeSql(txtStatement)
        arrResult.length = rs.rows.length

        for (var i = 0; i < rs.rows.length; i++) {
            //add new row in the array
            arrResult[i] = []

            //assign values to the array
            arrResult[i] = rs.rows.item(i)
        }
    })
    return arrResult
}

//insert data to database
function insertDB(txtStatement) {
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

//delete data from database
function deleteDB(txtStatement) {
    var db = openDB()

    db.transaction(function (tx) {
        tx.executeSql(txtStatement)
    })
}

//Create table in database
function createDB(txtStatement) {
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
