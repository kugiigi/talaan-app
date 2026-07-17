import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12

ToolBar {
    id: toolbar

    default property alias data: defaultContent.data
    property list<BaseAction> leftActions
    property list<BaseAction> rightActions

    property color backgroundColor: Suru.secondaryForegroundColor
    property real radius: Suru.units.gu(0.5)

    background: Rectangle {
        color: toolbar.backgroundColor
        radius: toolbar.radius
    }

    RowLayout {
        spacing: 0
        anchors.fill: parent
        
        ToolbarActions {
            id: leftActionsRow

            Layout.alignment: Qt.AlignLeft
            position: toolbar.position
            model: toolbar.leftActions
        }
        Item {
            id: defaultContent
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        ToolbarActions {
            id: rightActionsRow

            Layout.alignment: Qt.AlignRight
            position: toolbar.position
            model: toolbar.rightActions
        }
    }
}
