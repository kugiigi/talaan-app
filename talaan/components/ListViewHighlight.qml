import QtQuick 2.4
import Lomiri.Components 1.3

Rectangle {
    id: highlightRec
    color: switch (settings.currentTheme) {
           case "Default":
               "#2D371300"
               break
           case "Ambiance":
           case "System":
           case "SuruDark":
               theme.palette.highlighted.background
               break
           default:
               "#2D371300"
           }
}
