import QtQuick 2.4
import Ubuntu.Components 1.3
import Qt.labs.settings 1.0
import Ubuntu.Components.Themes.Ambiance 1.3
import "../components"
import "../components/Dialogs"
import "../components/Common"
import "../library"
import Ubuntu.Components.Popups 1.3
import "../library/DataProcess.js" as DataProcess
import "../library/ProcessFunc.js" as Process

PageWithBottom {
    id: pageItems

    property string currentIndex
    property string currentDescr
    property string pageMode
    property string currentCategory
    property string currentChecklist
    property string currentStatus
    property string currentTargetDate
    property int currentID
    property int currentContinual
    property var arrItemsStatus: []
    property int currentTotal
    property int totalChecked
    property bool hideChecked: false
    property bool searchMode: false
    property alias mainListView: groupedList

    property int intSort: 100
    property string searchText

    //workaround to tell that itemspage navigated to another page and do not switch to no selected
    property bool navigatedToPage: false

    actions: switch (pageMode) {
             case "talaan":
                 [addAction, mainView.bottomMenuActions[4], mainView.bottomMenuActions[1], mainView.bottomMenuActions[2], mainView.bottomMenuActions[3], mainView.bottomMenuActions[5]]
                 break
             case "saved":
                 [addAction, mainView.bottomMenuActions[4], mainView.bottomMenuActions[1], mainView.bottomMenuActions[0], mainView.bottomMenuActions[3], mainView.bottomMenuActions[5]]
                 break
             case "history":
                 [addAction, mainView.bottomMenuActions[4], mainView.bottomMenuActions[2], mainView.bottomMenuActions[0], mainView.bottomMenuActions[3], mainView.bottomMenuActions[5]]
                 break
             default:
                 [addAction, mainView.bottomMenuActions[4], mainView.bottomMenuActions[1], mainView.bottomMenuActions[0], mainView.bottomMenuActions[2], mainView.bottomMenuActions[5]]
                 break
             }

    header: defaultHeader

    onVisibleChanged: {
        //workaround to show NoSelectedPage when going back from itemsPage then switching to multi column
        if (!visible) {
            if (!mainLayout.multiColumn
                    && !pageItems.navigatedToPage) {
                mainLayout.noSelected = true
            }
        } else {
            mainLayout.noSelected = false
        }
    }

    onSearchModeChanged: {
        if (!searchMode) {
            pageItems.header = defaultHeader
        } else {
            pageItems.header = searchHeader
        }
    }

    onCurrentTotalChanged: {
        mainView.listItems.modelChecklist.updateTotal(currentID, currentTotal)
    }

    onTotalCheckedChanged: {
        mainView.listItems.modelChecklist.updateCheckedCount(currentID,
                                                             totalChecked)
    }

    onIntSortChanged: {
        loadChecklist(hideChecked === true ? 0 : null)
    }

    onSearchTextChanged: {
        loadChecklist(hideChecked === true ? 0 : null, searchText)
    }

    //functions
    function addNew() {
        bottomEdgePage.mode = "add"
        bottomEdgePage.open()
    }

    /*function used for keyboard shortcut*/
    function switchSection() {
        if (statsSections.visible) {
            statsSections.selectedIndex = statsSections.selectedIndex === 0 ? 1 : 0
        }
    }

    function loadChecklist(status) {

        //        0 = Unchecked
        //        1 = Checked
        //        2 = Skipped
        mainView.listItems.modelChecklistItems.getItems(currentID, status,
                                                        pageItems.searchText,
                                                        intSort)
    }

    function checkEmpty() {
        if (mainView.listItems.modelChecklistItems.count === 0) {
            emptyState.visible = true
        } else {
            emptyState.visible = false
        }
    }

    function getCheckedCount() {
        var itemStatus
        var modelItems = mainView.listItems.modelChecklistItems

        totalChecked = 0
        for (var i = 0; i < modelItems.count; i++) {
            //assign values to the array
            itemStatus = modelItems.get(i).status
            if (itemStatus === 1 || itemStatus === 2) {
                totalChecked++
            }
        }
    }

    function checkComplete() {
        if (currentTotal - totalChecked === 0) {
            return true
        } else {
            return false
        }
    }

    function getItemModelIndex(itemName, searchModel) {
        var boolItemFound = false
        var i = 0
        var modelCount = searchModel.count
        while (i < modelCount) {
            if (searchModel.get(i).itemName === itemName) {
                boolItemFound = true
                break
            }
            i++
        }
        return i
    }

    function uncheckAll() {

        var dialogCompleted = PopupUtils.open(dialogUncheckAll)

        var continueUncheck = function () {
            DataProcess.uncheckAllItems(currentID)
            totalChecked = 0
            loadChecklist(null)
            hideChecked = false
        }

        dialogCompleted.proceed.connect(continueUncheck)
    }

    function completeChecklist(lastItemIndex) {

        var dialogCompleted
        if (lastItemIndex !== "") {
            dialogCompleted = PopupUtils.open(dialog)
        } else {
            dialogCompleted = PopupUtils.open(dialogMarkComplete)
        }

        var toggleCheckbox = function () {
            dialogCompleted.undo.disconnect(toggleCheckbox)
            groupedList.changeStatus(0, lastItemIndex)
        }
        var continueToHistory = function () {
            dialogCompleted.proceed.disconnect(toggleCheckbox)
            DataProcess.updateChecklistComplete(currentID)
            mainView.listItems.modelChecklist.removeItem(currentID)
            mainLayout.switchNoSelected(true)
            mainView.notification.showNotification(
                        "Checklist completed successfully",
                        theme.palette.normal.positive)
        }

        dialogCompleted.undo.connect(toggleCheckbox)
        dialogCompleted.proceed.connect(continueToHistory)
    }

    onActiveChanged: {
        if (active === true) {
            var bottomMenuActions = [addAction, mainView.bottomActions[1], mainView.bottomActions[2], mainView.bottomActions[3], mainView.bottomActions[4], mainView.bottomActions[5]]

            if (mainView.bottomActions !== bottomMenuActions) {
                mainView.bottomActions = bottomMenuActions
            }

            if ((pageMode === "talaan") && currentStatus === "incomplete"
                    && settings.listItemHideChecked) {
                statsSections.selectedIndex = 1
            } else {
                loadChecklist(null)
            }
        } else {
            if (!mainLayout.multiColumn) {
                mainLayout.resetCurrentIndex()
            }
            statsSections.selectedIndex = 0
            bottomEdgePage.panelClose()
        }
    }

    Settings {
        property alias intSort: pageItems.intSort
    }

    RadialAction {
        id: addAction
        iconName: "add"
        iconColor: "white"
        hide: pageMode !== "history" ? false : true
        backgroundColor: theme.palette.normal.positive
        onTriggered: {
            addNew()
        }
    }

    /*Headers*/
    FindHeader {
        id: searchHeader

        property int intCurrentSectionIndex

        visible: searchMode ? true : false

        onVisibleChanged: {
            if(visible){
                intCurrentSectionIndex = statsSections.selectedIndex
                statsSections.selectedIndex = 0
            }
        }

        onCancel: {
            console.log("currentIndex: " + intCurrentSectionIndex)
            statsSections.selectedIndex = intCurrentSectionIndex
            searchMode = false
        }
        onSearch: {
            pageItems.searchText = searchText
        }
    }

    PageHeader {
        id: defaultHeader
        title: currentChecklist

        StyleHints {
            backgroundColor: switch (settings.currentTheme) {
                             case "Default":
                                 "#3D1400"
                                 break
                             case "System":
                             case "Ambiance":
                                 theme.palette.normal.background
                                 break
                             case "SuruDark":
                                 theme.palette.normal.foreground
                                 break
                             default:
                                 theme.palette.normal.background
                             }
            dividerColor: UbuntuColors.slate
        }
        contents: Label {
            id: lblHead
            text: currentChecklist
            fontSizeMode: Text.HorizontalFit
            fontSize: "large"
            minimumPixelSize: units.gu(2)
            elide: Text.ElideRight
            width: parent !== null ? parent.width : 0
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
        }

        extension: (pageMode === "talaan")
                   && currentStatus === "incomplete" ? statsSections : null

        trailingActionBar {
            numberOfSlots: 3
            actions: [
                Action {
                    iconName: "add"
                    text: i18n.tr("Add")
                    shortcut: "Ctrl+L"
                    visible: pageMode !== "history" ? true : false
                    onTriggered: {
                        addNew()
                    }
                },
                Action {
                    iconName: "find"
                    text: i18n.tr("Find")
                    shortcut: StandardKey.Find
                    visible: mainView.listItems.modelChecklistItems.count > 0 ? true : false
                    onTriggered: {
                        searchMode = true
                    }
                },
                Action {
                    iconName: "select"
                    text: i18n.tr("Mark as completed")
                    visible: pageMode === "talaan"
                             && mainView.listItems.modelChecklistItems.count > 0 ? true : false
                    onTriggered: {
                        completeChecklist("")
                    }
                },
                Action {
                    iconName: "select-none"
                    text: i18n.tr("Uncheck All")
                    visible: pageMode === "talaan"
                             && mainView.listItems.modelChecklistItems.count > 0 ? true : false
                    onTriggered: {
                        uncheckAll()
                    }
                },
                Action {
                    iconName: "note-new"
                    text: i18n.tr("New checklist")
                    visible: pageMode === "saved"
                             && mainView.listItems.modelChecklistItems.count > 0 ? true : false
                    onTriggered: {
                        var dialogCreate = PopupUtils.open(
                                    dialogCreateNewComponent)

                        var continueCreate = function (name, category, targetDate) {
                            var newChecklist
                            newChecklist = DataProcess.createNewFromSaved(
                                        currentID, name, category, targetDate)
                            mainView.notification.showNotification(
                                        i18n.tr(
                                            "New List successfully created"),
                                        UbuntuColors.green)
                            mainLayout.switchTab(0)
                            mainLayout.selectItemFromMain(
                                        mainLayout.primaryPage, itemsPage, {
                                            pageMode: "talaan",
                                            currentCategory: newChecklist.category,
                                            currentChecklist: newChecklist.checklist,
                                            currentID: newChecklist.id,
                                            currentStatus: newChecklist.status,
                                            currentTotal: newChecklist.total,
                                            currentDescr: newChecklist.descr,
                                            currentContinual: newChecklist.continual
                                        })
                        }

                        dialogCreate.proceed.connect(continueCreate)
                    }
                },
                Action {
                    iconName: "edit"
                    text: i18n.tr("Edit")
                    visible: pageMode !== "history" ? true : false
                    onTriggered: {
                        switch (pageItems.currentStatus) {
                        case "incomplete":

                        case "normal":
                            defaultTab.bottomEdge.commitWithProperties({
                                                                           actionMode: "edit",
                                                                           mode: "talaan",
                                                                           checklistID: currentID,
                                                                           type: currentStatus,
                                                                           checklist: currentChecklist,
                                                                           category: currentCategory,
                                                                           description: currentDescr,
                                                                           targetDate: currentTargetDate
                                                                       })
                            break
                        case "saved":
                            savedTab.bottomEdge.commitWithProperties({
                                                                         actionMode: "edit",
                                                                         mode: "saved",
                                                                         checklistID: currentID,
                                                                         type: currentStatus,
                                                                         checklist: currentChecklist,
                                                                         category: currentCategory,
                                                                         description: currentDescr,
                                                                         targetDate: currentTargetDate
                                                                     })
                            break
                        }
                        mainLayout.switchNoSelected(true)
                    }
                },
                Action {
                    iconName: "reminder"
                    text: i18n.tr("Set Reminders")
                    visible: (pageMode === "talaan" || pageMode === "normal")
                             && mainView.listItems.modelChecklistItems.count > 0
                             && mainView.mainLayout.columns !== 3 ? true : false
                    onTriggered: {
                        remindersPageLoader.showRemindersPage("current")
                    }
                },
                Action {
                    iconName: "sort-listitem"
                    text: switch (intSort) {
                          case 0:
                              i18n.tr("Sort") + ": " + i18n.tr("A-Z")
                              break
                          case 1:
                              i18n.tr("Sort") + ": " + i18n.tr("Z-A")
                              break
                          default:
                              i18n.tr("Sort") + ": " + i18n.tr("Default")
                              break
                          }

                    onTriggered: {
                        switch (intSort) {
                        case 0:
                            intSort = 1
                            break
                        case 1:
                            intSort = 100
                            break
                        default:
                            intSort = 0
                            break
                        }
                    }
                },
                Action {
                    iconName: "info"
                    text: i18n.tr("View Details")
                    onTriggered: {
                        PopupUtils.open(infoDialog)
                    }
                }
            ]
        }
    }

    Sections {
        id: statsSections

        actions: [
            Action {
                text: i18n.tr("All") + "  (" + currentTotal + ")"
                onTriggered: {
                    hideChecked = false
                    groupedList.positionViewAtBeginning()
                }
            },
            Action {
                text: i18n.tr("Remaining") + "  (" + String(
                          currentTotal - totalChecked) + ")"
                onTriggered: {
                    hideChecked = true
                    groupedList.positionViewAtBeginning()
                }
            }
        ]

        visible: (pageMode === "talaan")
                 && currentStatus === "incomplete" ? true : false
    }

    Component {
        id: dialogCreateNewComponent

        DialogCreateFromSaved {
            id: dialogCreateNew
            categoriesModel: mainView.listItems.modelCategories
            checklistName: currentChecklist
            category: currentCategory
        }
    }

    Component {
        id: infoDialog
        Dialog {
            id: infoDialogue
            title: currentChecklist

            Column {
                width: parent.width
                spacing: units.gu(0.5)
                Label {
                    text: "<b>Description: </b>" + currentDescr
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
                Label {
                    text: "<b>Category: </b>" + currentCategory
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
                Label {
                    text: "<b>Creation Date: </b>" + mainView.listItems.modelChecklist.get(
                              currentIndex).creation_dt
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
                Label {
                    text: "<b>Target Date: </b>"
                          + (currentTargetDate === "" ? "None" : Process.relativeDate(
                                                            currentTargetDate,
                                                            "ddd, MMMM d, yyyy",
                                                            "Basic"))
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    visible: currentStatus === "normal"
                             || currentStatus === "saved" ? false : true
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
                Label {
                    text: currentStatus === "normal" || currentStatus
                          === "complete" ? "<b>Total: </b>" + currentTotal : "<b>Status: </b>"
                                           + totalChecked + " / " + currentTotal
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    visible: currentStatus === "saved" ? false : true
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
                Label {
                    text: "<b>Completion Date: </b>" + mainView.listItems.modelChecklist.get(
                              currentIndex).completion_dt
                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    visible: currentStatus === "complete" ? true : false
                    anchors {
                        left: parent.left
                        right: parent.right
                    }
                }
            }

            Button {
                text: i18n.tr("Close")
                color: UbuntuColors.warmGrey
                onClicked: {
                    PopupUtils.close(infoDialogue)
                }
            }
        }
    }
    
    onHideCheckedChanged: {
        commentBubble.hideNotification(
                    ) //workaround on crash when commentBubble set currentindex to -1
        if (hideChecked === true) {
            loadChecklist(0, pageItems.searchText) // load only unchecked items
        } else {
            loadChecklist(null, pageItems.searchText) //load all items
        }
    }

    Loader {
        id: listViewLoader
    }

    EmptyState {
        id: emptyState
        iconName: pageItems.searchMode ? "find" : "stock_note"
        title: switch (true) {
               case pageItems.searchMode:
                   i18n.tr("No matching item found")
                   break
               case currentTotal > 0:
                   i18n.tr("No remaining item")
                   break
               default:
                   i18n.tr("List is empty")
                   break
               }
        subTitle: switch (true) {
                  case pageItems.searchMode:
                      i18n.tr("Please try a different query or try removing the filter if there's any")
                      break
                  case currentTotal > 0:
                      mainLayout.multiColumn ? i18n.tr(
                                                   "Click the '+' button to add more items (Ctrl + L)") : i18n.tr(
                                                   "Swipe from the bottom to add more items")
                      break
                  default:
                      mainLayout.multiColumn ? i18n.tr(
                                                   "Click the '+' button to add items (Ctrl + L)") : i18n.tr(
                                                   "Swipe from the bottom to add items")
                      break
                  }

        anchors {
            right: parent.right
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: units.gu(1)
        }
        shown: listItems.modelChecklistItems.count === 0
               && listItems.modelChecklistItems.loadingStatus === 'Ready' //false
    }


    LoadingComponent {
        visible: listItems.modelChecklistItems.loadingStatus !== "Ready"
        title: i18n.tr("Loading list items")
        subTitle: i18n.tr("Please wait")
    }

    ListItemActions {
        id: leading

        actions: Action {
            iconName: "delete"
            text: i18n.tr("Delete")
            shortcut: StandardKey.Delete
            onTriggered: {
                var currentItemName = groupedList.model.get(value).itemName
                DataProcess.deleteItem(
                            currentID,
                            currentItemName)
                currentTotal--
                var currentItemStatus = groupedList.model.get(value).status
                if (currentItemStatus === 1 || currentItemStatus === 2) {
                    totalChecked--
                }

                groupedList.model.remove(value)
            }
        }
    }

    ListItemActions {
        id: trailing
        actions: [
            Action {
                iconName: "edit"
                text: i18n.tr("Edit")

                onTriggered: {
                    var currentItemName = groupedList.model.get(value).itemName
                    var currentItemComment = groupedList.model.get(
                                value).comments
                    bottomEdgePage.open()
                    bottomEdgePage.mode = "edit"
                    bottomEdgePage.currentItem = currentItemName
                    bottomEdgePage.currentComment = currentItemComment
                    bottomEdgePage.itemName.text = currentItemName
                    bottomEdgePage.comments.text = currentItemComment
                    bottomEdgePage.isCommentsShown = currentItemComment !== "" ? true : false
                }
            },
            Action {
                iconName: "redo"
                text: i18n.tr("Skip")
                visible: pageMode === "talaan" ? true : false
                onTriggered: {
                    groupedList.changeStatus(2, value)
                    if (checkComplete() === true) {
                        completeChecklist(value)
                    }
                }
            },
            Action {
                iconName: "mail-mark-important"
                text: i18n.tr("Toggle Priority")
                visible: pageMode === "talaan" ? true : false
                onTriggered: {
                    var currentPriority = groupedList.model.get(value).priority

                    if (currentPriority === "Normal") {
                        groupedList.changPriority("High", value)
                    } else {
                        groupedList.changPriority("Normal", value)
                    }
                }
            },
            Action {
                iconName: "info"
                text: i18n.tr("View Details")

                onTriggered: {
                    PopupUtils.open(dialogItemDetails,null,{"title": groupedList.model.get(value).itemName,"description": groupedList.model.get(value).comments})
                }
            }
        ]
    }

    ScrollView {
        id: mainScrollView
        anchors.fill: parent
        anchors.topMargin: pageItems.header.height
        UbuntuListView {
            id: groupedList

            anchors {
                fill: parent
            }
            interactive: true
            model: mainView.listItems.modelChecklistItems
            clip: true
            currentIndex: -1
            highlightFollowsCurrentItem: true
            highlight: ListViewHighlight {
            }
            highlightMoveDuration: 200

            UbuntuNumberAnimation on opacity {
                running: groupedList.count > 1
                from: 0
                to: 1
                easing.type: Easing.OutCubic
                duration: UbuntuAnimation.SlowDuration
            }

            MessageBubble {
                id: commentBubble
                showDuration: 0
                fontSize: settings.listItemFontSize ? FontUtils.sizeToPixels(
                                                             "large") : FontUtils.sizeToPixels(
                                                             "medium")
                onIsShownChanged: {
                    if (!isShown) {
                        groupedList.currentIndex = -1
                    }
                }
            }

            displaced: Transition {
                UbuntuNumberAnimation {
                    properties: "x,y"
                    duration: UbuntuAnimation.FastDuration
                }
            }

            function changPriority(newPriority, itemIndex) {
                var currentItemName = groupedList.model.get(itemIndex).itemName
                var i = getItemModelIndex(
                            currentItemName,
                            mainView.listItems.modelChecklistItems)
                mainView.listItems.modelChecklistItems.setProperty(i,
                                                                   "priority",
                                                                   newPriority)
                DataProcess.updateItemPriority(currentID, currentItemName,
                                               newPriority)
            }

            function changeStatus(newStatus, itemIndex) {

                var currentItemName = groupedList.model.get(itemIndex).itemName
                var currentItemStatus = groupedList.model.get(itemIndex).status

                if (newStatus !== currentItemStatus) {
                    var i = getItemModelIndex(
                                currentItemName,
                                mainView.listItems.modelChecklistItems)

                    mainView.listItems.modelChecklistItems.setProperty(
                                i, "status", newStatus)
                    DataProcess.updateItemStatus(currentID, currentItemName,
                                                 newStatus)

                    if (newStatus === 0) {
                        totalChecked--
                    } else {
                        if (currentItemStatus === 0) {
                            totalChecked++
                        }
                    }
                }
            }

            delegate: ListItem {
                id: listWithActions
                height: labelName.height + units.gu(4)
                width: parent.width
                divider.visible: false
                color: "transparent"
                highlightColor: switch(settings.currentTheme){
                                case "Default":
                                    "#2D371300"
                                    break;
                                case "Ambiance":
                                case "System":
                                case "SuruDark":
                                    theme.palette.highlighted.background
                                    break;
                                default:
                                    "#2D371300"
                                }
                property int currentIndex: index
                property string itemID: currentID
                signal toggle

                onClicked: {
                    if (settings.listItemClickable) {
                        toggle()
                    }
                }

                onToggle: {
                    if (pageMode === "talaan") {
                        groupedList.changeStatus(status === 0 ? 1 : 0, index)

                        if (checkAbstractButton.checked) {
                            if (currentContinual !== 1 && checkComplete(
                                        ) === true) {
                                completeChecklist(index)
                            }
                        }
                    }
                }

                leadingActions: pageMode === "history" ? null : leading
                trailingActions: pageMode === "history" ? null : trailing

                Item {
                    id: itemContents
                    property bool checkboxStatus

                    checkboxStatus: status
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        right: parent.right
                        leftMargin: units.gu(2)
                        rightMargin: units.gu(2)
                    }


                    AbstractButton{
                        id: checkAbstractButton

                        property bool checked: false

                        width: units.gu(3)
                        height: width
                        visible: pageMode !== "talaan" && pageMode !== "history" ? false : true
                        enabled: pageMode === "history" ? false : true

                        anchors {
                            left: parent.left
                            verticalCenter: parent.verticalCenter
                        }

                        onClicked: {
                            listWithActions.toggle()
                        }

                        Icon {
                            id: checkIcon


                            color: checkAbstractButton.checked ? theme.palette.normal.foregroundText : theme.palette.normal.backgroundSecondaryText
                            name: checkAbstractButton.checked ? "tick" : "select-none"

                            asynchronous: true

                            width :checkAbstractButton.checked ? units.gu(3) : units.gu(2)
                            height: width
                            anchors.centerIn: checkAbstractButton

                            //workaround where binding to status gets lost when the checkbox is clicked
                            Component.onCompleted: checkAbstractButton.checked = (status === 0 ? false : true)

                            Connections {
                                target: itemContents
                                onCheckboxStatusChanged: {
                                    checkAbstractButton.checked = itemContents.checkboxStatus
                                }
                            }
                        }
                    }
                    Icon {
                        id: iconImportant
                        name: "mail-mark-important"
                        visible: checkAbstractButton.visible === true && status !== 0
                                 && pageMode !== "history" ? false : priority
                                                             === "High" ? true : false
                        color: theme.palette.normal.negative
                        width: mouseComment.height / 2
                        height: width
                        anchors {
                            left: checkAbstractButton.visible === true ? checkAbstractButton.right : parent.left
                            leftMargin: units.gu(1)
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    Label {
                        id: labelName
                        text: itemName
                        fontSize: settings.listItemFontSize ? "large" : "medium"
                        visible: true
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere

                        font.weight: checkAbstractButton.visible === true && status !== 0
                                     && pageMode !== "history" ? Font.Light : priority === "High" ? Font.DemiBold : Font.Light

                        font.strikeout: checkAbstractButton.visible === true
                                        && status !== 0
                                        && pageMode !== "history" && !itemsPage.searchMode ? true : false
                        color: switch (settings.currentTheme) {
                               case "Default":
                                   checkAbstractButton.visible === true && status !== 0
                                           && pageMode !== "history" && !itemsPage.searchMode ? theme.palette.normal.backgroundSecondaryText : priority === "High" ? theme.palette.normal.field : theme.palette.normal.background
                                   break
                               case "System":
                               case "Ambiance":
                                   checkAbstractButton.visible === true && status !== 0
                                           && pageMode !== "history" && !itemsPage.searchMode ? theme.palette.normal.overlayText : priority === "High" ? theme.palette.normal.backgroundText : theme.palette.normal.backgroundText
                                   break
                               case "SuruDark":
                                   checkAbstractButton.visible === true && status !== 0
                                           && pageMode !== "history" && !itemsPage.searchMode ? theme.palette.normal.backgroundSecondaryText : priority === "High" ? theme.palette.normal.backgroundText : theme.palette.normal.backgroundText
                                   break
                               default:
                                   checkAbstractButton.visible === true && status !== 0
                                           && pageMode !== "history" && !itemsPage.searchMode ? theme.palette.normal.backgroundSecondaryText : priority === "High" ? theme.palette.normal.field : theme.palette.normal.background
                               }
                        verticalAlignment: Text.AlignVCenter
                        anchors {
                            left: iconImportant.visible
                                  === true ? iconImportant.right : checkAbstractButton.visible
                                             === true ? checkAbstractButton.right : parent.left
                            leftMargin: iconImportant.visible === true ? units.gu(1) : units.gu(
                                                                             2)
                            right: labelSkipped.left
                            rightMargin: units.gu(1)
                            verticalCenter: parent.verticalCenter
                        }
                    }
                    Label {
                        id: labelSkipped
                        text: checkAbstractButton.visible === true
                              && status === 2 ? i18n.tr("Skipped") : ""
                        fontSize: "small"
                        font.weight: Font.DemiBold
                        font.bold: true
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignRight
                        anchors {
                            right: mouseComment.left
                            rightMargin: units.gu(1)
                            verticalCenter: parent.verticalCenter
                        }
                    }

                    MouseArea {
                        id: mouseComment

                        visible: comments === "" ? false : true
                        width: units.gu(5)
                        height: width
                        preventStealing: true
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                        }

                        onClicked: {
                            var mapped = listWithActions.mapToItem(
                                        commentBubble, commentBubble.x,
                                        commentBubble.y)

                            var bubbleBgColor

                            if ((commentBubble.y === mapped.y + listWithActions.height
                                 || commentBubble.y === mapped.y - commentBubble.height / 2)
                                    && commentBubble.notifyLoaderItem !== null) {
                                commentBubble.hideNotification()
                            } else {
                                commentBubble.y = mapped.y + listWithActions.height
                                commentBubble.startPosition = commentBubble.parent.width
                                commentBubble.endPosition = commentBubble.parent.width
                                        - commentBubble.bubbleWidth - units.gu(
                                            1)

                                switch (settings.currentTheme) {
                                case "Default":
                                    bubbleBgColor = "#513838"
                                    break
                                case "System":
                                case "Ambiance":
                                    bubbleBgColor = theme.palette.normal.foreground
                                    break
                                case "SuruDark":
                                    bubbleBgColor = theme.palette.normal.overlay
                                    break
                                default:
                                    bubbleBgColor = "#513838"
                                }

                                commentBubble.showNotification(comments,
                                                               bubbleBgColor)

                                if (commentBubble.y + commentBubble.height + units.gu(
                                            1) > (pageItems.height - pageItems.header.height)) {
                                    commentBubble.y = commentBubble.y
                                            - ((commentBubble.y + commentBubble.height + units.gu(
                                                    1)) - (pageItems.height
                                                           - pageItems.header.height))
                                }

                                groupedList.currentIndex = index
                            }
                        }
                        onReleased: {
                            switch (settings.currentTheme) {
                            case "Default":
                                iconComment.color = "#513838"
                                break
                            case "Ambiance":
                            case "System":
                            case "SuruDark":
                                iconComment.color = theme.palette.normal.backgroundText
                                break
                            default:
                                iconComment.color = "#513838"
                            }

                        }

                        onPressed: {
                            switch (settings.currentTheme) {
                            case "Default":
                                iconComment.color = "white"
                                break
                            case "System":
                            case "Ambiance":
                                iconComment.color = theme.palette.selected.foreground
                                break
                            case "SuruDark":
                                iconComment.color = theme.palette.selected.overlay
                                break
                            default:
                                iconComment.color = "white"
                            }

                        }

                        Icon {
                            id: iconComment
                            name: "message"
                            color: switch (settings.currentTheme) {
                                   case "Default":
                                       "#513838"
                                       break
                                   case "Ambiance":
                                   case "System":
                                   case "SuruDark":
                                       theme.palette.normal.backgroundText
                                       break
                                   default:
                                       "#513838"
                                   }
                            width: mouseComment.height * 0.60
                            height: width
                            anchors.centerIn: parent

                            Behavior on color {
                                ColorAnimation {
                                    easing: UbuntuAnimation.StandardEasing
                                    duration: UbuntuAnimation.BriskDuration
                                }
                            }
                        }
                    }
                }
            }
            Component {
                id: dialog
                Dialog {
                    id: dialogue
                    title: "Checklist Completed"
                    text: "You can view completed checklists from the History tab."
                    signal undo
                    signal proceed

                    Button {
                        text: "Continue"
                        color: UbuntuColors.green
                        onClicked: {
                            dialogue.proceed()
                            PopupUtils.close(dialogue)
                        }
                    }
                    Button {
                        color: UbuntuColors.red
                        text: i18n.tr("Undo last item")
                        onClicked: {
                            dialogue.undo()
                            PopupUtils.close(dialogue)
                        }
                    }
                }
            }

            Component {
                id: dialogMarkComplete
                Dialog {
                    id: dialogue
                    title: "Mark this checklist as completed?"
                    text: "You can view completed checklists from the History tab."
                    signal undo
                    signal proceed

                    Row {
                        id: buttonsRow
                        spacing: width * 0.1
                        Button {
                            color: theme.palette.normal.negative
                            width: parent.width * 0.45
                            text: i18n.tr("Cancel")
                            onClicked: {
                                dialogue.undo()
                                PopupUtils.close(dialogue)
                            }
                        }
                        Button {
                            text: "Continue"
                            color: theme.palette.normal.positive
                            width: parent.width * 0.45
                            onClicked: {
                                dialogue.proceed()
                                PopupUtils.close(dialogue)
                            }
                        }
                    }
                }
            }

            Component {
                id: dialogUncheckAll
                Dialog {
                    id: dialogue
                    text: "Are you sure to uncheck all items? Current state of each items won't be recoverable anymore."
                    signal undo
                    signal proceed

                    Row {
                        id: buttonsRow
                        spacing: width * 0.1
                        Button {
                            color: theme.palette.normal.negative
                            width: parent.width * 0.45
                            text: i18n.tr("Cancel")
                            onClicked: {
                                dialogue.undo()
                                PopupUtils.close(dialogue)
                            }
                        }
                        Button {
                            text: "Uncheck All"
                            color: theme.palette.normal.base
                            width: parent.width * 0.45
                            onClicked: {
                                dialogue.proceed()
                                PopupUtils.close(dialogue)
                            }
                        }
                    }
                }
            }
            
            DialogItemDetails {
                id: dialogItemDetails
            }

            ListViewPositioner {
                id: listViewPositioner
                mode: "Down"
            }
        }
    }

    AddItemsBar {
        id: bottomEdgePage
        property string currentItem
        property string currentComment

        hideHint: true
        enabled: mainLayout.columns === 1 ? (pageMode === "talaan"
                                             && currentStatus === "incomplete")
                                            || pageMode === "saved"
                                            || pageMode === "normal" ? true : false : false

        locked: pageMode !== "history" ? false : true

        onSaved: {
            save()
        }

        onOpenedChanged: {
            if (opened) {
                mainScrollView.anchors.bottomMargin = bottomEdgePage.dialogHeight
            } else {
                mainScrollView.anchors.bottomMargin = 0
            }
        }

        function save() {
            var txtName = itemName.text
            var txtComment = comments.text

            if (Process.checkRequired([txtName]) === false) {
                itemName.forceActiveFocus()
            } else if (bottomEdgePage.currentItem !== txtName
                       && DataProcess.itemExist(currentID, txtName) === true) {
                mainView.notification.showNotification(
                            "Item name already exists!", UbuntuColors.red)
            } else {
                switch (bottomEdgePage.mode) {
                case "add":
                    DataProcess.saveItem(currentID, currentChecklist, txtName,
                                         txtComment)
                    itemName.text = ""
                    comments.text = ""
                    itemName.forceActiveFocus()

                    currentTotal++
                    break
                case "edit":
                    DataProcess.updateItem(currentID,
                                           bottomEdgePage.currentItem, txtName,
                                           txtComment)
                    bottomEdgePage.panelClose()
                    mainView.notification.showNotification(
                                "Item updated successfully", UbuntuColors.green)
                    break
                }
                isCommentsShown = false
                loadChecklist(hideChecked === true ? 0 : null,
                                                     pageItems.searchText)
            }
        }
    }
}
