import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

Rectangle {
    id: root

    required property var dashboard_window

    width: 50
    height: 50
    color: "transparent"

    anchors {
        right: parent.right
        rightMargin: 390
        verticalCenter: parent.verticalCenter
    }

    RowLayout {
        spacing: 10
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        layoutDirection: Qt.RightToLeft

        Repeater {
            model: SystemTray.items.values.slice().reverse()

            delegate: Image {
                required property SystemTrayItem modelData

                source: modelData.icon
                fillMode: Image.PreserveAspectFit
                smooth: true

                Layout.preferredWidth: 24
                Layout.preferredHeight: 24

                MouseArea {
                    anchors.fill: parent

                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            modelData.activate();
                        } else if (mouse.button === Qt.MiddleButton) {
                            modelData.secondaryActivate();
                        } else if (mouse.button === Qt.RightButton) {
                            if (modelData.hasMenu) {
                                modelData.display(root.dashboard_window, root.x + parent.x, parent.y + parent.height);
                            }
                        }
                    }
                }
            }
        }
    }
}
