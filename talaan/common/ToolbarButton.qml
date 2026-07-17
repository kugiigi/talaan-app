import QtQuick 2.12
import QtQuick.Controls 2.12
import "." as Common

ToolButton {
    id: toolButton

    property string tooltipText
    property string iconName
    property real iconWidth
    property real iconHeight
    property color iconColor

    height: Suru.units.gu(5)
    width: height
    focusPolicy: Qt.TabFocus
    icon.width: Suru.units.gu(2)
    icon.height: Suru.units.gu(2)

    onClicked: Common.Haptics.playSubtle()

    ToolTip.delay: 1000
    ToolTip.visible: hovered
    ToolTip.text: toolButton.tooltipText
}
