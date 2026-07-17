import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common" as Common
import "../.." as Components

RowLayout {
    id: navigationRow
    
    property alias itemTitle: itemLabel.text
    property alias dateTitle: dateLabel.text
    property alias scopeTItle: scopeLabel.text
    property bool biggerDateLabel: true
    property bool isExpanded: true

    signal criteria
    signal next
    signal previous
    signal nextData
    signal previousData

    onNext: Common.Haptics.playSubtle()
    onPrevious: Common.Haptics.playSubtle()
    onNextData: Common.Haptics.play()
    onPreviousData: Common.Haptics.play()

    spacing: 0

    Common.BaseButton {
        id: detailsButton

        Layout.fillWidth: true
        Layout.fillHeight: true

        onClicked: navigationRow.criteria()

        ColumnLayout {
            anchors {
                top: parent.top
                topMargin: Suru.units.gu(1)
                left: parent.left
                leftMargin: Suru.units.gu(2)
                right: parent.right
                rightMargin: anchors.leftMargin
            }

            spacing: Suru.units.gu(1)

            Components.ColoredLabel {
                id: itemLabel
    
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignBaseline
                Suru.textLevel: navigationRow.biggerDateLabel ? Suru.HeadingThree : Suru.HeadingOne
                visible: navigationRow.isExpanded
                role: "category"
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10
    
                Components.ColoredLabel {
                    id: dateLabel
      
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignBaseline

                    fontSizeMode: Text.HorizontalFit
                    font.pixelSize: navigationRow.isExpanded ? navigationRow.biggerDateLabel ? Suru.units.gu(3) : Suru.units.gu(2.5)
                                                    : Suru.units.gu(2)
                    minimumPixelSize: navigationRow.biggerDateLabel ? Suru.units.gu(2) : Suru.units.gu(1.5)
                    font.italic: true
                    role: "date"
                    Behavior on font.pixelSize {
                        NumberAnimation {
                            duration: Suru.animations.SnapDuration
                        }
                    }
                }
              
                Components.ColoredLabel {
                    id: scopeLabel

                    Layout.alignment: Qt.AlignBottom
                    Suru.textLevel: Suru.HeadingThree
                    text: detailedListPage.scope
                    visible: false
                }
            }
        }
    }

    Common.BaseButton {
        id: prevButton

        Layout.fillHeight: true
        display: AbstractButton.IconOnly
        icon {
            name: "previous"
            height: Suru.units.gu(3)
            width: Suru.units.gu(3)
        }
        onClicked: navigationRow.previous()
        onPressAndHold: navigationRow.previousData()
        onRightClicked: navigationRow.previousData()
    }

    Common.BaseButton {
        id: nextButton

        Layout.fillHeight: true
        display: AbstractButton.IconOnly
        icon {
            name: "next"
            height: Suru.units.gu(3)
            width: Suru.units.gu(3)
        }
        onClicked: navigationRow.next()
        onPressAndHold: navigationRow.nextData()
        onRightClicked: navigationRow.nextData()
    }
}
