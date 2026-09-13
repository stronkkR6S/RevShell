import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    anchors.right: parent.right
    anchors.rightMargin: 10
    anchors.verticalCenter: parent.verticalCenter

    width: 110
    height: 34
    radius: 40

    color: Theme.vibrantOrange

    property int batteryLevel: 0
    property string batteryState: ""

    property string batteryCharging: {
        if (batteryState === "Charging") {
            return "󰛕"
        }

        return ""
    }

    property string batteryIcon: {
        if (batteryLevel <= 0) {
            return "󰂃"
        } else if (batteryLevel <= 10) {
            return "󰁺"
        } else if (batteryLevel <= 20) {
            return "󰁻"
        } else if (batteryLevel <= 30) {
            return "󰁼"
        } else if (batteryLevel <= 40) {
            return "󰁽"
        } else if (batteryLevel <= 50) {
            return "󰁾"
        } else if (batteryLevel <= 60) {
            return "󰁿"
        } else if (batteryLevel <= 70) {
            return "󰂀"
        } else if (batteryLevel <= 80) {
            return "󰂁"
        } else if (batteryLevel <= 90) {
            return "󰂂"
        } else if (batteryLevel <= 95) {
            return "󰁹"
        } else {
            return "󱈑"
        }
    }

    Process {
        id: batteryscript

        command: [
            "sh",
            "-c",
            "~/.config/quickshell/scripts/battery.sh"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text.trim())

                    root.batteryLevel = data.capacity
                    root.batteryState = data.state
                } catch (e) {
                    console.log("Battery error:", e)
                }
            }
        }
    }

    Timer {
        interval: 4000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            batteryscript.running = true
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 10


        // Battery
        Item {
            Layout.preferredWidth: 38
            Layout.fillHeight: true

            RowLayout {
                anchors.fill: parent
                spacing: 3

                Text {
                    Layout.alignment: Qt.AlignVCenter

                    text: root.batteryIcon
                    font.pixelSize: 22
                }

                Text {
                    Layout.alignment: Qt.AlignVCenter

                    text: root.batteryCharging
                    font.pixelSize: 20
                }

                Text {
                    Layout.alignment: Qt.AlignVCenter

                    text: root.batteryState === "Charging"
                          ? ""
                          : root.batteryLevel
                color: Theme.foreground

                    font.pixelSize: 15
                }
            }
        }

        // Power button
        Item {
            Layout.preferredWidth: 28
            Layout.fillHeight: true

            Text {
                anchors.fill: parent

                text: ""
                font.pixelSize: 22
                color: Theme.foreground

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    powermenupop.active = !powermenupop.active
                }
            }
        }
    }

    // Power menu
    Loader {
        id: powermenupop

        active: false
        source: "Powermenupop.qml"

        onLoaded: {
            item.closeRequested.connect(closeMenu)
        }
    }

    function closeMenu() {
        powermenupop.active = false
    }
}
