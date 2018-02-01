import QtQuick 2.4
import Ubuntu.Components 1.3
import QtOrganizer 5.0

Item {
    property alias model: organizerModel

    function createReminder(reminder_id,title,datetime){
        organizerItem.collectionId = "talaan_reminders"
        organizerItem.guid = reminder_id
        todo.startDateTime = datetime
        todo.displayLabel = title
        visualReminder.message = title
        visualReminder.repetitionCount = 1
        todo.setDetail(visualReminder)
        organizerItem.setDetail(todo)
        organizerItem.save()
        //collection.setMetaData(collection.KeyName,"Talaan")
        collection.setExtendedMetaData("collection-type", "Talaan Reminders");
        organizerModel.saveCollection(collection)
        organizerModel.saveItem(organizerItem)
        console.log("reminder saved")
    }

    OrganizerModel{
        id: organizerModel
        manager: "memory"
        Component.onCompleted: {
            var date = new Date();
            date.setFullYear("1900")
            startPeriod = date
            date.setFullYear("2100")
            endPeriod = date
            update()
        }
    }

    Collection{
        id: collection
        collectionId: "TALAAN"
        color: "#371300"
        description: "Talaan Reminders"
        name: "Talaan"
    }

    OrganizerItem{
        id: organizerItem
    }

    Todo{
        id: todo
    }
    VisualReminder{
        id: visualReminder
    }
}

