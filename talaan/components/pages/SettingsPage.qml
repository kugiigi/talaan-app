import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "settingspage"
import "../../common" as Common
import "../../common/pages" as Pages
import "../../common/listitems" as ListItems
import "../../library/functions.js" as Functions

Pages.BasePage {
    id: settingsPage

    property var settingsObject: mainView.settings

    title: i18n.tr("Settings")

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: Suru.units.gu(1)

            Common.BaseListView {
                anchors.fill: parent
                pageHeader: settingsPage.pageManager.pageHeader
                model: settingsItemsModel
                section {
                    property: "mainGroup"
                    delegate: RowLayout {
                        Label {
                            Layout.fillWidth: true
                            Layout.margins: Suru.units.gu(1)

                            text: section
                            wrapMode: Text.WordWrap
                            Suru.textLevel: Suru.HeadingThree
                        }
                    }
                }

                delegate: Loader {
                    id: itemLoader

                    readonly property real leftIndentionMargin: model.itemLevel * units.gu(2)

                    property var modelData: model

                    anchors {
                        left: parent.left
                        leftMargin: leftIndentionMargin + Suru.units.gu(1)
                        right: parent.right
                        rightMargin: Suru.units.gu(1)
                    }

                    visible: model.visible
                    asynchronous: false
                    sourceComponent: model && model.itemComponent ? model.itemComponent
                                        : settingsItemFactory.getComponent(model.itemType)
                }
            }
        }
    }

    Loader {
        id: bottomGesturesAreaPreview

        readonly property real visibleOpacity: 0.8

        active: opacity > 0
        asynchronous: true
        height: Suru.units.gu(settingsPage.settingsObject.bottomGesturesAreaHeight)
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        opacity: 0
        visible: opacity > 0
        Behavior on opacity {
            NumberAnimation {
                easing: Suru.animations.EasingIn
                duration: Suru.animations.BriskDuration
            }
        }
        sourceComponent: Rectangle {
            color: Suru.activeFocusColor
        }

        function show() {
            opacity = visibleOpacity
            delayHide.restart()
        }

        function hide() {
            opacity = 0
        }

        Timer {
            id: delayHide
            running: false
            interval: 1000
            onTriggered: bottomGesturesAreaPreview.hide()
        }

        Connections {
            target: settingsPage.settingsObject
            onBottomGesturesAreaHeightChanged: {
                bottomGesturesAreaPreview.height = Qt.binding( function() {return units.gu(settingsPage.settingsObject.bottomGesturesAreaHeight) })
                bottomGesturesAreaPreview.show()
            }
        }
    }

    SettingsItemFactory {
        id: settingsItemFactory

        settingsObject: settingsPage.settingsObject
    }

    property list<SettingsItem> settingsItemsModel: [
        SettingsItem {
            mainGroup: i18n.tr("Appearance and Layout")
            subGroup: "appearance"
            title: i18n.tr("Theme")
            description: i18n.tr("Sets the theme of the application")
            itemType: SettingsItem.ItemType.ComboBox
            bindProperty: "currentTheme"
            itemModel: [
                { value: "System", text: i18n.tr("System") }
                , { value: "Ambiance", text: i18n.tr("Light") }
                , { value: "SuruDark", text: i18n.tr("Dark") }
            ]
            itemMaximumWidth: Suru.units.gu(60)
        }
        , SettingsItem {
            mainGroup: i18n.tr("Appearance and Layout")
            subGroup: "appearance"
            title: i18n.tr("Display color coded texts")
            description: i18n.tr("Important texts such as categories and expense values are displayed with colors")
            itemType: SettingsItem.ItemType.CheckBox
            bindProperty: "coloredText"
        }
        , SettingsItem {
            mainGroup: i18n.tr("Appearance and Layout")
            subGroup: "appearance"
            title: i18n.tr("Larger list item font size")
            description: i18n.tr("Displays the list items with a larger font size")
            itemType: SettingsItem.ItemType.CheckBox
            bindProperty: "listItemFontSize"
        }
        , SettingsItem {
            mainGroup: i18n.tr("Currency")
            subGroup: "currency"
            title: i18n.tr("Home Currency")
            description: i18n.tr("The home currency that is used to process, format and display expenses")
            itemType: SettingsItem.ItemType.ComboBox
            bindProperty: "currentCurrency"
            itemModelTextRole: "descr"
            itemModelValueRole: "currency_code"
            itemModel: mainView.mainModels.currenciesModel
            itemMaximumWidth: Suru.units.gu(60)
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "options"
            title: i18n.tr("Haptic feedback")
            description: i18n.tr("Play haptic feedback when using gestures to perform actions.")
            itemType: SettingsItem.ItemType.Switch
            bindProperty: "enableHaptics"
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "options"
            title: i18n.tr("Bottom gesture area height")
            description: i18n.tr("The height of the gesture area at the bottom of the app that detects vertical or horizontal swipes")
            itemType: SettingsItem.ItemType.Slider
            bindProperty: "bottomGesturesAreaHeight"
            itemMaximumWidth: settingsPage.wide ? units.gu(60) : 0

            // Slider properties
            itemResetValue: 2
            itemFromValue: 1
            itemToValue: 6
            itemStepSizeValue: 0.25
            itemLiveValue: true
            itemDisplayCurrentValue: false
            itemDisplayCurrentValueOnControl: false
            itemRoundDisplayedValue: true
            itemRoundingDecimal: 2
            itemEnableFineControls: true
            itemSettingsToControl: function(value) {
                return value;
            }
            itemControlToSettings: function(value) {
                return parseFloat(value.toFixed(2))
            }
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "apppages"
            title: i18n.tr("Bottom Gesture hint")
            description: i18n.tr("Displays a visual hint for the Horizontal swipe gesture")
            + "\n"
            + Functions.bulletTextArray(
            [
                i18n.tr("The hint indicates the space where you can swipe horizontally to trigger page header actions")
                ,i18n.tr("When Bottom side gesture is enabled, the empty space on the left and right side indicate where you can swipe up to access its functions")
            ])
            itemType: SettingsItem.ItemType.Switch
            bindProperty: "hideBottomHint"
            invertedBind: true
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "apppages"
            title: i18n.tr("Header pull down")
            description: i18n.tr("Dragging the page contents down will expand the header's height to near half of the page")
                + " "
                + i18n.tr("This helps ease reaching top elements in the page.")
                + "\n"
                + Functions.bulletTextArray(
                    [
                        i18n.tr("Swipe down and release: Expands the header's height to near half of the app")
                        ,i18n.tr("Swipe up and release: Resets back the header to its normal state")
                    ])
            itemType: SettingsItem.ItemType.Switch
            bindProperty: "headerPullDown"
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "apppages"
            title: i18n.tr("Horizontal swipe gesture")
            description: i18n.tr("Enables a gesture area around the middle part of the bottom edge")
            + "\n"
            + Functions.bulletTextArray(
            [
                i18n.tr("Swipe to either direction to open a bottom menu with the corresponding actions from the page header")
                ,i18n.tr("When there's only one action is available, it will be triggered immediately upon performing the swipe")
            ])
            itemType: SettingsItem.ItemType.Switch
            bindProperty: "horizontalSwipe"
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "apppages"
            title: i18n.tr("Direct actions")
            itemLevel: 1
            enabled: settingsPage.settingsObject.horizontalSwipe
            description: i18n.tr("Directly select an action instead of opening a menu when there are multiple available actions.")
            + "\n"
            + Functions.bulletTextArray(
            [
                i18n.tr("Swipe to either direction to show actions that corresponds to the page header actions")
                ,i18n.tr("An action can be triggered by releasing the touch while it is selected.")
            ])
            itemType: SettingsItem.ItemType.Switch
            bindProperty: "horizontalDirectActions"
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "apppages"
            title: i18n.tr("Selection sensitivity")
            itemLevel: 2
            enabled: settingsPage.settingsObject.horizontalSwipe && settingsPage.settingsObject.horizontalDirectActions
            description: i18n.tr("Determines how sensitive when swiping horizontally to select from the available actions.")
            itemType: SettingsItem.ItemType.Slider
            bindProperty: "horizontalDirectActionsSensitivity"
            itemMaximumWidth: Suru.units.gu(60)

            // Slider properties
            itemResetValue: 0.5
            itemFromValue: 0.2
            itemToValue: 1
            itemStepSizeValue: 0.1
            itemLiveValue: true
            itemDisplayCurrentValue: false
            itemDisplayCurrentValueOnControl: false
            itemRoundDisplayedValue: true
            itemRoundingDecimal: 2
            itemEnableFineControls: true
            itemSettingsToControl: function(value) {
                return value;
            }
            itemControlToSettings: function(value) {
                return parseFloat(value.toFixed(2))
            }
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "apppages"
            title: i18n.tr("Bottom side gesture")
            description: i18n.tr("Enables gesture areas at the leftmost and rightmost parts of the bottom edge")
            + "\n"
            + Functions.bulletTextArray(
            [
                i18n.tr("A swipe will open a menu with all the actions from the corresponding side of the page header")
                ,i18n.tr("When there's only one action is available, it will be triggered immediately upon performing the swipe")
                ,i18n.tr("When Direct actions is enabled, Quick swipe has to be enabled to retain the original function")
            ])
            itemType: SettingsItem.ItemType.Switch
            bindProperty: "sideSwipe"
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "apppages"
            title: i18n.tr("Direct actions")
            itemLevel: 1
            enabled: settingsPage.settingsObject.sideSwipe
            description: i18n.tr("Enables a vertical menu for quickly performing actions that are present in the page header.")
            + " "
            + i18n.tr("The list of actions correspond to the same actions present in the page header.")
            + "\n"
            + Functions.bulletTextArray(
            [
                i18n.tr("Swiping up from the left/right side without lifting your finger will reveal a menu of list of actions")
                ,i18n.tr("Lifting your swipe will perform the currently selected action")
                ,i18n.tr("You can cancel the gesture without triggering an action by swiping down to the bottom again and release from there")
            ])
            itemType: SettingsItem.ItemType.Switch
            bindProperty: "directActions"
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "apppages"
            title: i18n.tr("Max height")
            itemLevel: 2
            enabled: settingsPage.settingsObject.sideSwipe && settingsPage.settingsObject.directActions
            description: i18n.tr("Maximum height of the Direct actions menu when there's enough available height")
            itemType: SettingsItem.ItemType.Slider
            bindProperty: "quickActionsHeight"
            itemMaximumWidth: Suru.units.gu(60)

            // Slider properties
            itemResetValue: 3
            itemFromValue: 1
            itemToValue: 5
            itemStepSizeValue: 0.25
            itemLiveValue: false
            itemDisplayCurrentValue: true
            itemDisplayCurrentValueOnControl: true
            itemRoundDisplayedValue: true
            itemRoundingDecimal: 2
            itemEnableFineControls: true
            itemUnit: i18n.tr("inch")
            itemSettingsToControl: function(value) {
                return value;
            }
            itemControlToSettings: function(value) {
                return parseFloat(value.toFixed(2))
            }
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "apppages"
            title: i18n.tr("Quick swipe")
            itemLevel: 2
            enabled: settingsPage.settingsObject.sideSwipe && settingsPage.settingsObject.directActions
            description: Functions.bulletTextArray(
            [
                i18n.tr("Enable this to retain the original function of the bottom side gesture by doing a quick swipe")
                ,i18n.tr("A quick swipe means swiping up with enough distance and lifting the finger immediately before triggering the Quick actions menu")
            ])
            itemType: SettingsItem.ItemType.Switch
            bindProperty: "quickSideSwipe"
        }
        , SettingsItem {
            mainGroup: i18n.tr("Gestures")
            subGroup: "apppages"
            title: i18n.tr("Direct actions delay")
            itemLevel: 2
            enabled: settingsPage.settingsObject.sideSwipe && settingsPage.settingsObject.directActions
                                && !settingsPage.settingsObject.quickSideSwipe
            description: Functions.bulletTextArray(
            [
                i18n.tr("Enables a delay before the Direct action menu will appear when swiping")
                ,i18n.tr("Disabled state only takes effect when Quick swipe is disabled")
            ])
            itemType: SettingsItem.ItemType.Switch
            bindProperty: "quickActionEnableDelay"
        }
    ]
}
