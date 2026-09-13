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

    implicitWidth: 120
    implicitHeight: 400

    anchors.right: true

    Rectangle {
        anchors.fill: parent
        anchors.rightMargin: 30

        color: Theme.background
        radius: 25

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
                        action: "loginctl lock-session"
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

                    radius: 25
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
