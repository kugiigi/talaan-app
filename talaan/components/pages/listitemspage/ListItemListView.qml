import QtQuick 2.12
import QtQml.Models 2.2
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import "../.." as Components
import "../../../common" as Common
//~ import "../../../library/functions.js" as Functions

Common.BaseListView {
    id: listItemListView

    readonly property real itemMargins: Suru.units.gu(1)
    property alias baseModel: filteredModel.model
    property bool isCheckableList: true
    property bool isReadOnlyList: false

    signal openContextMenu(var itemDelegate, real mouseX, real mouseY)
    signal openDetails(int listId)
    signal itemToggled(string itemName, int itemStatus)

    QtObject {
        id: internal

        property int previousIndex: 0
    }

    model: filteredModel
    currentIndex: -1
//~     interactive: false
    keyNavigationEnabled: true
//~     boundsMovement: contentY == 0 ? Flickable.StopAtBounds : Flickable.FollowBoundsBehavior
//~     boundsBehavior: Flickable.DragOverBounds

    onActiveFocusChanged: {
        if (!activeFocus) {
            internal.previousIndex = currentIndex
            currentIndex = -1
        } else {
            if (internal.previousIndex > -1) {
                currentIndex = internal.previousIndex
            }
        }
    }

    onVisibleChanged: {
        if (!visible) {
            currentIndex = -1
            internal.previousIndex = 0
        } else {
            currentIndex = -1
        }
    }

    Keys.onEnterPressed: currentItem.clicked()
    Keys.onReturnPressed: currentItem.clicked()

    add: Transition {
        NumberAnimation {
            properties: "y"
            easing: Suru.animations.EasingIn
            duration: Suru.animations.SnapDuration
        }
    }

    DelegateModel {
        id: filteredModel

        function update(searchText) {
            if (items.count > 0) {
                items.setGroups(0, items.count, ["items"]);
            }

            if (searchText) {
                filterOnGroup = "match"
                let _match = [];
                let _searchTextUpper = searchText.toUpperCase()
                let _nameUpper
                let _commentsUpper
                let _item

                for (var i = 0; i < items.count; ++i) {
                    _item = items.get(i);
                    _nameUpper = _item.model.name.toUpperCase()
                    _commentsUpper = _item.model.comments.toUpperCase()

                    if (_nameUpper.indexOf(_searchTextUpper) > -1 || _commentsUpper.indexOf(_searchTextUpper) > -1 ) {
                        _match.push(_item);
                    }
                }

                for (i = 0; i < _match.length; ++i) {
                    _item = _match[i];
                    _item.inMatch = true;
                }
            } else {
                filterOnGroup = "items"
            }
        }

        groups: [
            DelegateModelGroup {
                id: matchGroup

                name: "match"
                includeByDefault: false
            }
        ]

        delegate: ListItemDelegate {
            id: listViewDelegate

            highlighted: ListView.isCurrentItem
//~             scale: highlighted ? 1.05 : 1
//~             Behavior on scale {
//~                 NumberAnimation {
//~                     easing: Suru.animations.EasingIn
//~                     duration: Suru.animations.FastDuration
//~                 }
//~             }
            anchors {
                left: parent.left
                right: parent.right
                margins: Suru.units.gu(1)
            }
            itemName: model.name
            comments: model.comments
            priority: model.priority
            status: model.status

            isCheckable: listItemListView.isCheckableList
            isReadOnly: listItemListView.isReadOnlyList
            hasLargerFontSize: mainView.settings.listItemFontSize

//~             onIsCheckedChanged: listItemListView.itemToggled(itemName, isChecked ? 1 : 0)
            onInteractivelyToggled: listItemListView.itemToggled(itemName, isChecked ? 1 : 0)

            onHighlightedChanged: {
                if (highlighted) {
                    listItemListView.positionViewAtIndex(index, ListView.Contain)
                }
            }

            onClicked: {
                if (isExpandable) {
                    isExpanded = !isExpanded
                }
            }

            onShowContextMenu: {
                listItemListView.currentIndex = index
                listItemListView.openContextMenu(listViewDelegate, mouseX, mouseY)
            }

//~             onRightClicked: {
//~                 listItemListView.currentIndex = index
//~                 listItemListView.openContextMenu(listViewDelegate, mouseX, mouseY)
//~             }
//~             onPressAndHold: {
//~                 listItemListView.currentIndex = index
//~                 listItemListView.openContextMenu(listViewDelegate, mouseX, mouseY)
//~             }
        }
    }
}
