import QtQuick 2.12
import "../library/functions.js" as Functions

QtObject {
    id: listData
    
    property int listId: -1
    property string listName: ""
    property string description: ""
    property string type: "checklist"
    property string categoryName: i18n.tr("Uncategorized")
    property string creationDate: Functions.getToday()
    property string modifiedDate: Functions.getToday()
    property string completionDate: ""
    property string targetDate: ""
    property int status: 0
    property bool isFavorite: false
    property int itemCount: 0
    property int checkedCount: 0

    function reset() {
        listId = -1
        listName = ""
        description = ""
        type = "checklist"
        categoryName = ""
        creationDate = Functions.getToday()
        modifiedDate = Functions.getToday()
        completionDate = ""
        targetDate = ""
        status = 0
        isFavorite = true
        itemCount = 0
        checkedCount = 0
    }
}
