import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes.Ambiance 1.3
import Ubuntu.Components.Popups 1.3
import Qt.labs.settings 1.0
import "../ui"
import "SortFilter"
import "Search"
import "Dialogs"
import "Common"
import "../library"
import "../library/DataProcess.js" as DataProcess
import "../library/ProcessFunc.js" as Process

PageWithBottom {
    id: root

    property string pagemode: "talaan"

    property string searchPlaceHolderText
    property string searchingText
    property string pageTitle
    property string emptyTitle
    property string emptySubTitle
    property string emptyIconName
    property string loadingTitle
    property int searchActionIndex

    property int currentID
    property string currentChecklist
    property string currentCategory
    property string currentTargetDt
    property string currentDescription
    property string currentListType
    property int currentContinual
    property int intCurSectionIndex
    property string createdChecklistID
    property bool searchMode: false
    property bool searchActive: searchHeader.searchActive

    property alias sectionSelectedIndex: mainSections.selectedIndex
    property alias bottomEdge: bottomEdgePage
    property alias mainListView: groupedList
    property alias searchHeader: searchHeader
    property alias addRadialAction: addRadialAction

    /* Settings Properties */
    property bool favorite: false
    property string filter: "all"
    property string groupings: "name"
    property string order: "normal"
    property string searchFilter: "all"
    property string searchGroupings: "name"
    property string searchOrder: "normal"
    property string searchCondition: "="
    property string searchType: "default"
    property string searchText: ""

    hideLeadingActions: true

    header: {
        if (primaryLeftPage.isMultiColumn) {
            defaultHeader
        } else {
            if (searchMode) {
                searchHeader
            } else {
                defaultHeader
            }
        }
    }

    onSearchModeChanged: {
        if (!searchMode && !searchActive) {
            searchType = ""
            searchCondition = ""
            if (searchText !== "") {
                searchText = ""
                loadChecklist()
            }
        } else {
            searchType = searchHeader.selectedSection
        }
    }

    onActiveChanged: {
        if (active) {
            loadChecklist()
        }
    }

    //functions
    function loadChecklist() {
        if (active) {
            groupedList.currentIndex = -1
            if (!searchHeader.searchActive) {
                mainView.listItems.modelChecklist.getChecklists(pagemode, favorite,
                                                                groupings, filter,
                                                                order, "", "", "")
            } else {
                mainView.listItems.modelChecklist.getChecklists(pagemode, false,
                                                                searchGroupings,
                                                                searchFilter,
                                                                searchOrder,
                                                                searchType,
                                                                searchCondition,
                                                                searchText)
            }
        }
    }

    function addNew() {
        root.currentListType = pagemode !== "saved" ? "incomplete" : pagemode
        root.openAddChecklist(pagemode, "add")
    }

    function checkEmpty() {
        if (mainView.listItems.modelChecklist.count === 0) {
            emptyState.visible = true
            mainLayout.switchNoSelected(true)
        } else {
            emptyState.visible = false
        }
    }

    function openAddChecklist(mode, actionMode) {

        //root.pagemode = mode
        var properties = {

        }
        properties["mode"] = mode
        properties["actionMode"] = actionMode
        properties["type"] = root.currentListType
        properties["checklistID"] = root.currentID
        properties["checklist"] = root.currentChecklist
        properties["category"] = root.currentCategory
        properties["description"] = root.currentDescription
        properties["targetDate"] = root.currentTargetDt
        properties["continual"] = root.currentContinual
        bottomEdgePage.commitWithProperties(properties)
        mainLayout.switchNoSelected(true)
    }

    /* To perform appropriate adjustements when switching to 3 column mode */
    Connections {
        target: primaryLeftPage
        onIsMultiColumnChanged: {
            if (target.isMultiColumn) {
                searchMode = false
            }
        }
    }

    /*Headers*/
    SearchHeader {
        id: searchHeader
        mode: "text"
        sectionMode: pagemode
        visible: primaryLeftPage.isMultiColumn ? true : searchMode ? true : false
        noCancel: primaryLeftPage.isMultiColumn
        searchPlaceHolderText: root.searchPlaceHolderText

        leadingActionBar {
            anchors {
                top: searchHeader.top
            }

            actions: headerActionList.actions[root.searchActionIndex]
        }

        onCancel: {
            searchMode = false
        }
        onSearch: {
            root.searchCondition = searchCondition
            root.searchText = searchText
            loadChecklist()
        }

        onSelectedSectionChanged: {
            root.searchType = selectedSection
        }
    }

    RadialAction {
        id: addRadialAction
        text: i18n.tr("Add")
        iconName: "add"
        iconColor: "white"
        backgroundColor: UbuntuColors.green
        onTriggered: {
            addNew()
        }
    }

    ActionList {
        id: headerActionList
        actions: [
            Action {
                iconName: "add"
                text: i18n.tr("Add")
                visible: root.pagemode !== "history"
                shortcut: StandardKey.New
                onTriggered: {
                    addNew()
                }
            },
            Action {
                iconName: "search"
                text: i18n.tr("Search")
                shortcut: visible ? StandardKey.Save : undefined
                visible: primaryLeftPage.isMultiColumn ? false : true
                onTriggered: {
                    searchMode = true
                }
            },
            Action {
                iconName: "delete"
                text: i18n.tr("Clear History")
                visible: root.pagemode === "history"
                onTriggered: {

                    var dialogDateSelection = PopupUtils.open(dialogChoose)

                    var confirmClear = function (dateChosen) {

                        var dialogConfirmation = PopupUtils.open(dialogConfirm)

                        var processClear = function () {
                            DataProcess.clearHistory(dateChosen)
                            mainView.notification.showNotification(
                                        "History cleared successfully",
                                        theme.palette.normal.positive)
                            mainLayout.switchNoSelected(true)
                            loadChecklist()
                        }

                        dialogConfirmation.proceed.connect(processClear)
                    }

                    dialogDateSelection.processClear.connect(confirmClear)
                }
            },
            Action {
                iconName: "sort-listitem"
                text: i18n.tr("Sort/Filter")
                shortcut: "Ctrl+R"
                visible: primaryLeftPage.isMultiColumn ? false : true
                onTriggered: {
                    var dialogCompleted = PopupUtils.open(dialogSort)

                    var continueSort = function (sort, filter, reverse) {
                        if (root.searchActive) {
                            root.searchGroupings = sort
                            root.searchFilter = filter
                            root.searchOrder = reverse ? "reverse" : "normal"
                        } else {
                            root.groupings = sort
                            root.filter = filter
                            root.order = reverse ? "reverse" : "normal"
                        }

                        mainLayout.switchNoSelected(true)
                        loadChecklist()
                    }

                    dialogCompleted.proceed.connect(continueSort)
                }
            },
            Action {
                iconName: "event"
                text: i18n.tr("Upcoming")
                shortcut: visible ? "Ctrl+U" : undefined
                visible: root.pagemode !== "talaan"
                         || primaryLeftPage.isMultiColumn ? false : true
                onTriggered: {
                    remindersPageLoader.showRemindersPage("all")
                }
            }
        ]
    }

    SearchHeaderExtension {
        id: searchHeaderExtension

        visible: searchHeader.searchActive
        searchTotal: listItems.modelChecklist.count
    }

    PageHeader {
        id: defaultHeader
        contents: HeaderWithSubtitle {
            anchors.centerIn: parent
            anchors.verticalCenterOffset: units.gu(0.25)
            title: defaultHeader.title
            subtitle: defaultHeader.subtitle
        }
        title: root.searchActive ? root.searchingText : root.pageTitle
        subtitle: {
            var filterLabel
            var sortLabel
            var orderLabel
            var actualSubtitle

            switch (root.filter) {
            case "all":
                filterLabel = ""
                break
            case "normal":
                filterLabel = i18n.tr("Normal")
                break
            case "checklist":
                filterLabel = i18n.tr("Checklists")
                break
            default:
                filterLabel = ""
                break
            }

            switch (root.groupings) {
            case "name":
                sortLabel = ""
                break
            case "category":
                sortLabel = i18n.tr("By Category")
                break
            case "creation_date":
                sortLabel = i18n.tr("By Creation")
                break
            case "target_date":
                sortLabel = i18n.tr("By Target")
                break
            default:
                sortLabel = ""
                break
            }

            switch (root.order) {
            case "normal":
                orderLabel = ""
                break
            case "reverse":
                orderLabel = i18n.tr("Reverse")
                break
            default:
                orderLabel = ""
                break
            }

            actualSubtitle = filterLabel
            actualSubtitle = sortLabel === "" ? actualSubtitle : actualSubtitle
                                                !== "" ? actualSubtitle + " - "
                                                         + sortLabel : sortLabel
            actualSubtitle = orderLabel === "" ? actualSubtitle : actualSubtitle
                                                 !== "" ? actualSubtitle + " - "
                                                          + orderLabel : orderLabel
            actualSubtitle
        }
        StyleHints {
            backgroundColor: switch (settings.currentTheme) {
                             case "Default":
                                 "#3D1400"
                                 break
                             case "Ambiance":
                             case "System":
                             case "SuruDark":
                                 theme.palette.normal.foreground
                                 break
                             default:
                                 "#3D1400"
                             }
            dividerColor: UbuntuColors.slate
        }
        extension: searchHeaderExtension.visible ? searchHeaderExtension : mainSections

        leadingActionBar {
            actions: [
                Action {
                    text: i18n.tr("Navigation Panel")
                    iconName: "navigation-menu"
                    visible: mainView.navigationPanel ? primaryLeftPage.isMultiColumn ? false : true : false
                    onTriggered: {
                        mainView.navigationPanel.toggle()
                    }
                },
                Action {
                    text: i18n.tr("Close")
                    iconName: "close"
                    visible: searchHeader.searchActive
                    onTriggered: {
                        searchHeader.stopSearch()
                    }
                }
            ]
        }
        trailingActionBar.actions: headerActionList.actions
    }

    Sections {
        id: mainSections

        model: [i18n.tr("All"), i18n.tr("Favorites")]
        onSelectedIndexChanged: {
            mainLayout.switchNoSelected(true)
            switch (selectedIndex) {
            case 0:
                root.intCurSectionIndex = selectedIndex
                root.favorite = false
                loadChecklist()
                groupedList.positionViewAtBeginning()
                break
            case 1:
                root.intCurSectionIndex = selectedIndex
                root.favorite = true
                loadChecklist()
                groupedList.positionViewAtBeginning()
                break
            }
        }
    }

    BottomEdge {
        id: bottomEdgePage

        hint {
            visible: false
            enabled: false
        }

        height: parent ? parent.height : 0
        enabled: false
        visible: false

        contentComponent: Item {
            id: pageContent
            implicitWidth: bottomEdgePage.width
            implicitHeight: bottomEdgePage.height
            children: bottomEdgePage._realPage
        }

        property var _realPage: null

        function commitWithProperties(properties) {
            _realPage.destroy()
            _realPage = addChecklistComponent.createObject(null, properties)
            commit()
        }

        Component.onCompleted: {
            _realPage = addChecklistComponent.createObject(null)
        }

        Component.onDestruction: {
            _realPage.destroy()
        }

        onCollapseCompleted: {
            _realPage.active = false
            _realPage.destroy()
            _realPage = addChecklistComponent.createObject(null)
        }

        onCommitCompleted: {
            _realPage.active = true
        }

        Component {
            id: addChecklistComponent

            AddChecklist {
                id: addchecklistPage
                anchors.fill: parent
                onCancel: bottomEdgePage.collapse()
                onSaved: bottomEdgePage.collapse()
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        anchors.topMargin: root.header.height
        visible: mainView.itemsPage ? true : false

        UbuntuListView {
            id: groupedList

            property string filter
            property string actionTriggered
            property int modelCount: groupedList.model.count
            property string currentChecklist
            property string currentCategory

            anchors.fill: parent
            interactive: true
            model: mainView.listItems.modelChecklist
            clip: true
            currentIndex: -1
            highlightFollowsCurrentItem: true
            highlight: ListViewHighlight {
            }
            highlightMoveDuration: UbuntuAnimation.SnapDuration
            highlightResizeDuration: UbuntuAnimation.SnapDuration

            UbuntuNumberAnimation on opacity {
                running: groupedList.count > 0
                from: 0
                to: 1
                easing: UbuntuAnimation.StandardEasing
                duration: UbuntuAnimation.FastDuration
            }

            onCurrentIndexChanged: {
                if (currentIndex >= 0) {
                    currentItem.selectItemAction.trigger()
                }
            }

            //select the previous or next item
            function selectPrevNextItem(intIndex) {
                if (mainLayout.multiColumn && currentIndex === intIndex) {
                    if ((currentIndex + 1) === model.count) {
                        currentIndex--
                    } else {
                        currentIndex++
                    }
                }
            }

            displaced: Transition {
                UbuntuNumberAnimation {
                    properties: "x,y"
                    duration: UbuntuAnimation.BriskDuration
                }
            }

            delegate: ListItem {
                id: listWithActions

                property int currentIndex: index
                property alias selectItemAction: selectItemAction

                height: units.gu(9)
                width: parent.width
                color: "transparent"
                highlightColor: switch (settings.currentTheme) {
                                case "Default":
                                    "#2D371300"
                                    break
                                case "Ambiance":
                                case "System":
                                case "SuruDark":
                                    theme.palette.highlighted.background
                                    break
                                default:
                                    "#2D371300"
                                }
                divider.visible: false
                divider.height: units.gu(0.05)

                Action {
                    id: selectItemAction
                    onTriggered: {
                        itemsPageLoader.showItemsPage({
                                                          pageMode: root.pagemode === "talaan" ? status === "incomplete" ? root.pagemode : "normal" : root.pagemode,
                                                                                                                           currentCategory: category,
                                                                                                                           currentChecklist: checklist,
                                                                                                                           currentID: id,
                                                                                                                           currentDescr: descr,
                                                                                                                           currentStatus: status,
                                                                                                                           currentTotal: total ? total : 0,
                                                                                                                                                 currentTargetDate: target_dt ? target_dt : "",
                                                                                                                                                                                totalChecked: completed ? completed : "",
                                                                                                                                                                                                          currentIndex: currentIndex,
                                                                                                                                                                                                          currentContinual: continual
                                                      })
                    }
                }

                onClicked: {
                    groupedList.currentIndex = index
                }

                leadingActions: ListItemActions {
                    id: leading
                    actions: Action {
                        iconName: "delete"
                        text: i18n.tr("Delete")
                        shortcut: StandardKey.Delete
                        onTriggered: {
                            var dialogCompleted = PopupUtils.open(dialogDelete)

                            var continueDelete = function () {
                                groupedList.selectPrevNextItem(index)
                                DataProcess.deleteChecklist(id)
                                groupedList.model.remove(index)
                                mainView.notification.showNotification(
                                            i18n.tr(
                                                "List successfully deleted"),
                                            UbuntuColors.coolGrey)

                                /*Clear Items page when current item was deleted*/
                                if (itemsPage.currentID === id) {
                                    mainAdaptLayout.switchNoSelected(true)
                                }
                            }

                            dialogCompleted.proceed.connect(continueDelete)
                        }
                    }
                }

                trailingActions: ListItemActions {
                    id: trailing
                    actions: [
                        Action {
                            iconName: "bookmark"
                            text: i18n.tr("Save")
                            visible: root.pagemode
                                     !== "saved" ? status === "normal" ? false : true : false
                            onTriggered: {
                                var dialogIncludeComment = PopupUtils.open(
                                            dialogComment)

                                var continueDialog = function (answer) {
                                    DataProcess.markSavedChecklist(id, answer)
                                    mainView.notification.showNotification(
                                                i18n.tr(
                                                    "List successfully added to Saved Lists"),
                                                UbuntuColors.green)
                                }

                                dialogIncludeComment.proceed.connect(
                                            continueDialog)
                            }
                        },
                        Action {
                            iconName: "note-new"
                            text: i18n.tr("New checklist")
                            visible: root.pagemode === "saved"
                            onTriggered: {
                                groupedList.currentChecklist = checklist
                                groupedList.currentCategory = category
                                var dialogCreate = PopupUtils.open(
                                            dialogCreateNewComponent)

                                var continueCreate = function (name, category, targetDate) {
                                    var newChecklist
                                    newChecklist = DataProcess.createNewFromSaved(
                                                id, name, category, targetDate)
                                    mainView.notification.showNotification(
                                                i18n.tr(
                                                    "New List successfully created"),
                                                UbuntuColors.green)

                                    /*WORKAROUND: For known issue of not opening the list in 3 column mode*/
                                    mainAdaptLayout.switchTab(0)

                                    itemsPageLoader.showItemsPage({
                                                                      pageMode: "talaan",
                                                                      currentCategory: newChecklist.category,
                                                                      currentChecklist: newChecklist.checklist,
                                                                      currentID: newChecklist.id,
                                                                      currentStatus: newChecklist.status,
                                                                      currentTotal: newChecklist.total,
                                                                      currentDescr: newChecklist.descr,
                                                                      currentContinual: newChecklist.continual,
                                                                      currentTargetDate: newChecklist.target_dt
                                                                  })
                                }

                                dialogCreate.proceed.connect(continueCreate)
                            }
                        },
                        Action {
                            iconName: favorite ? "non-starred" : "starred"
                            text: favorite ? i18n.tr("Unfavorite") : i18n.tr(
                                                 "Favorite")
                            visible: root.pagemode !== "history"
                            onTriggered: {
                                var newFavoriteStatus = favorite ? 0 : 1
                                mainView.listItems.modelChecklist.setProperty(
                                            index, "favorite", !favorite)
                                DataProcess.updateFavorite(id,
                                                           newFavoriteStatus)
                                if (newFavoriteStatus === 0) {
                                    mainView.notification.showNotification(
                                                i18n.tr(
                                                    "List successfully removed from Favorites"),
                                                theme.palette.normal.negative)
                                } else {
                                    mainView.notification.showNotification(
                                                i18n.tr(
                                                    "List successfully added to Favorites"),
                                                theme.palette.normal.positive)
                                }
                            }
                        },

                        Action {
                            iconName: "edit"
                            text: i18n.tr("Edit")
                            visible: root.pagemode !== "history"
                            onTriggered: {
                                root.currentID = id
                                root.currentListType = root.pagemode
                                        === "talaan" ? status : pagemode
                                root.currentChecklist = checklist
                                root.currentCategory = category
                                root.currentDescription = descr
                                root.currentTargetDt = target_dt
                                root.currentContinual = continual
                                root.openAddChecklist(root.pagemode, "edit")
                            }
                        },
                        Action {
                            iconName: "undo"
                            text: i18n.tr("Reset")
                            visible: root.pagemode === "history"
                            onTriggered: {
                                groupedList.selectPrevNextItem(index)
                                DataProcess.updateChecklistIncomplete(id)
                                groupedList.model.remove(index)
                                mainView.notification.showNotification(
                                            "Checklist successfully marked as incomplete",
                                            theme.palette.normal.base)
                            }
                        }
                    ]
                }

                CheckListItem {
                    id: checklistItem
                    filter: root.searchActive ? root.searchGroupings : root.groupings
                    mode: root.pagemode
                    itemHighlighted: groupedList.currentIndex === index ? true : false
                }
            }
            section.property: "header"
            section.criteria: ViewSection.FullString
            section.labelPositioning: ViewSection.InlineLabels
                                      || ViewSection.CurrentLabelAtStart
            section.delegate: ListItem {
                height: units.gu(4)
                divider.height: units.gu(0.2)
                divider.visible: true
                highlightColor: "transparent"
                Rectangle {
                    id: categoryColorRec
                    width: units.gu(3)
                    height: width
                    transform: Rotation {
                        origin.x: categoryColorRec.width
                        origin.y: categoryColorRec.height
                        angle: 45
                    }
                    color: section.substring(section.indexOf("|") + 1)
                    visible: !settings.categoryColors || section.indexOf(
                                 "|") === -1 ? false : true
                    anchors {
                        verticalCenter: parent.top
                        right: parent.left
                    }
                }
                Label {
                    color: switch (settings.currentTheme) {
                           case "Default":
                               theme.palette.normal.background
                               break
                           case "Ambiance":
                           case "System":
                           case "SuruDark":
                               theme.palette.normal.backgroundText
                               break
                           default:
                               theme.palette.normal.background
                           }
                    fontSize: "small"
                    elide: Text.ElideRight
                    font.weight: Font.DemiBold
                    fontSizeMode: Text.HorizontalFit
                    minimumPixelSize: units.gu(2)
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: units.gu(1)
                    }
                    text: section.indexOf(
                              "|") === -1 ? section : section.substring(
                                                0, section.indexOf("|"))
                }
            }
        }
    }

    EmptyState {
        id: emptyState
        z: -1

        iconName: root.searchActive ? "search" : root.intCurSectionIndex
                                      === 1 ? "starred" : root.emptyIconName
        title: root.searchActive ? i18n.tr(
                                       "No matching list found") : root.intCurSectionIndex
                                   === 1 ? i18n.tr(
                                               "No Favorites") : root.emptyTitle
        subTitle: root.searchActive ? i18n.tr(
                                          "Please try a different query or change the Sort / Filter.") : root.emptySubTitle
        anchors {
            right: parent.right
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: units.gu(1)
        }

        shown: listItems.modelChecklist.count === 0
               && listItems.modelChecklist.loadingStatus === 'Ready'
    }

    LoadingComponent {
        visible: listItems.modelChecklist.loadingStatus !== "Ready"
        title: searchMode ? i18n.tr("Loading results") : root.loadingTitle
        subTitle: i18n.tr("Please wait")
    }

    DialogIncludeComment {
        id: dialogComment
    }

    Component {
        id: dialogSort

        Dialog {
            id: dialogue
            title: i18n.tr("Sort / Filter")
            signal cancel
            signal proceed(string sort, string filter, bool reverse)

            Component.onCompleted: {
                //initiate all values
                if (root.searchActive) {
                    sortFilterFields.optionSort.selectSpecific(
                                root.searchGroupings)
                    if (root.pagemode === "talaan") {
                        sortFilterFields.optionFilter.selectSpecific(
                                    root.searchFilter)
                    }
                    sortFilterFields.checkReverse.checked
                            = (root.searchOrder === "normal" ? false : true)
                } else {
                    sortFilterFields.optionSort.selectSpecific(root.groupings)
                    if (root.pagemode === "talaan") {
                        sortFilterFields.optionFilter.selectSpecific(
                                    root.filter)
                    }
                    sortFilterFields.checkReverse.checked = (root.order === "normal" ? false : true)
                }
            }

            SortFilterFields {
                id: sortFilterFields

                mode: root.pagemode
                width: dialogue.width
            }

            Row {
                id: buttonsRow
                spacing: width * 0.1
                Button {
                    color: theme.palette.normal.base
                    width: parent.width * 0.45
                    text: i18n.tr("Cancel")
                    onClicked: {
                        dialogue.cancel()
                        PopupUtils.close(dialogue)
                    }
                }
                Button {
                    text: i18n.tr("Apply")
                    color: theme.palette.normal.positive
                    width: parent.width * 0.45
                    onClicked: {
                        var sort = sortFilterFields.sortModel.get(
                                    sortFilterFields.optionSort.selectedIndex).value
                        var filter = root.pagemode
                                === "talaan" ? sortFilterFields.filterModel.get(
                                                   sortFilterFields.optionFilter.selectedIndex).value : ""
                        var reverse = sortFilterFields.checkReverse.checked
                        dialogue.proceed(sort, filter, reverse)
                        PopupUtils.close(dialogue)
                    }
                }
            }
        }
    }

    Component {
        id: dialogDelete
        Dialog {
            id: dialogue
            title: "Are you sure you want to delete this list?"
            text: i18n.tr(
                      "All items under this list will also be deleted permanently.")
            signal cancel
            signal proceed

            Row {
                id: buttonsRow
                spacing: width * 0.1

                Button {
                    color: theme.palette.normal.base
                    width: parent.width * 0.45
                    text: i18n.tr("Cancel")
                    onClicked: {
                        dialogue.cancel()
                        PopupUtils.close(dialogue)
                    }
                }

                Button {
                    text: i18n.tr("Delete")
                    color: theme.palette.normal.negative
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
        id: dialogCreateNewComponent

        DialogCreateFromSaved {
            id: dialogCreateNew
            categoriesModel: mainView.listItems.modelCategories
            checklistName: groupedList.currentChecklist
            category: groupedList.currentCategory
        }
    }

    Component {
        id: dialogConfirm

        Dialog {
            id: dialogue
            text: "Are you sure you want to clear history? This will delete them permanently."
            signal proceed

            Row {
                id: buttonsRow
                spacing: width * 0.1
                Button {
                    text: "Cancel"
                    width: parent.width * 0.45
                    onClicked: {
                        PopupUtils.close(dialogue)
                    }
                    color: theme.palette.normal.base
                }
                Button {
                    text: "Clear History"
                    width: parent.width * 0.45
                    onClicked: {
                        dialogue.proceed()
                        PopupUtils.close(dialogue)
                    }
                    color: theme.palette.normal.negative
                }
            }
        }
    }

    Component {
        id: dialogChoose

        Dialog {
            id: dialogue
            title: "Clear History"
            signal processClear(string dateChosen)

            Button {
                text: "Clear All"
                onClicked: {
                    clearHistory("all")
                    PopupUtils.close(dialogue)
                }
                color: theme.palette.normal.negative
            }

            Button {
                text: "Older than a <b>YEAR</b> ago"
                onClicked: {
                    clearHistory("year")
                }
                color: theme.palette.normal.backgroundTertiaryText
            }
            Button {
                text: "Older than a <b>MONTH</b> ago"
                onClicked: {
                    clearHistory("month")
                    PopupUtils.close(dialogue)
                }
                color: theme.palette.normal.backgroundTertiaryText
            }
            Button {
                text: "Older than a <b>WEEK</b> ago"
                onClicked: {
                    clearHistory("week")
                    PopupUtils.close(dialogue)
                }
                color: theme.palette.normal.backgroundTertiaryText
            }

            Button {
                text: "Cancel"
                onClicked: {
                    PopupUtils.close(dialogue)
                }
                color: theme.palette.normal.base
            }

            function clearHistory(selection) {
                dialogue.processClear(selection)
                PopupUtils.close(dialogue)
            }
        }
    }

    Connections {
        id: keyboard
        target: Qt.inputMethod
    }
}
