import QtQuick
import Quickshell
import Quickshell.Services.Mpris

Item {
anchors.centerIn : parent
// property var player: Mpris.players.values[0]
Text{
    text: player.trackTitle || "Unknown Title"
    color: "green"
    }
}
