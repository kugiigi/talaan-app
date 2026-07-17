import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import ".." as Common

Dialog {
    id: baseDialog

    // Space available for the actual dialog
    readonly property real availableVerticalSpace: anchorToKeyboard ? parent.height - keyboardRectangle.height - bottomMargin
                                                                    : parent.height

    property real maximumWidth: Suru.units.gu(40)
    property real preferredWidth: parent.width * 0.80
    property bool anchorToKeyboard: false
    property alias keyboardRectangle: osk

    bottomMargin: Suru.units.gu(2)
    width: Math.min(preferredWidth, maximumWidth)

    x: (parent.width - width) / 2
    parent: ApplicationWindow.overlay

    modal: true
    focus: true

    standardButtons: Dialog.Ok | Dialog.Cancel
    
    function openDialog() {
        y = Qt.binding( function() { return parent.width >= Suru.units.gu(90) ? ((parent.height - height) / 2) - (baseDialog.anchorToKeyboard ? osk.height : 0)
                                                : (parent.height - height - bottomMargin) - (baseDialog.anchorToKeyboard ? osk.height : 0) } )
        open()
    }

    function openBottom() {
        y = Qt.binding( function() { return (parent.height - height - bottomMargin) - (baseDialog.anchorToKeyboard ? osk.height : 0) } )
        open()
    }

    function openNormal() {
        y = Qt.binding( function() { return ((parent.height - height) / 2) - (baseDialog.anchorToKeyboard ? osk.height : 0) } )
        open()
    }

    header: Label {
        text: baseDialog.title
        visible: baseDialog.title
        elide: Label.ElideRight
        horizontalAlignment: Text.AlignHCenter
        topPadding: Suru.units.gu(3)
        leftPadding: Suru.units.gu(2)
        rightPadding: Suru.units.gu(2)

        Suru.textLevel: Suru.HeadingThree
        Suru.textStyle: Suru.PrimaryText
    }

    Common.KeyboardRectangle {
        id: osk
    }
}
