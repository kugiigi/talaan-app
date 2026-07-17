import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Suru 2.2
import "../../../common/listitems" as ListItems

ListItems.BaseItemDelegate {
    id: travelDataFields

    property bool isEditMode
    property string homeCurrency
    property string travelCurrency
    property real rate

    focusPolicy: Qt.NoFocus

    contentItem: Item {
        implicitHeight: layout.height
        implicitWidth: layout.width

        ColumnLayout {
            id: layout

            anchors.centerIn: parent
            spacing: 0

            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter

                Suru.textLevel: Suru.Paragraph
                text: travelDataFields.isEditMode ? i18n.tr("Exchange Rate") : i18n.tr("Travel Mode")
                wrapMode: Text.WordWrap
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                readonly property color secondaryFontColor: Suru.tertiaryForegroundColor

                Suru.textLevel: Suru.HeadingThree
                text: i18n.tr('%1 <font color=\"%2\">%3</font> = 1 <font color=\"%4\">%5</font>').arg(travelDataFields.rate)
                                .arg(secondaryFontColor).arg(travelDataFields.homeCurrency).arg(secondaryFontColor)
                                .arg(travelDataFields.travelCurrency)
                color: Suru.foregroundColor
            }
        }
    }
}
