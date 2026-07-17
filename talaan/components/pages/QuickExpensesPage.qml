import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import Lomiri.Components 1.3 as UT
import ".." as Components
import "../../common" as Common
import "../../common/listitems" as ListItems
import "../../common/pages" as Pages
import "../../common/dialogs" as Dialogs
import "../../common/menus" as Menus
import "quickexpensespage"
import "detailedlistpage"

Pages.BasePage {
    id: quickExpensesPage

    property bool coloredCategory: false
    property string homeCurrency: "PHP"

    title: i18n.tr("Quick Expenses")
    headerRightActions: [ addAction ]
    
    QtObject {
        id: internal

        property Components.ExpenseData expenseData: expenseDataObj
    }

    Common.BaseAction {
        id: addAction
        
        text: i18n.tr("New Quick Expense")
        shortText: i18n.tr("New")
        iconName: "add"
        
        onTrigger: {
            let _popup = addEditDialog.createObject(mainView.mainSurface, { mode: "add", currencySymbol: mainView.settings.currentCurrencySymbol })
            _popup.proceed.connect(function(category, name, description, value) {
                let _tooltipMsg

                internal.expenseData.name = name
                internal.expenseData.description = description
                internal.expenseData.category = category
                internal.expenseData.value = value

                let _result = mainView.quickExpenses.add(internal.expenseData)
                if (_result.success) {
                    _tooltipMsg = i18n.tr("Quick expense added")
                    _popup.close()
                } else {
                    if (_result.exists) {
                        _tooltipMsg = i18n.tr("Already exists")
                    } else {
                        _tooltipMsg = i18n.tr("New Quick expense failed")
                    }
                }

                mainView.tooltip.display(_tooltipMsg)
            })

            _popup.openDialog();
        }
    }

    Common.BaseAction {
        id: editAction

        text: i18n.tr("Edit")
        iconName: "edit"

        onTrigger: {
            let _properties = {
                mode: "edit"
                , currencySymbol: mainView.settings.currentCurrencySymbol
                , expenseData: contextMenu.itemData
            }
            let _popup = addEditDialog.createObject(mainView.mainSurface, _properties)
            _popup.proceed.connect(function(category, name, description, value) {
                let _tooltipMsg

                internal.expenseData.expenseID = contextMenu.itemData.expenseID
                internal.expenseData.name = name
                internal.expenseData.description = description
                internal.expenseData.category = category
                internal.expenseData.value = value

                let _result = mainView.quickExpenses.edit(internal.expenseData)
                if (_result.success) {
                    _tooltipMsg = i18n.tr("Quick expense edited")
                    _popup.close()
                } else {
                    if (_result.exists) {
                        _tooltipMsg = i18n.tr("Already exists")
                    } else {
                        _tooltipMsg = i18n.tr("Editing failed")
                    }
                }

                mainView.tooltip.display(_tooltipMsg)
            })

            _popup.openDialog();
        }
    }

    Common.BaseAction {
        id: deleteAction

        text: i18n.tr("Delete")
        iconName: "delete"

        onTrigger: {
            let _popup = deleteDialogComponent.createObject(mainView.mainSurface, { expenseData: contextMenu.itemData } )
            _popup.proceed.connect(function() {
                let _tooltipMsg

                if (mainView.quickExpenses.delete(contextMenu.itemData.expenseID).success) {
                    _tooltipMsg = i18n.tr("Quick expense deleted")
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

    Menus.ContextMenu {
        id: contextMenu

        readonly property Components.ExpenseData itemData: Components.ExpenseData {
            id: expenseDataObj
        }

        actions: [ editAction, separatorAction, deleteAction ]
        listView: listView
    }
    
    Components.EmptyState {
        id: emptyState

        anchors.centerIn: parent
        title: i18n.tr("No Quick Expenses")
        loadingTitle: i18n.tr("Loading data")
        loadingSubTitle: i18n.tr("Please wait")
        isLoading: !listView.model.ready
        shown: listView.count == 0 || !listView.model.ready
    }

    Common.BaseListView {
        id: listView

        anchors {
            fill: parent
            margins: Suru.units.gu(1)
        }
        currentIndex: -1
        pageHeader: quickExpensesPage.pageManager ? quickExpensesPage.pageManager.pageHeader : null
        model: mainView.mainModels.quickExpensesModel
        delegate: ValueListDelegate {
            id: valuesListDelegate

            anchors {
                left: parent.left
                right: parent.right
                margins: units.gu(1)
            }

            expenseID: model.quickID
            homeValue: model.value
            homeCurrency: quickExpensesPage.homeCurrency
            comments: model.description
            itemName: model.name
            categoryName: model.categoryName
            highlighted: listView.currentIndex == index
            showDate: false
            showCategory: true
            coloredCategory: quickExpensesPage.coloredCategory

            onShowContextMenu: {
                contextMenu.itemData.expenseID = expenseID
                contextMenu.itemData.name = itemName
                contextMenu.itemData.category = categoryName
                contextMenu.itemData.value = homeValue
                contextMenu.itemData.description = comments
                contextMenu.itemData.travelData.homeCur = homeCurrency

                listView.currentIndex = index
                contextMenu.popupMenu(valuesListDelegate, mouseX, mouseY)
            }

            onClicked: {
                if (isExpandable) {
                    isExpanded = !isExpanded
                }
            }
        }
    }

    Component {
        id: deleteDialogComponent

        DeleteQuickExpenseDialog {}
    }

    Component {
        id: addEditDialog

        NewQuickExpenseDialog {}
    }
}
