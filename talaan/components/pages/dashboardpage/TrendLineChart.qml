import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../library/external/qchart/QChart.js" as Charts
import "../../../library/external/qchart" as QCharts
import "../.." as Components
import "../../../common" as Common
import "../../../common/listitems" as ListItems
import "../../../library/functions.js" as Functions
import "../../../library/ApplicationFunctions.js" as AppFunctions

ListItems.BaseItemDelegate {
    id: trendLineChart

    readonly property bool isEmpty: currentIsEmpty && previousIsEmpty
    readonly property bool currentIsEmpty: currentTotal == 0
    readonly property bool previousIsEmpty: previousTotal == 0
    readonly property color gridColor: Suru.neutralColor
    readonly property alias currentTotal: internal.currentTotal
    readonly property alias previousTotal: internal.previousTotal
    readonly property alias currentAverage: internal.currentAverage
    readonly property alias previousAverage: internal.previousAverage

    property string currentTitle
    property string previousTitle
    property alias highlightPrevious: chartView.highlightPrevious
    property var model
    property alias chart: chartView

    QtObject {
        id: internal

        property color baseColor: Suru.secondaryForegroundColor
        property color activeColor: Qt.hsla(baseColor.hslHue, baseColor.hslSaturation, baseColor.hslLightness, 0.6)
        property color inactiveColor: Qt.hsla(activeColor.hslHue, activeColor.hslSaturation, activeColor.hslLightness, 0.2)
        property color activeAverageColor: Suru.highlightColor
        property color inactiveAverageColor: Qt.hsla(activeAverageColor.hslHue, activeAverageColor.hslSaturation, activeAverageColor.hslLightness, 0.4)

        property real currentTotal
        property real previousTotal
        property real currentAverage
        property real previousAverage
    }

    onClicked: {
        if (!isEmpty) {
            highlightPrevious = !highlightPrevious
        }
    }

    contentItem: Item {
        anchors.fill: parent

        ColumnLayout {
            id: titleLayout

            visible: !trendLineChart.isEmpty
            anchors {
                top: parent.top
                topMargin: Suru.units.gu(1)
                left: parent.left
                right: parent.right
            }

            Label {
                id: titleLabel

                Layout.fillWidth: true
                font.pixelSize: contentItem.height * 0.07
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                text: chartView.highlightPrevious ? trendLineChart.previousTitle : trendLineChart.currentTitle
            }
            
            RowLayout {
                Layout.fillWidth: false
                Layout.alignment: Qt.AlignHCenter

                RowLayout {
                    Layout.preferredHeight: contentItem.height * 0.06
                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillHeight: true
                        font.pixelSize: contentItem.height * 0.04
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        text: i18n.tr("Total:")
                    }

                    Components.ColoredLabel {
                        readonly property real value: chartView.highlightPrevious ? trendLineChart.previousTotal : trendLineChart.currentTotal

                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillHeight: true
                        role: "value"
                        font.pixelSize: contentItem.height * 0.04
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        text: AppFunctions.formatMoney(value)
                    }
                }

                RowLayout {
                    Layout.preferredHeight: contentItem.height * 0.06
                    Label {
                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillHeight: true
                        font.pixelSize: contentItem.height * 0.04
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        text: i18n.tr("Average:")
                    }

                    Components.ColoredLabel {
                        readonly property real value: chartView.highlightPrevious ? trendLineChart.previousAverage : trendLineChart.currentAverage

                        Layout.alignment: Qt.AlignVCenter
                        Layout.fillHeight: true
                        role: "value"
                        font.pixelSize: contentItem.height * 0.04
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.WordWrap
                        text: AppFunctions.formatMoney(value)
                    }
                }
            }
        }

        ColumnLayout {
            id: centerLabel

            anchors {
                left: parent.left
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter

                text: i18n.tr("%1 & %2").arg(trendLineChart.currentTitle).arg(trendLineChart.previousTitle)
                visible: text.trim() !== "" && trendLineChart.isEmpty
                font.pixelSize: chartView.height * 0.08
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter

                visible: text.trim() !== "" && trendLineChart.isEmpty
                font.pixelSize: chartView.height * 0.05
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
                text: i18n.tr("No expense")
            }
        }

        QCharts.QChart {
            id: chartView

            readonly property color gridColor: Suru.neutralColor
            readonly property var modelData: model.modelData
            property bool highlightPrevious: false

            anchors {
                top: titleLayout.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
                margins: Suru.units.gu(1)
            }

            chartType: Charts.ChartType.LINE
            chartAnimated: true
            chartAnimationEasing: Easing.InBounce
            chartAnimationDuration: Suru.animations.BriskDuration
            chartOptions: {
                "scaleFontColor": Suru.foregroundColor
                , "scaleGridLineColor": Qt.hsla(gridColor.hslHue, gridColor.hslSaturation, gridColor.hslLightness, 0.2)
                , "scaleFontSize": Suru.units.gu(1.5)
                , "pointDotRadius": Suru.units.dp(1)
                , "pointDotStrokeWidth": Suru.units.dp(1)
            }

            function processData() {
                let _datasets = modelData.datasets
                let _currentData = _datasets[0]
                let _currentAverage = _datasets[1]
                let _previousData = _datasets[2]
                let _previousAverage = _datasets[3]

                // Reassign colors since apparently colors doesn't bind when changing theme
                internal.baseColor = Suru.secondaryForegroundColor
                internal.activeColor = Qt.hsla(internal.baseColor.hslHue, internal.baseColor.hslSaturation, internal.baseColor.hslLightness, 0.6)
                internal.inactiveColor = Qt.hsla(internal.activeColor.hslHue, internal.activeColor.hslSaturation, internal.activeColor.hslLightness, 0.2)
                internal.activeAverageColor = Suru.highlightColor
                internal.inactiveAverageColor = Qt.hsla(internal.activeAverageColor.hslHue, internal.activeAverageColor.hslSaturation, internal.activeAverageColor.hslLightness, 0.4)

                if (chartView.highlightPrevious) {
                    modelData.labels = modelData.previousLabels
                    _currentData.fillColor = internal.inactiveColor
                    _currentData.strokeColor = _currentData.hasData ? internal.inactiveColor : "transparent"
                    _previousData.fillColor = internal.activeColor
                    _previousData.strokeColor = _previousData.hasData ? internal.activeColor : "transparent"
                    _currentAverage.strokeColor = _currentAverage.hasData ? internal.inactiveAverageColor : "transparent"
                    _previousAverage.strokeColor = _previousAverage.hasData ? internal.activeAverageColor : "transparent"
                } else {
                    modelData.labels = modelData.currentLabels
                    _previousData.fillColor = internal.inactiveColor
                    _previousData.strokeColor = _previousData.hasData ? internal.inactiveColor : "transparent"
                    _currentData.fillColor = internal.activeColor
                    _currentData.strokeColor = _currentData.hasData ? internal.activeColor : "transparent"
                    _previousAverage.strokeColor = _previousAverage.hasData ? internal.inactiveAverageColor : "transparent"
                    _currentAverage.strokeColor = _currentAverage.hasData ? internal.activeAverageColor : "transparent"
                }

                internal.currentTotal = modelData.currentTotal
                internal.previousTotal = modelData.previousTotal
                internal.currentAverage = modelData.currentAverage
                internal.previousAverage = modelData.previousAverage

                chartData = modelData
            }

            onModelDataChanged: processData()
            onHighlightPreviousChanged: processData()

            Connections {
                target: mainView
                onSuruThemeChanged: chartView.processData()
            }
        }
    }
}
