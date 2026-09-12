import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
//without any quickshell module

Item {
    id: allroot
    anchors.fill: parent

    property int batteryLevel: 0
    property string batteryState: ""
    property string isMuted: ""
    property int volumeLevel: 0

    property string volumeIcon: {
        if (volumeLevel === 0) {
            return ""
        } else if (volumeLevel <= 50) {
            return ""
        } else {
            return "󰕾"
        }
    }

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
        running: true

        command: [
            "sh",
            "-c",
            "~/.config/quickshell/scripts/battery.sh"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text.trim())

                    allroot.batteryLevel = data.capacity
                    allroot.batteryState = data.state
                } catch (e) {
                    console.log("Error:", e)
                }
            }
        }
    }

    Timer {
        interval: 4000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: batteryscript.running = true
    }

    Process {
        id: volumescript
        running: true

        command: [
            "sh",
            "-c",
            "~/.config/quickshell/scripts/volume.sh"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text.trim())

                    allroot.volumeLevel = data.volume
                    allroot.isMuted = data.state
                } catch (e) {
                    console.log("Error:", e)
                }
            }
        }
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: volumescript.running = true
    }

    Rectangle {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 70
        }

        height: 34
        width: 120
        radius: 25
        color: mousearea.containsMouse ? Theme.cyan : Theme.blue

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10

            // Volume
            Item {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                implicitWidth: volumeLayout.implicitWidth
                implicitHeight: volumeLayout.implicitHeight

                RowLayout {
                    id: volumeLayout
                    anchors.fill: parent
                    spacing: 4

                    Text {
                        text: allroot.isMuted === "MUTED"
                            ? ""
                            : allroot.volumeIcon

                        font.pixelSize: 22
                    }

                    Text {
                        text: allroot.volumeLevel
                        font.pixelSize: 17
                    }
                }

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    hoverEnabled: true

                    onClicked: {
                        mutetoggle.running = true
                    }

                    onWheel: function(wheel) {
                        if (wheel.angleDelta.y > 0) {
                            volumeUp.running = true
                        } else if (wheel.angleDelta.y < 0) {
                            volumeDown.running = true
                        }
                    }

                    Process {
                        id: mutetoggle
                        running: false

                        command: [
                            "sh",
                            "-c",
                            "wpctl set-mute 54 toggle"
                        ]
                    }

                    Process {
                        id: volumeUp

                        command: [
                            "wpctl",
                            "set-volume",
                            "@DEFAULT_AUDIO_SINK@",
                            "-l",
                            "1",
                            "2%+"
                        ]
                    }

                    Process {
                        id: volumeDown

                        command: [
                            "wpctl",
                            "set-volume",
                            "@DEFAULT_AUDIO_SINK@",
                            "2%-"
                        ]
                    }
                }
            }

            // Battery
            RowLayout {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                spacing: 2

                Text {
                    text: allroot.batteryIcon
                    font.pixelSize: 22
                }

                Text {
                    text: allroot.batteryCharging
                    font.pixelSize: 22
                }

                Text {
                    text: allroot.batteryState === "Charging"
                            ? " "
                            : allroot.batteryLevel

                    font.pixelSize: 17
                }
            }
        }
    }
}
