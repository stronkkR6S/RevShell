import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    property string distroName: "Linux"
    property string uptime: ""

    anchors {
        top: parent.top
        topMargin: 15
        left: parent.left
        leftMargin: 20
    }

    height: 100
    width: 240
    radius: Theme.module_radius
    color: "transparent"

    Text {
        text: Quickshell.env("USER").toUpperCase()
        color: "white"
        font.family: "orbitron"
        font.weight: Font.Black
        font.pixelSize: 15

        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 20
            topMargin: 10
        }
    }

    Process {
        id: autodistrofetch

        command: ["sh", "-c", "grep -Po '^PRETTY_NAME=\"\\K[^\"]+' /etc/os-release"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.distroName = this.text.trim();
            }
        }
    }

    Process {
        id: uptime

        command: ["sh", "-c", "uptime -p | sed -E 's/^up //; s/ hours?, / : /; s/ minutes?/ minute/'"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                root.uptime = this.text.trim();
            }
        }
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            uptime.running = true;
        }
    }

    Text {
        text: root.distroName
        font.pixelSize: 15
        color: "#E6E6E6"

        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 20
            topMargin: 38
        }
    }

    Text {
        text: root.uptime
        font.pixelSize: 15
        color: "#E6E6E6"
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 20
            topMargin: 63
        }
    }
    Text {
        text: "Sway"
        font.pixelSize: 15
        color: "#E6E6E6"

        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 20
            topMargin: 88
        }
    }
}
