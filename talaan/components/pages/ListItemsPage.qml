import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "listitemspage"
import ".." as Components
import "../dialogs" as AppDialogs
import "../../common" as Common
import "../../common/pages" as Pages
import "../../common/menus" as Menus
import "../../common/dialogs" as Dialogs
import "../../library/functions.js" as Functions
import "../../library/listFunctions.js" as ListFunctions
import "../../../library/listItemFunctions.js" as ListItemFunctions

Pages.BasePage {
    id: listItemsPage

    readonly property bool isAscending: sort == 1
    readonly property bool isDescending: sort == 2
    readonly property bool isNotSorted: sort == 0
    readonly property bool listIsEndless: listData.type == "endless"
    readonly property bool listIsChecklist: listData.type == "checklist" || listIsEndless
    readonly property bool listStatusIsCompleted: listData.status == 1
    readonly property bool listHasCompletionDate: listData.completionDate !== ""
//~     readonly property bool listIsArchived: (!listIsChecklist && listHasCompletionDate) || (listIsChecklist && listHasCompletionDate && !listStatusIsCompleted)
    readonly property bool listIsArchived: listHasCompletionDate

    property Components.ListData listData
    property int sort: 0
    property bool isSearchMode: false
    property bool shownInNarrow: false

//~     flickable: dateViewPath.currentItem.view
    title: listData && listData.listName ? listData.listName : ""
//~     focus: !mainView.newExpenseView.isOpen && mainView.sidePageIsOpen
    showBackButton: !isSearchMode

    signal refresh

    headerLeftActions: [ exitSearchAction ]
//~     headerRightActions: [ viewDetailsAction, markAsCompletedAction, sortAction, searchAction, addAction ]
    headerRightActions: [ addAction, searchAction, markAsCompletedAction, uncheckAllAction, setRemindersAction, sortAction, priorityFirstAction, viewDetailsAction ]

    onSortChanged: mainView.settings.intSort = sort

    function showInSearchMode() {
        if (mainView.sidePage) {
            mainView.sidePage.show()
            isSearchMode = true
        }
    }

    function toggleDateSort() {
        if (sort == 2) {
            sort = 0
        } else {
            sort += 1
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

//~     onIsSearchModeChanged: {
//~         if (!isSearchMode) {
//~             dateViewPath.forceActiveFocus()
//~         }
//~     }

    Common.BaseAction {
        id: addAction

        text: i18n.tr("Add item")
        shortText: i18n.tr("Add")
        iconName: "add"
        shortcut: StandardKey.New
        visible: !listItemsPage.isSearchMode
        enabled: visible
        disallowOverflowMenu: true

        onTrigger: newEntry()
    }

    Common.BaseAction {
        id: exitSearchAction

        text: i18n.tr("Exit")
        iconName: "back"
        shortcut: StandardKey.Cancel
        visible: listItemsPage.isSearchMode
        enabled: listItemsPage.focus && listItemsPage.visible && visible

        onTrigger: listItemsPage.isSearchMode = false
    }

    Common.BaseAction {
        id: searchAction

        text: i18n.tr("Search")
        iconName: "find"
        shortcut: StandardKey.Find
        visible: listItemsPage.isSearchMode ? !listItemsPage.searchFieldIsFocused : true
        enabled: listItemsPage.focus && listItemsPage.visible && visible
        disallowOverflowMenu: true

        onTrigger: {
            listItemsPage.isSearchMode = true
            listItemsPage.focusSearchField()
        }
    }

    Common.BaseAction {
        id: setRemindersAction

        text: i18n.tr("Set Reminders")
        iconName: "reminder"
        visible: !listItemsPage.isEmpty

        onTrigger: {
            
        }
    }

    Common.BaseAction {
        id: sortAction

        text: i18n.tr("Sort: %1").arg(listItemsPage.isNotSorted ? i18n.tr("Default")
                                : listItemsPage.isAscending ? i18n.tr("Ascending") : i18n.tr("Descending"))
        shortText: listItemsPage.isNotSorted ? i18n.tr("Def")
                    : listItemsPage.isAscending ? i18n.tr("Asc") : i18n.tr("Desc")
        iconName: "sort-listitem"
        visible: !listItemsPage.isEmpty

        onTrigger: listItemsPage.toggleDateSort()
    }

    Common.BaseAction {
        id: priorityFirstAction

        text: i18n.tr("Priority: %1").arg(mainView.settings.displayPriorityFirst ? i18n.tr("List first")
                                                    : i18n.tr("List normally"))
        shortText: i18n.tr("Prio: %1").arg(mainView.settings.displayPriorityFirst ? i18n.tr("First")
                                                    : i18n.tr("Norm"))
        iconName: "mail-mark-important"
        visible: !listItemsPage.isEmpty

        onTrigger: mainView.settings.displayPriorityFirst = !mainView.settings.displayPriorityFirst
    }

    Common.BaseAction {
        id: markAsCompletedAction

        text: listItemsPage.listStatusIsCompleted ? i18n.tr("Revert as incomplete") : i18n.tr("Mark as completed")
        iconName: listItemsPage.listStatusIsCompleted ? "revert" : "ok"
        visible: listItemsPage.listIsChecklist && !listItemsPage.listIsArchived

        onTrigger: {
            let _popup = markAsCompletedListDialogComponent.createObject(mainView.mainSurface, { listItemData: listItemsPage.listData })
            _popup.proceed.connect(function(skipUnchecked) {
                if (listItemsPage.listStatusIsCompleted) {
                    ListFunctions.revertAsIncomplete(listItemsPage.listData.listId)
                } else {
                    ListFunctions.markAsCompleted(listItemsPage.listData.listId, skipUnchecked)
                }
            })
            _popup.archive.connect(function() {
                ListFunctions.archive(listItemsPage.listData.listId)
            })

            _popup.openDialog();
        }
    }

    Common.BaseAction {
        id: uncheckAllAction

        text: i18n.tr("Uncheck all")
        iconName: "select-none"
        visible: listItemsPage.listIsChecklist && !listItemsPage.listIsArchived
                    && !listItemsPage.isSearchMode && !listItemsPage.isEmpty

        onTrigger: {
            let _popup = markAsCompletedListDialogComponent.createObject(mainView.mainSurface, { listItemData: listItemsPage.listData })
            _popup.proceed.connect(function(skipUnchecked) {
                if (listItemsPage.listStatusIsCompleted) {
                    ListFunctions.revertAsIncomplete(listItemsPage.listData.listId)
                } else {
                    ListFunctions.markAsCompleted(listItemsPage.listData.listId, skipUnchecked)
                }
            })
            _popup.archive.connect(function() {
                ListFunctions.archive(listItemsPage.listData.listId)
            })

            _popup.openDialog();
        }
    }

    Common.BaseAction {
        id: viewDetailsAction

        text: i18n.tr("View details")
        iconName: "info"

        onTrigger: {
            let _popup = viewDetailsDialogComponent.createObject(mainView.mainSurface, { listData: listItemsPage.listData })

            _popup.openDialog();
        }
    }

    Common.BaseAction {
        id: editAction

        text: i18n.tr("Edit")
        iconName: "edit"

        onTrigger: {
            mainView.newExpenseView.openInEditMode(contextMenu.itemData)
        }
    }

    Common.BaseAction {
        id: skipAction

        text: i18n.tr("Skip")
        iconName: "edit-undo"

        onTrigger: {
            ListItemFunctions.setStatus(listItemsPage.listData.listId, contextMenu.itemData.name, 2)
//~             contextMenu.itemDelegate.isChecked = true
//~             contextMenu.itemDelegate.status = 2
        }
    }

    Common.BaseAction {
        id: deleteAction

        text: i18n.tr("Delete")
        iconName: "delete"

        onTrigger: {
            let _popup = deleteExpenseDialogComponent.createObject(mainView.mainSurface, { expenseData: contextMenu.itemData })
            _popup.proceed.connect(function() {
                let _tooltipMsg

                if (mainView.expenses.delete(contextMenu.itemData.expenseID, contextMenu.itemData.entryDate)) {
                    _tooltipMsg = i18n.tr("Expense deleted")
                } else {
                    _tooltipMsg = i18n.tr("Deletion failed")
                }
                
                mainView.tooltip.display(_tooltipMsg)
            })

            _popup.openDialog();
        }
    }

    Common.BaseAction {
        id: separatorAction

        separator: true
    }

    Component {
        id: markAsCompletedListDialogComponent

        AppDialogs.MarkAsCompleteListDialog {}
    }

    Component {
        id: viewDetailsDialogComponent

        AppDialogs.ViewListDetailsDialog {}
    }

    Menus.ContextMenu {
        id: contextMenu

        readonly property Components.ListItemData itemData: Components.ListItemData {
            id: listItemDataObj
        }
        property var itemDelegate: null
        property bool isFromSearch: false

        actions: [ deleteAction, separatorAction, skipAction, editAction ]
//~         listView: isFromSearch ? listItemsPage.view : dateViewPath.currentItem.view
        listView: listItemListView

        onClosed: isFromSearch = false
    }

    Item {
        anchors.fill: parent

        Components.EmptyState {
            id: emptyState

            anchors.centerIn: parent
            title: i18n.tr("This list is empty!")
            loadingTitle: i18n.tr("Loading list items")
            loadingSubTitle: i18n.tr("Please wait")
            isLoading: !listItemListView.baseModel.ready
            shown: listItemListView.baseModel.count == 0 || !listItemListView.baseModel.ready
        }

        ListItemListView {
            id: listItemListView
            
            readonly property real defaultTopMargin: Suru.units.gu(2)

            anchors.fill: parent
            pageHeader: listItemsPage.pageManager.pageHeader
//~             ScrollBar.vertical: ScrollBar { width: Suru.units.gu(2) }
            clip: true
            topMargin: defaultTopMargin
            bottomMargin: Suru.units.gu(2)
            interactive: !internal.partiallyShown
            baseModel: mainView.mainModels.listItemsModel
            isCheckableList: listItemsPage.listIsChecklist
            isReadOnlyList: listItemsPage.listIsArchived

            onItemToggled: {
                ListItemFunctions.setStatus(listItemsPage.listData.listId, itemName, itemStatus)

//~                 if (itemStatus > 0) {
//~                 if (isChecked) {
//~                     if (!listItemsPage.listIsEndless && listItemsPage.checkComplete() === true) {
//~                         completeChecklist(index)
//~                     }
//~                 }
            }

            onOpenContextMenu: {
                // itemDelegate is from signal
                contextMenu.itemDelegate = itemDelegate
                contextMenu.itemData.listId = listItemsPage.listData.listId
                contextMenu.itemData.itemName = itemDelegate.itemName
                contextMenu.itemData.comments = itemDelegate.comments
                contextMenu.itemData.status = itemDelegate.status
                contextMenu.itemData.priority = itemDelegate.priority

                contextMenu.popupMenu(itemDelegate, mouseX, mouseY)
            }

            function resetScroll() {
                contentY = -defaultTopMargin
            }
        }
    }

    QtObject {
        id: internal

        property string internalBaseDate: Functions.getToday()

        function setBaseDate(_newBaseDate) {
            if (_newBaseDate == internalBaseDate) {
                dateViewPath.scrollToBegginer()
            } else {
                internalBaseDate = _newBaseDate
            }
        }
    }
}
