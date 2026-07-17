import QtQuick 2.12
import QtQml.Models 2.2
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import "../.." as Components
import "../../../common" as Common
import "../../../library/functions.js" as Functions

GridView {
    id: listGridView

    enum GridType {
        Rectangle
        , List
    }

    enum Type {
        List
        , Checklist
        , Endless
        , History
        , Archived
    }

    readonly property real preferredGridWidth: Suru.units.gu(30)
    readonly property real preferredGridHeight: Suru.units.gu(15)
    readonly property real preferredListHeight: Suru.units.gu(10)
    readonly property int minimumColumns: 2
    readonly property real itemMargins: Suru.units.gu(1)

    property Common.BaseFlickable flickable
    property alias baseModel: filteredModel.model
    property int gridType: ListGridView.GridType.Rectangle

    property int columnCount: {
        let intendedCount = Math.floor(width / preferredGridWidth)
        return Math.max(intendedCount, minimumColumns)
    }

    signal openContextMenu(var itemDelegate, real mouseX, real mouseY)
    signal openList(var itemDelegate)
    signal openDetails(int listId)

    QtObject {
        id: internal

        property int previousIndex: 0
    }

    model: filteredModel
    currentIndex: -1
    interactive: false
    keyNavigationEnabled: true
    boundsMovement: contentY == 0 ? Flickable.StopAtBounds : Flickable.FollowBoundsBehavior
    boundsBehavior: Flickable.DragOverBounds

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

    cellWidth: {
        switch (listGridView.gridType) {
            case ListGridView.GridType.List:
                return width
            default:
                return width / columnCount
        }
    }

    cellHeight: {
        switch (listGridView.gridType) {
            case ListGridView.GridType.List:
                return listGridView.preferredListHeight
            case ListGridView.GridType.Rectangle:
            default:
                return listGridView.preferredGridHeight
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
                let _descrUpper
                let _item

                for (var i = 0; i < items.count; ++i) {
                    _item = items.get(i);
                    _nameUpper = _item.model.name.toUpperCase()
                    _descrUpper = _item.model.description.toUpperCase()

                    if (_nameUpper.indexOf(_searchTextUpper) > -1 || _descrUpper.indexOf(_searchTextUpper) > -1 ) {
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

        delegate: ListGridDelegate {
            id: gridDelegate

            highlighted: GridView.isCurrentItem
            scale: highlighted ? 1.05 : 1
            Behavior on scale {
                NumberAnimation {
                    easing: Suru.animations.EasingIn
                    duration: Suru.animations.FastDuration
                }
            }
            type: model.type
            listId: model.list_id
            title: model.name
            description: model.description
            categoryName: model.category_name
            creationDate: model.creation_dt
            modifiedDate: model.modified_dt
            completionDate: model.completion_dt
            targetDate: model.target_dt
            status: model.status
            isFavorite: model.favorite == 1 ? true : false
            itemCount: model.item_count
            checkedCount: model.checked_count

            onHighlightedChanged: {
                if (highlighted) {
                    listGridView.flickable.scrollToItem(this, 0, 0)
                }
            }

            onClicked: {
                listGridView.openList(gridDelegate)
            }

            onRightClicked: {
                listGridView.currentIndex = index
                listGridView.openContextMenu(gridDelegate, mouseX, mouseY)
            }
            onPressAndHold: {
                listGridView.currentIndex = index
                listGridView.openContextMenu(gridDelegate, mouseX, mouseY)
            }
        }
    }
}
