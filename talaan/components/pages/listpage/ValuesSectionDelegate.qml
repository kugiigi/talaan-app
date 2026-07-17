import QtQuick 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../.." as Components
import "../../../library/functions.js" as Functions
import "../../../library/ApplicationFunctions.js" as AppFunctions

Rectangle {
    id: sectionItem

    property string sectionObj
    property var view
    property real topMargin
    property bool displayTravelTotal: false
    property string travelCurrency
    property string type: "category"
    property bool coloredCategory: false
    readonly property var splitValues: sectionObj.split("|")
    readonly property string groupName: splitValues[0] ? splitValues[0] : ""
    readonly property real groupTotal: splitValues[1] ? splitValues[1] : 0
    readonly property real groupTravelTotal: splitValues[2] ? splitValues[2] : 0

    color: Suru.backgroundColor
    height: Suru.units.gu(4)

    RowLayout {
        spacing: Suru.units.gu(2)
        anchors {
            fill: parent
            topMargin: sectionItem.topMargin
            leftMargin: Suru.units.gu(2)
            rightMargin: anchors.leftMargin
        }

        Components.ColoredLabel {
            font.pixelSize: Suru.units.gu(2)
            font.weight: Font.Medium
            text: sectionItem.groupName
            role: sectionItem.type == "category" ? "category" : "date"
            visible: !categoryRec.visible
        }

        Components.CategoryRectangle {
            id: categoryRec

            Suru.textLevel: Suru.HeadingThree
            categoryName: sectionItem.groupName
            visible: sectionItem.type == "category" && sectionItem.coloredCategory
        }

        Components.ColoredLabel {
            Layout.alignment: Qt.AlignRight
            Suru.textLevel: Suru.Caption

            text: {
                if (sectionItem.view.currentIndex > -1 && sectionItem.groupName) {
                    if (sectionItem.displayTravelTotal) {
                        return Functions.formatMoney(sectionItem.groupTravelTotal, sectionItem.travelCurrency, null)
                    }

                    return AppFunctions.formatMoney(sectionItem.groupTotal, false)
                }

                return ""
            }
            role: "value"
        }
    }
}
