/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* Copyright 2013 - 2020, nymea GmbH
* Contact: contact@nymea.io
*
* This file is part of nymea.
* This project including source code and documentation is protected by
* copyright law, and remains the property of nymea GmbH. All rights, including
* reproduction, publication, editing and translation, are reserved. The use of
* this project is subject to the terms of a license agreement to be concluded
* with nymea GmbH in accordance with the terms of use of nymea GmbH, available
* under https://nymea.io/license
*
* GNU General Public License Usage
* Alternatively, this project may be redistributed and/or modified under the
* terms of the GNU General Public License as published by the Free Software
* Foundation, GNU version 3. This project is distributed in the hope that it
* will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty
* of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
* Public License for more details.
*
* You should have received a copy of the GNU General Public License along with
* this project. If not, see <https://www.gnu.org/licenses/>.
*
* For any further details and any questions please contact us under
* contact@nymea.io or see our FAQ/Licensing Information on
* https://nymea.io/license/faq
* 
* Modified by Kugi Eusebio <https://github.com/kugiigi>
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls.Suru 2.2
import "." as Common
import "../library/functions.js" as Functions

ColumnLayout {
    id: root

    readonly property bool inDayMode: mode == internal.dayModeID
    readonly property bool inMonthMode: mode == internal.monthModeID
    readonly property bool inYearMode: mode == internal.yearModeID

    property date baseDate: new Date()
    property date selectedDate: baseDate
    property string mode: internal.dayModeID

    Component.onCompleted: selectedDate = baseDate
    
    onBaseDateChanged: dateViewPath.scrollToBegginer()

    function switchToDayMode() {
        mode = internal.dayModeID
    }

    function toggleMonthMode() {
        if (mode != internal.monthModeID) {
            mode = internal.monthModeID
        } else {
            switchToDayMode()
        }
    }

    function toggleYearMode() {
        if (mode != internal.yearModeID) {
            mode = internal.yearModeID
        } else {
            switchToDayMode()
        }
    }

    function next() {
        dateViewPath.incrementCurrentIndex()
    }
    
    function previous() {
        dateViewPath.decrementCurrentIndex()
    }

    function previousYear() {
        internal.setBaseDateYear(selectedDate.getFullYear() - 1)
    }

    function nextYear() {
        internal.setBaseDateYear(selectedDate.getFullYear() + 1)
    }

    RowLayout {
        Layout.fillWidth: true

        Common.BaseButton {
            id: prevButton

            Layout.preferredHeight: Suru.units.gu(4)

            visible: root.inDayMode
            display: AbstractButton.IconOnly
            icon {
                name: "previous"
                height: Suru.units.gu(2.5)
                width: Suru.units.gu(2.5)
            }

            onClicked: {
                root.previous()
                Common.Haptics.playSubtle()
            }

            onPressAndHold: {
                root.previousYear()
                Common.Haptics.play()
            }

            onRightClicked: root.previousYear()
        }

        Common.BaseButton {
            Layout.fillWidth: true

            text: root.selectedDate.toLocaleDateString(Qt.locale(), "MMMM")
            display: AbstractButton.TextOnly
            alignment: Text.AlignHCenter
            highlighted: root.inMonthMode
            highlightedBorderColor: backgroundColor
            Suru.textLevel: Suru.HeadingThree

            onClicked: root.toggleMonthMode()
        }

        Common.BaseButton {
            Layout.fillWidth: true

            text: root.selectedDate.toLocaleDateString(Qt.locale(), "yyyy")
            display: AbstractButton.TextOnly
            alignment: Text.AlignHCenter
            highlighted: root.inYearMode
            highlightedBorderColor: backgroundColor
            Suru.textLevel: Suru.HeadingThree

            onClicked: root.toggleYearMode()
        }

        Common.BaseButton {
            id: nextButton

            Layout.preferredHeight: Suru.units.gu(4)

            visible: root.inDayMode
            display: AbstractButton.IconOnly
            icon {
                name: "next"
                height: Suru.units.gu(2.5)
                width: Suru.units.gu(2.5)
            }

            onClicked: {
                root.next()
                Common.Haptics.playSubtle()
            }

            onPressAndHold: {
                root.nextYear()
                Common.Haptics.play()
            }

            onRightClicked: root.nextYear()
        }
    }

    ListModel {
        id: monthModel
        ListElement { text: qsTr("January"); days: 31; leapYearDays: 31 }
        ListElement { text: qsTr("February"); days: 28; leapYearDays: 29 }
        ListElement { text: qsTr("March"); days: 31; leapYearDays: 31 }
        ListElement { text: qsTr("April"); days: 30; leapYearDays: 30 }
        ListElement { text: qsTr("May"); days: 31; leapYearDays: 31 }
        ListElement { text: qsTr("June"); days: 30; leapYearDays: 30 }
        ListElement { text: qsTr("July"); days: 31; leapYearDays: 31 }
        ListElement { text: qsTr("August"); days: 31; leapYearDays: 31 }
        ListElement { text: qsTr("September"); days: 30; leapYearDays: 30 }
        ListElement { text: qsTr("October"); days: 31; leapYearDays: 31 }
        ListElement { text: qsTr("November"); days: 30; leapYearDays: 30 }
        ListElement { text: qsTr("December"); days: 31; leapYearDays: 31 }
    }

    ListModel {
        id: weekModel
        ListElement { text: qsTr("Mon") }
        ListElement { text: qsTr("Tue") }
        ListElement { text: qsTr("Wed") }
        ListElement { text: qsTr("Thu") }
        ListElement { text: qsTr("Fri") }
        ListElement { text: qsTr("Sat") }
        ListElement { text: qsTr("Sun") }
    }

    RowLayout {
        visible: root.inDayMode

        Repeater {
            model: weekModel

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: width

                Label {
                    anchors.centerIn: parent
                    text: model.text
                }
            }
        }
    }

    Common.BasePathView {
        id: dateViewPath
        objectName: "dateViewPath"

        Layout.fillWidth: true
        Layout.fillHeight: true

        visible: root.inDayMode
        clip: true

        onCurrentItemChanged: {
            let _newDate = new Date(root.selectedDate)
            _newDate.setMonth(currentItem.baseDate.getMonth())
            _newDate.setFullYear(currentItem.baseDate.getFullYear())
            root.selectedDate = _newDate
        }

        delegate: Item {
            id: pathViewDelegate

            property date baseDate: Functions.addMonths(root.baseDate, dateViewPath.loopCurrentIndex + dateViewPath.indexType(index), false)

            width: parent.width
            height: daysGrid.height

            GridLayout {
                id: daysGrid

                anchors {
                    left: parent.left
                    right: parent.right
                }
                columns: 7
                columnSpacing: 0
                rowSpacing: 0

                property date firstOfMonth: new Date(pathViewDelegate.baseDate.getFullYear(), pathViewDelegate.baseDate.getMonth(), 1)
                property int offset: ((firstOfMonth.getDay() - 1) % 7 + 7) % 7
                property bool isLeapYear: firstOfMonth.getFullYear() % 4 == 0 && firstOfMonth.getFullYear() % 100 != 0
                property int daysInMonth: isLeapYear ? monthModel.get(pathViewDelegate.baseDate.getMonth()).leapYearDays : monthModel.get(pathViewDelegate.baseDate.getMonth()).days
                property int daysInPreviousMonth: isLeapYear ? monthModel.get((pathViewDelegate.baseDate.getMonth() + 11) % 12).leapYearDays
                                    : monthModel.get((pathViewDelegate.baseDate.getMonth() + 11) % 12).days

                Repeater {
                    model: 6 * 7

                    delegate: Rectangle {
                        id: dayItem

                        Layout.preferredWidth: height
                        Layout.preferredHeight: pathViewDelegate.PathView.view.height / 6
                        Layout.alignment: Qt.AlignHCenter

                        readonly property bool isCurrentDay: pathViewDelegate.PathView.isCurrentItem && !isPreviousMonth && !isNextMonth
                                                                    && correctedDayOfMonth == root.selectedDate.getDate()
                        property int dayOfMonth: index - daysGrid.offset + 1
                        property bool isPreviousMonth: dayOfMonth < 1
                        property bool isNextMonth: dayOfMonth > daysGrid.daysInMonth
                        property int correctedDayOfMonth: isPreviousMonth ? daysGrid.daysInPreviousMonth + dayOfMonth
                                                                          : isNextMonth ? dayOfMonth - daysGrid.daysInMonth : dayOfMonth
                        color: isCurrentDay ? Suru.activeFocusColor : "transparent"
                        radius: width / 2

                        Behavior on color {
                            ColorAnimation {
                                duration: Suru.animations.FastDuration
                                easing: Suru.animations.EasingIn
                            }
                        }

                        function selectDate() {
                            if (isPreviousMonth) {
                                root.previous()
                            } else if (isNextMonth) {
                                root.next()
                            }
                            let _newDate = new Date(pathViewDelegate.baseDate)
                            _newDate.setDate(dayOfMonth)
                            root.selectedDate = _newDate
                        }

                        Label {
                            anchors.centerIn: parent
                            opacity: isPreviousMonth || isNextMonth ? 0.6 : 1
                            text: correctedDayOfMonth
                            color: isCurrentDay ? Suru.backgroundColor : Suru.foregroundColor
                            Behavior on color {
                                ColorAnimation {
                                    duration: Suru.animations.FastDuration
                                    easing: Suru.animations.EasingIn
                                }
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                dayItem.selectDate()
                                Common.Haptics.play()
                            }
                        }
                    }
                }
            }
        }
    }

    GridView {
        id: monthsListView

        Layout.fillWidth: true
        Layout.fillHeight: true

        readonly property real preferredDelegateWidth: Suru.units.gu(15)
        readonly property int numberOfColumns: Math.floor(width / preferredDelegateWidth)
        readonly property real defaultDelegateHeight: Suru.units.gu(10)
        readonly property int selectedMonth: new Date(root.selectedDate).getMonth()

        clip: true
        visible: root.inMonthMode
        snapMode: GridView.SnapToRow
        cellWidth: numberOfColumns < 1 ? width : width / numberOfColumns
        cellHeight: defaultDelegateHeight
        model: monthModel
        currentIndex: selectedMonth

        function scrollToCurrent() {
            positionViewAtIndex(currentIndex, GridView.Center)
        }

        onVisibleChanged: if (visible) delayMonthScroll.restart()
        onCurrentIndexChanged: scrollToCurrent()

        Timer {
            id: delayMonthScroll
            running: false
            interval: 1
            onTriggered: monthsListView.scrollToCurrent()
        }

        delegate: Common.BaseButton {
            display: AbstractButton.TextOnly
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
            highlighted: GridView.isCurrentItem
            text: model.text
            Suru.textLevel: Suru.HeadingThree

            onClicked: {
                internal.setBaseDateMonth(index)
                root.switchToDayMode()
            }
        }
    }

    GridView {
        id: yearsListView

        Layout.fillWidth: true
        Layout.fillHeight: true

        readonly property int startYear: 1900
        readonly property real preferredDelegateWidth: Suru.units.gu(15)
        readonly property int numberOfColumns: Math.floor(width / preferredDelegateWidth)
        readonly property real defaultDelegateHeight: Suru.units.gu(6)
        readonly property int selectedYear: new Date(root.selectedDate).getFullYear()

        clip: true
        visible: root.inYearMode
        snapMode: GridView.SnapToRow
        cellWidth: numberOfColumns < 1 ? width : width / numberOfColumns
        cellHeight: defaultDelegateHeight
        model: new Date().getFullYear() - startYear + 50
        currentIndex: selectedYear - startYear

        function scrollToCurrent() {
            positionViewAtIndex(currentIndex, GridView.Center)
        }

        onVisibleChanged: if (visible) delayScroll.restart()
        onCurrentIndexChanged: scrollToCurrent()

        Timer {
            id: delayScroll
            running: false
            interval: 1
            onTriggered: yearsListView.scrollToCurrent()
        }

        delegate: Common.BaseButton {
            display: AbstractButton.TextOnly
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
            highlighted: GridView.isCurrentItem
            text: modelData + GridView.view.startYear
            Suru.textLevel: Suru.HeadingThree

            onClicked: {
                internal.setBaseDateYear(text)
                root.switchToDayMode()
            }
        }
    }

    Shortcut {
        enabled: root.inDayMode
        sequence: StandardKey.MoveToNextChar
        onActivated: next()
    }

    Shortcut {
        enabled: root.inDayMode
        sequence: StandardKey.MoveToPreviousChar
        onActivated: previous()
    }

    Shortcut {
        enabled: root.inDayMode
        sequence: StandardKey.MoveToNextWord
        onActivated: nextYear()
    }

    Shortcut {
        enabled: root.inDayMode
        sequence: StandardKey.MoveToPreviousWord
        onActivated: previousYear()
    }

    QtObject {
        id: internal

        readonly property string dayModeID: "day"
        readonly property string monthModeID: "month"
        readonly property string yearModeID: "year"

        function setBaseDateYear(newYear) {
            let _newDate = new Date(root.selectedDate)
            _newDate.setFullYear(newYear)
            root.baseDate = _newDate
            root.selectedDate = _newDate
        }

        function setBaseDateMonth(newMonth) {
            let _newDate = new Date(root.selectedDate)
            _newDate.setMonth(newMonth)
            root.baseDate = _newDate
            root.selectedDate = _newDate
        }
    }
}
