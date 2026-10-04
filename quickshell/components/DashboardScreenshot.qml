import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    property string mpvCommand: "file=$(ls -t \"$HOME/pics/screenshots\"/*.png 2>/dev/null | head -n 1); [ -n \"$file\" ] && mpv --pause \"$file\""

    property string screenshotCommand: "mkdir -p \"$HOME/pics/screenshots\" && sleep 2; grim \"$HOME/pics/screenshots/screenshot-$(/usr/bin/date '+%d-%m-%Y-%H_%M_%S').png\""
        readonly property string areascreenshotCommand: 'grim -g "$(slurp)" ~/pics/screenshots/area-$(date "+%d-%m-%Y-%H_%M_%S").png'
    height: 40
    width: 205
    color: Theme.modulefg
    radius: 15

    anchors {
        bottom: parent.bottom
        bottomMargin: 5
        left: parent.left
        leftMargin: 5
    }
    Process {
        id: fullscreen
        command: ["sh", "-c", root.screenshotCommand]
    }
    Process {
        id: areascreen
    }
    Process {
        id: viewlastimage

        command: ["sh", "-c", root.mpvCommand]
    }

    Text {
        text: ""
        color: full.pressed ? Theme.blue : Theme.white
        font.pixelSize: 30
        rotation: 90

        anchors {
            left: parent.left
            leftMargin: 15
        }
        MouseArea {
            id: full
            anchors.fill: parent
            onClicked: {
                fullscreen.running = true;
            }
        }
    }

    Text {
        text: "󱣴"
        color: area.pressed ? Theme.vibrantOrange : Theme.white
        font.pixelSize: 30

        anchors {
            left: parent.left
            leftMargin: 85
        }
        MouseArea {
            id: area
            anchors.fill: parent
            onClicked: {
                Quickshell.execDetached(["sh", "-c", root.areascreenshotCommand]);
            }
        }
    }
    Text {
        text: ""
        color: showimage.pressed ? Theme.blue : Theme.white
        font.pixelSize: 28

        anchors {
            top: parent.top
            topMargin: 2
            left: parent.left
            leftMargin: 160
        }
        MouseArea {
            id: showimage
            anchors.fill: parent
            onClicked: {
                viewlastimage.running = true;
            }
        }
    }
}
