import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: toplevel

    signal closeRequested

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    color: "transparent"

    implicitWidth: 85
    implicitHeight: 400

    anchors.right: true

    Rectangle {
        anchors.right: parent.right
        height: parent.height
        width: 0
        clip: true
        Component.onCompleted: {
            width = 85;
        }
        Behavior on width {
            NumberAnimation {
                duration: 200
                easing.type: Easing.InOutCubic
            }
        }

        color: Theme.background
        topLeftRadius: 20
        bottomLeftRadius: 20
        ColumnLayout {
            anchors.fill: parent
            spacing: 0

            Repeater {
                id: repeater

                model: [
                    {
                        icon: "",
                        size: 34,
                        action: "systemctl poweroff"
                    },
                    {
                        icon: "",
                        size: 44,
                        action: "systemctl reboot"
                    },
                    {
                        icon: "",
                        size: 44,
                        action: "qs ipc call lockscreen toggle"
                    },
                    {
                        icon: "󰒲",
                        size: 44,
                        action: "systemctl suspend"
                    }
                ]

                delegate: Rectangle {
                    id: button

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    color: activeFocus ? Theme.vibrantOrange : "transparent"

                    topLeftRadius: 22
                    bottomLeftRadius: 22
                    border.width: 2
                    border.color: Theme.background
                    focus: index === 0

                    Text {
                        anchors.centerIn: parent

                        text: modelData.icon
                        font.pixelSize: modelData.size
                        color: Theme.foreground
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true

                        onClicked: {
                            actionProcess.running = true;
                        }
                    }

                    Process {
                        id: actionProcess

                        command: ["sh", "-c", modelData.action]
                    }

                    Keys.onPressed: event => {
                        if (event.key === Qt.Key_Tab) {
                            let nextIndex = (index + 1) % repeater.count;

                            repeater.itemAt(nextIndex).forceActiveFocus();

                            event.accepted = true;
                        } else if (event.key === Qt.Key_Escape) {
                            closeRequested();

                            event.accepted = true;
                        } else if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            actionProcess.running = true;

                            event.accepted = true;
                        }
                    }
                }
            }
        }
    }
}
