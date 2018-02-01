import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Themes.Ambiance 1.3
import Ubuntu.Components.Popups 1.3
import Qt.labs.settings 1.0
import "../components"

ListPage {
    id: root

    pagemode: "history"
    favorite: false
    filter: "all"
    groupings: "completion_date"
    order: "normal"
    searchFilter: "all"
    searchGroupings: "completion_date"
    searchOrder: "normal"
    searchCondition: "="
    searchType: "default"
    searchText: ""

    searchingText: i18n.tr("Searching History")
    pageTitle: i18n.tr("History")
    searchPlaceHolderText: i18n.tr("Search History")
    emptyTitle: i18n.tr("History is empty")
    emptySubTitle: root.intCurSectionIndex
                   === 1 ? i18n.tr(
                               "Completed checklists from your Favorites are listed here") : i18n.tr(
                               "Completed checklists are listed here")
    emptyIconName: "history"
    loadingTitle: i18n.tr("Loading History")
    actions: [mainView.bottomMenuActions[4], mainView.bottomMenuActions[4], mainView.bottomMenuActions[2], mainView.bottomMenuActions[0], mainView.bottomMenuActions[3], mainView.bottomMenuActions[5]]
    searchActionIndex: 3

    Settings {
        property alias historyTabGroup: root.groupings
        property alias historyTabGroupOrder: root.order
        property alias currentHistorySection: root.sectionSelectedIndex
    }
}
