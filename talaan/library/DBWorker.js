.pragma library

Qt.include("MetaData.js",WorkerScript.onMessage);

WorkerScript.onMessage = function(message) {
    // ... long-running operations and calculations are done here
    console.log("eto yung message" + message.Initialize);

    //meteDataCheck()
    if( message.Initialize === "True"){
        console.log("pasok pagcreate");
        createMetaTables();
        createInitialData();
    }
   WorkerScript.sendMessage({ 'reply': 'Meta Tables and Data were created' })
}

