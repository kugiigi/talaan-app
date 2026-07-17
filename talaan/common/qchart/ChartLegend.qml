import QtQuick 2.9
import Lomiri.Components 1.3
import "../Common"

Flow {
    id: root

    property alias model: repeater.model
    property bool showValue: false

    spacing: units.gu(1)

    Repeater{
        id: repeater

        delegate: ChartLegendItem{
            legendColor: modelData.color
            title: if(showValue){
                       modelData.category + " (" + modelData.percentage + "%)"
                   }else{
                       modelData.category
                   }

        }

    }
}
