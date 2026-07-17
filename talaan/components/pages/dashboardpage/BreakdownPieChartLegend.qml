import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../.." as Components
import "../../../common/listitems" as ListItems
import "../../../library/ApplicationFunctions.js" as AppFunctions
import "../../../library/functions.js" as Functions

ListItems.BaseItemDelegate {
    id: breakdownLegend

    readonly property bool isEmpty: model.length == 0
    property alias model: repeater.model
    property bool showValues: false

    function updateData(chart) {
        let _legendModel = []
        let _seriesName = chart.highlightPrevious ? "previous" : "current"
        let _pieSeries = chart.series(_seriesName)

        if (_pieSeries) {
            for (let i = 0; i < _pieSeries.count; i++) {
                let _slice = _pieSeries.at(i)
                _legendModel.push( { label: _slice.label, color: _slice.color, value: _slice.value, percentage: _slice.percentage } )
            }
        }

        currenChartConnections.target = chart
        model = _legendModel
    }

    onClicked: showValues = !showValues

    Connections {
        id: currenChartConnections

        ignoreUnknownSignals: true

        onCurrentHasLoadedChanged: {
            if (target.currentHasLoaded) {
                updateData(target)
            }
        }

        onHighlightPreviousChanged: updateData(target)
    }

    contentItem: Item {
        implicitHeight: gridLayout.height
        implicitWidth: gridLayout.width

        GridLayout {
            id: gridLayout

            readonly property real itemPreferredWidth: Suru.units.gu(10)

            columns: Math.floor(width / itemPreferredWidth)
            columnSpacing: Suru.units.gu(1)
            rowSpacing: Suru.units.gu(1)

            anchors {
                left: parent.left
                right: parent.right
            }

            Repeater {
                id: repeater

                delegate: ColumnLayout {
                    id: content

                    Layout.fillWidth: false
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: gridLayout.itemPreferredWidth

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        color: modelData.color
                        width: Suru.units.gu(2)
                        height: width
                        radius: width / 2
                        border {
                            width: Suru.units.dp(1)
                            color: Suru.foregroundColor
                        }
                    }

                    Components.ColoredLabel {
                        Layout.fillWidth: true
                        role: "category"
                        text: modelData.label
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                    }

                    ColumnLayout {
                        visible: breakdownLegend.showValues

                        Components.ColoredLabel {
                            Layout.fillWidth: true
                            role: "value"
                            text: AppFunctions.formatMoney(modelData.value)
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }

                        Label {
                            Layout.fillWidth: true
                            text: Functions.formatToPercentage(modelData.percentage)
                            wrapMode: Text.WordWrap
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }
    }
}
