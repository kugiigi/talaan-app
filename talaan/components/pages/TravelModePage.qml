import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.12
import Lomiri.Components 1.3 as UT
import "../../common" as Common
import "../../common/listitems" as ListItems
import "../../common/pages" as Pages
import "../../common/dialogs" as Dialogs
import "travelmodepage"

Pages.BasePage {
    id: travelModePage

    property var settingsObject: mainView.settings

    title: i18n.tr("Travel Mode")

    Common.BaseFlickable {
        anchors.fill: parent
        pageHeader: travelModePage.pageManager.pageHeader
        contentHeight: layout.height
        
        ColumnLayout {
            id: layout

            anchors {
                left: parent.left
                right: parent.right
                margins: Suru.units.gu(1)
            }

            ListItems.BaseSwitchDelegate {
                id: switchDelegate

                Layout.fillWidth: true

                text: i18n.tr("Enable")
                switchPosition: ListItems.BaseSwitchDelegate.Position.Left
                onCheckedChanged: travelModePage.settingsObject.travelMode = checked

                Binding {
                    target: switchDelegate
                    property: "checked"
                    value: travelModePage.settingsObject.travelMode
                }

                indicator: Common.HelpButton {
                    text: i18n.tr("Travel mode can be used when you are out of your home country and you spend with a different currency. Your expenses will be saved with the travel currency including the converted value to your home currency.")

                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                        margins: Suru.units.gu(1)
                        right: parent.right
                    }
                }
            }

            ListItems.BaseComboBoxDelegate {
                id: comboboxDelegate

                Layout.fillWidth: true

                visible: travelModePage.settingsObject.travelMode
                text: i18n.tr("Travel Currency")
                model: mainView.mainModels.currenciesModel
                helpText: i18n.tr("Currency that will be used for storing and displaying your expenses when travel mode is enabled")
                controlMaximumWidth: Suru.units.gu(60)
                valueRole: "currency_code"
                textRole: "descr"
                currentIndex: findIndexOfValue(travelModePage.settingsObject.travelCurrency)

                onActivated: {
                    let _newValue
                    if (Array.isArray(model)) {
                        _newValue = model[index][valueRole]
                    } else {
                        _newValue = model.get(index)[valueRole]
                    }

                    travelModePage.settingsObject.travelCurrency = _newValue

                    if (travelModePage.settingsObject.fetchExchangeRate) {
                        rateField.updateRate(false)
                    }
                }
            }

            RateField {
                id: rateField

                Layout.fillWidth: true
                visible: travelModePage.settingsObject.travelMode
                settingsObject: travelModePage.settingsObject
                model: mainModels.exchangeRatesModel

                onDataFetched: {
                    if (!status) {
                        let _popup = fetchFailedDialog.createObject(travelModePage)
                    }
                }
            }
        }
    }


    Component {
        id: fetchFailedDialog

        Dialogs.DialogWithContents {
            id: dialog

            title: i18n.tr("Cannot fetch exchange rate data")

            Label {
                Layout.fillWidth: true
                Suru.textLevel: Suru.Paragraph
                text: i18n.tr("Please check if you have a working internet connection")
                wrapMode: Text.WordWrap
            }

            UT.Button {
                Layout.fillWidth: true

                text: i18n.tr("OK")
                onClicked: dialog.close()
            }
        }
    }
}
