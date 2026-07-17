import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import ".." as Components
import "../../library/dataUtils.js" as DataUtils
import "../../library/functions.js" as Functions
import "../../library/ApplicationFunctions.js" as AppFunctions
import "../../common/" as Common

Item {
    id: mainModels

    readonly property string listsID: "Lists"
    readonly property string listItemsID: "ListItems"
//~     readonly property string currenciesID: "Currencies"
    readonly property string categoriesID: "Categories"
//~     readonly property string firstDetailedListID: "Detailed_1"
//~     readonly property string secondDetailedListID: "Detailed_2"
//~     readonly property string thirdDetailedListID: "Detailed_3"
//~     readonly property string quickExpensesID: "QuickExpenses"
//~     readonly property string historyEntryExpensesID: "HistoryEntry"
//~     readonly property string searchExpenseID: "SearchExpense"

//~     readonly property string todayBreakdownChartID: "TodayBreakdownChart"
//~     readonly property string thisWeekBreakdownChartID: "ThisWeekBreakdownChart"
//~     readonly property string thisMonthBreakdownChartID: "ThisMonthBreakdownChart"
//~     readonly property string thisYearBreakdownChartID: "ThisYearBreakdownChart"
//~     readonly property string recentBreakdownChartID: "RecentBreakdownChart"

//~     readonly property string thisWeekTrendChartID: "ThisWeekTrendChart"
//~     readonly property string recentTrendChartID: "RecentTrendChart"
//~     readonly property string thisMonthTrendChartID: "ThisMonthTrendChart"
//~     readonly property string thisYearTrendChartID: "ThisYearTrendChart"
    
    property alias listsModel: listsModel
    property alias listItemsModel: listItemsModel
//~     property var detailedListModels: [ firstDetailedListModel, secondDetailedListModel, thirdDetailedListModel ]
//~     property alias firstDetailedListModel: firstDetailedListModel
//~     property alias secondDetailedListModel: secondDetailedListModel
//~     property alias thirdDetailedListModel: thirdDetailedListModel
//~     property alias exchangeRatesModel: exchangeRatesModel
//~     property alias currenciesModel: currenciesModel
    property alias categoriesModel: categoriesModel
//~     property alias quickExpensesModel: quickExpensesModel
//~     property alias historyEntryExpensesModel: historyEntryExpensesModel

//~     property alias searchExpenseModel: searchExpenseModel

//~     // Breakdown Chart Models
//~     property alias todayBreakdownChartModel: todayBreakdownChartModel
//~     property alias thisWeekBreakdownChartModel: thisWeekBreakdownChartModel
//~     property alias thisMonthBreakdownChartModel: thisMonthBreakdownChartModel
//~     property alias thisYearBreakdownChartModel: thisYearBreakdownChartModel
//~     property alias recentBreakdownChartModel: recentBreakdownChartModel
    
//~     // Trend Chart Models
//~     property alias thisWeekTrendChartModel: thisWeekTrendChartModel
//~     property alias recentTrendChartModel: recentTrendChartModel
//~     property alias thisMonthTrendChartModel: thisMonthTrendChartModel
//~     property alias thisYearTrendChartModel: thisYearTrendChartModel

//~     // Refresh models that are affected by new, edited or deleted expense values
//~     function refreshValues(entryDate, expenseID) {
//~         if (entryDate) {
//~             // Refresh quick history model
//~             if (Functions.isToday(entryDate)) {
//~                 historyEntryExpensesModel.refresh()
//~             }

//~             // Refresh detailed list models
//~             if (Functions.checkIfWithinDateRange(entryDate, firstDetailedListModel.fromDate, firstDetailedListModel.toDate)) {
//~                 firstDetailedListModel.refresh()
//~             }

//~             if (Functions.checkIfWithinDateRange(entryDate, secondDetailedListModel.fromDate, secondDetailedListModel.toDate)) {
//~                 secondDetailedListModel.refresh()
//~             }

//~             if (Functions.checkIfWithinDateRange(entryDate, thirdDetailedListModel.fromDate, thirdDetailedListModel.toDate)) {
//~                 thirdDetailedListModel.refresh()
//~             }

//~             // Refresh breakdown chart models
//~             if (Functions.checkIfWithinDateRange(entryDate, todayBreakdownChartModel.getFromDate(), todayBreakdownChartModel.getToDate())) {
//~                 todayBreakdownChartModel.refresh()
//~             }

//~             if (Functions.checkIfWithinDateRange(entryDate, thisWeekBreakdownChartModel.getFromDate(), thisWeekBreakdownChartModel.getToDate())) {
//~                 thisWeekBreakdownChartModel.refresh()
//~             }

//~             if (Functions.checkIfWithinDateRange(entryDate, thisMonthBreakdownChartModel.getFromDate(), thisMonthBreakdownChartModel.getToDate())) {
//~                 thisMonthBreakdownChartModel.refresh()
//~             }

//~             if (Functions.checkIfWithinDateRange(entryDate, thisYearBreakdownChartModel.getFromDate(), thisYearBreakdownChartModel.getToDate())) {
//~                 thisYearBreakdownChartModel.refresh()
//~             }

//~             if (Functions.checkIfWithinDateRange(entryDate, recentBreakdownChartModel.getFromDate(), recentBreakdownChartModel.getToDate())) {
//~                 recentBreakdownChartModel.refresh()
//~             }

//~             // Refresh trend chart models
//~             if (Functions.checkIfWithinDateRange(entryDate, thisWeekTrendChartModel.getFromDate(), thisWeekTrendChartModel.getToDate())) {
//~                 thisWeekTrendChartModel.refresh()
//~             }

//~             if (Functions.checkIfWithinDateRange(entryDate, thisMonthTrendChartModel.getFromDate(), thisMonthTrendChartModel.getToDate())) {
//~                 thisMonthTrendChartModel.refresh()
//~             }

//~             if (Functions.checkIfWithinDateRange(entryDate, thisYearTrendChartModel.getFromDate(), thisYearTrendChartModel.getToDate())) {
//~                 thisYearTrendChartModel.refresh()
//~             }

//~             if (Functions.checkIfWithinDateRange(entryDate, recentTrendChartModel.getFromDate(), recentTrendChartModel.getToDate())) {
//~                 recentTrendChartModel.refresh()
//~             }
//~         }

//~         if (expenseID) {
//~             if (searchExpenseModel.find(expenseID, "expense_id") > -1) {
//~                 searchExpenseModel.refresh()
//~             }
//~         }
//~     }

//~     // Refreshes all data relevant to the active profile
//~     function refreshAllProfileData() {
//~         firstDetailedListModel.refresh()
//~         secondDetailedListModel.refresh()
//~         thirdDetailedListModel.refresh()

//~         categoriesModel.refresh()
//~         quickExpensesModel.refresh()
//~         historyEntryExpensesModel.refresh()
//~         searchExpenseModel.refresh()

//~         // Breakdown Chart Models
//~         todayBreakdownChartModel.refresh()
//~         thisWeekBreakdownChartModel.refresh()
//~         thisMonthBreakdownChartModel.refresh()
//~         thisYearBreakdownChartModel.refresh()
//~         recentBreakdownChartModel.refresh()

//~         // Trend Chart Models
//~         thisWeekTrendChartModel.refresh()
//~         recentTrendChartModel.refresh()
//~         thisMonthTrendChartModel.refresh()
//~         thisYearTrendChartModel.refresh()
//~     }

//~     function refreshQuickExpense() {
//~         quickExpensesModel.refresh()
//~     }

//~     function refreshProfiles() {
//~         profilesModel.refresh()
//~     }

    function refreshCategories(operation = "ADD") {
//~         switch(operation) {
//~             case "EDIT":
//~                 // Refresh all data with category to take effect
//~                 refreshAllProfileData() // Same list for now
//~                 break
//~             case "DELETE":
                categoriesModel.refresh()
//~                 quickExpensesModel.refresh() // Since they are deleted too
//~                 break
//~             case "ADD":
//~             default:
//~                 categoriesModel.refresh()
//~                 break
//~         }
    }

    /*WorkerScript for asynch loading of models*/
    WorkerScript {
        id: workerLoader
        source: "ModelWorkerScript.mjs"

        onMessage: {
            switch (messageObject.modelId) {
            case mainModels.listsID:
                listsModel.loadingStatus = "Ready"
                break;
            case mainModels.listItemsID:
                listItemsModel.loadingStatus = "Ready"
                break;
            case mainModels.categoriesID:
                categoriesModel.loadingStatus = "Ready"
                break;
            }
        }
    }

    Common.BaseListModel {
        id: listsModel

        worker: workerLoader
        modelId: mainModels.listsID
        Component.onCompleted: refresh()

        function refresh() {
            fillData(mainView.lists.activeList())
//~             fillData(mainView.lists.archivedList())
        }

        function removeItem(listId) {
            let _itemIndex = find(listId, "list_id")

            if (_itemIndex > -1) {
                remove(_itemIndex)
            }
        }

        function updateFavorite(listId, isFavorite) {
            let _item = getItem(listId, "list_id")

            if (_item) {
                _item.favorite = isFavorite ? 1 : 0
            }
        }
    }

    Common.BaseListModel {
        id: categoriesModel

        modelId: mainModels.categoriesID
        worker: workerLoader
        Component.onCompleted: refresh()

        function refresh() {
            fillData(mainView.categories.list())
        }

        function getColor(category) {
            for (let i = 0; i < count; i++) {
                if (get(i).category_name === category) {
                    return get(i).colorValue
                }
            }
        }
    }

    Common.BaseListModel {
        id: listItemsModel

        readonly property int listId: listData.listId
        readonly property Components.ListData listData: Components.ListData {
            id: listDataObj
        }
        property int sort: mainView.settings.intSort
        property bool listPriorityFirst: mainView.settings.displayPriorityFirst

        modelId: mainModels.listItemsID
        worker: workerLoader
        Component.onCompleted: refresh()
        onListIdChanged: refresh()
        onSortChanged: refresh()
        onListPriorityFirstChanged: refresh()

        function refresh() {
            fillData(mainView.listItems.list(listId, sort, listPriorityFirst))
        }
    }

//~     Common.BaseListModel {
//~         id: quickExpensesModel
  
//~         worker: workerLoader
//~         modelId: mainModels.quickExpensesID
//~         Component.onCompleted: refresh()

//~         function refresh() {
//~             fillData(mainView.quickExpenses.list())
//~         }
//~     }

//~     Common.BaseListModel {
//~         id: historyEntryExpensesModel

//~         property string searchText: ""
//~         property int resultLimit: 10

//~         worker: workerLoader
//~         modelId: mainModels.historyEntryExpensesID
//~         Component.onCompleted: refresh()

//~         onSearchTextChanged: refresh()

//~         function refresh() {
//~             fillData(mainView.expenses.historyDataForEntry(searchText, resultLimit))
//~         }
//~     }
    
//~     // Search Expense model
//~     Common.BaseListModel {
//~         id: searchExpenseModel

//~         property string searchText: ""
//~         property string order: "desc"
//~         property int resultLimit: 50

//~         modelId: mainModels.searchExpenseID
//~         worker: workerLoader

//~         function refresh() {
//~             fillData(mainView.expenses.search(searchText, resultLimit, order))
//~         }

//~         Component.onCompleted: refresh()

//~         onSearchTextChanged: refresh()
//~         onOrderChanged: refresh()
//~     }

//~     // Detailed List Models
//~     BaseValuesModel {
//~         id: firstDetailedListModel

//~         modelId: mainModels.firstDetailedListID
//~         worker: workerLoader
//~     }

//~     BaseValuesModel {
//~         id: secondDetailedListModel

//~         modelId: mainModels.secondDetailedListID
//~         worker: workerLoader
//~     }

//~     BaseValuesModel {
//~         id: thirdDetailedListModel

//~         modelId: mainModels.thirdDetailedListID
//~         worker: workerLoader
//~     }

//~     // Breakdown Charts
//~     BreakdownChartModel {
//~         id: todayBreakdownChartModel

//~         dataID: "today"
//~         modelFunction: mainView.dashboard.breakdown
//~         worker: workerLoader
//~         modelId: mainModels.todayBreakdownChartID
//~         onReadyChanged: {
//~             if (ready) {
//~                 let _currentProfileName = mainView.profiles.currentName()
//~                 let _currentData = get(0).data
//~                 let _newMetricMsg = ""
//~                 let _total = 0

//~                 if (_currentProfileName) {
//~                     _newMetricMsg = "<b>" + i18n.tr("Today's expenses [%1]:<br>").arg(_currentProfileName) + "</b>"
//~                 } else {
//~                     _newMetricMsg = "<b>" + i18n.tr("Today's expenses:<br>") + "</b>"
//~                 }

//~                 for (let i = 0; i < _currentData.count; i++) {
//~                     let _currentItem = _currentData.get(i)
//~                     let _label = _currentItem.label
//~                     let _value = _currentItem.value

//~                     _total += _value
//~                     _newMetricMsg = _newMetricMsg + "<br>%1 - %2".arg(_label).arg(AppFunctions.formatMoney(_value))
                    
//~                 }

//~                 if (_total > 0) {
//~                     _newMetricMsg = _newMetricMsg + "<br><br><i>" + i18n.tr("Total: <b>%1</b>").arg(AppFunctions.formatMoney(_total)) + "</i>"
//~                     mainView.userMetric.circleMetric = _newMetricMsg
//~                     mainView.userMetric.increment(1)
//~                 } else {
//~                     mainView.userMetric.circleMetric = mainView.userMetric.emptyFormat
//~                 }
//~             }
//~         }
//~     }

//~     BreakdownChartModel {
//~         id: thisWeekBreakdownChartModel

//~         dataID: "thisweek"
//~         modelFunction: mainView.dashboard.breakdown
//~         worker: workerLoader
//~         modelId: mainModels.thisWeekBreakdownChartID
//~     }

//~     BreakdownChartModel {
//~         id: thisMonthBreakdownChartModel

//~         dataID: "thismonth"
//~         modelFunction: mainView.dashboard.breakdown
//~         worker: workerLoader
//~         modelId: mainModels.thisMonthBreakdownChartID
//~     }

//~     BreakdownChartModel {
//~         id: thisYearBreakdownChartModel

//~         dataID: "thisyear"
//~         modelFunction: mainView.dashboard.breakdown
//~         worker: workerLoader
//~         modelId: mainModels.thisYearBreakdownChartID
//~     }

//~     BreakdownChartModel {
//~         id: recentBreakdownChartModel

//~         dataID: "recent"
//~         modelFunction: mainView.dashboard.breakdown
//~         worker: workerLoader
//~         modelId: mainModels.recentBreakdownChartID
//~     }

//~     // Trend Chart Models
//~     TrendChartModel {
//~         id: thisWeekTrendChartModel

//~         chartRange: "thisweek"
//~         chartMode: "day"
//~         modelFunction: mainView.dashboard.trend
//~         worker: workerLoader
//~         modelId: mainModels.thisWeekTrendChartID
//~     }

//~     TrendChartModel {
//~         id: recentTrendChartModel

//~         chartRange: "recent"
//~         chartMode: "day"
//~         modelFunction: mainView.dashboard.trend
//~         worker: workerLoader
//~         modelId: mainModels.recentTrendChartID
//~     }

//~     TrendChartModel {
//~         id: thisMonthTrendChartModel

//~         chartRange: "thismonth"
//~         chartMode: "week"
//~         modelFunction: mainView.dashboard.trend
//~         worker: workerLoader
//~         modelId: mainModels.thisMonthTrendChartID
//~     }

//~     TrendChartModel {
//~         id: thisYearTrendChartModel

//~         chartRange: "thisyear"
//~         chartMode: "month"
//~         modelFunction: mainView.dashboard.trend
//~         worker: workerLoader
//~         modelId: mainModels.thisYearTrendChartID
//~     }

//~     Connections {
//~         target: mainView

//~         // Refresh 
//~         onCurrentDateChanged: {
//~             mainModels.refreshValues(currentDate)
//~         }
//~     }

//~     Connections {
//~         target: mainView.settings
//~         onActiveProfileChanged: {
//~             refreshAllProfileData()
//~         }
//~     }
}
