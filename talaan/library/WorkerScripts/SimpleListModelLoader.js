WorkerScript.onMessage = function (msg) {

    if (msg.model) {
        msg.model.clear()
    }

    switch (msg.mode) {
    case "Currencies":
        var txtCode, txtDescr, txtSysmbol

        for (var i = 0; i < msg.result.length; i++) {
            txtCode = msg.result[i].currency_code
            txtDescr = msg.result[i].description
            txtSysmbol = msg.result[i].symbol
            msg.model.append({
                                 currency_code: txtCode,
                                 descr: txtDescr,
                                 symbol: txtSysmbol
                             })
        }
        break
    }

    if (msg.model) {
        msg.model.sync() // updates the changes to the list
        msg.model.clear(
                    ) //clear model after sync to remove from memory (assumption only :))
    }

    WorkerScript.sendMessage({
                                 mode: msg.mode,
                                 result: result
                             })
}
