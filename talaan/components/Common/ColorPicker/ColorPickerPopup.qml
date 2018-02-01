import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3

Item {
    id: root

    property real dialogWidth: units.gu(40)
    property real dialogHeight: units.gu(32)
    property alias cellHeight: gridView.cellHeight
    property alias cellWidth: gridView.cellWidth
    property color backgroundColor: theme.palette.normal.background
    property color selectedColor
    property int maxRows: 4
    property int maxColumns: 8
    readonly property real gridViewMargin: units.gu(1.5)

    signal selected

    height: (gridView.cellHeight * maxRows) + (gridViewMargin * 2)
    width: (gridView.cellWidth * maxColumns) + (gridViewMargin * 2)

    ListModel {
        id: colorModel
        Component.onCompleted: initialise()

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
                                  colorValue: "darkgray"
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
                                  colorValue: "darkslategray"
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
                                  colorValue: "dimgray"
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
                                  colorValue: "gray"
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
                                  colorValue: "lightgray"
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
                                  colorValue: "lightslategray"
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
                                  colorValue: "slategray"
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

            var i = 0
            for (i = 0; i < colorModel.count; i++) {
                gridView.currentIndex = i

                if (gridView.currentItem.cellColor === root.selectedColor) {
                    //console.log("naselect na color: " + i)
                    i = colorModel.count
                }else{
                    if(i === colorModel.count - 1){
                        gridView.currentIndex = -1
                    }
                }
            }
        }
    }

    Rectangle {
        id: bgRec
        z: -1
        anchors.fill: parent
        color: backgroundColor
    }

    Component {
        id: highlight
        Rectangle {
            width: gridView.cellWidth
            height: gridView.cellHeight
            z: 100
            color: "transparent"
            border.color: UbuntuColors.blue //theme.palette.normal.selection
            border.width: units.gu(1)
            //radius: 5
            //            x: gridView.currentItem.x
            //            y: gridView.currentItem.y
            //            Behavior on x { SpringAnimation { spring: 3; damping: 0.2 } }
            //            Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }
        }
    }

    GridView {
        id: gridView

        model: colorModel
        clip: true
        cellHeight: units.gu(8)
        cellWidth: cellHeight
        currentIndex: -1
        highlightFollowsCurrentItem: true
        highlight: highlight

        highlightMoveDuration: UbuntuAnimation.BriskDuration
        snapMode: GridView.SnapToRow


        anchors {
            fill: root
            margins: gridViewMargin
        }

        delegate: Rectangle {
            id: recMargin
            color: backgroundColor //"white"
            height: gridView.cellHeight
            width: gridView.cellWidth

            property color cellColor: colorRec.color

            Rectangle {
                id: colorRec

                color: colorValue //modelData
                height: recMargin.height - units.gu(1.5)
                width: gridView.cellWidth - units.gu(1.5)

                anchors.centerIn: recMargin

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("color selected")
                        root.selectedColor = colorValue
                        gridView.currentIndex = index
                        selected()
                    }
                }
            }
        }
    }
}
