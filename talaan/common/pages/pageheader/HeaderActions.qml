import QtQuick 2.12
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Layouts 1.12
import "../.." as Common
import "../../menus" as Menus

RowLayout {
    id: headerActions

    readonly property int visibleActionsCount: showOverflow ? 1 : actionsRowLayout.visibleCount
    readonly property bool showOverflow: allowOverflow && actionsRowLayout.visibleCount > overflowThreshold
    readonly property Common.BaseAction firstVisibleAction: showOverflow ? overflowButton.action
                                                                         : actionsRowLayout.visibleChildren[0] ? actionsRowLayout.visibleChildren[0].action
                                                                                                               : null

    property alias model: repeater.model
    property int buttonDisplay: QQC2.AbstractButton.IconOnly
    // Put all actions into overflow menu when visible buttons are more than this threshold
    property int overflowThreshold: 3
    property bool allowOverflow: false
    property Item currentItem

    // TODO: Show overflow menu at the bottom
    function triggerFirstVisibleItem() {
        if (firstVisibleAction) {
            firstVisibleAction.trigger(true, currentItem)
        }
    }

    spacing: units.gu(0.5)

    RowLayout {
        id: actionsRowLayout

        property int visibleCount: visibleChildren.length

        Layout.fillWidth: false
        // FIXME: There might be a better way to hide this
//~         Layout.preferredWidth: headerActions.showOverflow || visibleCount == 0 ? 0 : implicitWidth
//~         Layout.preferredWidth: visibleCount == 0 ? 0 : implicitWidth
//~         enabled: !headerActions.showOverflow
//~         opacity: headerActions.showOverflow ? 0 : 1

        Repeater {
            id: repeater

            visible: false // So it won't be included in visible count

            HeaderToolButton {
                id: button

                action: modelData
                display: headerActions.buttonDisplay
                tooltipText: modelData ? modelData.tooltipText : ""
                // FIXME: Binding loop with visibleCount
                hideDueToOverflow: headerActions.showOverflow
            }
        }
    }

    HeaderToolButton {
        id: overflowButton

        display: headerActions.buttonDisplay
        action: Common.BaseAction {
            visible: headerActions.showOverflow
            iconName:  "contextual-menu"
            shortText: i18n.tr("More")

            onTrigger: menuComponent.createObject(headerActions.currentItem).show("", caller, isBottom)
        }
    }

    Component {
        id: menuComponent

        Menus.AdvancedMenu {
            id: overflowMenu

            type: Menus.AdvancedMenu.Type.ItemAttached
            transformOrigin: QQC2.Menu.TopRight
            menuActions: pageHeader.rightActions
            destroyOnClose: true
            modal: true
        }
    }
}
