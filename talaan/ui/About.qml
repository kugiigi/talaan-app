import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3
//import QtSystemInfo 5.0
import "../components"
import "../components/Common"
import "../components/Dialogs"

PageWithBottom {
    id: aboutPage

    actions: [mainView.bottomMenuActions[4], mainView.bottomMenuActions[4], mainView.bottomMenuActions[1], mainView.bottomMenuActions[0], mainView.bottomMenuActions[2], mainView.bottomMenuActions[5]]

    header: PageHeader {
        title: i18n.tr("About Talaan")

        StyleHints {
            backgroundColor: switch(settings.currentTheme){
                             case "Default":
                                 "#3D1400"
                                 break;
                             case "System":
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
    }

    onActiveChanged: {
        if (active === true) {

        } else {
            if (!mainLayout.multiColumn) {
                mainLayout.resetCurrentIndex()
            }
        }
    }

    function externalLinkConfirmation(link, continueFunction){
        var dialogConfirm = PopupUtils.open(
                    dialogExternalLink,null,{"externalURL": link})

        var continueDialog = function (answer) {
            if(answer){
                Qt.openUrlExternally(link)
            }
        }

        dialogConfirm.proceed.connect(
                    continueDialog)
    }


    ScrollView {
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            top: aboutPage.header.bottom
        }
        Flickable {
            id: flickableAbout
            boundsBehavior: Flickable.DragAndOvershootBounds
            interactive: true
            contentHeight: bodyColumn.height + iconlabelGroup.height + units.gu(
                               5)
            anchors.fill: parent

            flickableDirection: Flickable.VerticalFlick
            clip: true

            UbuntuNumberAnimation on opacity {
                running: flickableAbout.visible
                from: 0
                to: 1
                easing: UbuntuAnimation.StandardEasing
                duration: UbuntuAnimation.FastDuration
            }

            Item {
                id: iconlabelGroup
                height: units.gu(30)

                anchors {
                    left: parent.left
                    right: parent.right
                }

                UbuntuShape {
                    id: iconShape
                    width: units.gu(20)
                    height: width
                    aspect: UbuntuShape.Flat

                    radius: "medium"
                    relativeRadius: 0.5
                    anchors {
                        top: iconlabelGroup.top
                        topMargin: units.gu(3)
                        horizontalCenter: parent.horizontalCenter
                    }
                    source: Image {
                        source: "../Talaan_Splash.png"
                        asynchronous: true
                    }
                }
                Label {
                    id: labelName
                    text: i18n.tr("© Talaan Version ") + mainView.current_version
                    textSize: Label.Medium
                    horizontalAlignment: Text.AlignHCenter
                    anchors {
                        top: iconShape.bottom
                        topMargin: units.gu(1)
                        horizontalCenter: parent.horizontalCenter
                    }
                }
                Label {
                    id: labelLicense

                    text: i18n.tr("Released under license") + " <a href='https://www.gnu.org/licenses/gpl-3.0.en.html' title='GNU GPL v3'>GNU GPL v3</a>"
                    textSize: Label.Medium
                    horizontalAlignment: Text.AlignHCenter
                    anchors {
                        top: labelName.bottom
                        topMargin: units.gu(1)
                        horizontalCenter: parent.horizontalCenter
                    }

                    onLinkActivated: {
                        externalLinkConfirmation(link)
                    }
                }
            }

            Column {
                id: bodyColumn
                anchors {
                    top: iconlabelGroup.bottom
                    topMargin: units.gu(3)
                    left: parent.left
                    right: parent.right
                }
                ListItemSectionHeader {
                    title: i18n.tr("Support")
                }

                //Commented out since rating apps isn't yet supported in OpenStore
//                NavigationItem {
//                    titleText.text: i18n.tr("Rate this App")
//                    iconName: "starred"

//                    anchors {
//                        left: parent.left
//                        right: parent.right
//                    }

//                    action: Action {
//                        onTriggered: {
//                            Qt.openUrlExternally(
//                                        "scope://com.canonical.scopes.clickstore?q=Talaan")
//                        }
//                    }
//                }


                // No equivalent in Github
//                NavigationItem {
//                    titleText.text: i18n.tr("Ask a question")
//                    iconName: "help"

//                    anchors {
//                        left: parent.left
//                        right: parent.right
//                    }

//                    action: Action {
//                        onTriggered: {
//                            Qt.openUrlExternally(
//                                        "https://answers.launchpad.net/talaan-app")
//                        }
//                    }
//                }
                NavigationItem {
                    titleText.text: i18n.tr("Report a bug")
                    iconName: "mail-mark-important"

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    action: Action {
                        onTriggered: {
                            externalLinkConfirmation("https://github.com/kugiigi/talaan-app/issues")
                        }
                    }
                }
                NavigationItem {
                    titleText.text: i18n.tr("Contact Developer")
                    iconName: "stock_email"

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    action: Action {
                        onTriggered: {
                            externalLinkConfirmation('mailto:kugi_eusebio@protonmail.com')
                        }
                    }
                }
                NavigationItem {
                    titleText.text: i18n.tr("View source")
                    iconName: "stock_document"

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    action: Action {
                        onTriggered: {
                            externalLinkConfirmation(
                                        'https://github.com/kugiigi/talaan-app')
                        }
                    }
                }
                NavigationItem {
                    titleText.text: i18n.tr("Donate via Paypal")
                    iconName: "like"

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    action: Action {
                        onTriggered: {
                            externalLinkConfirmation(
                                        'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=2GBQRJGLZMBCL')
                        }
                    }
                }
                NavigationItem {
                    titleText.text: i18n.tr("Donate via LibrePay")
                    iconName: "unlike"

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    action: Action {
                        onTriggered: {
                            externalLinkConfirmation(
                                        'https://liberapay.com/kugi_eusebio/donate')
                        }
                    }
                }
                NavigationItem {
                    titleText.text: i18n.tr("Other apps by the developer")
                    iconName: "stock_application"

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    action: Action {
                        onTriggered: {
                            externalLinkConfirmation(
                                        "https://open-store.io/?sort=relevance&search=author%3AKugi%20Eusebio")
                        }
                    }
                }

                ListItemSectionHeader {
                    title: i18n.tr("Developers")
                }
                NavigationItem {
                    titleText.text: "Kugi Eusebio"
                    subText.text: i18n.tr("Main developer")

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    action: Action {
                        onTriggered: {
                            externalLinkConfirmation(
                                        'https://github.com/kugiigi')
                        }
                    }
                }
                ListItemSectionHeader {
                    title: i18n.tr("Logo")
                }
                NavigationItem {
                    titleText.text: "Sander Klootwijk"

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    action: Action {
                        onTriggered: {
                            externalLinkConfirmation(
                                        'mailto:sander.k1007@kpnmail.nl')
                        }
                    }
                }
                ListItemSectionHeader {
                    title: i18n.tr("Powered by")
                }
                NavigationItem {
                    titleText.text: "moment.js"
                    subText.text: i18n.tr("Date and Time manipulation")

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    action: Action {
                        onTriggered: {
                            externalLinkConfirmation('http://momentjs.com/')
                        }
                    }
                }
                NavigationItem {
                    titleText.text: "jsonpath.js"
                    subText.text: i18n.tr("For processing JSON models")

                    anchors {
                        left: parent.left
                        right: parent.right
                    }

                    action: Action {
                        onTriggered: {
                            externalLinkConfirmation(
                                        'https://github.com/s3u/JSONPath')
                        }
                    }
                }
            }
        }
    }


    DialogExternalLink {
        id: dialogExternalLink
    }


}
