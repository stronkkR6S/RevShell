import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Qt5Compat.GraphicalEffects

Rectangle {
    id: dashboardMedia

    // property var choosesource: Mpris.players.values
    // property var player: Mpris.players.values[0]
    //
    property var players: Mpris.players.values
    property int sourceIndex: 0
    property var player: players.length > 0 ? players[sourceIndex] : null

    FrameAnimation {
        running: dashboardMedia.player && dashboardMedia.player.playbackState === MprisPlaybackState.Playing
        onTriggered: dashboardMedia.player.positionChanged()
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
            source: dashboardMedia.player ? dashboardMedia.player.trackArtUrl : "../icons/music.png"
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
        text: dashboardMedia.player ? dashboardMedia.player.trackTitle + (dashboardMedia.player.trackAlbum ? " — " + dashboardMedia.player.trackAlbum : "") : "Play Something"
        font.bold: true
        font.pixelSize: 20
    }
    Sliderr {
        handle: Item {
            visible: false
        }
        from: 0
        to: dashboardMedia.player ? dashboardMedia.player.length : 0
        value: dashboardMedia.player.position

        onMoved: {
            if (dashboardMedia.player)
                dashboardMedia.player.position = value;
        }

        onPressedChanged: {
            if (!dashboardMedia.player)
                return;
            if (pressed) {
                dashboardMedia.player.pause();
            } else {
                dashboardMedia.player.play();
            }
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
                function formatTime(seconds) {
                    if (seconds <= 0)
                        return "0:00";

                    var totalSeconds = Math.floor(seconds);
                    var minutes = Math.floor(totalSeconds / 60);
                    var secs = totalSeconds % 60;

                    return minutes + ":" + (secs < 10 ? "0" + secs : secs);
                }
                anchors {
                    top: parent.top
                    topMargin: 15
                }
                font.bold: true
                text: dashboardMedia.player ? formatTime(dashboardMedia.player.position) : "0:00"
            }
            Text {
                id: totalLength
                function formatTime(seconds) {
                    if (seconds <= 0)
                        return "0:00";

                    var totalSeconds = Math.floor(seconds);
                    var minutes = Math.floor(totalSeconds / 60);
                    var secs = totalSeconds % 60;

                    return minutes + ":" + (secs < 10 ? "0" + secs : secs);
                }
                anchors {
                    top: parent.top
                    topMargin: 15
                    left: parent.left
                    leftMargin: 230
                }
                text: dashboardMedia.player ? formatTime(dashboardMedia.player.length) : "0:00"
                font.bold: true
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
                        dashboardMedia.player.previous();
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
                    text: dashboardMedia.player ? (dashboardMedia.player.playbackState === MprisPlaybackState.Paused ? "" : "") : ""
                    font.pixelSize: 21
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        dashboardMedia.player.togglePlaying();
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
                        dashboardMedia.player.next();
                    }
                }
            }

            AnimatedImage {
                width: 28
                height: 28

                source: "../icons/kurukuru.gif"
            }
            Rectangle {
                id: sourceButton

                width: 32
                height: 32
                radius: 8
                color: "transparent"

                Image {
                    anchors.centerIn: parent
                    width: 20
                    height: 20
                    function playerIcon(identity) {
                        let id = identity.toLowerCase();

                        if (id === "mozilla firefox")
                            return "file:///usr/share/icons/Papirus/32x32/apps/firefox.svg";

                        if (id === "spotify")
                            return "file:///usr/share/icons/Papirus/32x32/apps/spotify.svg";

                        if (id === "music player daemon")
                            return "file:///usr/share/icons/Papirus/32x32/apps/mpd.svg";

                        if (id === "vlc media player")
                            return "file:///usr/share/icons/Papirus/32x32/apps/vlc.svg";

                        if (id === "mpv")
                            return "file:///usr/share/icons/Papirus/32x32/apps/mpv.svg";

                        if (id === "strawberry")
                            return "file:///usr/share/icons/Papirus/32x32/apps/strawberry.svg";

                        return "";
                    }

                    source: playerIcon(dashboardMedia.player.identity)
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        let players = Mpris.players.values;

                        if (players.length === 0)
                            return;

                        let current = players.indexOf(dashboardMedia.player);
                        let next = players[(current + 1) % players.length];
                        //pause before switching
                        if (dashboardMedia.player)
                            dashboardMedia.player.pause();

                        dashboardMedia.player = next;
                    }
                }
            }
        }
    }
}
