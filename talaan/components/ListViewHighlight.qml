import QtQuick 2.4
import Ubuntu.Components 1.3

Rectangle {
    id: highlightRec
    color: switch (settings.currentTheme) {
           case "Default":
               "#2D371300"
               break
           case "Ambiance":
               theme.palette.highlighted.background
               break
           case "SuruDark":
               theme.palette.highlighted.background
               break
           default:
               "#2D371300"
           }
}
