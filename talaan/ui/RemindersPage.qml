import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes.Ambiance 1.3
import "../components"
import "../components/Dialogs"
import "../library"
import Ubuntu.Components.Popups 1.3
import Ubuntu.Layouts 1.0
import "../library/DataProcess.js" as DataProcess
import "../library/ProcessFunc.js" as Process

//Page {
PageWithBottom{
    id: pageReminders

    property string pagemode

    header: PageHeader {
        title: i18n.tr("Reminders")

        StyleHints {
            backgroundColor: switch (settings.currentTheme) {
                             case "Default":
                                 "#3D1400"
                                 break
                             case "Ambiance":
                                 theme.palette.normal.background
                                 break
                             case "SuruDark":
                                 theme.palette.normal.foreground
                                 break
                             default:
                                 "#3D1400"
                             }
            dividerColor: UbuntuColors.slate
        }
        extension: Sections {
            id: mainSections

            property string selectedSection: model[selectedIndex]

            model: itemsPageLoader.active ? (itemsPage.pageMode === "talaan"
                                             || itemsPage.pageMode === "normal")
                                            && itemsPage.currentID !== 0
                                            && pagemode
                                            !== "all" ? [i18n.tr(
                                                             "Current"), i18n.tr(
                                                             "All")] : [i18n.tr(
                                                                            "All")] : [i18n.tr(
                                                                                           "All")]

            onSelectedIndexChanged: {
                switch (selectedSection) {
                case i18n.tr("Current"):
                    switchToCurrent()
                    break
                case i18n.tr("All"):
                    switchToAll()
                    break
                }
            }

            onSelectedSectionChanged: {
                switch (selectedSection) {
                case i18n.tr("Current"):
                    switchToCurrent()
                    break
                case i18n.tr("All"):
                    switchToAll()
                    break
                }
            }

            onModelChanged: {
                switch (selectedSection) {
                case i18n.tr("Current"):
                    switchToCurrent()
                    break
                case i18n.tr("All"):
                    switchToAll()
                    break
                }
            }
        }
        trailingActionBar.actions: [
            Action {
                iconName: "add"
                text: i18n.tr("Add")
                shortcut: "Ctrl+R"
                visible: itemsPageLoader.active ? (itemsPage.pageMode === "talaan"
                                                   || itemsPage.pageMode === "normal")
                                                  && itemsPage.currentID !== 0
                                                  && pagemode !== "all" ? true : false : false
                onTriggered: {
                    addNew()
                }
            }
        ]
    }

    //functions
    function addNew() {
        var dialogCompleted = PopupUtils.open(dialogAlarmComponent)

        var continueReminder = function (title, customDate, reminder, silent) {
            var targetdt = new Date(itemsPage.currentTargetDate)
            var newTitle = title === "" ? itemsPage.currentChecklist : title
            var newDate = isNaN(customDate) ? targetdt : customDate

            alarmReminder.createNew(itemsPage.currentID, newTitle, newDate,
                                    reminder, silent)
        }

        dialogCompleted.proceed.connect(continueReminder)
    }

    function switchToCurrent() {
        //console.log("Current")
        var checklistId = itemsPage.currentID
        var preRegexp = /^\[Talaan\]\w|\W\(/
        var postRegexp = /\)$/
        var regexp = new RegExp(preRegexp.source + checklistId + postRegexp.source)
        sortedAlarms.filter.pattern = regexp
    }

    function switchToAll() {
        //console.log("All")
        sortedAlarms.filter.pattern = /^\[Talaan\]\w|\W\(\d{1,}\)$/
    }

    function cleanupAlarms() {
        var modelCount = alarmModel.count
        for (var i = modelCount - 1; i > -1; i--) {
            var today = new Date()
            var alarm = alarmModel.get(i)
            var alarmName = alarm.message

            if (/^\[Talaan\]\w|\W\(\d{1,}\)$/.test(alarmName)
                    && alarm.date < today) {
                alarm.cancel()
                console.log("nadelete: " + alarmName)
            }
        }
    }

    onActiveChanged: {

        if (active === true) {
            var today = new Date()
            var dayToday = today.getDate()
            today.setDate(dayToday + 1)
            today.setHours(0)
            today.setMinutes(0)
            today.setSeconds(0)
            today.setMilliseconds(0)

            liveTimer.relativeTime = today

            if (pagemode === "normal") {
                mainSections.selectedIndex = 0
            }

            cleanupAlarms()
        } else {
            itemsPage.navigatedToPage = false
        }
    }

    LiveTimer {
        id: liveTimer
        frequency: LiveTimer.Hour //Relative
        onTrigger: {
            //Update Reminders and Targets to detect
            mainView.listItems.modelTargets.updateOverdueStatus()
        }
    }

    AlarmReminder {
        id: alarmReminder
    }

    BottomEdge {
        id: bottomEdgePage
        preloadContent: true
        enabled: !primaryLeftPage.isMultiColumn
        hint.swipeArea.anchors.rightMargin: settings.bottomMenuAnchor === "Right" ? units.gu(10) : 0 //for the BottomEdgeMenu
        hint.swipeArea.anchors.leftMargin: settings.bottomMenuAnchor === "Left" ? units.gu(10) : 0 //for the BottomEdgeMenu

        hint {
            visible: bottomEdgePage.enabled
            status: "Active"
            enabled: visible
            action: Action {
                iconName: "stock_event"
                text: i18n.tr("Targets")
                enabled: bottomEdgePage.enabled
                onTriggered: bottomEdgePage.commit()
            }
        }

        height: pageReminders.height

        onCollapseCompleted: {
            hint.status = "Active"
        }

        contentComponent: targetComponent

        Component {
            id: targetComponent
            TargetsPage {
                id: targetsPage
                height: pageReminders.height
            }
        }
    }

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

    AlarmModel {
        id: alarmModel
    }

    SortFilterModel {
        id: sortedAlarms
        model: alarmModel
        filter.property: "message"
        filter.pattern: /^\[Talaan\]\w|\W\(\d{1,}\)$/ /*/\[Talaan_\d{1,}\]$/*/

        onCountChanged: {
            if (count === 0) {
                emptyState.visible = true
            } else {
                emptyState.visible = false
            }
        }
    }

    Component {
        id: dialogAlarmComponent
        DialogAlarm {
            id: dialogAlarm
        }
    }

    Item {
        id: reminderContent
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            topMargin: pageReminders.header.height
        }

        EmptyState {
            id: emptyState
            iconName: "reminder"
            title: mainSections.selectedSection
                   === "All" ? i18n.tr("No reminders for any list") : i18n.tr(
                                   "No reminders for this list")
            subTitle: mainSections.selectedSection
                      === "All" ? i18n.tr(
                                      "Open a list to set reminders") : i18n.tr(
                                      "Tap/Click the '+' button to add Reminders")
            anchors {
                right: parent.right
                left: parent.left
                verticalCenter: parent.verticalCenter
                margins: units.gu(1)
            }
            visible: false
        }

        ScrollView {
            id: scrollTargetList
            anchors.fill: parent

            UbuntuListView {
                id: groupedList

                anchors.fill: parent
                interactive: true
                model: sortedAlarms
                clip: true
                currentIndex: -1
                highlightFollowsCurrentItem: true
                highlight: ListViewHighlight {
                }
                highlightMoveDuration: 200
                property string category
                delegate: ListItem {
                    id: listWithActions
                    divider.colorFrom: UbuntuColors.darkGrey
                    divider.colorTo: UbuntuColors.warmGrey
                    highlightColor: switch (settings.currentTheme) {
                                    case "Default":
                                        "#2D371300"
                                        break
                                    case "Ambiance":
                                        theme.palette.highlighted.background
                                        break
                                    case "SuruDark":
                                        theme.palette.highlighted.background
                                        break
                                    default:
                                        "#2D371300"
                                    }
                    property int currentIndex: index

                    leadingActions: ListItemActions {
                        id: leading
                        actions: Action {
                            iconName: "delete"
                            text: i18n.tr("Delete")
                            onTriggered: {
                                console.log("deleted")
                                model.cancel()
                            }
                        }
                    }

                    ListItemLayout {
                        id: layout
                        title.text: alarmReminder.getActualMessage(
                                        message) //date
                        subtitle.text: Qt.formatDateTime(date) //time
                    }
                }
            }
        }
    }
}
