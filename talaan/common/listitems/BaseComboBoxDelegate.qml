import QtQuick 2.12
import Lomiri.Components 1.3 as UT
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Suru 2.2
import ".." as Common

BaseItemDelegate {
    id: comboboxItem

    property alias label: mainLabel
	property alias currentIndex: comboBox.currentIndex
	property alias model: comboBox.model
	property alias currentText: comboBox.currentText
	property alias count: comboBox.count
	property alias helpText: helpButton.text
	property string valueRole //TODO: Make into alias when Qt5.14+
	property alias textRole: comboBox.textRole
	property alias editable: comboBox.editable
    property real controlMaximumWidth: 0

    signal activated(int index)

    transparentBackground: true
    interactive: false
    rightPadding: Suru.units.gu(1)

    function find(text, flags) {
        var result = comboBox.find(text, flags)
        return result
    }

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

    onClicked: comboBox.popup.open()

    contentItem: ColumnLayout {

        RowLayout {
            Label {
                id: mainLabel

                Layout.fillWidth: true
                text: comboboxItem.text
                wrapMode: Text.WordWrap
                elide: Text.ElideRight
                maximumLineCount: 2
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
            }

            Common.HelpButton {
                id: helpButton
            }
        }

        ComboBox {
            id: comboBox

            Layout.fillWidth: true
            Layout.maximumWidth: comboboxItem.controlMaximumWidth > 0 ? comboboxItem.controlMaximumWidth
                                        : parent.width
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            onActivated: comboboxItem.activated(index)
        }
    }
}
