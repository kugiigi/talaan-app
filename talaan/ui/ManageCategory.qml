import QtQuick 2.4
import Ubuntu.Components 1.3
//import QtQuick.Layouts 1.1
import Ubuntu.Components.Themes.Ambiance 1.3
import "../components"
import "../library"
import Ubuntu.Components.Popups 1.3
import "../library/DataProcess.js" as DataProcess
import "../library/ProcessFunc.js" as Process

PageWithBottom {

    property string pagemode
    property string currentCategory
    property string currentDescription
    property color currentColor
    property string dialogResponse

    id: pageCategories

    actions: [addRadialAction,mainView.bottomMenuActions[4],mainView.bottomMenuActions[1],mainView.bottomMenuActions[0],mainView.bottomMenuActions[2],mainView.bottomMenuActions[5]]

    header: PageHeader {
        title: i18n.tr("Categories")
        //flickable: groupedList
        StyleHints {
            backgroundColor: switch(settings.currentTheme){
                             case "Default":
                                 "#3D1400"
                                 break;
                             case "Ambiance":
                                 theme.palette.normal.background
                                 break;
                             case "SuruDark":
                                 theme.palette.normal.foreground
                                 break;
                             default:
                                 "#3D1400"
                             }
            dividerColor: UbuntuColors.slate
        }
        trailingActionBar.actions: [
            Action {
                iconName: "add"
                text: i18n.tr("Add")
                //visible: mainLayout.columns === 1 ? false : true
                onTriggered: {
                    addNew()
                }
            }
        ]
    }

    RadialAction {
        id: addRadialAction
        iconName: "add"
        iconColor: "white"
        backgroundColor: UbuntuColors.green
        onTriggered: {
            addNew()
        }
    }

    BottomEdge {
        id: bottomEdgePage

        hint {
            visible: false
            enabled: false
        }

        height: parent ? parent.height : 0
        enabled: false
        visible: false

        contentComponent: Item {
            id: pageContent
            implicitWidth: bottomEdgePage.width
            implicitHeight: bottomEdgePage.height
            children: bottomEdgePage._realPage
        }

        property var _realPage: null

        function commitWithProperties(properties) {
            _realPage.destroy()
            _realPage = addCategoryComponent.createObject(null, properties)
            commit()
        }

        Component.onCompleted: {
            _realPage = addCategoryComponent.createObject(null)
        }

        Component.onDestruction: {
            _realPage.destroy()
        }

        onCollapseCompleted: {
            _realPage.active = false
            _realPage.destroy()
            _realPage = addCategoryComponent.createObject(null)
        }

        onCommitCompleted: {
            _realPage.active = true
        }

        Component {
            id: addCategoryComponent
            AddCategory {
                id: addCategoryPage
                anchors.fill: parent
                onCancel: bottomEdgePage.collapse()
                onSaved: bottomEdgePage.collapse()
            }
        }
    }

    //functions
    function addNew() {
        pageCategories.openAddCategory("add")
    }

    function loadCategories() {
        mainView.listItems.modelCategories.isListOnly = false
        mainView.listItems.modelCategories.getCategories()
        checkEmpty()
    }

    function checkEmpty() {
        if (mainView.listItems.modelCategories.count === 0) {
            emptyState.visible = true
        } else {
            emptyState.visible = false
        }
    }

    function openAddCategory(mode) {
        pageCategories.pagemode = mode
        //pageCategories.bottomEdgeState = "expanded"
        var properties = {

        }

        properties["mode"] = pageCategories.pagemode
        properties["category_name"] = pageCategories.currentCategory
        properties["description"] = pageCategories.currentDescription
        properties["categoryColor"] = pageCategories.currentColor
                === "" || mode === "add" ? "white" : pageCategories.currentColor
        bottomEdgePage.commitWithProperties(properties)
    }

    onVisibleChanged: {
        if (visible) {
            if (mainView.bottomActions !== bottomMenuActions.actions) {
                mainView.bottomActions = bottomMenuActions.actions
            }
        }
    }

    onActiveChanged: {
        //bottomEdge.edgeState = "collapsed"
        if (active === true) {
            loadCategories()
        } else {
            if (!mainLayout.multiColumn) {
                mainLayout.resetCurrentIndex()
            }
        }
    }

    EmptyState {
        id: emptyState
        iconName: "stock_note"
        title: i18n.tr("No Category Exists")
        subTitle: mainLayout.multiColumn ? i18n.tr(
                                               "Tap/Click the '+' button to add categories") : i18n.tr(
                                               "Swipe from the bottom to add categories")
        anchors {
            right: parent.right
            left: parent.left
            verticalCenter: parent.verticalCenter
            margins: units.gu(1)
        }
    }

    ScrollView {
        anchors.fill: parent
        anchors.topMargin: pageCategories.header.height
        UbuntuListView {
            id: groupedList

            property string category

            anchors.fill: parent
            interactive: true
            model: mainView.listItems.modelCategories
            clip: true
            currentIndex: -1
            highlightFollowsCurrentItem: true
            highlight: ListViewHighlight {
            }
            highlightMoveDuration: 200


            UbuntuNumberAnimation on opacity {
                running: groupedList.count > 0
                from: 0
                to: 1
                easing: UbuntuAnimation.StandardEasing
                duration: UbuntuAnimation.FastDuration
            }

            delegate: ListItem {
                id: listWithActions
                divider.colorFrom: UbuntuColors.darkGrey
                divider.colorTo: UbuntuColors.warmGrey
                highlightColor: switch(settings.currentTheme){
                                case "Default":
                                    "#2D371300"
                                    break;
                                case "Ambiance":
                                    theme.palette.highlighted.background
                                    break;
                                case "SuruDark":
                                    theme.palette.highlighted.background
                                    break;
                                default:
                                    "#2D371300"
                                }
                property int currentIndex: index
                property string itemAction: dialogResponse

                Rectangle{
                    id: categoryColorRec
                    width: units.gu(3)
                    height: width
                    transform: Rotation { origin.x: categoryColorRec.width; origin.y: categoryColorRec.height; angle: 45}
                    color: colorValue === "default" ? "white" : colorValue !== undefined ? colorValue : "white"
                    anchors{
                        verticalCenter: parent.top
                        right: parent.left
                    }
                }

                ListItemLayout {
                    id: layout
                    title.text: categoryname
                    title.color: switch(settings.currentTheme){
                                 case "Default":
                                     theme.palette.normal.background
                                     break;
                                 case "Ambiance":
                                     theme.palette.normal.backgroundText
                                     break;
                                 case "SuruDark":
                                     theme.palette.normal.backgroundText
                                     break;
                                 default:
                                     theme.palette.normal.background
                                 }
                    subtitle.color: switch(settings.currentTheme){
                                    case "Default":
                                        theme.palette.normal.background
                                        break;
                                    case "Ambiance":
                                        theme.palette.normal.backgroundText
                                        break;
                                    case "SuruDark":
                                        theme.palette.normal.backgroundText
                                        break;
                                    default:
                                        theme.palette.normal.background
                                    }
                    subtitle.text: descr
                }

                onItemActionChanged: {
                    if (dialogResponse === "YES"
                            && categoryname === groupedList.category) {
                        DataProcess.deleteCategory(categoryname)
                        groupedList.model.remove(currentIndex)
                        checkEmpty()
                    }
                }

                leadingActions: ListItemActions {
                    id: leading
                    actions: Action {
                        iconName: "delete"
                        text: i18n.tr("Delete")
                        visible: categoryname !== i18n.tr("Uncategorized")
                        onTriggered: {
                            dialogResponse = ""
                            groupedList.category = categoryname
                            PopupUtils.open(dialog)
                        }
                    }
                }

                trailingActions: ListItemActions {
                    id: trailing
                    actions: [
                        Action {
                            iconName: "edit"
                            text: i18n.tr("Edit")
                            visible: categoryname !== i18n.tr("Uncategorized")
                            onTriggered: {
                                pageCategories.currentCategory = categoryname
                                pageCategories.currentDescription = descr
                                pageCategories.currentColor = colorValue
                                        === "default" ? "white" : colorValue
                                pageCategories.openAddCategory("edit")
                            }
                        }
                    ]
                }
            }
        }
    }

    Component {
        id: dialog
        Dialog {
            id: dialogue
            title: "Delete Category"
            text: "Are you sure you want to delete this category?<br>If you continue, all lists under this category will be moved under 'Uncategorized'"
            Row {
                id: buttonsRow
                spacing: width * 0.1
                Button {
                    text: "Cancel"
                    width: parent.width * 0.45
                    onClicked: PopupUtils.close(dialogue)
                }
                Button {
                    text: "Delete"
                    color: UbuntuColors.red
                    width: parent.width * 0.45
                    onClicked: {
                        dialogResponse = "YES"
                        PopupUtils.close(dialogue)
                        mainView.notification.showNotification(
                                    i18n.tr("Category successfully deleted"),
                                    UbuntuColors.coolGrey)
                    }
                }
            }
        }
    }
}
