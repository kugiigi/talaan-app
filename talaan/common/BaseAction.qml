import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2

Action {
    id: action

    property bool visible: true
    property bool onlyShowInBottom: false
    property bool separator: false
    property bool triggerOnTriggered: true
    property string shortText: text
    property string tooltipText
    property string iconName
    property bool disallowOverflowMenu: false

    icon {
        name: iconName
        color: mainView.uitkColors.normal.backgroundSecondaryText
    }
    enabled: visible

    signal trigger(bool isBottom, var caller)
    onTriggered: if (triggerOnTriggered) trigger(false, parent)
}
