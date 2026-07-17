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
import "profilespage"

Pages.BasePage {
    id: profilesPage

    property int activeProfile: 0

    title: i18n.tr("Profiles")
    headerRightActions: [ addAction ]

    Common.BaseAction {
        id: addAction
        
        text: i18n.tr("New Profile")
        shortText: i18n.tr("New")
        iconName: "add"
        
        onTrigger: {
            let _popup = addEditDialog.createObject(mainView.mainSurface, { mode: "add" })
            _popup.proceed.connect(function(displayName, enableOverlay, overlayColor, overlayOpacity) {
                let _tooltipMsg
                let _result = mainView.profiles.add(displayName, enableOverlay, overlayColor, overlayOpacity)

                if (_result.success) {
                    _tooltipMsg = i18n.tr("Profile added")
                    _popup.close()
                } else {
                    if (_result.exists) {
                        _tooltipMsg = i18n.tr("Already exists")
                    } else {
                        _tooltipMsg = i18n.tr("New Profile failed")
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
                , profileId: contextMenu.profileId
                , displayName: contextMenu.displayName
                , enableOverlay: contextMenu.enableOverlay
                , overlayColor: contextMenu.overlayColor
                , overlayOpacity: contextMenu.overlayOpacity
            }
            let _popup = addEditDialog.createObject(mainView.mainSurface, _properties)
            _popup.proceed.connect(function(displayName, enableOverlay, overlayColor, overlayOpacity) {
                let _tooltipMsg

                let _result = mainView.profiles.edit(contextMenu.profileId, contextMenu.displayName, displayName, enableOverlay, overlayColor, overlayOpacity)
                if (_result.success) {
                    _tooltipMsg = i18n.tr("Profile edited")
                    _popup.close()
                } else {
                    if (_result.exists) {
                        _tooltipMsg = i18n.tr("Same name already exists")
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
            let _popup = deleteDialogComponent.createObject(mainView.mainSurface, { displayName: contextMenu.displayName } )
            _popup.proceed.connect(function() {
                let _tooltipMsg

                if (mainView.profiles.delete(contextMenu.profileId).success) {
                    _tooltipMsg = i18n.tr("Profile deleted")
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

        property int profileId
        property string displayName
        property bool enableOverlay
        property color overlayColor
        property real overlayOpacity

        actions: profileId !== profilesPage.activeProfile ? [ editAction, separatorAction, deleteAction ]
                        : [ editAction ]
        listView: listView
    }

    Components.EmptyState {
        id: emptyState

        anchors.centerIn: parent
        title: i18n.tr("No Profiles")
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
        pageHeader: profilesPage.pageManager ? profilesPage.pageManager.pageHeader : null
        model: mainView.mainModels.profilesModel
        delegate: ListItems.BaseItemDelegate {
            id: itemDelegate

            text: model.displayName
            highlighted: listView.currentIndex == index
            anchors {
                left: parent.left
                right: parent.right
            }
            
            indicator: Label {
                visible: model.profileId == profilesPage.activeProfile
                text: i18n.tr("Active")
                color: Suru.activeFocusColor
                anchors {
                    right: parent.right
                    rightMargin: Suru.units.gu(2)
                    verticalCenter: parent.verticalCenter
                }
            }

            function showContextMenu(mouseX, mouseY) {
                contextMenu.profileId = model.profileId
                contextMenu.displayName = model.displayName
                contextMenu.enableOverlay = model.enableOverlay
                contextMenu.overlayColor = model.overlayColor
                contextMenu.overlayOpacity = model.overlayOpacity
                listView.currentIndex = index
                contextMenu.popupMenu(itemDelegate, mouseX, mouseY)
            }

            onPressAndHold: showContextMenu(pressX, pressY)
            onRightClicked: showContextMenu(mouseX, mouseY)
        }
    }

    Component {
        id: deleteDialogComponent

        DeleteProfileDialog {}
    }

    Component {
        id: addEditDialog

        NewProfileDialog {}
    }
}
