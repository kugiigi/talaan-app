import QtQuick 2.4
import Lomiri.Components 1.3
import Lomiri.Components.Popups 1.3
import "../library/ProcessFunc.js" as Process

Item {
    id: alarmReminder

    function createNew(checklistid, title, target_dt,offset, silent) {
        var alarmTime = target_dt
        switch(offset){
        case "OneHour":
                alarmTime.subtractHours(1)
        break
        case "TwoHour":
            alarmTime.subtractHours(2)
        break
        case "OneDay":
            alarmTime.subtractDays(1)
        break
        case "TwoDay":
            alarmTime.subtractDays(2)
        break
        case "OneWeek":
            alarmTime.subtractWeeks(1)
        break
        case "TwoWeek":
            alarmTime.subtractWeeks(2)
        break
        case "OneMonth":
            alarmTime.subtractMonths(1)
        break
        case "TwoMonth":
            alarmTime.subtractMonths(2)
        break
        default:
            //retain target date
        break
        }

        if(silent){
            alarm.sound = "dummy"
        }

        alarm.message = "[Talaan] " + title + " (" + checklistid + ")"
        console.log(alarmTime)
        alarm.date = alarmTime
        alarm.save()
        if (alarm.error != Alarm.NoError) {
            console.log("error saving: " + alarm.error)
            mainView.notification.showNotification(
                        i18n.tr(
                            "Reminder was not set successfully"),
                        LomiriColors.red)
            PopupUtils.open(dialogError)
        }else{
            mainView.notification.showNotification(
                        i18n.tr(
                            "Reminder successfully set"),
                        LomiriColors.green)
        }
    }

    function getActualMessage(message){
        var prefix = "[Talaan] "
        var preIndex = prefix.length
        var postIndex = message.search(/\(\d{1,}\)$/)
        var newMessage = message.substring(preIndex,postIndex)
        return newMessage
    }

//    function loadAlarm(alarmObject){
//        alarm =  alarmObject
//    }

    Alarm {
        id: alarm
        onStatusChanged: {
            if (status !== Alarm.Ready)
                return
            if ((operation > Alarm.NoOperation)
                    && (operation < Alarm.Reseting)) {
                reset()
            }
        }
    }

    Component{
      id: dialogError
      Dialog {
          id: dialogueError

          title: i18n.tr("Error saving the Reminder")
          text: i18n.tr("The Target Date might have already passed or the intended reminder is set in the past")

          Button {
              color: theme.palette.normal.base
              text: i18n.tr("OK")
              onClicked: {
                  PopupUtils.close(dialogueError)
              }
          }
      }
    }
}
