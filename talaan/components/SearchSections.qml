import QtQuick 2.4
import Ubuntu.Components 1.3

Sections {
    id: mainSections

    property string mode
    property string selectedSection:"default"

    anchors {
        left: parent.left
        right: parent.right
        //rightMargin: units.gu(2)
        bottom: parent.bottom
    }
    state: mode
    states: [
        State {
            name: "talaan"
            PropertyChanges {
                target: mainSections
                model: [i18n.tr("Name / Description"), i18n.tr(
                        "Category"), i18n.tr("Creation Date"), i18n.tr(
                        "Target Date")]
                onSelectedIndexChanged: {
                    switch (selectedIndex) {
                    case 0:
                        selectedSection = "default"
                        break
                    case 1:
                        selectedSection = "category"
                        break
                    case 2:
                        selectedSection = "creation_date"
                        break
                    case 3:
                        selectedSection = "target_date"
                        break
                    default:
                        selectedSection = "default"
                        break
                    }
                }
            }
        },
        State {
            name: "saved"
            PropertyChanges {
                target: mainSections
                model: [i18n.tr("Name / Description"), i18n.tr(
                        "Category"), i18n.tr("Creation Date")]
                onSelectedIndexChanged: {
                    switch (selectedIndex) {
                    case 0:
                        selectedSection = "default"
                        break
                    case 1:
                        selectedSection = "category"
                        break
                    case 2:
                        selectedSection = "creation_date"
                        break
                    default:
                        selectedSection = "default"
                        break
                    }
                }
            }
        },
        State {
            name: "history"
            PropertyChanges {
                target: mainSections
                model: [i18n.tr("Name / Description"), i18n.tr(
                        "Category"), i18n.tr("Creation Date"), i18n.tr(
                        "Completion Date"), i18n.tr("Target Date")]
                onSelectedIndexChanged: {
                    switch (selectedIndex) {
                    case 0:
                        selectedSection = "default"
                        break
                    case 1:
                        selectedSection = "category"
                        break
                    case 2:
                        selectedSection = "creation_date"
                        break
                    case 3:
                        selectedSection = "completion_date"
                        break
                    case 4:
                        selectedSection = "target_date"
                        break
                    default:
                        selectedSection = "default"
                        break
                    }
                }
            }
        }
    ]
}
