/*
 * Copyright (C) 2016 Canonical, Ltd.
 * Copyright (C) 2022 UBports Foundation
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
 * 
 * Modified by Kugi Eusebio <https://github.com/kugiigi>
 */

import QtQuick 2.12
import QtQuick.Controls.Suru 2.2
import QtGraphicalEffects 1.0

Item {
    id: root

    property Item sourceItem
    property alias color: background.color
    property alias backgroundOpacity: background.opacity
    property alias blurRadius: fastBlur.radius
    property rect blurRect: Qt.rect(0,0,0,0)
    property bool occluding: false

    ShaderEffectSource {
        id: shaderEffectSource
        sourceItem: root.sourceItem
        hideSource: root.occluding
        sourceRect: root.blurRect
        live: false
        enabled: sourceItem != null
    }

    FastBlur {
        id: fastBlur
        anchors.fill: parent
        source: shaderEffectSource
        radius: Suru.units.gu(3)
        cached: false
        visible: sourceItem != null
        enabled: visible
    }

    Timer {
        interval: 48
        repeat: root.visible && (sourceItem != null)
        running: repeat
        onTriggered: shaderEffectSource.scheduleUpdate()
    }

    Rectangle {
        id: background

        anchors.fill: parent
        opacity: 0.8
        color: Suru.backgroundColor
    }
}
