import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3 as UT
import ".." as Common

BaseItemDelegate {
    id: customizedSliderDelegate

    property alias label: mainLabel
    property alias helpText: helpButton.text

    property real controlMaximumWidth: 0
    property int defaultValue: 1

    // From Slider
    property alias value: slider.value
    property alias from: slider.minimumValue
    property alias to: slider.maximumValue
    property alias live: slider.live
    property alias stepSize: slider.stepSize

    property bool displayCurrentValue: true
    property bool showCurrentValueOnHandle: true
    property bool displayInPercentage: false
    property bool valueIsInPercentage: false
    property bool roundDisplayedValue: true
    property int roundingDecimal: 0
    property bool enableFineControls: false
    property string unit: displayInPercentage ? "%" : ""

    signal reset
    signal valueModified

    transparentBackground: true
    interactive: false
    rightPadding: Suru.units.gu(1)

    property var textFromValue: defaultTextFromValue
    property var defaultTextFromValue: function (v) {
        if (displayInPercentage) {
            if (valueIsInPercentage) {
                return ("%1 %2").arg(Math.round(v)).arg(unit)
            } else {
                return ("%1 %2").arg(Math.round(v * 100)).arg(unit)
            }
        } else {
            if (roundDisplayedValue) {
                return ("%1 %2").arg(parseFloat(v.toFixed(customizedSliderDelegate.roundingDecimal))).arg(unit)
            } else  {
                return ("%1 %2").arg(v).arg(unit)
            }
        }
    }

    contentItem: ColumnLayout {
        RowLayout {
            Label {
                id: mainLabel

                Layout.fillWidth: true
                text: customizedSliderDelegate.text
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: 2
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            // Dummy spacer
            Item {
                Layout.fillWidth: true
            }

            Label {
                Layout.alignment: Qt.AlignRight
                visible: customizedSliderDelegate.displayCurrentValue
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignRight
                text: customizedSliderDelegate.textFromValue(slider.value)
            }

            Common.BaseButton {
                id: resetButton

                visible: customizedSliderDelegate.defaultValue != slider.value
                display: AbstractButton.IconOnly
                tooltipText: i18n.tr("Reset to default")
                icon.name: "reset"
                transparentBackground: true

                onClicked: customizedSliderDelegate.reset()
            }

            Common.HelpButton {
                id: helpButton
            }
        }

        RowLayout {
            Layout.maximumWidth: customizedSliderDelegate.controlMaximumWidth > 0 ? customizedSliderDelegate.controlMaximumWidth
                                        : parent.width

            Common.BaseButton {
                Layout.fillHeight: true
                visible: customizedSliderDelegate.enableFineControls
                enabled: slider.value > slider.minimumValue
                display: AbstractButton.IconOnly
                tooltipText: i18n.tr("Decrease by %1").arg(customizedSliderDelegate.stepSize)
                icon.name: "remove"
                transparentBackground: true

                onClicked: {
                    let newValue = slider.value - slider.stepSize
                    if (newValue >= slider.minimumValue) {
                        slider.value = newValue
                    } else {
                        slider.value = slider.minimumValue
                    }
                }
            }

            UT.Slider {
                id: slider

                Layout.fillWidth: true

                enabled: customizedSliderDelegate.enabled
                minimumValue: 0
                maximumValue: 100
                live: true

                onValueChanged: customizedSliderDelegate.valueModified()

                // FIXME - to be deprecated in Lomiri.Components.
                // Use this to disable the label, since there is no way to do it on the component.
                function formatValue(v) {
                    if (customizedSliderDelegate.showCurrentValueOnHandle) {
                        return customizedSliderDelegate.textFromValue(v)
                    } else {
                        return "";
                    }
                }
            }

            Common.BaseButton {
                Layout.fillHeight: true
                visible: customizedSliderDelegate.enableFineControls
                enabled: slider.value < slider.maximumValue
                display: AbstractButton.IconOnly
                tooltipText: i18n.tr("Increase by %1").arg(customizedSliderDelegate.stepSize)
                icon.name: "add"
                transparentBackground: true

                onClicked: {
                    let newValue = slider.value + slider.stepSize
                    if (newValue <= slider.maximumValue) {
                        slider.value = newValue
                    } else {
                        slider.value = slider.maximumValue
                    }
                }
            }
        }
    }
}
