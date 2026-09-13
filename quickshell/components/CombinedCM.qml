import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Services.Mpris
import Qt5Compat.GraphicalEffects

Item {
    id: box

    anchors.fill: parent

    property var player: Mpris.players.values[0]

    SwipeView {
        id: swipe

        height: 34
        width: currentIndex === 0 ? 120 : 190

        anchors.centerIn: parent
        clip: true

        Behavior on width {
            NumberAnimation {
                duration: 300
                easing.type: Easing.OutCubic
            }
        }

        // Clock
        Item {
            id: swipeclock

            width: swipe.width
            height: swipe.height

            Rectangle {
                anchors.fill: parent
                color: Theme.vibrantOrange
                radius: 20
            }

            Text {
                id: clock

                color: Theme.foreground

                anchors.centerIn: parent

                font.pixelSize: 23
                font.italic: true
                font.bold: true
                font.letterSpacing: 3.5
            }

            Timer {
                interval: 1000
                running: true
                repeat: true

                onTriggered: {
                    clock.text = Qt.formatTime(new Date(), "h:mm ap").replace(/ am| pm/i, "");
                }
            }
        }

        // Current media
        Item {
            id: swipemedia

            clip: true

            Rectangle {
                anchors.fill: parent
                height: 34
                visible: Mpris.players.values.length > 0

                color: Theme.vibrantOrange
                radius: 20
            }

            RowLayout {
                anchors.centerIn: parent
                spacing: 12

                Image {
                    id: playerArt // Added an ID for safe scoping
                    visible: Mpris.players.values.length > 0
                    Layout.preferredWidth: visible ? 60 : 0
                    Layout.preferredHeight: visible ? 30 : 0

                    source: player ? player.trackArtUrl : ""

                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    smooth: true

                    //we need layer for radius in picture
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle {
                            width: playerArt.width
                            height: playerArt.height
                            radius: 9
                        }
                    }
                }

                // Previous
                Text {
                    visible: Mpris.players.values.length > 0
                    text: "󰒮"
                    color: Theme.foreground
                    font.pixelSize: 28

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            player.previous();
                        }
                    }
                }

                // Play / Pause
                Text {
                    visible: Mpris.players.values.length > 0
                    text: player.playbackState === MprisPlaybackState.Paused ? "" : ""

                    color: Theme.foreground
                    font.pixelSize: 22

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            player.togglePlaying();
                        }
                    }
                }

                // Next
                Text {
                    visible: Mpris.players.values.length > 0
                    text: "󰒭"
                    color: Theme.foreground
                    font.pixelSize: 28

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            player.next();
                        }
                    }
                }
            }
        }
    }
}
