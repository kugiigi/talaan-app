TEMPLATE = app
TARGET = talaan

load(ubuntu-click)

QT += qml quick

SOURCES += main.cpp

RESOURCES += talaan.qrc

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  talaan.apparmor \
               talaan.png \
               Talaan_Splash.png

AP_TEST_FILES += tests/autopilot/run \
                 $$files(tests/*.py,true)

#show all the files in QtCreator
OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               $${AP_TEST_FILES} \
               talaan.desktop \
    components/Dialogs/DialogExternalLink.qml

#specify where the config files are installed to
config_files.path = /talaan
config_files.files += $${CONF_FILES}
INSTALLS+=config_files

#install the desktop file, a translated version is 
#automatically created in the build directory
desktop_file.path = /talaan
desktop_file.files = $$OUT_PWD/talaan.desktop
desktop_file.CONFIG += no_check_exist
INSTALLS+=desktop_file

# Default rules for deployment.
target.path = $${UBUNTU_CLICK_BINARY_PATH}
INSTALLS+=target

DISTFILES += \
    library/DataProcess.js \
    library/DBUtilities.js \
    library/DBUtils.js \
    library/DBWorker.js \
    library/jsonpath.js \
    library/MetaData.js \
    library/ProcessFunc.js \
    library/wait.js \
    assets/icons/aeroplane7.png \
    assets/icons/arrow115.png \
    assets/icons/bah.png \
    assets/icons/blackboard.png \
    assets/icons/books71.png \
    assets/icons/business11.png \
    assets/icons/camera148.png \
    assets/icons/candles5.png \
    assets/icons/car15.png \
    assets/icons/car211.png \
    assets/icons/clock12.png \
    assets/icons/clock14.png \
    assets/icons/cloud50.png \
    assets/icons/college3.png \
    assets/icons/control1.png \
    assets/icons/currency3.png \
    assets/icons/cut5.png \
    assets/icons/default.png \
    assets/icons/device18.png \
    assets/icons/direction66.png \
    assets/icons/energy39.png \
    assets/icons/facebook30.png \
    assets/icons/gear62.png \
    assets/icons/grapes.png \
    assets/icons/hamburger.png \
    assets/icons/hat3.png \
    assets/icons/info11.png \
    assets/icons/keyboard3.png \
    assets/icons/light13.png \
    assets/icons/marketing8.png \
    assets/icons/medical11.png \
    assets/icons/money209.png \
    assets/icons/movies6.png \
    assets/icons/music26.png \
    assets/icons/musical12.png \
    assets/icons/network57.png \
    assets/icons/network60.png \
    assets/icons/old.png \
    assets/icons/open9.png \
    assets/icons/paperairplane.png \
    assets/icons/piechart7.png \
    assets/icons/plants9.png \
    assets/icons/romance12.png \
    assets/icons/rugby3.png \
    assets/icons/science42.png \
    assets/icons/second.png \
    assets/icons/shredder3.png \
    assets/icons/signal57.png \
    assets/icons/spoon1.png \
    assets/icons/statistics.png \
    assets/icons/storagedevice.png \
    assets/icons/sunny27.png \
    assets/icons/tags9.png \
    assets/icons/telephone145.png \
    assets/icons/telephone17.png \
    assets/icons/transport35.png \
    assets/icons/trucks.png \
    assets/icons/tv3.png \
    assets/icons/wifi118.png \
    assets/icons/woman160.png \
    assets/images/background.png \
    assets/images/background@medium.png \
    assets/images/background@small.png \
    components/circle.png \
    Talaan_Splash.png \
    components/ListViewHighlight.qml.wb4457 \
    ui/ItemsPage.qml.Ag5775 \
    components/Dialogs/DialogAction.qml \
    components/Dialogs/DialogAlarm.qml \
    components/Dialogs/DialogBottomEdge.qml \
    components/Dialogs/DialogCreateFromSaved.qml \
    components/Dialogs/DialogIncludeComment.qml \
    components/ActionsHover.qml \
    components/AddItemsBar.qml \
    components/AlarmReminder.qml \
    components/CheckListItem.qml \
    components/CircleImage.qml \
    components/CreateBottomEdge.qml \
    components/CustomSplitView.qml \
    components/EmptyState.qml \
    components/FindHeader.qml \
    components/JSONListModel.qml \
    components/ListItemContent.qml \
    components/ListItemWithActionsCheckBox.qml \
    components/ListViewHighlight.qml \
    components/ListViewHover.qml \
    components/MessageBubble.qml \
    components/NavigationFlickable.qml \
    components/NavigationPanel.qml \
    components/NoSelectedPage.qml \
    components/NotificationBubble.qml \
    components/OrganizerReminder.qml \
    components/PageBackGround.qml \
    components/PullToAction.qml \
    components/RadialAction.qml \
    components/RadialBottomEdge.qml \
    components/RectangleChecklist.qml \
    components/SearchHeader.qml \
    components/SearchSections.qml \
    components/SortFilterModels.qml \
    components/TextualButtonStyle.qml \
    components/Walkthrough.qml \
    library/ListModels.qml \
    ui/About.qml \
    ui/AddCategory.qml \
    ui/AddChecklist.qml \
    ui/DefaultTab.qml \
    ui/HistoryTab.qml \
    ui/ItemsPage.qml \
    ui/ItemsPage_layouts.qml \
    ui/ManageCategory.qml \
    ui/NavigationSplitPage.qml \
    ui/PrimaryPage.qml \
    ui/RemindersPage.qml \
    ui/SavedTab.qml \
    ui/SettingsTab.qml \
    ui/TargetsPage.qml \
    components/Common/ListViewPositioner.qml \
    library/moment.js \
    components/Common/HeaderWithSubtitle.qml \
    components/RadialBottomMenu.qml \
    components/Common/ListItemSectionHeader.qml \
    components/Common/CheckBoxItem.qml \
    components/Common/NavigationItem.qml \
    components/Common/ColorPicker.qml \
    components/Common/ColorPicker/ColorPicker.qml \
    components/Common/ColorPicker/ColorPickerPopup.qml \
    components/PageWithBottom.qml \
    components/SortFilter/SortFilterFields.qml \
    components/Search/SearchHeaderExtension.qml \
    library/WorkerScripts/ListModelLoader.js \
    components/Common/LoadingComponent.qml \
    components/TabActions.qml \
    components/ListPage.qml \
    components/BottomEdgeMenu.qml \
    library/WorkerScripts/BottomMenuLoader.js
