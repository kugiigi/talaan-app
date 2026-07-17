import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "listpage"
import ".." as Components
import "../dialogs" as AppDialogs
import "../../common" as Common
import "../../common/pages" as Pages
import "../../common/menus" as Menus
import "../../common/dialogs" as Dialogs
import "../../library/functions.js" as Functions
import "../../library/listFunctions.js" as ListFunctions

ColumnLayout {
    id: listPage

    readonly property bool isByMonth: scope == "month"
    readonly property bool isByDay: scope == "day"
    readonly property bool isByWeek: scope == "week"
    readonly property bool isAscending: order == "asc"
    readonly property bool isDescending: order == "desc"
    readonly property bool isSortByCategory: sort == "category"
    readonly property bool isSortByDate: sort == "date"

    property string currentCategory: "all"
    property string scope: "day"
    property string order: "asc"
    property string sort: "category"
    property bool coloredCategory: false
    property bool isSearchMode: false
    property bool shownInNarrow: false

    property alias pageHeader: mainFlickable.pageHeader

    spacing: 0

//~     focus: !mainView.newExpenseView.isOpen && mainView.sidePageIsOpen

    signal refresh

//~     headerLeftActions: [ exitSearchAction ]
//~     headerRightActions: [ lastDataAction, nextDataAction, searchAction, sortAction, todayAction, addAction ]

    function showInSearchMode() {
        if (mainView.sidePage) {
            mainView.sidePage.show()
            isSearchMode = true
        }
    }

    function toggleViewType() {
        if (listGridView.gridType === ListGridView.GridType.List) {
            listGridView.gridType = ListGridView.GridType.Rectangle;
        } else {
            listGridView.gridType = ListGridView.GridType.List;
        }
        
    }

//~     function deleteList(listId) {
//~         if (mainView.lists.delete(listId)) {
//~             mainView.tooltip.display(i18n.tr("List deleted"))
//~         } else {
//~             mainView.tooltip.display(i18n.tr("Deletion failed"))
//~         }
//~     }

//~     function markAsCompleted(listId, skipUnchecked) {
//~         if (mainView.lists.setAsComplete(listId, skipUnchecked)) {
//~             mainView.tooltip.display(i18n.tr("List marked as completed"))
//~         } else {
//~             mainView.tooltip.display(i18n.tr("Failed to mark as completed"))
//~         }
//~     }

//~     function revertAsIncomplete(listId) {
//~         if (mainView.lists.setAsIncomplete(listId)) {
//~             mainView.tooltip.display(i18n.tr("List reverted as incomplete"))
//~         } else {
//~             mainView.tooltip.display(i18n.tr("Failed to revert as incomplete"))
//~         }
//~     }

//~     function archive(listId) {
//~         if (mainView.lists.archive(listId)) {
//~             mainView.tooltip.display(i18n.tr("List archived"))
//~         } else {
//~             mainView.tooltip.display(i18n.tr("Failed to archive"))
//~         }
//~     }

//~     function unarchive(listId) {
//~         if (mainView.lists.unarchive(listId)) {
//~             mainView.tooltip.display(i18n.tr("List unarchived"))
//~         } else {
//~             mainView.tooltip.display(i18n.tr("Failed to unarchive"))
//~         }
//~     }

//~     function saveAsTemplate(listId) {
//~         if (mainView.lists.saveAsTemplate(listId)) {
//~             mainView.tooltip.display(i18n.tr("List saved as template"))
//~         } else {
//~             mainView.tooltip.display(i18n.tr("Failed to save as template"))
//~         }
//~     }

//~     function setAsFavorite(listId) {
//~         if (mainView.lists.setAsFavorite(listId)) {
//~             mainView.tooltip.display(i18n.tr("List added to favorites"))
//~         } else {
//~             mainView.tooltip.display(i18n.tr("Adding to favorites failed"))
//~         }
//~     }

//~     function unsetAsFavorite(listId) {
//~         if (mainView.lists.unsetAsFavorite(listId)) {
//~             mainView.tooltip.display(i18n.tr("List removed from favorites"))
//~         } else {
//~             mainView.tooltip.display(i18n.tr("Removing from favorites failed"))
//~         }
//~     }

    onIsSearchModeChanged: {
        if (!isSearchMode) {
            dateViewPath.forceActiveFocus()
        }
    }

//~     Common.BaseAction {
//~         id: addAction

//~         text: i18n.tr("New Expense")
//~         shortText: i18n.tr("New")
//~         iconName: "add"
//~         shortcut: StandardKey.New
//~         visible: !listPage.isSearchMode
//~         enabled: visible

//~         onTrigger: newEntry()
//~     }

//~     Common.BaseAction {
//~         id: exitSearchAction

//~         text: i18n.tr("Exit")
//~         iconName: "back"
//~         shortcut: StandardKey.Cancel
//~         visible: listPage.isSearchMode
//~         enabled: listPage.focus && listPage.visible && visible

//~         onTrigger: listPage.isSearchMode = false
//~     }

//~     Common.BaseAction {
//~         id: searchAction

//~         text: i18n.tr("Search")
//~         iconName: "find"
//~         shortcut: StandardKey.Find
//~         visible: listPage.isSearchMode ? !expenseSearchView.searchFieldIsFocused : true
//~         enabled: listPage.focus && listPage.visible && visible

//~         onTrigger: {
//~             listPage.isSearchMode = true
//~             expenseSearchView.focusSearchField()
//~         }
//~     }

//~     Common.BaseAction {
//~         id: sortAction

//~         text: expenseSearchView.isAscending ? i18n.tr("Ascending") : i18n.tr("Descending")
//~         shortText: expenseSearchView.isAscending ? i18n.tr("Asc") : i18n.tr("Desc")
//~         iconName: "calendar"
//~         visible: listPage.isSearchMode && !expenseSearchView.isEmpty

//~         onTrigger: expenseSearchView.toggleDateSort()
//~     }

    Common.BaseAction {
        id: viewDetailsAction

        text: i18n.tr("View details")
        iconName: "info"

        onTrigger: {
            let _popup = viewDetailsDialogComponent.createObject(mainView.mainSurface, { listData: contextMenu.itemData })

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
        id: setAsFavoriteAction

        text: contextMenu.itemData.isFavorite ? i18n.tr("Unfavorite") : i18n.tr("Favorite")
        iconName: contextMenu.itemData.isFavorite ? "favorite-unselected" : "favorite-selected"

        onTrigger: {
            if (contextMenu.itemData.isFavorite) {
                ListFunctions.unsetAsFavorite(contextMenu.itemData.listId)
            } else {
                ListFunctions.setAsFavorite(contextMenu.itemData.listId)
            }
        }
    }

    Common.BaseAction {
        id: saveAsTemplateAction

        text: i18n.tr("Save as template")
        iconName: "bookmark"
        visible: contextMenu.itemIsChecklist

        onTrigger: {
            let _popup = saveListAsTemplateDialogComponent.createObject(mainView.mainSurface, { listData: contextMenu.itemData })
            _popup.proceed.connect(function() {
                ListFunctions.saveAsTemplate(contextMenu.itemData.listId, false)
            })

            _popup.openDialog();
        }
    }

    Common.BaseAction {
        id: archiveAction

        text: contextMenu.itemIsArchived ? i18n.tr("Unarchive") : i18n.tr("Archive")
        iconName: contextMenu.itemIsArchived ? "revert" : "application-x-archive-symbolic"
        visible: contextMenu.itemIsArchived || !contextMenu.statusIsCompleted || !contextMenu.itemIsChecklist

        onTrigger: {
            let _popup = archiveListDialogComponent.createObject(mainView.mainSurface, { listData: contextMenu.itemData })
            _popup.proceed.connect(function() {
                if (contextMenu.itemIsArchived) {
                    ListFunctions.unarchive(contextMenu.itemData.listId)
                } else {
                    ListFunctions.archive(contextMenu.itemData.listId)
                }
            })

            _popup.openDialog();
        }
    }

    Common.BaseAction {
        id: markAsCompletedAction

        text: contextMenu.statusIsCompleted ? i18n.tr("Revert as incomplete") : i18n.tr("Mark as completed")
        iconName: contextMenu.statusIsCompleted ? "revert" : "ok"
        visible: contextMenu.itemIsChecklist && !contextMenu.itemIsArchived

        onTrigger: {
            let _popup = markAsCompletedListDialogComponent.createObject(mainView.mainSurface, { listData: contextMenu.itemData })
            _popup.proceed.connect(function(skipUnchecked) {
                if (contextMenu.statusIsCompleted) {
                    ListFunctions.revertAsIncomplete(contextMenu.itemData.listId)
                } else {
                    ListFunctions.markAsCompleted(contextMenu.itemData.listId, skipUnchecked)
                }
            })
            _popup.archive.connect(function() {
                ListFunctions.archive(contextMenu.itemData.listId)
            })

            _popup.openDialog();
        }
    }

    Common.BaseAction {
        id: deleteAction

        text: i18n.tr("Delete")
        iconName: "delete"

        onTrigger: {
            let _popup = deleteListDialogComponent.createObject(mainView.mainSurface, { listData: contextMenu.itemData })
            _popup.proceed.connect(function() {
                ListFunctions.deleteList(contextMenu.itemData.listId)
            })
            _popup.archive.connect(function() {
                ListFunctions.archive(contextMenu.itemData.listId)
            })

            _popup.openDialog();
        }
    }

    Common.BaseAction {
        id: separatorAction

        separator: true
    }

    Component {
        id: deleteListDialogComponent

        AppDialogs.DeleteListDialog {}
    }

    Component {
        id: markAsCompletedListDialogComponent

        AppDialogs.MarkAsCompleteListDialog {}
    }

    Component {
        id: viewDetailsDialogComponent

        AppDialogs.ViewListDetailsDialog {}
    }

    Component {
        id: archiveListDialogComponent

        AppDialogs.ArchiveListDialog {}
    }

    Component {
        id: saveListAsTemplateDialogComponent

        AppDialogs.SaveListAsTemplateDialog {}
    }

    Menus.ContextMenu {
        id: contextMenu

        readonly property Components.ListData itemData: Components.ListData {
            id: listDataObj
        }
        readonly property bool itemIsChecklist: itemData.type == "checklist" || itemData.type == "endless"
        readonly property bool statusIsCompleted: itemData.status == 1
        readonly property bool hasCompletionDate: itemData.completionDate !== ""
        readonly property bool itemIsArchived: (!itemIsChecklist && hasCompletionDate) || (itemIsChecklist && hasCompletionDate && !statusIsCompleted)

        property bool isFromSearch: false

        actions: [ deleteAction, separatorAction, editAction, separatorAction
                    , saveAsTemplateAction, setAsFavoriteAction, archiveAction, markAsCompletedAction
                    , separatorAction, viewDetailsAction ]
//~         listView: isFromSearch ? expenseSearchView.view : listGridView
        listView: listGridView

        onClosed: isFromSearch = false
    }

    Connections {
        target: mainView

        onCurrentDateChanged: {
//~             navigationRow.labelRefresh()

            // Rebind values when current date changed
//~             listPage.isToday = Qt.binding( function() { return Functions.isToday(dateViewPath.currentItem.fromDate) } )
        }
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true

        Components.EmptyState {
            id: emptyState

            anchors.centerIn: parent
            title: i18n.tr("You have no lists yet!")
            loadingTitle: i18n.tr("Loading your lists")
            loadingSubTitle: i18n.tr("Please wait")
            isLoading: !listGridView.baseModel.ready
            shown: listGridView.baseModel.count == 0 || !listGridView.baseModel.ready
        }

        Common.BaseFlickable {
            id: mainFlickable
            
            readonly property real defaultTopMargin: Suru.units.gu(2)

            anchors.fill: parent

//~             ScrollBar.vertical: ScrollBar { width: Suru.units.gu(2) }
            boundsBehavior: Flickable.DragOverBounds
            boundsMovement: Flickable.StopAtBounds
            clip: true
            topMargin: defaultTopMargin
            contentHeight: listGridView.contentHeight
            interactive: !internal.partiallyShown

            function resetScroll() {
                contentY = -defaultTopMargin
            }

            ListGridView {
                id: listGridView

                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Suru.units.gu(1)
                    rightMargin: Suru.units.gu(1)
                }
                height: contentHeight
                visible: count > 0
//~                         gridType: ListGridView.GridType.List
                    gridType: ListGridView.GridType.Rectangle
    //~             gridType: newExpenseView.displayType
                flickable: mainFlickable
                baseModel: mainView.mainModels.listsModel
//~                             KeyNavigation.up: contextActionsListView.visible ? contextActionsListView : searchField
//~                             KeyNavigation.down: historyGridView.count > 0 ? historyGridView : null

                onOpenContextMenu: {
                    // itemDelegate is from signal
                    contextMenu.itemData.listId = itemDelegate.listId
                    contextMenu.itemData.listName = itemDelegate.title
                    contextMenu.itemData.description = itemDelegate.description
                    contextMenu.itemData.type = itemDelegate.type
                    contextMenu.itemData.categoryName = itemDelegate.categoryName
                    contextMenu.itemData.creationDate = itemDelegate.creationDate
                    contextMenu.itemData.modifiedDate = itemDelegate.modifiedDate
                    contextMenu.itemData.completionDate = itemDelegate.completionDate
                    contextMenu.itemData.targetDate = itemDelegate.targetDate
                    contextMenu.itemData.status = itemDelegate.status
                    contextMenu.itemData.isFavorite = itemDelegate.isFavorite
                    contextMenu.itemData.itemCount = itemDelegate.itemCount
                    contextMenu.itemData.checkedCount = itemDelegate.checkedCount

                    contextMenu.popupMenu(itemDelegate, mouseX, mouseY)
                }
                onOpenList: {
//~                     mainView.mainModels.listItemsModel.listId = listId
                    mainView.mainModels.listItemsModel.listData.listId = itemDelegate.listId
                    mainView.mainModels.listItemsModel.listData.listName = itemDelegate.title
                    mainView.mainModels.listItemsModel.listData.description = itemDelegate.description
                    mainView.mainModels.listItemsModel.listData.type = itemDelegate.type
                    mainView.mainModels.listItemsModel.listData.categoryName = itemDelegate.categoryName
                    mainView.mainModels.listItemsModel.listData.creationDate = itemDelegate.creationDate
                    mainView.mainModels.listItemsModel.listData.modifiedDate = itemDelegate.modifiedDate
                    mainView.mainModels.listItemsModel.listData.completionDate = itemDelegate.completionDate
                    mainView.mainModels.listItemsModel.listData.targetDate = itemDelegate.targetDate
                    mainView.mainModels.listItemsModel.listData.status = itemDelegate.status
                    mainView.mainModels.listItemsModel.listData.isFavorite = itemDelegate.isFavorite
                    mainView.mainModels.listItemsModel.listData.itemCount = itemDelegate.itemCount
                    mainView.mainModels.listItemsModel.listData.checkedCount = itemDelegate.checkedCount
                    mainView.sidePage.show()
                }
//~                 onOpenDetails: 
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
