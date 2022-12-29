/*
 * Copyright (C) 2015-2016 Canonical Ltd
 *
 * This file is part of Ubuntu Clock App
 *
 * Ubuntu Clock App is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * Ubuntu Clock App is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

/*
  * Some modifications by Nick Luigi V. Eusebio for Talaan <https://launchpad.net/talaan-app>
 */
import QtQuick 2.9
import Lomiri.Components 1.3


/*
 Component which extends the SDK Expandable list item and provides a easy
 to use component where the title, subtitle and a listview can be displayed. It
 matches the design specification provided for clock.
*/

ListItem {
    id: root

    // Public APIs
    property ListModel model
    property Component delegate
    property Component delegateChild
    property string savedValue
    property int selectedIndex
    property alias titleText: expandableHeader.title
    property alias subText: expandableHeader.subtitle
    property alias listViewHeight: expandableListLoader.height
    property alias delegateItem: expandableListLoader.item
    property alias trailingItemComponent: leadingItemLoader.sourceComponent
    property alias color: headerListItem.color
    property alias highlightColor: highlightRec.color
    property alias padding: expandableHeader.padding
    property int modelCount: model !== null ? model.count : 0
    property bool expansionBottomDivider: true
    property string iconName
    property color iconColor
    property bool arrowVisible: true
    property bool listViewInteractive: false
    property alias headerDivider: headerListItem.divider
    property color listBackgroundColor: theme.palette.normal.background
    property bool listBackground: false
    property bool dropDownMode: false
    property bool multipleSelectionWithOrder: false
    property bool multipleSelection: false
    property string valueRoleName: "value"
    property string textRoleName: "text"
    property string subTextRoleName: "subText"
    property bool listDividerVisible: true
    property color listItemColor: theme.palette.normal.foregroundText

    height: headerListItem.height
    expansion.height: expandableListLoader.item
                      !== null ? headerListItem.height
                                 + expandableListLoader.item.height : headerListItem.height

    divider.visible: !expansion.expanded ? true : expansionBottomDivider ? true : false

    signal toggle(string newValue)
    signal orderToggle(string newValue)

    onModelCountChanged: {
        if (modelCount > 0) {
            var i = 0
            var value = model.get(i)[root.valueRoleName]

            while (savedValue !== value && i != model.count - 1) {
                i++
                value = model.get(i)[root.valueRoleName]
            }
            selectedIndex = i
        }
    }

    onSavedValueChanged: {
        if (model) {
            if (model.count > 0) {
                var i = 0
                while (savedValue !== model.get(i)[root.valueRoleName]
                       && i != model.count - 1) {
                    i++
                }
                root.selectedIndex = i
            }
        }
    }

    Behavior on height {
        LomiriNumberAnimation {
            easing: LomiriAnimation.StandardEasing
            duration: LomiriAnimation.SnapDuration
        }
    }

    Rectangle {
        id: highlightRec
        color: theme.palette.highlighted.overlay //"#2D371300"
        visible: opacity === 0 ? false : true
        opacity: 0
        height: headerListItem.height //units.gu(8)
        Behavior on opacity {
            LomiriNumberAnimation {
                easing.type: Easing.OutCubic
                duration: LomiriAnimation.BriskDuration
            }
        }
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
    }

    MouseArea {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        onPressed: {
            highlightRec.opacity = 1
        }
        onReleased: {
            highlightRec.opacity = 0
        }
        onCanceled: highlightRec.opacity
                    = 0 //workaround on the issue when swiping does not trigger Released

        Component.onCompleted: height = units.gu(8) //expandableHeader.height

        onClicked: root.expansion.expanded = !root.expansion.expanded
    }

    ListItem {
        id: headerListItem

        height: divider.visible ? expandableHeader.height + divider.height : expandableHeader.height
        highlightColor: theme.palette.highlighted.foreground //"#2D371300"
        divider.visible: model !== null ? true : false

        ListItemLayout {
            id: expandableHeader

            title.text: model !== null
                        && root.dropDownMode ? model.get(
                                                   root.selectedIndex)[root.textRoleName] : ""
            subtitle.text: if (root.multipleSelection
                                   || root.multipleSelectionWithOrder) {
                               model !== null ? root.savedValue : ""
                           } else {
                               model !== null ? !root.dropDownMode ? model.get(
                                                                         root.selectedIndex)[root.textRoleName] : model.get(root.selectedIndex)[root.subTextRoleName] : ""
                           }

            Icon {
                name: iconName
                SlotsLayout.position: SlotsLayout.Leading
                color: iconColor !== "" ? iconColor : theme.palette.normal.overlay
                width: units.gu(3)
                visible: iconName !== "" ? true : false
            }

            Loader {
                id: leadingItemLoader
                asynchronous: true
                visible: status == Loader.Ready
                SlotsLayout.position: SlotsLayout.Trailing
            }

            Icon {
                id: arrow

                width: units.gu(2)
                visible: arrowVisible
                height: width
                color: theme.palette.normal.foregroundText
                SlotsLayout.position: SlotsLayout.Trailing
                name: "go-down"
                rotation: root.expansion.expanded ? 180 : 0
                asynchronous: true

                Behavior on rotation {
                    LomiriNumberAnimation {
                    }
                }
            }
        }
    }

    Loader {
        id: expandableListLoader
        width: parent.width
        asynchronous: true
        anchors.top: headerListItem.bottom
        sourceComponent: {
            if (root.model !== null) {
                root.expansion.expanded ? expandableListComponent : undefined
            } else {
                delegateChild
            }
        }
    }

    Component {
        id: expandableListComponent
        ListView {
            id: expandableList

            property bool rootExpanded: root.height === root.expansion.height //wait for the expansion to complete

            interactive: root.listViewInteractive
            clip: true
            model: root.model
            ViewItems.dragMode: root.multipleSelectionWithOrder
            ViewItems.onDragUpdated: {
                if (event.status == ListItemDrag.Started) {
                    if (model.get(event.from).label == "Immutable")
                        event.accept = false
                    return
                }
                if (model.get(event.to).label == "Immutable") {
                    event.accept = false
                    return
                }
                // Live update as you drag
                if (event.status == ListItemDrag.Moving) {
                    model.move(event.from, event.to, 1)
                }
                if (event.status == ListItemDrag.Dropped) {
                    var newValue = getItems(true)
                    var newOrder = getItems(false)
                    toggle(newValue)
                    orderToggle(newOrder)
                }
            }

            onRootExpandedChanged: {
                {
                    if (rootExpanded) {
                        expandableList.positionViewAtIndex(root.selectedIndex,
                                                           ListView.Center)
                    }
                }
            }

            function getItems(selectedOnly) {
                var result = []
                var itemSelected

                for (var i = 0; i <= model.count - 1; i++) {

                    if (selectedOnly) {
                        //WORKAROUND: contentItem has unknown object in index 1
                        if (i >= 1) {
                            if (expandableList.contentItem.children[i + 1] !== undefined) {
                                itemSelected = expandableList.contentItem.children[i + 1].selected
                            }
                        } else {
                            if (expandableList.contentItem.children[i] !== undefined) {
                                itemSelected = expandableList.contentItem.children[i].selected
                            }
                        }
                        if (itemSelected) {
                            result.push(model.get(i)[root.valueRoleName])
                        }
                    } else {
                        result.push(model.get(i)[root.valueRoleName])
                    }
                }

                return result.join(";")
            }

            delegate: ListItem {
                id: listItem

                highlightColor: theme.palette.highlighted.foreground //"#2D371300"
                selected: root.savedValue.search(
                              root.model.get(index)[root.valueRoleName]) >= 0
                divider.visible: root.listDividerVisible
                ListItemLayout {
                    id: listItemLayout
                    title.text: root.model.get(index)[[root.textRoleName]]
                    title.color: listItemColor //theme.palette.normal.foregroundText
                    title.textSize: Label.Small
                    title.font.weight: tickIcon.visible ? Font.Normal : Font.Light

                    Icon {
                        id: tickIcon
                        SlotsLayout.position: SlotsLayout.Leading
                        color: listItemColor //theme.palette.normal.foregroundText
                        width: units.gu(2)
                        height: width
                        name: "tick"
                        visible: if (root.multipleSelection
                                         || root.multipleSelectionWithOrder) {
                                     //                                     root.savedValue.search(root.model.get(
                                     //                                                                index)[root.valueRoleName]) >= 0
                                     listItem.selected
                                 } else {
                                     root.savedValue === root.model.get(
                                                 index)[root.valueRoleName]
                                 }

                        asynchronous: true
                    }
                }

                onClicked: {
                    if (root.multipleSelection
                            || root.multipleSelectionWithOrder) {
                        listItem.selected = !listItem.selected
                        var newValue = expandableList.getItems(true)
                        toggle(newValue)
                    } else {
                        root.selectedIndex = index
                        toggle(root.model.get(index)[root.valueRoleName])
                        root.expansion.expanded = false
                    }
                }
            }
            Rectangle {
                z: -1
                anchors.fill: parent
                visible: root.listBackground
                color: root.listBackgroundColor
                border.width: units.gu(0.05)
                border.color: color
            }
        }
    }
}
