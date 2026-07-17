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
import "categoriespage"

Pages.BasePage {
    id: categoriesPage

    title: i18n.tr("Categories")
    headerRightActions: [ addAction ]

    Common.BaseAction {
        id: addAction
        
        text: i18n.tr("New Category")
        shortText: i18n.tr("New")
        iconName: "add"
        
        onTrigger: {
            let _popup = addEditDialog.createObject(mainView.mainSurface, { mode: "add" })
            _popup.proceed.connect(function(categoryName, newCategoryName, categoryDescription, categoryColor) {
                let _tooltipMsg
                let _result = mainView.categories.add(newCategoryName, categoryDescription, categoryColor)
                if (_result.success) {
                    _tooltipMsg = i18n.tr("Category added")
                    _popup.close()
                } else {
                    if (_result.nameExists) {
                        _tooltipMsg = i18n.tr("Name already exists")
                    } else if (_result.colorExists) {
                        _tooltipMsg = i18n.tr("Color already exists")
                    } else {
                        _tooltipMsg = i18n.tr("New category failed")
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
                , categoryName: contextMenu.categoryName
                , categoryDescription: contextMenu.categoryDescription
                , categoryColor: contextMenu.categoryColor
            }
            let _popup = addEditDialog.createObject(mainView.mainSurface, _properties)
            _popup.proceed.connect(function(categoryName, newCategoryName, categoryDescription, categoryColor) {
                let _tooltipMsg
                let _result = mainView.categories.edit(categoryName, newCategoryName, categoryDescription, categoryColor)
                if (_result.success) {
                    _tooltipMsg = i18n.tr("Category edited")
                    _popup.close()
                } else {
                    if (_result.nameExists) {
                        _tooltipMsg = i18n.tr("Name already exists")
                    } else if (_result.colorExists) {
                        _tooltipMsg = i18n.tr("Color already exists")
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
            let _properties = {
                categoryName: contextMenu.categoryName
                , categoryDescription: contextMenu.categoryDescription
            }
            let _popup = deleteDialogComponent.createObject(mainView.mainSurface, _properties )
            _popup.proceed.connect(function() {
                let _tooltipMsg
                let _result = mainView.categories.delete(contextMenu.categoryName)

                if (_result.success) {
                    _tooltipMsg = i18n.tr("Category deleted")
                } else {
                    if (_result.hasData) {
                        _tooltipMsg = i18n.tr("Cannot delete when assigned to expenses")
                    } else {
                        _tooltipMsg = i18n.tr("Deletion failed")
                    }
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

        property string categoryName
        property string categoryDescription
        property color categoryColor

        actions: [ editAction, separatorAction, deleteAction ]
        listView: listView
    }

    Components.EmptyState {
        id: emptyState

        anchors.centerIn: parent
        title: i18n.tr("No Categories")
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
        pageHeader: categoriesPage.pageManager ? categoriesPage.pageManager.pageHeader : null
        model: mainView.mainModels.categoriesModel
        delegate: ListItems.BaseItemDelegate {
            id: itemDelegate

            text: model.category_name
            highlighted: listView.currentIndex == index
            anchors {
                left: parent.left
                right: parent.right
            }

            indicator: Rectangle {
                color: model.colorValue
                radius: height * 0.2
                height: Suru.units.gu(3)
                width: height
                anchors {
                    right: parent.right
                    rightMargin: Suru.units.gu(2)
                    verticalCenter: parent.verticalCenter
                }
                border {
                    color: Suru.tertiaryForegroundColor
                    width: Suru.units.dp(1)
                }
            }

            function showContextMenu(mouseX, mouseY) {
                contextMenu.categoryName = model.category_name
                contextMenu.categoryDescription = model.descr
                contextMenu.categoryColor = model.colorValue
                listView.currentIndex = index
                contextMenu.popupMenu(itemDelegate, mouseX, mouseY)
            }

            onPressAndHold: showContextMenu(pressX, pressY)
            onRightClicked: showContextMenu(mouseX, mouseY)
        }
    }

    Component {
        id: deleteDialogComponent

        DeleteCategoryDialog {}
    }

    Component {
        id: addEditDialog

        NewCategoryDialog {}
    }
}
