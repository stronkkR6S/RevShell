import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts

Rectangle {
    id: root
    width: 50
    height: 220
    radius: 15
    color: Theme.modulefg

    anchors {
        left: parent.left
        top: parent.top
        leftMargin: 5
        topMargin: 5
    }

    property string currentRecording: ""
    property int elapsedSeconds: 0
    property bool systemAudio: false
    property string systemSound: "--audio=alsa_output.pci-0000_03_00.6.HiFi__Speaker__sink.monitor"

property string recordingCommand: "mkdir -p \"$HOME/vids/recordings\" && wf-recorder -r 60 -p bitrate=20M " + (systemAudio ? systemSound + "  " : "") + "-f \"$HOME/vids/recordings/recording-$(date '+%d-%m-%Y-%I-%M-%S-%p').mp4\""


property string mpvCommand: "file=$(ls -t \"$HOME/vids/recordings\"/*.mp4 2>/dev/null | head -n 1); [ -n \"$file\" ] && mpv \"$file\""


    Timer {
        id: recordingTimer
        running: recorder.running
        interval: 1000
        repeat: true

        onTriggered: root.elapsedSeconds++
    }

    Process {
        id: recorder

        command: ["sh", "-c", root.recordingCommand]

        onRunningChanged: {
            if (!running)
                root.elapsedSeconds = 0;
        }
    }

    Process {
        id: playLastRecording

        command: ["sh", "-c", root.mpvCommand]
    }

    Text {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 25
        }

        rotation: 90

        text: Qt.formatTime(new Date(0, 0, 0, 0, 0, root.elapsedSeconds), "mm:ss")

        font.pixelSize: 25
        color: Theme.white
    }

    Rectangle {
        width: 40
        height: 3
        radius: 15
        color: "black"
        opacity: 0.5

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 85
        }
    }

    Item {
        width: 50
        height: 40

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 90
        }

        Text {
            anchors.centerIn: parent

            text: recorder.running ? "" : ""
            font.pixelSize: 22
            color: recorder.running ? "red" : Theme.white
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: recorder.running = !recorder.running
        }
    }

    Item {
        width: 50
        height: 40

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 130
        }

        Text {
            anchors.centerIn: parent

            text: root.systemAudio ? "" : "󰍭"
            font.pixelSize: 25
            color: Theme.white
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                root.systemAudio = !root.systemAudio;
            }
        }
    }

    Item {
        width: 50
        height: 40

        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 170
        }

        Text {
            anchors.centerIn: parent

            text: "󱧺"
            font.pixelSize: 24
            color: playLastRecording.running ? "orange" : Theme.white
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor

            onClicked: {
                playLastRecording.running = true;
            }
        }
    }
}
