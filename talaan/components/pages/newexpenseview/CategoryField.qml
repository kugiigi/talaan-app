import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import "../../../common" as Common
import "../.." as Components

ComboBox {
    id: categoryField

    readonly property bool highlighted: activeFocus
    property color color: Suru.InformationHighlight ? Suru.activeFocusColor : Suru.foregroundColor
    property Common.BaseFlickable flickable

    model: mainView.mainModels.categoriesModel
    textRole: "category_name"
    implicitHeight: Suru.units.gu(6)
    font.pixelSize: Suru.units.gu(2.5)
    editable: true
    focus: false

    onAccepted: focusScrollConnections.focusNext()
    onActiveFocusChanged: {
        if (!activeFocus) {
            // Always select a valid value
            let _itemFound = find(editText, Qt.MatchStartsWith)
            if (_itemFound > -1) {
                currentIndex = _itemFound
            } else {
                editText = currentText
            }
        }
    }

    background: Common.BaseBackgroundRectangle {
        control: categoryField
        radius: Suru.units.gu(1)
        highlightColor: "transparent"
    }

    Components.FocusScrollConnections {
        id: focusScrollConnections

        target: textField
        flickable: categoryField.flickable
    }

    indicator: Button {
        property var control: categoryField

        width: control.height * 0.8
        height: width
        focusPolicy: Qt.NoFocus

        anchors {
            verticalCenter: parent.verticalCenter
            left: control.mirrored ? parent.left : undefined
            right: control.mirrored ? undefined : parent.right
            leftMargin: control.leftPadding
            rightMargin: control.rightPadding
        }

        icon.name: "down"
        icon.color: Suru.foregroundColor
        icon.width: Suru.units.gu(3)
        icon.height: Suru.units.gu(3)
        leftPadding: 0
        rightPadding: 0
        topPadding: 0
        bottomPadding: 0

        background: Item {}

        onClicked: control.popup.open()
    }

    contentItem: TextField {
        id: textField

        property var control: categoryField

        leftPadding: control.mirrored && control.indicator ? control.indicator.width + control.spacing : 0
        rightPadding: !control.mirrored && control.indicator ? control.indicator.width + control.spacing : 0

        text: control.editable ? control.editText : control.displayText

        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: Qt.ImhNoPredictiveText
        validator: control.validator
        font: control.font
        Suru.highlightType: Suru.InformationHighlight
        color: control.color ? control.color : Suru.foregroundColor
        selectionColor: Suru.highlightColor
        selectedTextColor: 'white'

        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter

        background: Item {}

        onActiveFocusChanged: {
            if (activeFocus) {
                selectAll()
            }
        }
    }
}
