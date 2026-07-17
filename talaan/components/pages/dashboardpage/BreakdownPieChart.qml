import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import QtCharts 2.3
import "../.." as Components
import "../../../common" as Common
import "../../../common/listitems" as ListItems
import "../../../library/functions.js" as Functions
import "../../../library/ApplicationFunctions.js" as AppFunctions

ItemDelegate {
    id: breakdownPieChart

    readonly property int currentTheme: mainView.suruTheme == Suru.Light ? ChartView.ChartThemeLight : ChartView.ChartThemeDark
    readonly property bool isEmpty: currentIsEmpty && previousIsEmpty
    readonly property bool currentIsEmpty: currentLabel.value == 0
    readonly property bool previousIsEmpty: previousLabel.value == 0
    property string currentTitle
    property string previousTitle
    property alias highlightPrevious: chartView.highlightPrevious
    property ListModel model
    property alias chart: chartView
    property real sideMargins: Suru.units.gu(1)
    property bool showDifference: false
    property Item originalParent: parent
    property Item selectedParent: parent

    signal showLegend
    signal rightClicked(real mouseX, real mouseY)

    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0
    hoverEnabled: true

    onClicked: {
        if (checked) {
            highlightPrevious = !highlightPrevious
        } else {
            checked = true
        }
    }

    onPressAndHold: {
        if (checked) {
            showLegend()
        } else {
            highlightPrevious = !highlightPrevious
        }
    }

    onRightClicked: {
        if (checked) {
            showLegend()
        } else {
            highlightPrevious = !highlightPrevious
        }
    }

    onCurrentThemeChanged: {
        delayPropertyChanges.restart()
    }
    
    onHighlightPreviousChanged: {
        let _currentPieSeries = chartView.series("current")

        if (_currentPieSeries) {
            _currentPieSeries.opacity = highlightPrevious ? 0.5 : 1
        }

        let _previousPieSeries = chartView.series("previous")

        if (_previousPieSeries) {
            _previousPieSeries.opacity = highlightPrevious ? 1 : 0.5
        }
    }

    states: [
        State {
            name: "normal"
            when: !checked
            ParentChange { target: breakdownPieChart; parent: originalParent; }
        }
        , State {
            name: "selected"
            when: checked
            ParentChange { target: breakdownPieChart; parent: selectedParent; }
        }
    ]

    transitions: Transition {
        ParentAnimation {
            id: parentAnimation

            ParallelAnimation {
                SequentialAnimation {
                    PropertyAction { target: chartView; property: "scale"; value: breakdownPieChart.checked ? 0.8 : 1 }
                    NumberAnimation {
                        target: chartView
                        property: "scale"
                        to: 1
                        easing: Suru.animations.EasingOut
                        duration: Suru.animations.BriskDuration
                    }
                }
                SequentialAnimation {
                    PropertyAction { target: breakdownPieChart; property: "opacity"; value: breakdownPieChart.checked ? 0 : 1 }
                    PropertyAction { target: breakdownPieChart.background; property: "visible"; value: false }
                    NumberAnimation {
                        target: breakdownPieChart
                        property: "opacity"
                        to: 1
                        duration: Suru.animations.BriskDuration
                    }
                    PropertyAction { target: breakdownPieChart.background; property: "visible"; value: true }
                }
            }
        }
    }

    Timer {
        id: delayPropertyChanges
        running: false
        interval: 1
        onTriggered: chartView.backgroundColor = "transparent"
    }

    background: Common.BaseBackgroundRectangle {
        control: abstractButton
        radius: Suru.units.gu(3)
    }

    contentItem: ChartView {
        id: chartView

        readonly property real chartPlotSize: height - margins.top - margins.bottom - margins.left - margins.right
        property bool highlightPrevious: false
        property bool currentHasLoaded: false
        property bool previousHasLoaded: false

        backgroundColor: "transparent"
        animationDuration: Suru.animations.BriskDuration
        legend.visible: false
        antialiasing: true
        theme: currentTheme
        margins {
            top: titleLabel.visible ? titleLabel.height + titleLabel.anchors.topMargin : breakdownPieChart.sideMargins
            bottom: breakdownPieChart.sideMargins
            left: breakdownPieChart.sideMargins
            right: breakdownPieChart.sideMargins
        }

        // Only enable animation when updating data
        Timer {
            id: disableAnimationDelay
            running: false
            interval: chartView.animationDuration
            onTriggered: chartView.animationOptions = ChartView.NoAnimation
        }

        Connections {
            target: mainView
            onSuruThemeChanged: {
                // Refresh the charts since colors are reassigned when them changes
                instantiator.model = null
                instantiator.model = breakdownPieChart.model
            }
        }

        Instantiator {
            id: instantiator

            asynchronous: true
            model: breakdownPieChart.model

            onObjectAdded: {
                if (index == 0) {
                    chartView.currentHasLoaded = false
                } else {
                    chartView.previousHasLoaded = false
                }
                // Disable animations for now
                // chartView.animationOptions = ChartView.AllAnimations
                let pieSeries = chartView.createSeries(ChartView.SeriesTypePie, index == 0 ? "current" : "previous", null, null)

                for (let i = 0; i < object.data.count; i++) {
                    let _currentObj = object.data.get(i)
                    let pieSlice = pieSeries.append(_currentObj.label, _currentObj.value)
                    pieSlice.color = _currentObj.color
                }

                if (pieSeries.name == "current") {
                    currentLabel.value = pieSeries.sum
                    chartView.currentHasLoaded = true
                }

                if (pieSeries.name == "previous") {
                    previousLabel.value = pieSeries.sum
                    disableAnimationDelay.restart()
                    chartView.previousHasLoaded = true
                }

                if (index == 0) {
                    pieSeries.size = 1
                    pieSeries.holeSize = 0.8
                    pieSeries.opacity = breakdownPieChart.highlightPrevious ? 0.5 : 1

                    if (breakdownPieChart.showDifference) {
                        let _previous = chartView.series(0)
                        let _previousSum = _previous.sum
                        if (_previousSum > pieSeries.sum) {
                            pieSeries.endAngle = (pieSeries.sum / _previousSum) * 360
                        } else {
                            _previous.endAngle = (_previousSum / pieSeries.sum) * 360
                        }
                    }
                } else {
                    pieSeries.size = 0.75
                    pieSeries.holeSize = 0.6
                    pieSeries.opacity = breakdownPieChart.highlightPrevious ? 1 : 0.5
                }
            }

            onObjectRemoved: chartView.removeAllSeries()

            delegate: QtObject {
                property var data: model.data
            }
        }

        ColumnLayout {
            id: centerLabel

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: (chartView.margins.top / 2) - (chartView.margins.bottom / 2)
            }

            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: chartView.chartPlotSize * 0.9

                text: i18n.tr("%1 & %2").arg(breakdownPieChart.currentTitle).arg(breakdownPieChart.previousTitle)
                visible: text.trim() !== "" && breakdownPieChart.isEmpty
                font.pixelSize: chartView.height * 0.08
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                Layout.maximumWidth: chartView.chartPlotSize * 0.9

                visible: text.trim() !== "" && breakdownPieChart.isEmpty
                font.pixelSize: chartView.height * 0.05
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                text: i18n.tr("No expense")
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignCenter
                Layout.fillWidth: false
                Layout.preferredWidth: chartView.chartPlotSize * 0.55

                visible: !breakdownPieChart.isEmpty

                ValueLabel {
                    id: currentLabel

                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true

                    enableAnimation: breakdownPieChart.checked
                    chartHeight: chartView.height
                    highlight: !breakdownPieChart.highlightPrevious
                    text: AppFunctions.formatMoney(value)
                }

                ValueLabel {
                    id: previousLabel

                    Layout.alignment: Qt.AlignCenter
                    Layout.fillWidth: true

                    enableAnimation: breakdownPieChart.checked
                    chartHeight: chartView.height
                    highlight: breakdownPieChart.highlightPrevious
                    text: AppFunctions.formatMoney(value)
                }
            }
        }

        Label {
            id: titleLabel

            visible: text.trim() !== "" && !breakdownPieChart.isEmpty

            anchors {
                top: parent.top
                topMargin: Suru.units.gu(1)
                left: parent.left
                right: parent.right
            }
            font.pixelSize: chartView.height * 0.08
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            wrapMode: Text.WordWrap
            text: breakdownPieChart.highlightPrevious ? breakdownPieChart.previousTitle : breakdownPieChart.currentTitle
        }

        Rectangle {
            visible: breakdownPieChart.currentIsEmpty
            radius: width / 2
            color: "transparent"
            opacity: 0.2
            border {
                width: breakdownPieChart.isEmpty ? Suru.units.dp(1) : chartView.chartPlotSize * 0.1
                color: Suru.tertiaryForegroundColor
            }
            anchors.centerIn: centerLabel
            height: chartView.chartPlotSize
            width: height
        }

        MouseArea {
            id: abstractButton

            property bool highlighted: false
            readonly property bool interactive: enabled
            readonly property bool down: pressed
            readonly property bool hovered: hoverEnabled && containsMouse

            anchors.fill: parent
            acceptedButtons: Qt.LeftButton | Qt.RightButton
            hoverEnabled: false

            onClicked: {
                if (mouse.button == Qt.RightButton) {
                    breakdownPieChart.rightClicked(mouse.x, mouse.y)
                } else {
                    breakdownPieChart.clicked()
                }
            }
            onPressAndHold: breakdownPieChart.pressAndHold()
        }
    }
}
