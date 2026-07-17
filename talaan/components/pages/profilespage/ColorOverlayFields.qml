import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common/listitems" as ListItems
import "../../../common" as Common

ColumnLayout {
    id: root

    property alias enableOverlay: enableOverlaySwitch.checked
    property alias overlayOpacity: opacitySlider.value
    property alias overlayColor: colorPicker.selectedColor

    property Common.BaseFlickable flickable

    spacing: Suru.units.gu(1)

    ListItems.BaseSwitchDelegate {
        id: enableOverlaySwitch

        Layout.fillWidth: true
        leftPadding: Suru.units.gu(1)
        rightPadding: indicator.width + Suru.units.gu(1)
        text: i18n.tr("Enable color overlay when profile is active")
        switchPosition: ListItems.BaseSwitchDelegate.Position.Left

        indicator: Common.HelpButton {
            text: i18n.tr("A color overlay will be displayed whenever this profile is active so that it's easy distinguish the active profile and avoid incorrect operations.")

            anchors {
                top: parent.top
                bottom: parent.bottom
                margins: Suru.units.gu(1)
                right: parent.right
            }
        }
    }

    Common.ColorPicker {
        id: colorPicker

        Layout.fillWidth: true
        Layout.leftMargin: Suru.units.gu(2)
        visible: enableOverlaySwitch.checked
    }

    ListItems.BaseSliderDelegate {
        id: opacitySlider

        Layout.fillWidth: true
        Layout.leftMargin: Suru.units.gu(2)
        visible: enableOverlaySwitch.checked
        text: i18n.tr("Transparency")
        controlMaximumWidth: Suru.units.gu(60)
        helpText: i18n.tr("Determine the transparency of the color overlay")
        value: defaultValue
        defaultValue: 20
        from: 10
        to: 60
        stepSize: 5
        live: true
        displayCurrentValue: false
        showCurrentValueOnHandle: true
        displayInPercentage: true
        valueIsInPercentage: true
        roundDisplayedValue: true
        roundingDecimal: 2
        enableFineControls: true

        onReset: value = defaultValue
    }

}
