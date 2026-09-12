import QtQuick
import QtQuick.Layouts
import Quickshell

Item{
anchors.fill: parent
id: box

Rectangle{
    id: clockbar
    anchors.centerIn: parent
    color: Theme.vibrantOrange
    height: 34
    width: 120
    radius: 20
    
}
    Text {
        id: clock
        color: Theme.background
        anchors.centerIn: parent
        font.pixelSize: 23
        font.italic: true
        font.bold: true
        font.letterSpacing: 3.5
        // font.family: "Noto Serif Black"//"Orbitron"
    }

Timer {
    interval: 1000; running: true; repeat: true

    onTriggered: {
    clock.text = Qt.formatTime(new Date(), "h:mm ap").replace(/ am| pm/i, "")

  }

 }

}
