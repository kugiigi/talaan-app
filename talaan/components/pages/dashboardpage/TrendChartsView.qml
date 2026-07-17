import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../library/external/qchart/QChart.js" as Charts
import "../../../library/external/qchart" as QCharts
import "../../../common" as Common

ColumnLayout {
    id: trendsLayout

    property alias pageHeader: mainFlickable.pageHeader

    spacing: 0

    Item {
        Layout.leftMargin: Suru.units.gu(1)
        Layout.rightMargin: Suru.units.gu(1)
        Layout.fillHeight: true
        Layout.fillWidth: true

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

                anchors {
                    left: parent.left
                    right: parent.right
                }

                GridLayout  {
                    id: gridLayout

                    readonly property real itemPreferredWidth: Suru.units.gu(60)
                    readonly property real itemPreferredHeight: Suru.units.gu(40)
                    readonly property real itemMaximumWidth: Suru.units.gu(100)

                    Layout.fillWidth: true
                    columns: itemPreferredWidth >= width ? 1 : Math.floor(width / (itemPreferredWidth + Suru.units.gu(2)))
                    columnSpacing: Suru.units.gu(1)
                    rowSpacing: Suru.units.gu(1)
                    
                    TrendLineChart {
                        id: thisWeekTrendChart

                        Layout.fillWidth: true
                        Layout.preferredWidth: gridLayout.itemPreferredWidth
                        Layout.preferredHeight: gridLayout.itemPreferredHeight

                        currentTitle: i18n.tr("This Week")
                        previousTitle: i18n.tr("Last Week")
                        model: mainView.mainModels.thisWeekTrendChartModel
                    }

                    TrendLineChart {
                        id: recentTrendChart

                        Layout.fillWidth: true
                        Layout.preferredWidth: gridLayout.itemPreferredWidth
                        Layout.preferredHeight: gridLayout.itemPreferredHeight

                        currentTitle: i18n.tr("Last 7 Days")
                        previousTitle: i18n.tr("Previous 7 Days")
                        model: mainView.mainModels.recentTrendChartModel
                    }

                    TrendLineChart {
                        id: thisMonthTrendChart

                        Layout.fillWidth: true
                        Layout.preferredWidth: gridLayout.itemPreferredWidth
                        Layout.preferredHeight: gridLayout.itemPreferredHeight

                        currentTitle: i18n.tr("This Month")
                        previousTitle: i18n.tr("Last Month")
                        model: mainView.mainModels.thisMonthTrendChartModel
                    }

                    TrendLineChart {
                        id: thisYearTrendChart

                        Layout.fillWidth: true
                        Layout.preferredWidth: gridLayout.itemPreferredWidth
                        Layout.preferredHeight: gridLayout.itemPreferredHeight

                        currentTitle: i18n.tr("This Year")
                        previousTitle: i18n.tr("Last Year")
                        model: mainView.mainModels.thisYearTrendChartModel
                    }
                }
            }
        }
    }
}
