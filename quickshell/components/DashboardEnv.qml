import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    property string distroName: "Linux"
    property var uptime: ""

    anchors {
        top: parent.top
        topMargin: 40
        left: parent.left
        leftMargin: 290
    }

    height: 100
    width: 240
    radius: Theme.module_radius
    color: Theme.customGray

    Rectangle {
        anchors {
            left: parent.left
            leftMargin: 10
            top: parent.top
            topMargin: 12
        }
        radius: 15
        color: "#a6a6a6"
        width: 80
        height: 80

        Text {
            anchors.centerIn: parent
            text: ""
            font.pixelSize: 40
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
    Timer{
        interval: 60000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            uptime.running = true
        }
    }

    Text {
        text: " : "
        font.pixelSize: 18

        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 105
            topMargin: 12
        }
    }
    Text {
        text: root.distroName
        font.pixelSize: 15

        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 137
            topMargin: 15
        }
    }
    Text {
        text: "󰰮  :"
        font.pixelSize: 18
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 105
            topMargin: 37
        }
    }
    Text {
        text: "Sway"
        font.pixelSize: 15

        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 137
            topMargin: 40
        }
    }

    Text {
        text: "  : "
        font.pixelSize: 18
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 105
            topMargin: 63
        }
    }
    Text {
        text: root.uptime
        font.pixelSize: 15

        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 137
            topMargin: 66
        }
    }

}
