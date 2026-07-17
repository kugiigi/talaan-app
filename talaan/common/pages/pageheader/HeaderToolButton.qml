import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import "../.." as Common

ToolButton {
    id: headerToolButton

    property alias radius: backgroundRectangle.radius
    property alias transparentBackground: backgroundRectangle.transparentBackground
    property alias backgroundColor: backgroundRectangle.backgroundColor
    property alias borderColor: backgroundRectangle.borderColor
    property alias highlightedBorderColor: backgroundRectangle.highlightedBorderColor
    property string tooltipText
    property bool hideDueToOverflow: false
    readonly property bool forceHide: action && !action.disallowOverflowMenu && hideDueToOverflow

    // TODO: Enable once UT's issue with hover is fixed
    hoverEnabled: false

    text: display == AbstractButton.TextUnderIcon ? action.shortText : action.text
//~     visible: ((action && action.visible) || !action) && !action.onlyShowInBottom
    visible: ((action && action.visible) || !action) && !action.onlyShowInBottom
                && !forceHide
    display: AbstractButton.IconOnly
    icon {
        width: Suru.units.gu(2)
        height: Suru.units.gu(2)
        color: Suru.foregroundColor
    }

    background: Common.BaseBackgroundRectangle {
        id: backgroundRectangle

        implicitHeight: Suru.units.gu(5)
        implicitWidth: Suru.units.gu(5)
        control: headerToolButton
        showDivider: false
        radius: Suru.units.gu(1)
    }

    ToolTip.delay: 1000
    ToolTip.visible: hovered && (headerToolButton.text !== "" || headerToolButton.tooltipText !== "")
    ToolTip.text: {
        if (headerToolButton.tooltipText)
            return headerToolButton.tooltipText

        if (headerToolButton.action && headerToolButton.action.shortText)
            return headerToolButton.action.text

        return headerToolButton.text
    }
}
