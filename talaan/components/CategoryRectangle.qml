import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../library/ApplicationFunctions.js" as AppFunctions

Rectangle {
    id: categoryRec

    property string categoryName

    Suru.textLevel: Suru.Small
    implicitWidth: categoryLayout.width
    implicitHeight: categoryLayout.height
    radius: height / 4
    color: categoryName ? AppFunctions.getCategoryColor(categoryName)
                    : "black"

    RowLayout {
        id: categoryLayout

        Label {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.bottomMargin: Suru.units.gu(0.2)
            Layout.topMargin: Suru.units.gu(0.2)
            Layout.leftMargin: Suru.units.gu(0.5)
            Layout.rightMargin: Suru.units.gu(0.5)
            Suru.textLevel: categoryRec.Suru.textLevel
            color: AppFunctions.getContrastYIQ(categoryRec.color) ? "#111111" : "#F7F7F7" // Black - White
            text: categoryRec.categoryName
        }
    }
}
