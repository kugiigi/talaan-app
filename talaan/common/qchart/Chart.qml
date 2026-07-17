import QtQuick 2.9
import Lomiri.Components 1.3
import "../Common"
import "../ListModels"
import "../QChart/QChart.js" as Charts

Item {
    id: root

    property string type: "LINE"
    property string range: "This Year"
    property string mode: "Month"
    property variant filter: ""
    property variant exception: ""
    property string dateFilter1: ""
    property string dateFilter2: ""

    property alias animated: chart.chartAnimated

    signal doubleClicked
    signal clicked

    state: if (chartLegend.visible === true) {
               if (root.width > units.gu(50)) {
                   "LeftLegend"
               } else {
                   "BottomLegend"
               }
           } else {
               "NoLegend"
           }

    function reload() {
        hide.restart()
    }

    states: [
        State {
            name: "NoLegend"

            AnchorChanges {
                target: chartLegend
                anchors {
                    top: undefined
                    bottom: undefined
                    left: undefined
                    right: undefined
                }
            }

            AnchorChanges {
                target: chart
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
            }

            PropertyChanges {
                target: chart
                anchors.margins: units.gu(1)
            }
        },
        State {
            name: "BottomLegend"

            AnchorChanges {
                target: chartLegend
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                    top: undefined
                }
            }

            PropertyChanges {
                target: chartLegend
                flow: Flow.LeftToRight
                anchors {
                    leftMargin: units.gu(1)
                    rightMargin: units.gu(1)
                    topMargin: 0
                    bottomMargin: units.gu(1)
                }
            }

            AnchorChanges {
                target: chart
                anchors {
                    top: parent.top
                    bottom: chartLegend.top
                    left: parent.left
                    right: parent.right
                }
            }

            PropertyChanges {
                target: chart
                anchors {
                    leftMargin: units.gu(1)
                    rightMargin: units.gu(1)
                    topMargin: units.gu(1)
                    bottomMargin: units.gu(1)
                }
            }
        },
        State {
            name: "LeftLegend"
            AnchorChanges {
                target: chartLegend

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: undefined
                    left: parent.left
                }
            }

            PropertyChanges {
                target: chartLegend

                flow: Flow.TopToBottom
                anchors {
                    leftMargin: units.gu(1)
                    rightMargin: 0
                    topMargin: units.gu(1)
                    bottomMargin: units.gu(1)
                }
            }

            AnchorChanges {
                target: chart
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: chartLegend.right
                    right: parent.right
                }
            }

            PropertyChanges {
                target: chart
                anchors {
                    leftMargin: units.gu(1)
                    rightMargin: units.gu(1)
                    topMargin: units.gu(1)
                    bottomMargin: units.gu(1)
                }
            }
        }
    ]


    OpacityAnimator {
        id: show

        target: root
        from: 0
        to: 1
        easing: LomiriAnimation.StandardEasing
        duration: LomiriAnimation.SlowDuration
        alwaysRunToEnd: true
//        onStopped: console.log("show")
    }
    OpacityAnimator {
        id: hide

        target: root
        from: 1
        to: 0
        easing: LomiriAnimation.StandardEasing
        duration: LomiriAnimation.SlowDuration
        alwaysRunToEnd: true
        onStopped: {
            emptyStateLoader.active = false
            chart.visible = false
            chartModel.load(type, range, mode, filter, exception, dateFilter1,
                            dateFilter2)
        }
    }

    ChartModel {
        id: chartModel

        onLoadingStatusChanged: {
            if (loadingStatus === "Ready") {
//                root.opacity = 1
                if (modelData !== null) {
                    chart.paintData()
                } else {
                    emptyStateLoader.active = true
                }
            }
        }
    }

    QChart {
        id: chart

        chartData: ""
        chartType: switch (root.type) {
                   case "LINE":
                       Charts.ChartType.LINE
                       break
                   case "POLAR":
                       Charts.ChartType.POLAR
                       break
                   case "RADAR":
                       Charts.ChartType.RADAR
                       break
                   case "PIE":
                       Charts.ChartType.PIE
                       break
                   case "BAR":
                       Charts.ChartType.BAR
                       break
                   case "DOUGHNUT":
                       Charts.ChartType.DOUGHNUT
                       break
                   default:
                       Charts.ChartType.LINE
                       break
                   }

        chartAnimated: false
        chartAnimationEasing: Easing.InBounce
        chartAnimationDuration: LomiriAnimation.BriskDuration
        chartOptions: {
            "scaleFontColor": theme.palette.normal.backgroundText,
                            "scaleGridLineColor": theme.palette.normal.base
        }

        onPainted: {
            if(chartModel.modelData !== null && chartModel.loadingStatus === "Ready"){
               visible = true
                show.restart()
            }

        }

        function paintData() {
            if(chartModel.modelData !== null && chartModel.loadingStatus === "Ready"){
                chartData = chartModel.modelData
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        z: 1

        function singleClick(){
            if(chartLegend.visible){
                if(chartLegend.showValue){
                    chartLegend.showValue = false
                }else{
                    chartLegend.showValue = true
                }
            }

            root.clicked()
        }

        function doubleClick(){
            root.doubleClicked()
        }

        Timer{
           id: clickTimer
           interval: 200
           onTriggered: mouseArea.singleClick()
        }

        onClicked: {
            if(clickTimer.running){
                clickTimer.stop()
                doubleClick()
            }else{
                clickTimer.restart()
            }
        }
    }

    ChartLegend {
        id: chartLegend

        visible: root.type === "PIE"
        model: chartModel.modelData
    }

    Loader {
        id: emptyStateLoader

        active: false
        asynchronous: true
        visible: status == Loader.Ready
        anchors.fill: parent
        sourceComponent: emptyStateComponent

        onLoaded: show.restart()
    }

    Component {
        id: emptyStateComponent
        EmptyState {
            id: emptySate
            z: -1

            title: i18n.tr("Not enough data to display the report")

            subTitle: i18n.tr("Select different report criteria")
            anchors {
                right: parent.right
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
            shown: true
        }
    }
}
