WorkerScript.onMessage = function (msg) {


    msg.model.clear()

    console.log("trailing: " + msg.trailing[1].iconName);
    console.log("msg.hideTrailingActions: " + msg.hideTrailingActions);
    if (!msg.hideTrailingActions) {

        for (var i = msg.trailing.length - 1; i > -1; i--) {
            if (msg.trailing[i].visible) {
                msg.model.append({
                                     action: msg.trailing[i]
                                 })
            }
        }
    }

    if (!msg.hideLeadingActions) {
        for (var i = 0; i < msg.leading.length; i++) {
            if (msg.leading[i].visible) {
                msg.model.append({
                                     action: msg.leading[i]
                                 })
            }
        }
    }

    if (msg.navigation.length > 0) {
        msg.model.append({
                             action: msg.customActions
                         })
    }

    msg.model.sync() // updates the changes to the list
    msg.model.clear() //clear model after sync to remove from memory (assumption only :))
    WorkerScript.sendMessage()
}
