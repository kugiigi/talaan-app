.pragma library

.import QtQuick.LocalStorage 2.0 as Sql
.import "DBUtilities.js" as DB
.import "DataProcess.js" as DataProcess


function meteDataCheck(){
    var db = openMetaDB();
    var rs = null;
    var boolInitMeta = 'False';
    var prevDBVersion = '';
    var curDBVersion = '';
    var txtFile = Qt.resolvedUrl("../Databases/db_version.txt");
    var req = new XMLHttpRequest();

    req.open("GET", txtFile, true);
    req.send(null);
    req.onreadystatechange = function()
    {
        if (req.readyState == 4)
        {
            var curDBVersion = req.responseText.split;
            try {
                db.transaction(function(tx){
                rs = tx.executeSql('SELECT version from version');
                prevDBVersion = rs.rows.item(0).version;
                    if(prevDBVersion !== curDBVersion){
                        boolInitMeta = "True";
                        console.log("New DB Vresion Available");
                    }
                });

            } catch (err) {
                boolInitMeta = "True";
                console.log("First Application Run - " + err);
            };
        }
    }

    return boolInitMeta;
 }

function createMetaTables() {//Creates or recreate Meta-Tables

    var db = openMetaDB();
    var rs = null;
    var txtFile = Qt.resolvedUrl("../Databases/MetaData.txt");
    var req = new XMLHttpRequest();

    try{//DROP TABLE first if already exists
        db.transaction(function(tx){
            rs = tx.executeSql('SELECT name FROM my_db.sqlite_master WHERE type=?;', 'table');

            for(var i = 0; i < rs.rows.length; i++) {
               tx.executeSql('DROP TABLE ?',rs.rows(i));
            }

        });
    }catch (err) {
        console.log('No Meta-Table exists yet - ' + err);
    };

    req.open("GET", txtFile, true);
    req.send(null);
    req.onreadystatechange = function()
    {
        if (req.readyState == 4)
        {
            var lines = req.responseText.split("\n")
            for(var l = 0; l < lines.length-1; l++)
            {
            db.transaction(function(tx){
                tx.executeSql(lines[l]);
            });
            }
        }
    }
}

function createInitialData(){ //Create or Recreate Data needed by the App
DataProcess.createMetaTables();
DataProcess.initiateData();
}

//Database Changes for User Version 1
function executeUserVersion1(){
    var db = DataProcess.openDB();
    var currentDataBaseVersion

    currentDataBaseVersion = DataProcess.checkUserVersion()

    if(currentDataBaseVersion < 1){
        db.transaction(function (tx) {
            tx.executeSql('ALTER TABLE items ADD COLUMN priority TEXT DEFAULT Normal');
        });
        console.log("Database Upgraded to 1")
        DataProcess.upgradeUserVersion()
    }
}

//Database Changes for User Version 2
function executeUserVersion2(){
    var db = DataProcess.openDB();
    var currentDataBaseVersion

    currentDataBaseVersion = DataProcess.checkUserVersion()

    if(currentDataBaseVersion < 2){
        db.transaction(function (tx) {
            tx.executeSql('UPDATE checklist SET status = "saved" WHERE status = "favorited"');
            tx.executeSql('ALTER TABLE checklist ADD COLUMN favorite INTEGER DEFAULT 0');
        });
        console.log("Database Upgraded to 2")
        DataProcess.upgradeUserVersion()
    }
}

//Database Changes for User Version 3
function executeUserVersion3(){
    var db = DataProcess.openDB();
    var currentDataBaseVersion

    currentDataBaseVersion = DataProcess.checkUserVersion()

    if(currentDataBaseVersion < 3){
        db.transaction(function (tx) {
            tx.executeSql('ALTER TABLE checklist ADD COLUMN continual INTEGER DEFAULT 0');
        });
        console.log("Database Upgraded to 3")
        DataProcess.upgradeUserVersion()
    }
}






