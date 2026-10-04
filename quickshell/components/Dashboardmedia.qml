import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Qt5Compat.GraphicalEffects

Rectangle {
    id: dashboardMedia

    property var player: Mpris.players.values[0]
    property real currentPosition: player ? player.position : 0

    Timer {
        id: position
        interval: 1000
        running: player && player.playbackState === MprisPlaybackState.Playing
        repeat: true
        onTriggered: {
            onTriggered: player.positionChanged();
        }
    }

    anchors {
        top: parent.top
        topMargin: 250
        left: parent.left
        leftMargin: 85
    }
    width: 415
    height: 150
    radius: 15
    color: Theme.customGray

    //for image also so we can use radius
    Rectangle {
        id: artcontainer

        anchors {
            left: parent.left
            leftMargin: 10
            rightMargin: 10
            top: parent.top
            topMargin: 10
            bottom: parent.bottom
            bottomMargin: 10
        }
        radius: 15
        color: "transparent"
        width: 120
        height: 100
        border.color: Theme.white
        border.width: 2

        Image {
            id: playerArt
            anchors.fill: parent
            anchors.margins: 3.5
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
            smooth: true
            clip: true
            source: player ? player.trackArtUrl : "../icons/music.png" 
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Rectangle {
                    width: playerArt.width
                    height: playerArt.height
                    radius: 12
                }
            }
        }
    }
    Text {
        anchors {
            left: parent.left
            leftMargin: 145
            right: dashboardMedia.right
            top: parent.top
            topMargin: 22
        }
        elide: Text.ElideRight
        text: player ? player.trackTitle + (player.trackAlbum ? " — " + player.trackAlbum : "") : "Play Something"
        font.bold: true
        font.pixelSize: 20
    }
    Sliderr {
        handle: Item {
            visible: false
        }
        from: 0
        value: player.position
        onMoved: {
            player.position = value;
        }

        height: 10
        width: 200
        anchors {
            top: parent.top
            left: parent.left
            leftMargin: 145
            topMargin: 70
            right: dashboardMedia.right
            rightMargin: 15
        }
        backgroundColor: "white"
        rounding: 5

        Row {
            Text {
                id: liveposition
                anchors {
                    top: parent.top
                    topMargin: 15
                }
                font.bold: true
                text: {
                    if (dashboardMedia.currentPosition <= 0)
                        return "0:00";
                    let totalSeconds = Math.floor(dashboardMedia.currentPosition);
                    let minutes = Math.floor(totalSeconds / 60);
                    let seconds = totalSeconds % 60;
                    return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds);
                }
            }
        }
        Row {
            anchors {
                left: parent.left
                top: parent.top
                topMargin: 40
            }

            spacing: 25

            Rectangle {
                id: first
                width: 30
                height: 25
                radius: 10
                color: Theme.customGray

                Text {
                    anchors.centerIn: parent
                    text: "󰼥"
                    font.pixelSize: 24
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        player.previous();
                    }
                }
            }

            Rectangle {
                id: second
                width: first.width
                height: first.height
                radius: first.radius
                color: Theme.customGray
                Text {
                    anchors.centerIn: parent
                    text: player ? (player.playbackState === MprisPlaybackState.Paused ? "" : "") : ""
                    font.pixelSize: 21
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        player.togglePlaying();
                    }
                }
            }

            Rectangle {
                id: third
                width: second.width
                height: second.height
                radius: second.radius
                color: Theme.customGray
                Text {
                    anchors.centerIn: parent
                    font.pixelSize: 24
                    text: "󰼦"
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        player.next();
                    }
                }
            }
            
                AnimatedImage {
                    width: 28
                    height: 28

                    source: "../icons/kurukuru.gif"
                }
        }
    }
}
