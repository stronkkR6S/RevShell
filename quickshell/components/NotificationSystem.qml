import QtQuick
import QtQuick.Layouts
import QtQml.Models
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Notifications

Scope {
    id: root

    // property alias history: historyModel
    // property alias trackedNotifications: server.trackedNotifications
    property bool isNotiSilent: false

    ListModel {
        id: historyModel
    }

    NotificationServer {
        id: server

        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        bodySupported: true
        actionIconsSupported: true
        bodyImagesSupported: true
        inlineReplySupported: false
        actionsSupported: true
        keepOnReload: true
        persistenceSupported: true

        onNotification: notification => {
            //used histroy dismiss() or expire() remove from the notification server
            historyModel.insert(0, {
                summary: notification.summary,
                body: notification.body,
                urgency: notification.urgency,
                appname: notification.appName,
                appicon: notification.appIcon,
                profileimage: notification.image
            });

            notification.tracked = true;
        }
    }

    // Notification popup
    PanelWindow {
        id: notificationBox

        implicitWidth: 320
        implicitHeight: popupColumn.implicitHeight
        Behavior on implicitHeight {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutBounce
            }
        }

        WlrLayershell.layer: WlrLayer.Overlay
        color: "transparent"

        anchors {
            top: true
            right: true
        }
        visible: !root.isNotiSilent

        Column {
            id: popupColumn

            width: 320
            padding: 10
            spacing: 8

            Repeater {
                model: server.trackedNotifications.values

                delegate: Rectangle {
                    required property var modelData

                    width: 300
                    height: popupContent.implicitHeight + 20

                    border.width: 2
                    border.color: modelData.urgency === NotificationUrgency.Critical ? Theme.red : Theme.blue

                    color: Theme.background
                    radius: 15
                    clip: true

                    Timer {
                        interval: 5000
                        running: modelData.urgency !== NotificationUrgency.Critical
                        repeat: false
                        onTriggered: modelData.expire()
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: modelData.dismiss()
                    }

                    Column {
                        id: popupContent

                        width: parent.width
                        spacing: 10
                        topPadding: 10
                        bottomPadding: 10
                        leftPadding: 10

                        Text {
                            width: parent.width - 10
                            text: modelData.summary
                            font.pixelSize: 18
                            font.family: "Orbitron"
                            font.weight: Font.Black
                            // horizontalAlignment: Text.AlignHCenter
                            elide: Text.ElideRight
                        }

                        Text {
                            width: parent.width - 10
                            text: modelData.body
                            font.pixelSize: 16
                            // horizontalAlignment: Text.AlignHCenter
                            wrapMode: Text.Wrap
                            maximumLineCount: 10
                        }
                    }
                }
            }
        }
    }

    // Notification center
    PanelWindow {
        id: panelBox

        implicitWidth: 400
        implicitHeight: 500

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        color: "transparent"
        visible: false

        anchors {
            right: true
        }

        margins {
            right: 20
        }

        Rectangle {
            anchors.fill: parent
            radius: 15
            color: Theme.background
            border.width: 2
            border.color: Theme.blue

            Text {
                anchors.centerIn: parent
                text: "No notifications"
                font.pixelSize: 25
                visible: historyModel.count <= 0
                color: Qt.rgba(0, 0, 0, 0.5)
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        Layout.topMargin: 11
                        text: historyModel.count === 0 && !root.isNotiSilent ? "Notifications" : (root.isNotiSilent ? "Notifications 󰂛" : "Notifications")
                        color: Theme.blue
                        font.pixelSize: 18
                        font.family: "Orbitron"
                        font.weight: Font.Black
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.isNotiSilent = !root.isNotiSilent
                        }
                    }

                    Text {
                        text: "Clear All"
                        visible: historyModel.count > 0
                        color: clearAllArea.containsMouse ? Theme.red : Theme.blue
                        font.pixelSize: 16

                        MouseArea {
                            id: clearAllArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                historyModel.clear();
                                //we will not clear the server notifications it will be done by the popup

                                // const list = server.trackedNotifications.values
                                // for (let i = list.length - 1; i >= 0; i--) {
                                //     if (list[i])
                                //         list[i].dismiss()
                                // }
                            }
                        }
                    }
                }

                ListView {
                    id: notificationList

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    clip: true
                    spacing: 5
                    model: historyModel
                    maximumFlickVelocity: 3000
                    flickDeceleration: 1500

                    delegate: Rectangle {
                        required property int index
                        required property string summary
                        required property string body
                        required property int urgency
                        required property string appname
                        required property string appicon
                        required property string profileimage

                        width: notificationList.width
                        height: notibox.implicitHeight + 20

                        color: Theme.blue
                        radius: 15

                        border.width: 2
                        border.color: urgency === NotificationUrgency.Critical ? Theme.red : Theme.blue

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 8

                            Image {
                                source: appicon ? Quickshell.iconPath(appicon) : Qt.resolvedUrl("../icons/Noti.png")

                                Layout.preferredWidth: 35
                                Layout.preferredHeight: 35
                                Layout.alignment: Qt.AlignTop

                                fillMode: Image.PreserveAspectFit
                            }

                            ColumnLayout {
                                id: notibox
                                Layout.fillWidth: true
                                spacing: 5

                                Text {
                                    Layout.fillWidth: true
                                    text: summary
                                    font.bold: true
                                    elide: Text.ElideRight
                                    maximumLineCount: 2
                                    wrapMode: Text.Wrap
                                    font.pixelSize: 15
                                }

                                Text {
                                    Layout.fillWidth: true
                                    text: body
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 10
                                    elide: Text.ElideRight
                                    font.pixelSize: 16
                                }
                                Text {
                                    Layout.fillWidth: true
                                    text: appname
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 2
                                    elide: Text.ElideRight
                                    font.pixelSize: 15
                                    color: Qt.rgba(0, 0, 0, 0.4)
                                }
                            }

                            Text {
                                text: "󰎟"
                                font.pixelSize: 18
                                Layout.alignment: Qt.AlignTop

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor

                                    onClicked: {
                                        historyModel.remove(index);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "noticenter"

        function toggle(): void {
            panelBox.visible = !panelBox.visible;
        }
    }
}
