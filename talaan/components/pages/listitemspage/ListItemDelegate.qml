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
    id: listItemDelegate

    readonly property bool isExpandable: ((commentsLabel.truncated || itemLabel.truncated) && !isExpanded)
                                            || isExpanded

    readonly property bool isSkipped: status == 2
    readonly property bool isCompleted: status == 1
    readonly property bool isDone: isSkipped || isCompleted
    readonly property bool isPriority: priority > 0

    property bool hasLargerFontSize: false
    property bool isCheckable: true
    property bool isReadOnly: false
    property bool isExpanded: false

    // To avoid default click behavior when using `checked`
    readonly property bool isChecked: status == 1 || status == 2

    property string itemName
    property string comments
    property int priority
    property int status

//~     property bool isTravelMode: false
//~     property string expenseID
//~     property string currentTravelCurrency
//~     property real homeValue
//~     property real travelValue
//~     property string homeCurrency
//~     property string travelCurrency
//~     property real exchangeRate
//~     property string entryDate
//~     property string entryDateRelative
    
//~     property string categoryName
//~     property bool showDate: false
//~     property bool showCategory: false
//~     property bool coloredCategory: false

    signal showContextMenu(real mouseX, real mouseY)
    signal interactivelyToggled

    checkable: false
    showDivider: false
    backgroundColor: isExpanded ? Suru.secondaryBackgroundColor : Suru.backgroundColor
//~     backgroundColor: isExpanded ? Suru.backgroundColor : Suru.secondaryBackgroundColor

    onPressAndHold: showContextMenu(listItemDelegate.pressX, listItemDelegate.pressY)
    onRightClicked: listItemDelegate.showContextMenu(mouseX, mouseY)

    Behavior on implicitHeight { UT.LomiriNumberAnimation { duration: UT.LomiriAnimation.SnapDuration } }

    contentItem: RowLayout {
        spacing: Suru.units.gu(2)

        CheckBox {
            id: checkBoxItem

            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

//~             enabled: !listItemDelegate.isReadOnly
            topPadding: 0
            bottomPadding: 0
            checked: listItemDelegate.isDone
//~             visible: listItemDelegate.isCheckable
            visible: listItemDelegate.isCheckable && !listItemDelegate.isReadOnly
//~             onCheckedChanged: listItemDelegate.isChecked = checked
            Binding {
                target: checkBoxItem
                property: "checked"
                value: listItemDelegate.isChecked
            }
            onToggled: listItemDelegate.interactivelyToggled()
        }

        UT.Icon {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            visible: listItemDelegate.isReadOnly
            name: listItemDelegate.isSkipped ? "edit-redo"
                                             : listItemDelegate.checked ? "tick" : ""
            implicitHeight: Suru.units.gu(2.5)
            implicitWidth: implicitHeight
            color: Suru.foregroundColor
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
//~             Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
//~             Layout.alignment: listItemDelegate.isExpanded ? Qt.AlignLeft | Qt.AlignTop : Qt.AlignLeft | Qt.AlignVCenter

//~             opacity: listItemDelegate.isDone ? 0.4 : 1
            opacity: listItemDelegate.isDone && !listItemDelegate.isReadOnly ? 0.4 : 1

            Components.ColoredLabel {
                id: itemLabel

                Layout.fillWidth: true
//~                 Layout.alignment: Qt.AlignTop

                visible: listItemDelegate.itemName
//~                 Suru.textLevel: listItemDelegate.hasLargerFontSize ? Suru.HeadingTwo : Suru.HeadingThree
//~                 Suru.textLevel: listItemDelegate.hasLargerFontSize ? Suru.HeadingThree : Suru.Paragraph
//~                 Suru.textStyle: listItemDelegate.isPriority ? Suru.PrimaryText : Suru.SecondaryText
//~                 font.pixelSize: listItemDelegate.hasLargerFontSize ? Suru.units.gu(3) : Suru.units.gu(2)
                font.pixelSize: listItemDelegate.hasLargerFontSize ? Suru.units.gu(2.5) : Suru.units.gu(2)
//~                 font.strikeout: listItemDelegate.isDone
                font.weight: listItemDelegate.isPriority && !listItemDelegate.isDone ? Font.Bold : Font.Normal
                text: listItemDelegate.itemName
                wrapMode: Text.WordWrap
                maximumLineCount: listItemDelegate.isExpanded ? 99 : 5
                elide: Text.ElideRight
                horizontalAlignment: Text.AlignVCenter
            }

            Label {
                id: commentsLabel
      
                Layout.fillWidth: true

                text: listItemDelegate.comments
                visible: text.trim() !== "" ? true : false
//~                 Suru.textLevel: Suru.Caption
                font.pixelSize: listItemDelegate.hasLargerFontSize ? Suru.units.gu(2) : Suru.units.gu(1.5)
//~                 font.italic: true
                wrapMode: Text.WordWrap
                maximumLineCount: listItemDelegate.isExpanded ? 999 : 1
                elide: Text.ElideRight
            }
        }

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignRight | Qt.AlignTop

            UT.Icon {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                visible: listItemDelegate.isExpandable
                name: "go-down"
                implicitHeight: Suru.units.gu(1.5)
                implicitWidth: implicitHeight
                color: Suru.foregroundColor
                rotation: listItemDelegate.isExpanded ? 180 : 0

                Behavior on rotation {
                    RotationAnimation {
                        direction: RotationAnimation.Shortest
                        duration: UT.LomiriAnimation.SnapDuration
                    }
                }
            }

            UT.Icon {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                visible: listItemDelegate.isSkipped && !listItemDelegate.isReadOnly
                name: "edit-redo"
                implicitHeight: Suru.units.gu(2)
                implicitWidth: implicitHeight
                color: Suru.foregroundColor
            }

            UT.Icon {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                visible: listItemDelegate.isPriority && !listItemDelegate.isDone
                name: "mail-mark-important"
                implicitHeight: Suru.units.gu(2)
                implicitWidth: implicitHeight
                color: Suru.highlightColor
                Suru.highlightType: Suru.WarningHighlight
            }
        }
    }
}
