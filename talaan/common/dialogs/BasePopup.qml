import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2

Dialog {
    id: customPopup

    objectName: "customPopup"

    property real maximumWidth: Suru.units.gu(90)
    property real preferredWidth: parent.width

    property real maximumHeight: Suru.units.gu(80)
    property real preferredHeight: parent.height > maximumHeight ? parent.height * 0.7 : parent.height

    width: preferredWidth > maximumWidth ? maximumWidth : preferredWidth
    height: preferredHeight > maximumHeight ? maximumHeight 
                                              : parent.height > maximumHeight ? preferredHeight
                                                                              : parent.height
    x: (parent.width - width) / 2
    parent: ApplicationWindow.overlay
    topPadding: Suru.units.gu(0.2)
    leftPadding: Suru.units.gu(0.2)
    rightPadding: Suru.units.gu(0.2)
    bottomPadding: Suru.units.gu(0.2)
    closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
    modal: true
    focus: true

    function openPopup(){
        y = Qt.binding(function(){return parent.width >= Suru.units.gu(90) ? (parent.height - height) / 2 : (parent.height - height)})
        open()
    }
}
