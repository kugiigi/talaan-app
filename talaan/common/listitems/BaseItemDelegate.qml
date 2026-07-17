import QtQuick 2.12
import Lomiri.Components 1.3
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Controls.Suru 2.2
import ".." as Common

QQC2.ItemDelegate {
    id: baseItemDelegate

    property string rightSideText
    property alias showDivider: backgroundRectangle.showDivider
    property alias radius: backgroundRectangle.radius
    property alias transparentBackground: backgroundRectangle.transparentBackground
    property alias backgroundColor: backgroundRectangle.backgroundColor
    property alias borderColor: backgroundRectangle.borderColor
    property alias highlightedBorderColor: backgroundRectangle.highlightedBorderColor
    property string tooltipText
    property bool interactive: true
    property bool enableDropShadow: false
    property bool enableChealDropShadow: false

    signal rightClicked(real mouseX, real mouseY)

    // TODO: Enable once UT's issue with hover is fixed
    hoverEnabled: false
    focusPolicy: Qt.TabFocus

    indicator: QQC2.Label {
        text: baseItemDelegate.rightSideText
        verticalAlignment: Text.AlignVCenter
        color: Suru.foregroundColor
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
            rightMargin: units.gu(2)
        }
    }

    background: Item {
        Loader {
            asynchronous: true
            active: baseItemDelegate.enableChealDropShadow
            opacity: 0.4
            anchors {
                fill: parent
                leftMargin: Suru.units.gu(-0.1)
                rightMargin: Suru.units.gu(-0.2)
                topMargin: Suru.units.gu(-0.05)
                bottomMargin: Suru.units.gu(-0.2)
            }
            sourceComponent: Rectangle {
                readonly property color shadowColor: Suru.foregroundColor

                color: "transparent"
                border {
                    width: Suru.units.gu(0.2)
                    color: Qt.hsla(shadowColor.hslHue, shadowColor.hslSaturation, shadowColor.hslLightness, 0.2)
                }
                radius: backgroundRectangle.radius
            }
        }

        Common.BaseBackgroundRectangle {
            id: backgroundRectangle

            anchors.fill: parent
            control: baseItemDelegate
            radius: Suru.units.gu(1.5)
            enableDropShadow: baseItemDelegate.enableDropShadow
        }
    }

    Common.MouseAreaContext {
        anchors.fill: parent

        onTrigger: baseItemDelegate.rightClicked(mouseX, mouseY)
    }

    QQC2.ToolTip.delay: 1000
    QQC2.ToolTip.visible: hovered && baseItemDelegate.tooltipText !== ""
    QQC2.ToolTip.text: baseItemDelegate.tooltipText
}
