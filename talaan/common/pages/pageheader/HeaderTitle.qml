import QtQuick 2.12
import Lomiri.Components 1.3
import QtQuick.Controls 2.12 as QQC2
import QtQuick.Controls.Suru 2.2

QQC2.Label {
    id: headerTitle

    Suru.textLevel: Suru.HeadingTwo
    color: Suru.foregroundColor
    elide: Label.ElideRight
    fontSizeMode: Text.HorizontalFit
    minimumPixelSize: Suru.units.gu(1)
    verticalAlignment: Text.AlignVCenter
}
