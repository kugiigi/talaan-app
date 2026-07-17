import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12

Item {
    id: colorPickerPopup

    readonly property real gridViewMargin: Suru.units.gu(1.5)

    property alias cellHeight: gridView.cellHeight
    property alias cellWidth: gridView.cellWidth
    property color selectedColor: "white"

    signal colorSelected(color selectedColor)

    Component.onCompleted: colorModel.initialise()

    Component {
        id: highlight

        Rectangle {
            width: gridView.cellWidth
            height: gridView.cellHeight
            z: 100
            color: "transparent"
            radius: height * 0.2
            border.color: Suru.activeFocusColor
            border.width: Suru.units.gu(1)
        }
    }

    GridView {
        id: gridView

        readonly property real preferredGridWidth: Suru.units.gu(8)
        property int columnCount: {
            let intendedCount = Math.floor(width / preferredGridWidth)
            return intendedCount
        }

        anchors {
            fill: colorPickerPopup
            margins: colorPickerPopup.gridViewMargin
        }

        focus: true
        model: colorModel
        cellWidth: width / columnCount
        cellHeight: cellWidth
        clip: true
        currentIndex: -1
        highlightFollowsCurrentItem: true
        highlight: highlight
        highlightMoveDuration: Suru.animations.SnapDuration
        snapMode: GridView.SnapToRow

        delegate: Rectangle {
            id: recMargin

            color: backgroundColor
            height: gridView.cellHeight
            width: gridView.cellWidth

            property color cellColor: colorRec.color

            function select() {
                gridView.currentIndex = index
                colorSelected(model.colorValue)
            }

            Keys.onReturnPressed: select()
            Keys.onEnterPressed: select()

            Rectangle {
                id: colorRec

                anchors.centerIn: recMargin
                radius: height * 0.2
                color: model.colorValue
                height: recMargin.height - Suru.units.gu(1.5)
                width: gridView.cellWidth - Suru.units.gu(1.5)
                border {
                    width: Suru.units.dp(1)
                    color: Suru.tertiaryForegroundColor
                }
                scale: recMargin.GridView.isCurrentItem ? 1.2 : 1
                Behavior on scale {
                    NumberAnimation {
                        duration: Suru.animations.SnapDuration
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        recMargin.select()
                    }
                }
            }
        }
    }

    ListModel {
        id: colorModel

        function initialise() {
            colorModel.append({
                                  colorValue: "aliceblue"
                              })
            colorModel.append({
                                  colorValue: "antiquewhite"
                              })
            colorModel.append({
                                  colorValue: "aqua"
                              })
            colorModel.append({
                                  colorValue: "aquamarine"
                              })
            colorModel.append({
                                  colorValue: "azure"
                              })
            colorModel.append({
                                  colorValue: "beige"
                              })
            colorModel.append({
                                  colorValue: "bisque"
                              })
            colorModel.append({
                                  colorValue: "black"
                              })
            colorModel.append({
                                  colorValue: "blanchedalmond"
                              })
            colorModel.append({
                                  colorValue: "blue"
                              })
            colorModel.append({
                                  colorValue: "blueviolet"
                              })
            colorModel.append({
                                  colorValue: "brown"
                              })
            colorModel.append({
                                  colorValue: "burlywood"
                              })
            colorModel.append({
                                  colorValue: "cadetblue"
                              })
            colorModel.append({
                                  colorValue: "chartreuse"
                              })
            colorModel.append({
                                  colorValue: "chocolate"
                              })
            colorModel.append({
                                  colorValue: "coral"
                              })
            colorModel.append({
                                  colorValue: "cornflowerblue"
                              })
            colorModel.append({
                                  colorValue: "cornsilk"
                              })
            colorModel.append({
                                  colorValue: "crimson"
                              })
            colorModel.append({
                                  colorValue: "cyan"
                              })
            colorModel.append({
                                  colorValue: "darkblue"
                              })
            colorModel.append({
                                  colorValue: "darkcyan"
                              })
            colorModel.append({
                                  colorValue: "darkgoldenrod"
                              })
            colorModel.append({
                                  colorValue: "darkgreen"
                              })
            colorModel.append({
                                  colorValue: "darkgrey"
                              })
            colorModel.append({
                                  colorValue: "darkkhaki"
                              })
            colorModel.append({
                                  colorValue: "darkmagenta"
                              })
            colorModel.append({
                                  colorValue: "darkolivegreen"
                              })
            colorModel.append({
                                  colorValue: "darkorange"
                              })
            colorModel.append({
                                  colorValue: "darkorchid"
                              })
            colorModel.append({
                                  colorValue: "darkred"
                              })
            colorModel.append({
                                  colorValue: "darksalmon"
                              })
            colorModel.append({
                                  colorValue: "darkseagreen"
                              })
            colorModel.append({
                                  colorValue: "darkslateblue"
                              })
            colorModel.append({
                                  colorValue: "darkslategrey"
                              })
            colorModel.append({
                                  colorValue: "darkturquoise"
                              })
            colorModel.append({
                                  colorValue: "darkviolet"
                              })
            colorModel.append({
                                  colorValue: "deeppink"
                              })
            colorModel.append({
                                  colorValue: "deepskyblue"
                              })
            colorModel.append({
                                  colorValue: "dimgrey"
                              })
            colorModel.append({
                                  colorValue: "dodgerblue"
                              })
            colorModel.append({
                                  colorValue: "firebrick"
                              })
            colorModel.append({
                                  colorValue: "floralwhite"
                              })
            colorModel.append({
                                  colorValue: "forestgreen"
                              })
            colorModel.append({
                                  colorValue: "fuchsia"
                              })
            colorModel.append({
                                  colorValue: "gainsboro"
                              })
            colorModel.append({
                                  colorValue: "ghostwhite"
                              })
            colorModel.append({
                                  colorValue: "gold"
                              })
            colorModel.append({
                                  colorValue: "goldenrod"
                              })
            colorModel.append({
                                  colorValue: "green"
                              })
            colorModel.append({
                                  colorValue: "greenyellow"
                              })
            colorModel.append({
                                  colorValue: "grey"
                              })
            colorModel.append({
                                  colorValue: "honeydew"
                              })
            colorModel.append({
                                  colorValue: "hotpink"
                              })
            colorModel.append({
                                  colorValue: "indianred"
                              })
            colorModel.append({
                                  colorValue: "indigo"
                              })
            colorModel.append({
                                  colorValue: "ivory"
                              })
            colorModel.append({
                                  colorValue: "khaki"
                              })
            colorModel.append({
                                  colorValue: "lavender"
                              })
            colorModel.append({
                                  colorValue: "lavenderblush"
                              })
            colorModel.append({
                                  colorValue: "lawngreen"
                              })
            colorModel.append({
                                  colorValue: "lemonchiffon"
                              })
            colorModel.append({
                                  colorValue: "lightblue"
                              })
            colorModel.append({
                                  colorValue: "lightcoral"
                              })
            colorModel.append({
                                  colorValue: "lightcyan"
                              })
            colorModel.append({
                                  colorValue: "lightgoldenrodyellow"
                              })
            colorModel.append({
                                  colorValue: "lightgreen"
                              })
            colorModel.append({
                                  colorValue: "lightgrey"
                              })
            colorModel.append({
                                  colorValue: "lightpink"
                              })
            colorModel.append({
                                  colorValue: "lightsalmon"
                              })
            colorModel.append({
                                  colorValue: "lightseagreen"
                              })
            colorModel.append({
                                  colorValue: "lightskyblue"
                              })
            colorModel.append({
                                  colorValue: "lightslategrey"
                              })
            colorModel.append({
                                  colorValue: "lightsteelblue"
                              })
            colorModel.append({
                                  colorValue: "lightyellow"
                              })
            colorModel.append({
                                  colorValue: "lime"
                              })
            colorModel.append({
                                  colorValue: "limegreen"
                              })
            colorModel.append({
                                  colorValue: "linen"
                              })
            colorModel.append({
                                  colorValue: "magenta"
                              })
            colorModel.append({
                                  colorValue: "maroon"
                              })
            colorModel.append({
                                  colorValue: "mediumaquamarine"
                              })
            colorModel.append({
                                  colorValue: "mediumblue"
                              })
            colorModel.append({
                                  colorValue: "mediumorchid"
                              })
            colorModel.append({
                                  colorValue: "mediumpurple"
                              })
            colorModel.append({
                                  colorValue: "mediumseagreen"
                              })
            colorModel.append({
                                  colorValue: "mediumslateblue"
                              })
            colorModel.append({
                                  colorValue: "mediumspringgreen"
                              })
            colorModel.append({
                                  colorValue: "mediumturquoise"
                              })
            colorModel.append({
                                  colorValue: "mediumvioletred"
                              })
            colorModel.append({
                                  colorValue: "midnightblue"
                              })
            colorModel.append({
                                  colorValue: "mintcream"
                              })
            colorModel.append({
                                  colorValue: "mistyrose"
                              })
            colorModel.append({
                                  colorValue: "moccasin"
                              })
            colorModel.append({
                                  colorValue: "navajowhite"
                              })
            colorModel.append({
                                  colorValue: "navy"
                              })
            colorModel.append({
                                  colorValue: "oldlace"
                              })
            colorModel.append({
                                  colorValue: "olive"
                              })
            colorModel.append({
                                  colorValue: "olivedrab"
                              })
            colorModel.append({
                                  colorValue: "orange"
                              })
            colorModel.append({
                                  colorValue: "orangered"
                              })
            colorModel.append({
                                  colorValue: "orchid"
                              })
            colorModel.append({
                                  colorValue: "palegoldenrod"
                              })
            colorModel.append({
                                  colorValue: "palegreen"
                              })
            colorModel.append({
                                  colorValue: "paleturquoise"
                              })
            colorModel.append({
                                  colorValue: "palevioletred"
                              })
            colorModel.append({
                                  colorValue: "papayawhip"
                              })
            colorModel.append({
                                  colorValue: "peachpuff"
                              })
            colorModel.append({
                                  colorValue: "peru"
                              })
            colorModel.append({
                                  colorValue: "pink"
                              })
            colorModel.append({
                                  colorValue: "plum"
                              })
            colorModel.append({
                                  colorValue: "powderblue"
                              })
            colorModel.append({
                                  colorValue: "purple"
                              })
            colorModel.append({
                                  colorValue: "red"
                              })
            colorModel.append({
                                  colorValue: "rosybrown"
                              })
            colorModel.append({
                                  colorValue: "royalblue"
                              })
            colorModel.append({
                                  colorValue: "saddlebrown"
                              })
            colorModel.append({
                                  colorValue: "salmon"
                              })
            colorModel.append({
                                  colorValue: "sandybrown"
                              })
            colorModel.append({
                                  colorValue: "seagreen"
                              })
            colorModel.append({
                                  colorValue: "seashell"
                              })
            colorModel.append({
                                  colorValue: "sienna"
                              })
            colorModel.append({
                                  colorValue: "silver"
                              })
            colorModel.append({
                                  colorValue: "skyblue"
                              })
            colorModel.append({
                                  colorValue: "slateblue"
                              })
            colorModel.append({
                                  colorValue: "slategrey"
                              })
            colorModel.append({
                                  colorValue: "snow"
                              })
            colorModel.append({
                                  colorValue: "springgreen"
                              })
            colorModel.append({
                                  colorValue: "steelblue"
                              })
            colorModel.append({
                                  colorValue: "tan"
                              })
            colorModel.append({
                                  colorValue: "teal"
                              })
            colorModel.append({
                                  colorValue: "thistle"
                              })
            colorModel.append({
                                  colorValue: "tomato"
                              })
            colorModel.append({
                                  colorValue: "turquoise"
                              })
            colorModel.append({
                                  colorValue: "violet"
                              })
            colorModel.append({
                                  colorValue: "wheat"
                              })
            colorModel.append({
                                  colorValue: "white"
                              })
            colorModel.append({
                                  colorValue: "whitesmoke"
                              })
            colorModel.append({
                                  colorValue: "yellow"
                              })
            colorModel.append({
                                  colorValue: "yellowgreen"
                              })

            for (let i = 0; i < colorModel.count; i++) {
                gridView.currentIndex = i
                if (Qt.colorEqual(gridView.currentItem.cellColor, colorPickerPopup.selectedColor)) {
                    i = colorModel.count
                } else {
                    if (i === colorModel.count - 1) {
                        gridView.currentIndex = -1
                    }
                }
            }
        }
    }
}
