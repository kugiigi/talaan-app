import QtQuick 2.4
import Lomiri.Components 1.3

Action {
    property string iconName: "add"
    property color iconColor: switch (settings.currentTheme) {
                              case "Default":
                                  "black"
                                  break
                              case "Ambiance":
                              case "System":
                              case "SuruDark":
                                  theme.palette.highlighted.overlayText
                                  break
                              default:
                                  "black"
                              }
    property color backgroundColor: switch (settings.currentTheme) {
                                    case "Default":
                                        "white"
                                        break
                                    case "Ambiance":
                                    case "System":
                                    case "SuruDark":
                                        theme.palette.highlighted.overlay
                                        break
                                    default:
                                        "white"
                                    }
    property bool hide: false
    property string label: ""
    text: label
    visible: !hide
}
