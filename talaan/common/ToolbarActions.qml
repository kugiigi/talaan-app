import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import "." as Common

Row {
    id: toolbarActions

    property alias model: repeater.model
    property int position: ToolBar.Footer

    spacing: Suru.units.gu(2)

    Repeater {
        id: repeater
        
        Common.BaseButton {
            id: toolButton

            display: AbstractButton.IconOnly
            action: modelData
            tooltipText: modelData.text
            visible: modelData.visible
            height: Suru.units.gu(5)
            icon.width: Suru.units.gu(3)
            icon.height: Suru.units.gu(3)
            onClicked: {
				modelData.trigger(toolbarActions.position == ToolBar.Footer, toolButton)
                Common.Haptics.playSubtle()
			}
        }
    }
}
