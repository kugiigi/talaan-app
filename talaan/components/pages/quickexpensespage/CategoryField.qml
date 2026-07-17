import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import "../../../common" as Common
import "../.." as Components

ColumnLayout {
    id: root

    property Common.BaseFlickable flickable
    property string category: categoryField.model.get(categoryField.currentIndex).category_name

    spacing: Suru.units.gu(1)

    function setCategory(name) {
        categoryField.currentIndex = categoryField.model.find(name, "category_name")
    }

    Label {
        id: nameLabel

        Layout.fillWidth: true
        Suru.textLevel: Suru.HeadingThree
        text: i18n.tr("Category")
        color: Suru.foregroundColor
    }

    ComboBox {
        id: categoryField

        Layout.fillWidth: true
        model: mainView.mainModels.categoriesModel
        textRole: "category_name"
        focus: false

        onAccepted: focusScrollConnections.focusNext()

        Components.FocusScrollConnections {
            id: focusScrollConnections

            target: categoryField
            flickable: root.flickable
        }
    }
}
