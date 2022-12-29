import QtQuick 2.4
import Lomiri.Components 1.3
//import QtQuick.Layouts 1.1
import Lomiri.Components.Themes.Ambiance 1.3
import "../components"
import "../library"
//import Lomiri.Components.Popups 1.3
import Lomiri.Layouts 1.0
import "../library/DataProcess.js" as DataProcess
import "../library/ProcessFunc.js" as Process

Page {

    property alias splitView: splitView
    property string pagemode
    property bool isReadyForSplit: (layouts.height > units.gu(80)
                                    && mainView.height > units.gu(
                                        80)) ? true : false
    property alias navigationFlickable: navigationContent.children

    id: root

    header: {
        if (primaryLeftPage.isMultiColumn) {
            switch (mainLayout.selectedTabIndex) {
            case 0:
                defaultTab.searchHeader
                break
            case 1:
                savedTab.searchHeader
                break
            case 2:
                historyTab.searchHeader
                break
            case 3:
                defaultTab.searchHeader
                break
            }
        }else{
            null
        }
    }

    //defaultTab.searchHeader
    onActiveChanged: {

    }

    //    PageHeader{
    //        id: dummyHeader
    //        //title: "Sample"
    //        StyleHints {
    //            backgroundColor: "#3D1400"
    //            dividerColor: LomiriColors.slate
    //        }
    //        extension: Sections{

    //        }
    //    }
    LiveTimer {
        id: liveTimer
        frequency: LiveTimer.Hour //Relative
        onTrigger: {
            //Update Reminders and Targets to detect
            mainView.listItems.modelTargets.updateOverdueStatus()
        }
    }

    BottomEdge {
        id: bottomEdgePage
        preloadContent: true
        enabled: layouts.currentLayout === "full" ? true : false

        hint {
            visible: bottomEdgePage.enabled
            status: "Active"
            enabled: visible
            action: Action {
                iconName: "event"
                text: i18n.tr("Upcoming")
                shortcut: "Ctrl+U"
                enabled: bottomEdgePage.enabled
                onTriggered: bottomEdgePage.commit()
            }
        }

        height: root.height

        onCollapseCompleted: {
            hint.status = "Active"
        }

        onContentItemChanged: contentItem.noBackground = false

        contentComponent: targetLoader.sourceComponent
    }

    Layouts {
        id: layouts
        anchors.fill: parent
        onCurrentLayoutChanged: {
            //console.log(currentLayout + " - " + layouts.height + " - " + units.gu(80))
            bottomEdgePage.collapse()
        }

        layouts: [
            ConditionalLayout {
                name: "full"
                when: (layouts.height <= units.gu(80)
                       && mainView.height <= units.gu(80))
                      || !settings.panelSplit //mainView.height as a workaround on issues with AdaptivePageLayout and ConditionalLayout


                Item {
                    anchors.fill: parent

                    ItemLayout {
                        item: "topItem"
                        anchors {
                            left: parent.left
                            right: parent.right
                            top: parent.top
                            bottom: parent.bottom
                            topMargin: root.header !== null ? root.header.height : 0
                            bottomMargin: bottomEdgePage.hint.height
                        }
                    }
                }
            }
        ]

        Item {
            id: targetPageItem
            anchors.fill: parent
            ActivityIndicator {
                id: activity
                anchors.centerIn: parent
                running: targetLoader.status !== Loader.Ready
            }
            Loader {
                id: targetLoader
                anchors.fill: parent
                sourceComponent: targetComponent
                asynchronous: true
                visible: status == Loader.Ready
            }
        }

        CustomSplitView {
            id: splitView
            minimumItemHeight: units.gu(30)
            anchors.fill: parent
            bottomItem: targetPageItem

            topItem: navigationContent
        }

        /*Workaround for the bug where the page is gone when switching to split*/
        Connections {
            target: settingsTab
            onPanelSplitChanged: {
                targetLoader.active = false
                targetLoader.active = true
            }
        }

        Item {
            id: navigationContent
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                topMargin: root.header === null ? 0 : root.header.height
            }
            Layouts.item: "topItem"

            Item {
                id: itemFlickable
                anchors.fill: parent
            }
        }

        Component {
            id: targetComponent
            TargetsPage {
                id: targetsPage
                noBackground: true
                height: layouts.currentLayout === '' ? undefined : root.height
            }
        }
    }
}
