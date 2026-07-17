import QtQuick 2.12
import "../library/functions.js" as Functions

QtObject {
    id: listItemData

    property string itemName: ""
    property string comments: ""
    property int listId: -1
    property int status: 0
    property int priority: 0

    function reset() {
        itemName = ""
        comments = ""
        listId = -1
        status = 0
        priority = 0
    }
}
