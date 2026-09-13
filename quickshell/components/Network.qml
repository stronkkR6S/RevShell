import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: networkbackend
    anchors.fill: parent

    property string currentSsid: "  "
    property string currentState: "offline"
    property int currentSignal: 0

    readonly property var icon: {
        "online": "󰤨",
        "offline": "󰤭",
        "unknown": ""
    }

    readonly property string signalIcon: {
        if (currentState !== "online")
            return networkbackend.icon.offline

        if (currentSignal >= -50)
            return "󰤨"
        else if (currentSignal >= -60)
            return "󰤥"
        else if (currentSignal >= -70)
            return "󰤟"
        else
            return "󰤯"
    }

    Process {
        id: networkfrontend
        running: true

        // { "key": "value", "key": "value" } format,
        // so we don't have to do a lot of formatting.
        command: ["sh", "-c", "~/.config/quickshell/scripts/network.sh"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    // Trim \n
                    let data = JSON.parse(this.text.trim())

                    networkbackend.currentSsid = data.ssid
                    networkbackend.currentState = data.state
                    networkbackend.currentSignal = data.signal
                } catch (e) {
                    console.log("JSON parse error")
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: networkfrontend.running = true
    }

    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: 250
        anchors.verticalCenter: parent.verticalCenter

        height: 34
        width: 120
        radius: 20
        color: Theme.blue

        RowLayout {
            anchors.centerIn: parent
            spacing: 4

            Text {
                text: networkbackend.signalIcon
                font.pixelSize: 27
                color: Theme.foreground
            }

            Text {
                text: networkbackend.currentSsid
                font.pixelSize: 15
                color: Theme.foreground
            }
        }
    }
}
