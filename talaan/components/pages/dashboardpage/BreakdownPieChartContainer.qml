import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

Item {
    id: container

    property real chartPreferredWidth
    property real chartMaxWidth
    property alias checked: breakdownPieChart.checked
    property alias model: breakdownPieChart.model
    property alias currentTitle: breakdownPieChart.currentTitle
    property alias previousTitle: breakdownPieChart.previousTitle
    property alias selectedParent: breakdownPieChart.selectedParent
    property ButtonGroup buttonGroup

    signal showLegend

    Layout.fillWidth: true
    implicitHeight: width

    visible: !breakdownPieChart.checked

    BreakdownPieChart {
        id: breakdownPieChart

        width: Math.min(Math.max(parent.width, parent.chartPreferredWidth), parent.chartMaxWidth)
        height: width
        anchors.centerIn: parent
        selectedParent: selectedItem
        originalParent: container
        ButtonGroup.group: container.buttonGroup

        onShowLegend: container.showLegend()
    }
}
