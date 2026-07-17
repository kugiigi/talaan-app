import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3 as UT
import QtQuick.Layouts 1.12
import "../../../common" as Common
import "../../../common/listitems" as ListItems
import "../.." as Components
import "../../../library/functions.js" as Functions
import "../../../library/ApplicationFunctions.js" as AppFunctions

ListItems.BaseItemDelegate {
    id: valueListDelegate

    readonly property bool isExpandable: ((commentsLabel.truncated || itemLabel.truncated || hasTravelValue) && !isExpanded)
                                            || isExpanded
    readonly property bool displayTravelValueAsMain: isTravelMode && currentTravelCurrency == travelCurrency
                                                            && hasTravelValue
    readonly property bool hasTravelValue: travelValue > 0
    readonly property alias formattedValue: mainValueLabel.text

    property bool isTravelMode: false
    property string expenseID
    property string currentTravelCurrency
    property real homeValue
    property real travelValue
    property string homeCurrency
    property string travelCurrency
    property real exchangeRate
    property string entryDate
    property string entryDateRelative
    property string comments
    property string itemName
    property string categoryName
    property bool isExpanded: false
    property bool showDate: false
    property bool showCategory: false
    property bool coloredCategory: false

    signal showContextMenu(real mouseX, real mouseY)

    showDivider: false
    backgroundColor: isExpanded ? Suru.secondaryBackgroundColor : Suru.backgroundColor

    Behavior on implicitHeight { UT.LomiriNumberAnimation { duration: UT.LomiriAnimation.SnapDuration } }

    onPressAndHold: showContextMenu(valueListDelegate.pressX, valueListDelegate.pressY)

    onRightClicked: valueListDelegate.showContextMenu(mouseX, mouseY)

    contentItem: RowLayout {
        spacing: Suru.units.gu(2)

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            Components.ColoredLabel {
                Layout.fillWidth: true
                visible: valueListDelegate.entryDateRelative && valueListDelegate.showDate
                Suru.textLevel: Suru.Caption
                text: valueListDelegate.entryDateRelative
                elide: Text.ElideRight
                role: "date"
            }

            Components.ColoredLabel {
                id: itemLabel

                Layout.fillWidth: true
                visible: valueListDelegate.itemName
                Suru.textLevel: Suru.HeadingTwo
                text: valueListDelegate.itemName
                wrapMode: Text.WordWrap
                maximumLineCount: valueListDelegate.isExpanded ? 99 : 2
                elide: Text.ElideRight
            }

            Label {
                id: commentsLabel
      
                Layout.fillWidth: true

                text: valueListDelegate.comments
                visible: valueListDelegate.comments ? true: false
                Suru.textLevel: Suru.Caption
                wrapMode: Text.WordWrap
                maximumLineCount: valueListDelegate.isExpanded ? 999 : 1
                elide: Text.ElideRight
            }
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignRight | Qt.AlignTop
            
            Components.CategoryRectangle {
                id: categoryRec

                Layout.alignment: Qt.AlignRight

                categoryName: valueListDelegate.categoryName
                visible: valueListDelegate.showCategory && valueListDelegate.coloredCategory && categoryName
            }

            Components.ColoredLabel {
                Layout.alignment: Qt.AlignRight

                text: valueListDelegate.categoryName
                role: "category"
                visible: valueListDelegate.showCategory && !categoryRec.visible && text !== ""
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight

                spacing: Suru.units.gu(1)

                UT.Icon {
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                    visible: valueListDelegate.isExpandable
                    name: "go-down"
                    implicitHeight: Suru.units.gu(1.5)
                    implicitWidth: implicitHeight
                    color: Suru.foregroundColor
                    rotation: valueListDelegate.isExpanded ? 180 : 0

                    Behavior on rotation {
                        RotationAnimation {
                            direction: RotationAnimation.Shortest
                            duration: UT.LomiriAnimation.SnapDuration
                        }
                    }
                }

                Components.ColoredLabel {
                    id: mainValueLabel

                    Suru.textLevel: Suru.HeadingTwo
                    text: valueListDelegate.displayTravelValueAsMain ? Functions.formatMoney(valueListDelegate.travelValue, valueListDelegate.travelCurrency, null)
                                    : AppFunctions.formatMoney(valueListDelegate.homeValue, false)
                    role: "value"
                }
            }

            ColumnLayout {
                Layout.alignment: Qt.AlignRight

                visible: (valueListDelegate.displayTravelValueAsMain || valueListDelegate.hasTravelValue)

                Components.ColoredLabel {
                    id: secondaryValueLabel

                    Layout.alignment: Qt.AlignRight
                    Suru.textLevel: Suru.Paragraph
                    text: valueListDelegate.displayTravelValueAsMain ? AppFunctions.formatMoney(valueListDelegate.homeValue, false)
                                : valueListDelegate.hasTravelValue ? 
                                        Functions.formatMoney(valueListDelegate.travelValue, valueListDelegate.travelCurrency, null)
                                        : ""
                    role: "value"
                }

                Components.ColoredLabel {
                    id: rateLabel

                    visible: valueListDelegate.isExpanded
                    Layout.alignment: Qt.AlignRight
                    Suru.textLevel: Suru.Caption
                    text: valueListDelegate.exchangeRate ? i18n.tr("@ %1").arg(AppFunctions.formatMoney(valueListDelegate.exchangeRate, false)) : ""
                }
            }
        }
    }
}
