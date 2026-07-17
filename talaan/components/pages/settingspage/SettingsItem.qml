import QtQuick 2.12

QtObject {
    id: settingsItem

    enum ItemType {
        Header
        , CheckBox
        , Switch
        , ComboBox
        , Action
        , SpinBox
        , Slider
        , GroupedRadio
        , PopupPage
    }

    property bool enabled: true
    property bool visible: true
    property string mainGroup
    property string subGroup
    property string title
    property string iconName
    property string description
    property var itemComponent
    property int itemType
    property string bindProperty
    property bool invertedBind: false
    property int itemLevel: 0 // Use for grouping or indenting items
    property var itemFunction
    property real itemMaximumWidth: 0 // 0 means fill parent's width

    property var itemCustomValue // Used in items where you can set a custom value such as Grouped Radio Buttons

    // Function to use for validating if custom value are valid (i.e. Grouped Radio Buttons)
    property var itemCustomValueValidator: function(value) { return value }

    // Function to use before saving custom value to settings (i.e. Grouped Radio Buttons)
    property var itemCustomValueToSettings: function(value) { return value }

    // Used in items that needs a model such as a ComboxBox
    property var itemModel
    property var itemModelTextRole: "text" //ComboBox
    property var itemModelValueRole: "value" //ComboBox

    property var itemResetValue // Used in items with reset function like SpinBox
    property real itemFromValue // Used in items with from property like SpinBox
    property real itemToValue // Used in items with to property like SpinBox
    property real itemStepSizeValue // Used in items with stepsize property like SpinBox
    property var itemTextFromValue // Function used in items with textFromValue property like SpinBox

    property bool itemDisplayCurrentValue: true // Used in items where current value can be displayed or not like Slider
    property bool itemDisplayCurrentValueOnControl: true // Used in items where current value can be displayed or not on the control like on a slider's handle
    property bool itemRoundDisplayedValue: true // Used in items where the displayed value can be rounded
    property int itemRoundingDecimal: 0 // Used in items where the displayed value can be rounded
    property bool itemLiveValue: true // Used in items where value can take effect live or after a specific action like in a Slider
    property bool itemDisplayInPercentage: false // Used in items where value can be displayed in percentage like Slider
    property bool itemValueIsInPercentage: false // Used in items where value can be displayed in percentage and the value is already in percentage like Slider
    property bool itemEnableFineControls: false // Used in items that supports enabling fine controls such as Slider
    property string itemUnit: "" // Used in items where a unit can be displayed along with the value such as Slider

    // Function used in items that need special processing for intializing the control's value from the stored settings value
    property var itemSettingsToControl: function(value) { return value }

    // Function used in items that need special processing when storing the settings value
    property var itemControlToSettings: function(value) { return value }
}
