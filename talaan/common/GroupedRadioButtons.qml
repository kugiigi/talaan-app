import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Suru 2.2
import "listitems" as ListItems

ListItems.BaseItemDelegate {
    id: radioButtonsItem

    enum CustomFieldType {
        None
        , TextField
    }

    property alias label: mainLabel
    property alias helpText: helpButton.text
    property int defaultValue: 1
    property int currentIndex: -1
    property var currentItem
    property alias model: repeater.model
    property string valueRole: "value"
	property string textRole: "text"
    property var customValue
    property var customValueValidator: function(value) { return value ? true : false }

    readonly property int count: model ? Array.isArray(model) ? model.length : model.count
                                       : 0
    readonly property bool customIsSelected: currentItem && currentItem.isCustom

    signal reset

    transparentBackground: true
    interactive: false
    rightPadding: Suru.units.gu(1)

    function findIndexOfValue(_findValue) {
		let i = 0
        let _currentValue

		for (i = 0; i <= count - 1; i++) {
            if (Array.isArray(model)) {
                _currentValue = model[i][valueRole]
            } else {
                _currentValue = model.get(i)[valueRole]
            }
            if (_findValue == _currentValue) {
                return i
            }
		}
	
		return -1
	}

    ButtonGroup { id: radioGroup }

    contentItem: ColumnLayout {
        RowLayout {
            Label {
                id: mainLabel

                Layout.fillWidth: true
                text: radioButtonsItem.text
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: 2
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            BaseButton {
                id: resetButton

                visible: radioButtonsItem.defaultValue != radioButtonsItem.currentIndex
                display: AbstractButton.IconOnly
                tooltipText: i18n.tr("Reset to default")
                icon.name: "reset"
                backgroundColor: "transparent"
                borderColor: "transparent"

                onClicked: radioButtonsItem.reset()
            }

            // Dummy spacer
            Item {
                Layout.fillWidth: true
            }

            HelpButton {
                id: helpButton
            }
        }

        ColumnLayout {
            Repeater {
                id: repeater

                ColumnLayout {
                    id: itemLayout

                    readonly property bool isSelected: radioButtonsItem.currentIndex == index
                    readonly property bool isCustom: modelData.hasOwnProperty("customFieldType")

                    onIsSelectedChanged: if (isSelected) radioButton.checked = true

                    BaseRadioButton {
                        id: radioButton

                        Layout.fillWidth: true

                        text: modelData[radioButtonsItem.textRole]
                        ButtonGroup.group: radioGroup
                        checked: itemLayout.isSelected
                        focusPolicy: Qt.TabFocus
                        onCheckedChanged: {
                            if (checked) {
                                radioButtonsItem.currentIndex = index
                                radioButtonsItem.currentItem = itemLayout
                            }
                        }
                    }

                    Loader {
                        Layout.fillWidth: true
                        Layout.leftMargin: units.gu(5)

                        asynchronous: true
                        active: true
                        enabled: modelData.hasOwnProperty("customFieldType") && itemLayout.isSelected
                        sourceComponent: {
                            if (modelData.customFieldType) {
                                switch (modelData.customFieldType) {
                                    case GroupedRadioButtons.CustomFieldType.TextField:
                                        return textFieldComponent
                                }
                            }

                            return null
                        }

                        onLoaded: {
                            switch (modelData.customFieldType) {
                                case GroupedRadioButtons.CustomFieldType.TextField:
                                    item.textField.text = radioButtonsItem.customValue ? radioButtonsItem.customValue : ""
                                    item.textField.inputMethodHints = modelData.customInputMethodHints
                                    break
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: textFieldComponent
        
        ColumnLayout {
            property alias textField: textField

            TextField {
                id: textField

                Layout.fillWidth: true
                onTextChanged: radioButtonsItem.customValue = text
            }
            
            Label {
                Layout.fillWidth: true
                color: Suru.highlightColor
                Suru.textLevel: Suru.Caption
                Suru.highlightType: Suru.NegativeHighlight
                text: i18n.tr("Value is invalid and not saved")
                visible: radioButtonsItem.customIsSelected && !radioButtonsItem.customValueValidator(textField.text)
            }
        }
    }
}
