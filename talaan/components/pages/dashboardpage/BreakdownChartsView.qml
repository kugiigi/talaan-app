import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common" as Common

ColumnLayout {
    id: breakdownLayout

    property alias pageHeader: mainFlickable.pageHeader

    spacing: 0

    Item {
        Layout.leftMargin: Suru.units.gu(1)
        Layout.rightMargin: Suru.units.gu(1)
        Layout.fillHeight: true
        Layout.fillWidth: true

        ButtonGroup { id: breakdownChartButtonGrp }

        Common.BaseFlickable {
            id: mainFlickable

            anchors.fill: parent
            bottomMargin: Suru.units.gu(2)
            contentHeight: contentsLayout.height

            // TODO: Disable for now because clicking it hangs the app when swiping to the last item in the SwipeView
            // Replacing the ScrollPositioner with a custom item with MouseArea doesn't have the issue
            enableScrollPositioner: false

            ColumnLayout {
                id: contentsLayout

                property bool showLegend: false

                anchors {
                    left: parent.left
                    right: parent.right
                }

                function toggleLegend() {
                    showLegend = !showLegend
                }
                
                Item {
                    Layout.margins: Suru.units.gu(1)
                    Layout.topMargin: 0
                    Layout.preferredHeight: chartLegend.visible ? chartLegend.implicitHeight : 0
                    Layout.maximumWidth: Suru.units.gu(80)
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true

                    z: 1

                    Behavior on Layout.preferredHeight {
                        NumberAnimation {
                            easing: Suru.animations.EasingOut
                            duration: Suru.animations.FastDuration
                        }
                    }

                    BreakdownPieChartLegend {
                        id: chartLegend

                        anchors.fill: parent
                        visible: contentsLayout.showLegend && !chartLegend.isEmpty
                    }
                }

                GridLayout  {
                    id: gridLayout

                    readonly property real itemPreferredWidth: Suru.units.gu(20)
                    readonly property real itemMaximumWidth: Suru.units.gu(30)

                    Layout.fillWidth: true
                    columns: Math.floor(width / (itemPreferredWidth + Suru.units.gu(2)))
                    columnSpacing: 0
                    rowSpacing: 0

                    Item {
                        id: selectedItem

                        property real chartPreferredWidth: Suru.units.gu(30)
                        property real chartMaxWidth: Suru.units.gu(40)

                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredWidth: Suru.units.gu(30)
                        Layout.maximumWidth: Suru.units.gu(40)
                        Layout.fillWidth: true
                        Layout.columnSpan: gridLayout.columns > 0 ? gridLayout.columns : 1
                        implicitHeight: width

                        onChildrenChanged: {
                            if (children.length > 0) {
                                let _legendModel = []
                                let _chart = children[0].chart
                                chartLegend.updateData(_chart)
                            }
                        }
                    }

                    BreakdownPieChartContainer {
                        id: dayContainer

                        currentTitle: i18n.tr("Today")
                        previousTitle: i18n.tr("Yesterday")
                        chartPreferredWidth: gridLayout.itemPreferredWidth
                        chartMaxWidth: gridLayout.itemMaximumWidth
                        checked: true
                        model: mainView.mainModels.todayBreakdownChartModel
                        selectedParent: selectedItem
                        buttonGroup: breakdownChartButtonGrp

                        onShowLegend: contentsLayout.toggleLegend()
                    }

                    BreakdownPieChartContainer {
                        id: weekContainer

                        currentTitle: i18n.tr("This Week")
                        previousTitle: i18n.tr("Last Week")
                        chartPreferredWidth: gridLayout.itemPreferredWidth
                        chartMaxWidth: gridLayout.itemMaximumWidth
                        model: mainView.mainModels.thisWeekBreakdownChartModel
                        selectedParent: selectedItem
                        buttonGroup: breakdownChartButtonGrp

                        onShowLegend: contentsLayout.toggleLegend()
                    }

                    BreakdownPieChartContainer {
                        id: recentContainer

                        currentTitle: i18n.tr("Last 7 days")
                        previousTitle: i18n.tr("Previous 7 days")
                        chartPreferredWidth: gridLayout.itemPreferredWidth
                        chartMaxWidth: gridLayout.itemMaximumWidth
                        model: mainView.mainModels.recentBreakdownChartModel
                        selectedParent: selectedItem
                        buttonGroup: breakdownChartButtonGrp

                        onShowLegend: contentsLayout.toggleLegend()
                    }

                    BreakdownPieChartContainer {
                        id: monthContainer

                        currentTitle: i18n.tr("This Month")
                        previousTitle: i18n.tr("Last Month")
                        chartPreferredWidth: gridLayout.itemPreferredWidth
                        chartMaxWidth: gridLayout.itemMaximumWidth
                        model: mainView.mainModels.thisMonthBreakdownChartModel
                        selectedParent: selectedItem
                        buttonGroup: breakdownChartButtonGrp

                        onShowLegend: contentsLayout.toggleLegend()
                    }

                    BreakdownPieChartContainer {
                        id: yearContainer

                        currentTitle: i18n.tr("This Year")
                        previousTitle: i18n.tr("Last Year")
                        chartPreferredWidth: gridLayout.itemPreferredWidth
                        chartMaxWidth: gridLayout.itemMaximumWidth
                        model: mainView.mainModels.thisYearBreakdownChartModel
                        selectedParent: selectedItem
                        buttonGroup: breakdownChartButtonGrp

                        onShowLegend: contentsLayout.toggleLegend()
                    }
                }
            }
        }
    }
}
