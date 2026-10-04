import QtQuick
import Quickshell
import Quickshell.Io

Sliderr {
        id: slider
    property int brightnessLevel: 0

    from: 0
    to: 100
    value: slider.brightnessLevel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 85
    anchors.rightMargin: 50
    anchors.topMargin: 150

    onMoved: {
        let targetValue = Math.round(value) + "%";
        Quickshell.execDetached(["brightnessctl", "set",targetValue])

    }
        Process {
        id: brightness_script
        running: true

        command: ["sh", "-c", "~/.config/quickshell/scripts/brightness.sh"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text.trim());

                    slider.brightnessLevel = data.brightnesslevel;
                } catch (e) {
                    console.log("Error:", e);
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: brightness_script.running = true
    }
Image {
    source: "../icons/bright.svg"
    width: 22
    height: 22
     fillMode: Image.PreserveAspectFit
    smooth: true
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.top: parent.top
    anchors.topMargin: 4
}
}
