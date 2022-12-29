/*
 * Copyright (C) 2016 Canonical, Ltd.
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

Component {
    id: textualButton
    AbstractButton {
        id: button
        action: modelData
        width: layout.width + units.gu(4)
        height: parent.height
        Rectangle {
            color: theme.palette.normal.base//LomiriColors.Slate
            opacity: 0.8
            anchors.fill: parent
            visible: button.pressed
        }
        Row {
            id: layout
            anchors.centerIn: parent
            spacing: units.gu(1)
            Icon {
                anchors.verticalCenter: parent.verticalCenter
                width: visible ? units.gu(2) : 0
                height: width
                name: action.iconName
                source: action.iconSource
                visible: (name != "") || (source != "")
            }
            Label {
                anchors.verticalCenter: parent.verticalCenter
                text: action.text
                font.weight: text === i18n.tr("Pick") ? Font.Normal : Font.Light
                color: {
                    if (button.enabled)
                        return text === i18n.tr("Pick") ? theme.palette.selected.backgroundText : theme.palette.normal.backgroundText

                    return theme.palette.disabled.backgroundText
                }
            }
        }
    }
}
