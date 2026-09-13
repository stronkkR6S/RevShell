import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
Item {
    id: micro

    implicitWidth: 22
    implicitHeight: 22

    property string isMicroMuted: ""

    Process {
        id: microscript
        running: true

        command: [
            "sh", "-c",
            "~/.config/quickshell/scripts/microphone.sh"
        ]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text.trim());
                    micro.isMicroMuted = data.state;
                } catch (e) {
                    console.log("Error:", e);
                }
            }
        }
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: microscript.running = true
    }

    Text {
        anchors.centerIn: parent

        text: micro.isMicroMuted === "MUTED" ? "" : ""
        color: Theme.foreground
        font.pixelSize: 20
    }

    MouseArea {
        id: micMouseArea

        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            micMuteToggle.running = true;
        }

        Process {
            id: micMuteToggle
            running: false

            command: [
                "wpctl",
                "set-mute",
                "@DEFAULT_AUDIO_SOURCE@",
                "toggle"
            ]
        }
    }
}
