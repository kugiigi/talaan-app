import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Suru 2.2
import Lomiri.Components 1.3 as UT
import QtQuick.Layouts 1.12
import "../../../common" as Common
import "../../../common/listitems" as ListItems
import "../../../library/ApplicationFunctions.js" as AppFunctions
import "../.." as Components

Item {
    id: gridDelegate

    readonly property bool isGridDisplay: GridView.view.gridType == ListGridView.GridType.Rectangle
    readonly property int delegateType: {
        switch (true) {
            case type == "checklist" && completionDate == "":
                return ListGridView.Type.Checklist
            case type == "checklist" && completionDate !== "":
                return ListGridView.Type.History
            case type == "list" && completionDate == "":
                return ListGridView.Type.List
            case type == "list" && completionDate !== "":
                return ListGridView.Type.Archived
            case type == "endless":
                return ListGridView.Type.Endless
            default:
                return ListGridView.Type.Checklist
        }
    }
    property alias highlighted: itemDelegate.highlighted
    property int listId: -1
    property string title
    property string description
    property string type
    property string categoryName
    property string creationDate
    property string modifiedDate
    property string completionDate
    property string targetDate
    property int status: 0
    property bool isFavorite
    property int itemCount: 0
    property int checkedCount: 0

    signal clicked
    signal rightClicked(real mouseX, real mouseY)
    signal doubleClicked
    signal pressAndHold(real mouseX, real mouseY)
    signal pressed
    signal released

    width: GridView.view.cellWidth
    height: GridView.view.cellHeight

    ListItems.BaseItemDelegate {
        id: itemDelegate

        topPadding: 0
        bottomPadding: 0
//~         enableDropShadow: true
        enableChealDropShadow: true
        anchors {
            fill: parent
            margins: gridDelegate.isGridDisplay ? Suru.units.gu(1) : Suru.units.gu(0.8)
        }

        onClicked: gridDelegate.clicked()
        onRightClicked: gridDelegate.rightClicked(mouseX, mouseY)
        onDoubleClicked: gridDelegate.doubleClicked()
        onPressAndHold: {
            Common.Haptics.play()
            gridDelegate.pressAndHold(itemDelegate.pressX, itemDelegate.pressY)
        }
        onPressed: gridDelegate.pressed()
        onReleased: gridDelegate.released()

        tooltipText: gridDelegate.description

        indicator: Item {
            anchors {
                right: parent.right
                verticalCenter: parent.top
                verticalCenterOffset: gridDelegate.isGridDisplay ? 0 : height * 0.2
            }
            width: indicatorLayout.width
            height: indicatorLayout.height

            RowLayout {
                id: indicatorLayout

                Components.CategoryRectangle {
                    id: categoryRec

                    categoryName: gridDelegate.categoryName
                    visible: categoryName
                }

                Rectangle {
                    visible: gridDelegate.isFavorite
                    radius: height / 4
                    color: Suru.tertiaryForegroundColor
                    width: Suru.units.gu(2.5)
                    height: width

                    UT.Icon {
                        anchors.centerIn: parent
                        width: Suru.units.gu(1.5)
                        height: width
                        color: Suru.backgroundColor
                        name: "favorite-selected"
                    }
                }

                Rectangle {
                    radius: height / 4
                    color: Suru.tertiaryForegroundColor
                    width: Suru.units.gu(2.5)
                    height: width

                    UT.Icon {
                        anchors.centerIn: parent
                        width: Suru.units.gu(2)
                        height: width
                        color: Suru.backgroundColor
                        name: {
                            switch (gridDelegate.delegateType) {
                                case ListGridView.Type.List:
                                    return "note"
                                case ListGridView.Type.Checklist:
                                case ListGridView.Type.Endless:
                                    return "tick"
                                case ListGridView.Type.History:
                                    return "history"
                                case ListGridView.Type.Archived:
                                    return "application-x-archive-symbolic"
                                default:
                                    return "tick"
                            }
                        }
                    }
                }
            }
        }

        contentItem: Item {
            id: layout

            implicitHeight: layout.height
            implicitWidth: layout.width

            ColumnLayout {
                id: contentItemColumnLayout

                spacing: Suru.units.gu(0.5)
                anchors {
                    left: parent.left
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }

                RowLayout {
                    id: rowLayout

                    Layout.alignment: Qt.AlignCenter

                    ColumnLayout {
                        id: nameDescrColumnLayout

                        spacing: 0

                        Components.ColoredLabel {
                            id: mainLabel

                            Layout.fillWidth: true
                            Layout.maximumHeight: font.pixelSize * maximumLineCount

                            visible: text !== ""
                            Suru.textLevel: Suru.HeadingThree
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: gridDelegate.title
                            wrapMode: Text.WordWrap
                            maximumLineCount: 2
                            minimumPixelSize: Suru.units.gu(2)
                            fontSizeMode: Text.HorizontalFit
                            elide: Text.ElideRight
                        }
                    }
                }

                Components.ColoredLabel {
                    id: descrLabel

                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignCenter

                    Suru.textLevel: Suru.Caption
                    color: Suru.secondaryForegroundColor
                    horizontalAlignment: gridDelegate.isGridDisplay ? Text.AlignHCenter : Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    visible: gridDelegate.description !== ""
                    text: gridDelegate.description
                    maximumLineCount: 1
                    elide: Text.ElideRight
                }

                Components.ColoredLabel {
                    id: itemCountLabel

                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignCenter

                    Suru.textLevel: gridDelegate.isGridDisplay ? Suru.Paragraph : Suru.HeadingThree
                    verticalAlignment: Text.AlignVCenter
                    text: gridDelegate.delegateType == ListGridView.Type.List
                                || gridDelegate.delegateType == ListGridView.Type.Archived ? gridDelegate.itemCount
                                        : i18n.tr("%1 / %2").arg(gridDelegate.checkedCount).arg(gridDelegate.itemCount)
                    role: "value"
                }

                states: [
                    State {
                        name: "grid"
                        when: gridDelegate.isGridDisplay
                        ParentChange {
                            target: descrLabel
                            parent: contentItemColumnLayout
                        }
                        ParentChange {
                            target: itemCountLabel
                            parent: contentItemColumnLayout
                        }
                        PropertyChanges {
                            target: mainLabel
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    , State {
                        name: "list"
                        when: !gridDelegate.isGridDisplay
                        ParentChange {
                            target: descrLabel
                            parent: nameDescrColumnLayout
                        }
                        ParentChange {
                            target: itemCountLabel
                            parent: rowLayout
                        }
                        PropertyChanges {
                            target: mainLabel
                            horizontalAlignment: Text.AlignLeft
                        }
                    }
                ]
            }
        }
    }
}
