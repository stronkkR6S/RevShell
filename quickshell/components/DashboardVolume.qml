import QtQuick
import Quickshell
import Quickshell.Io

Sliderr {
        id: slider
    property int volumeLevel: 0
        from: 0
        to: 100
        value: slider.volumeLevel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.leftMargin: 85
    anchors.rightMargin: 50
    anchors.topMargin: 200
    handleColor: Theme.vibrantOrange
    textColor: Theme.vibrantOrange
    onMoved: {
        let targetValue = Math.round(value) + "%";
        Quickshell.execDetached(["wpctl", "set-volume" , "@DEFAULT_AUDIO_SINK@", "-l", "1" ,targetValue])

    }
        Process {
        id: volumescript
        running: true

        command: ["sh", "-c", "~/.config/quickshell/scripts/volume.sh"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text.trim());

                    slider.volumeLevel = data.volume;
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

        onTriggered: volumescript.running = true
    }
Image {
    source: "../icons/volume.svg"
    width: 21
    height: 21
     fillMode: Image.PreserveAspectFit
    anchors.left: parent.left
    anchors.leftMargin: 5
    anchors.top: parent.top
    anchors.topMargin: 4
}
       


}

