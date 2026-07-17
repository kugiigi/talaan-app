import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import "../../../common/listitems" as ListItems
import "../../../common" as Common

Item {
    id: settingsItemFactory

    property QtObject settingsObject

    function getComponent(type) {
        switch (type) {
            case SettingsItem.ItemType.Header:
                return headerComponent
            case SettingsItem.ItemType.CheckBox:
                return checkboxComponent
            case SettingsItem.ItemType.Switch:
                return switchComponent
            case SettingsItem.ItemType.ComboBox:
                return comboboxComponent
            case SettingsItem.ItemType.Action:
                return actionComponent
            case SettingsItem.ItemType.SpinBox:
                return spinBoxComponent
            case SettingsItem.ItemType.Slider:
                return sliderComponent
            case SettingsItem.ItemType.GroupedRadio:
                return groupedRadioComponent
            case SettingsItem.ItemType.PopupPage:
                return popUpPageComponent
        }
    }

    Component {
        id: headerComponent
        
        RowLayout {
            Label {
                Layout.fillWidth: true
                Layout.margins: Suru.units.gu(1)

                text: modelData ? modelData.title : ""
                wrapMode: Text.WordWrap
                Suru.textLevel: Suru.HeadingThree
            }
        }
    }

    Component {
        id: switchComponent
        
        ListItems.BaseSwitchDelegate {
            id: switchDelegate

            text: modelData ? modelData.title : ""
            enabled: modelData && modelData.enabled
            switchPosition: ListItems.BaseSwitchDelegate.Position.Left
            onCheckedChanged: {
                if (modelData) {
                    settingsItemFactory.settingsObject[modelData.bindProperty] = modelData.invertedBind ? !checked : checked
                }
            }
            
            Binding {
                target: switchDelegate
                property: "checked"
                value: modelData ? modelData.invertedBind ? !settingsItemFactory.settingsObject[modelData.bindProperty]
                                              : settingsItemFactory.settingsObject[modelData.bindProperty]
                                 : false
            }

            indicator: Common.HelpButton {
                text: modelData ? modelData.description : ""

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    margins: Suru.units.gu(1)
                    right: parent.right
                }
            }
        }
    }

    Component {
        id: checkboxComponent

        ListItems.BaseCheckBoxDelegate {
            id: checkBoxDelegate

            text: modelData ? modelData.title : ""
            enabled: modelData && modelData.enabled
            label.maximumLineCount: 3
            checkBoxPosition: ListItems.BaseCheckBoxDelegate.Position.Left

            onCheckedChanged: {
                if (modelData) {
                    settingsItemFactory.settingsObject[modelData.bindProperty] = modelData.invertedBind ? !checked : checked
                }
            }
            
            Binding {
                target: checkBoxDelegate
                property: "checked"
                value: modelData ? modelData.invertedBind ? !settingsItemFactory.settingsObject[modelData.bindProperty]
                                                     : settingsItemFactory.settingsObject[modelData.bindProperty]
                                 : false
            }
            rightPadding: indicator.width + Suru.units.gu(1)
            indicator: Common.HelpButton {
                text: modelData ? modelData.description : ""

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    margins: Suru.units.gu(1)
                    right: parent.right
                }
            }
        }
    }

    Component {
        id: comboboxComponent

        ListItems.BaseComboBoxDelegate {
            id: comboboxDelegate

            text: modelData ? modelData.title : ""
            enabled: modelData && modelData.enabled
            model: modelData ? modelData.itemModel : null
            helpText: modelData ? modelData.description : ""
            controlMaximumWidth: modelData ? modelData.itemMaximumWidth : 0
            valueRole: modelData ? modelData.itemModelValueRole : ""
            textRole: modelData ? modelData.itemModelTextRole : ""
            currentIndex: modelData ? findIndexOfValue(settingsItemFactory.settingsObject[modelData.bindProperty]) : -1

            onActivated: {
                let _newValue
                if (Array.isArray(model)) {
                    _newValue = model[index][valueRole]
                } else {
                    _newValue = model.get(index)[valueRole]
                }
                settingsItemFactory.settingsObject[modelData.bindProperty] = _newValue
            }
        }
    }

    Component {
        id: actionComponent

        ListItems.BaseItemDelegate {
            transparentBackground: true
            text: modelData ? modelData.title : ""
            enabled: modelData && modelData.enabled
            leftPadding: Suru.units.gu(3)

            onClicked: {
                if (modelData) {
                    modelData.itemFunction()
                }
            }

            rightPadding: indicator.width + Suru.units.gu(1)
            indicator: Common.HelpButton {
                text: modelData ? modelData.description : ""

                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    margins: Suru.units.gu(1)
                    right: parent.right
                }
            }
        }
    }

    Component {
        id: spinBoxComponent

        ListItems.BaseSpinBoxDelegate {
            id: spinBoxDelegate

            text: modelData ? modelData.title : ""
            enabled: modelData && modelData.enabled
            controlMaximumWidth: modelData ? modelData.itemMaximumWidth : 0
            helpText: modelData ? modelData.description : ""
            defaultValue: modelData ? modelData.itemSettingsToControl(modelData.itemResetValue) : 1
            from: modelData ? modelData.itemFromValue : 0
            to: modelData ? modelData.itemToValue : 1
            stepSize: modelData ? modelData.itemStepSizeValue : 1
            textFromValue: modelData ? modelData.itemTextFromValue
                                     : function(value, locale) { return value }

            value: modelData ? modelData.itemSettingsToControl(settingsItemFactory.settingsObject[modelData.bindProperty])
                             : 0

            onReset: {
                if (modelData) {
                    settingsItemFactory.settingsObject[modelData.bindProperty] = modelData.itemResetValue
                }
            }
            
            onValueModified: {
                if (modelData) {
                    settingsItemFactory.settingsObject[modelData.bindProperty] = modelData.itemControlToSettings(value)
                }
            }
        }
    }

    Component {
        id: sliderComponent

        ListItems.BaseSliderDelegate {
            id: sliderDelegate

            text: modelData ? modelData.title : ""
            enabled: modelData && modelData.enabled
            controlMaximumWidth: modelData ? modelData.itemMaximumWidth : 0
            helpText: modelData ? modelData.description : ""
            defaultValue: modelData ? modelData.itemSettingsToControl(modelData.itemResetValue) : 1
            from: modelData ? modelData.itemFromValue : 0
            to: modelData ? modelData.itemToValue : 1
            stepSize: modelData ? modelData.itemStepSizeValue : 1
            live: modelData ? modelData.itemLiveValue : true
            displayCurrentValue: modelData ? modelData.itemDisplayCurrentValue : true
            showCurrentValueOnHandle: modelData ? modelData.itemDisplayCurrentValueOnControl : true
            displayInPercentage: modelData ? modelData.itemDisplayInPercentage : false
            valueIsInPercentage: modelData ? modelData.itemValueIsInPercentage : false
            roundDisplayedValue: modelData ? modelData.itemRoundDisplayedValue : true
            roundingDecimal: modelData ? modelData.itemRoundingDecimal : 0
            enableFineControls: modelData ? modelData.itemEnableFineControls : false
            unit: modelData ? modelData.itemUnit : ""
            textFromValue: modelData && modelData.itemTextFromValue ? modelData.itemTextFromValue
                                     : defaultTextFromValue

            Binding {
                target: sliderDelegate
                property: "value"
                value: modelData ? modelData.itemSettingsToControl(settingsItemFactory.settingsObject[modelData.bindProperty])
                             : 0
            }

            onReset: {
                if (modelData) {
                    settingsItemFactory.settingsObject[modelData.bindProperty] = modelData.itemResetValue
                }
            }
            
            onValueModified: {
                if (modelData) {
                    settingsItemFactory.settingsObject[modelData.bindProperty] = modelData.itemControlToSettings(value)
                }
            }
        }
    }

    Component {
        id: groupedRadioComponent

        Common.GroupedRadioButtons {
            id: groupedRadioButtons

            text: modelData ? modelData.title : ""
            model: modelData ? modelData.itemModel : null
            helpText: modelData ? modelData.description : ""
            defaultValue: modelData ? modelData.itemResetValue : 0
            valueRole: modelData ? modelData.itemModelValueRole : ""
            textRole: modelData ? modelData.itemModelTextRole : ""
            customValueValidator: modelData ? modelData.itemCustomValueValidator : ""
            customValue: customIsSelected ? settingsItemFactory.settingsObject[modelData.bindProperty] : ""
            currentIndex: {
                if (modelData) {
                    if (modelData.itemSettingsToControl) {
                        return modelData.itemSettingsToControl(settingsItemFactory.settingsObject[modelData.bindProperty])
                    } else {
                        return findIndexOfValue(settingsItemFactory.settingsObject[modelData.bindProperty])
                    }
                }

                return -1
            }

            onCurrentIndexChanged: {
                if (modelData) {
                    let _newValue
                    if (Array.isArray(model)) {
                        _newValue = model[currentIndex][valueRole]
                    } else {
                        _newValue = model.get(currentIndex)[valueRole]
                    }

                    // Do not change save when custom is selected
                    // This will only save when custom value is valid
                    if (_newValue == "custom") {
                        if (modelData.itemCustomValueValidator(customValue)) {
                            settingsItemFactory.settingsObject[modelData.bindProperty] = modelData.itemCustomValueToSettings(customValue)
                        }
                    } else {
                        settingsItemFactory.settingsObject[modelData.bindProperty] = _newValue
                    }
                }
            }

            onReset: {
                if (modelData) {
                    if (modelData.itemSettingsToControl) {
                        currentIndex = modelData.itemSettingsToControl(modelData.itemResetValue)
                    } else {
                        currentIndex = findIndexOfValue(modelData.itemResetValue)
                    }
                }
            }

            onCustomValueChanged: {
                if (modelData && customIsSelected) {
                    if (modelData.itemCustomValueValidator(customValue)) {
                        settingsItemFactory.settingsObject[modelData.bindProperty] = modelData.itemCustomValueToSettings(customValue)
                    }
                }
            }
        }
    }
}
