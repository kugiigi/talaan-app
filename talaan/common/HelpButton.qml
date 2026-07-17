import QtQuick 2.12
import QtQuick.Controls 2.12

BaseButton {
    id: helpButton

    display: AbstractButton.IconOnly
    icon.name: "help"
    transparentBackground: true

    onClicked: {
        ToolTip.delay = 0
        ToolTip.visible = true
    }

    ToolTip.delay: 500
    ToolTip.visible: hovered
    ToolTip.text: helpButton.text
    ToolTip.onVisibleChanged: ToolTip.delay = 500
}
