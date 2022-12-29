
/*
 * Copyright (C) 2016 - Nick Eusebio <kugi_igi@gmail.com>
 *                      adapted from WifiScanner created by Michael Zanetti <michael.zanetti@ubuntu.com>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/
import QtQuick 2.4
import Lomiri.Components 1.3

Item {
    id: splitItem

    property alias bottomItem: bottomItem.children
    property alias topItem: topItem.children
    property alias dragHandle: dragHandle
    property real defaultDivider: parent === null ? 0 : parent.height/ 2
    property real minimumItemHeight:0

    Behavior on y {
        LomiriNumberAnimation {
        }
    }

    Item {
        id: topItem
        z: 2
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: dragHandle.top
        }
    }

    Rectangle {
        id: dragHandle

        property bool highlighted: false

        z: 3
        anchors {
            left: parent.left
            right: parent.right
        }
        y: defaultDivider
        height: units.gu(2)
        color: switch (settings.currentTheme) {
               case "Default":
                   highlighted ? theme.palette.normal.selection : Qt.lighter(Qt.lighter("#2E2020"))
                   break
               case "Ambiance":
               case "System":
               case "SuruDark":
                   highlighted ? theme.palette.normal.selection : theme.palette.normal.overlay
                   break
               default:
                   highlighted ? theme.palette.normal.selection : Qt.lighter(Qt.lighter("#2E2020"))
               }

        Row {
            z: 4
            anchors.centerIn: parent
            spacing: units.gu(1)
            Repeater {
                model: 3
                Rectangle {
                    height: units.gu(1)
                    width: height
                    radius: height / 2
                    color: switch (settings.currentTheme) {
                           case "Default":
                               "#371300"
                               break
                           case "Ambiance":
                           case "System":
                           case "SuruDark":
                               theme.palette.normal.overlayText
                               break
                           default:
                               "#371300"
                           }
                }
            }
        }


        MouseArea {
            id: dragHandleMouseArea
            z: 5
            cursorShape: Qt.SplitVCursor
            anchors.fill: parent

            property bool ignoring: false
            property real nextY

            onPressed: {
                dragHandle.highlighted = true
            }
            onMouseYChanged: {

                nextY = dragHandle.y + mouseY
                if(nextY < (splitItem.height - minimumItemHeight) && nextY > minimumItemHeight){
                    dragHandle.y = dragHandle.y + mouseY
                }
            }
            onReleased: {
                if (Math.abs(defaultDivider - (dragHandle.y + (dragHandle.height / 2))) < units.gu(3)) {
                    dragHandle.y = defaultDivider - (dragHandle.height / 2)
                }
                dragHandle.highlighted = false
            }
        }
    }

    Item {
        id: bottomItem
        z: 1
        anchors {
            left: parent.left
            right: parent.right
            top: dragHandle.bottom
            bottom: parent.bottom
        }
    }
}
