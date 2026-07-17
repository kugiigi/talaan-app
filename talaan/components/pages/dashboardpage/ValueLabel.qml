import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../.." as Components

Components.ColoredLabel {
    id: previousLabel

    readonly property real preferredFontSize: highlight ? chartHeight * 0.1
                                                        : chartHeight * 0.05
    readonly property real minimumFontSize: highlight ? Suru.units.gu(0.5)
                                                        : Suru.units.gu(1)
    property real chartHeight
    property bool enableAnimation: true
    property bool highlight: false
    property real value

    role: "value"
    opacity: highlight ? 1 : 0.7
    fontSizeMode: Text.HorizontalFit
    font.pixelSize: preferredFontSize
    minimumPixelSize: minimumFontSize
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    text: AppFunctions.formatMoney(value)

    Behavior on font.pixelSize {
        enabled: enableAnimation
        NumberAnimation {
            duration: Suru.animations.SnapDuration
        }
    }
}
