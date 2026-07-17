import QtQuick 2.12
import Qt.labs.settings 1.0
import "../library/Currencies.js" as Currencies
import "../common" as Common

Item {
    id: tempSettings

    property alias listItemClickable: settingsItem.listItemClickable
    property alias listItemFontSize: settingsItem.listItemFontSize
    property alias listItemHideChecked: settingsItem.listItemHideChecked
//~     property alias panelSplit: settingsItem.panelSplit
    property alias categoryColors: settingsItem.categoryColors
//~     property alias radialBottomMenu: settingsItem.radialBottomMenu
//~     property alias bottomMenuHint: settingsItem.bottomMenuHint
//~     property alias bottomMenuType: settingsItem.bottomMenuType
//~     property alias bottomMenuAnchor: settingsItem.bottomMenuAnchor
    property alias currentTheme: settingsItem.currentTheme
    property alias hideBottomHint: settingsItem.hideBottomHint
    property alias enableHaptics: settingsItem.enableHaptics
    property alias coloredText: settingsItem.coloredText
    property alias intSort: settingsItem.intSort
    property alias displayPriorityFirst: settingsItem.displayPriorityFirst

    // Gestures
    property alias horizontalSwipe: settingsItem.horizontalSwipe
    property alias horizontalDirectActions: settingsItem.horizontalDirectActions
    property alias horizontalDirectActionsSensitivity: settingsItem.horizontalDirectActionsSensitivity
    property alias sideSwipe: settingsItem.sideSwipe
    property alias directActions: settingsItem.directActions
    property alias quickActionsHeight: settingsItem.quickActionsHeight
    property alias quickSideSwipe: settingsItem.quickSideSwipe
    property alias quickActionEnableDelay: settingsItem.quickActionEnableDelay
    property alias headerPullDown: settingsItem.headerPullDown
    property alias bottomGesturesAreaHeight: settingsItem.bottomGesturesAreaHeight

    Component.onCompleted: Common.Haptics.enabled = Qt.binding( function() { return enableHaptics } )

    Settings {
        id: settingsItem

        property bool listItemClickable: true
        property bool listItemFontSize: false
        property bool listItemHideChecked: false
//~         property bool panelSplit: true
        property bool categoryColors: false
//~         property string radialBottomMenu: "Always"
//~         property string bottomMenuHint: "Always"
//~         property string bottomMenuType: "Radial"
//~         property string bottomMenuAnchor: "Right"
        property string currentTheme: "System"
        property bool hideBottomHint: false
        property bool enableHaptics: true

        property bool horizontalSwipe: true
        property bool sideSwipe: false
        property bool directActions: false
        property real quickActionsHeight: 3
        property bool quickSideSwipe: false
        property bool quickActionEnableDelay: false
        property bool headerPullDown: true
        property real bottomGesturesAreaHeight: 2
        property bool horizontalDirectActions: false
        property real horizontalDirectActionsSensitivity: 0.5
        property bool coloredText: true
        property int intSort: 0
        property bool displayPriorityFirst: false
    }
}
