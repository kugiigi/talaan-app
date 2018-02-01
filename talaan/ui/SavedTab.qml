import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes.Ambiance 1.3
import Ubuntu.Components.Popups 1.3
import Qt.labs.settings 1.0
import "../components"

ListPage {
    id: root

    pagemode: "saved"
    favorite: false
    filter: "all"
    groupings: "name"
    order: "normal"
    searchFilter: "all"
    searchGroupings: "name"
    searchOrder: "normal"
    searchCondition: "="
    searchType: "default"
    searchText: ""

    searchingText: i18n.tr("Searching Saved Lists")
    pageTitle: i18n.tr("Saved")
    searchPlaceHolderText: i18n.tr("Search Saved Lists")
    emptyTitle: i18n.tr("No Saved Checklists")
    emptySubTitle: root.intCurSectionIndex
                   === 1 ? i18n.tr(
                               "Favorite a list by using the 'starred' action") : i18n.tr(
                               "Save a list from the Lists Tab")
    emptyIconName: "bookmark"
    loadingTitle: i18n.tr("Loading Saved Lists")
    actions: [addRadialAction, mainView.bottomMenuActions[4], mainView.bottomMenuActions[1], mainView.bottomMenuActions[0], mainView.bottomMenuActions[3], mainView.bottomMenuActions[5]]
    searchActionIndex: 3

    Settings {
        property alias savedTabGroup: root.groupings
        property alias savedTabGroupOrder: root.order
        property alias currentSavedSection: root.sectionSelectedIndex
    }
}
