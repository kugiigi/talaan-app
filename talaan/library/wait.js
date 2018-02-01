.pragma library

WorkerScript.onMessage = function(message) {
    var start = new Date().getTime()
    for (var i = 0; i < 1e7; i++) {
        if ((new Date().getTime() - start) > message.duration) {
            break
        }
    }
    WorkerScript.sendMessage({ result: true})
}

