import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2

Label {
    id: customlabel
    
    property string role

    color: {
        if (mainView.settings.coloredText) {
            switch (role) {
                case "category":
                    return Suru.activeFocusColor
                case "value":
                    return Suru.highlightColor
                case "date":
                    return Suru.secondaryForegroundColor
                default:
                    return Suru.foregroundColor
            }
        } else {
            return Suru.foregroundColor
        }
    }

    Suru.highlightType: {
        if (mainView.settings.coloredText) {
            switch (role) {
                case "category":
                    return Suru.InformationHighlight
                case "value":
                    return Suru.PositiveHighlight
                case "date":
                    return Suru.WarningHighlight
                default:
                    return Suru.InformationHighlight
            }
        } else {
            Suru.InformationHighlight
        }
    }
}
