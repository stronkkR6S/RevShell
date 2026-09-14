import QtQuick
import QtQuick.Layouts
import Quickshell.Io

// without any quickshell module

Item {
    id: allroot
    anchors.fill: parent

    property string isMuted: ""
    property int volumeLevel: 0
    property string isHeadphone: ""
    property string isHeadphoneMuted: ""

    property string volumeIcon: {
        if (volumeLevel === 0) {
            return "";
        } else if (volumeLevel <= 50) {
            return "";
        } else {
            return "󰕾";
        }
    }

    Process {
        id: volumescript
        running: true

        command: ["sh", "-c", "~/.config/quickshell/scripts/volume.sh"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text.trim());

                    allroot.volumeLevel = data.volume;
                    allroot.isMuted = data.state;
                    allroot.isHeadphone = data.headphone;
                    allroot.isHeadphoneMuted = data.headphonemuted;
                } catch (e) {
                    console.log("Error:", e);
                }
            }
        }
    }

    Timer {
        interval: 200
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: volumescript.running = true
    }

    Rectangle {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 135
        }
        height: 34
        width: 110
        radius: 25

        color: volumeMouseArea.containsMouse ? Theme.cyan : Theme.blue

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 13
            anchors.rightMargin: 10

            Item {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

                implicitWidth: volumeLayout.implicitWidth
                implicitHeight: volumeLayout.implicitHeight
                RowLayout {
                    id: volumeLayout

                    anchors.fill: parent
                    spacing: 4

                    // VOLUME
                    Item {
                        implicitWidth: volumeContent.implicitWidth
                        implicitHeight: volumeContent.implicitHeight

                        RowLayout {
                            id: volumeContent
                            spacing: 4

                            Text {
                                text: {
                                    if (allroot.isHeadphoneMuted === "MUTED")
                                        return "󰟎";

                                    if (allroot.isHeadphone === "Headphones")
                                        return "󰋋";

                                    if (allroot.isMuted === "MUTED")
                                        return "";

                                    return allroot.volumeIcon;
                                }

                                font.pixelSize: 22
                            }

                            Text {
                                text: allroot.volumeLevel
                                font.pixelSize: 17
                                color: Theme.foreground
                            }
                        }

                    //volume area
                        MouseArea {
                            id: volumeMouseArea

                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                mutetoggle.running = true;
                            }

                            onWheel: function (wheel) {
                                if (wheel.angleDelta.y > 0) {
                                    volumeUp.running = true;
                                } else if (wheel.angleDelta.y < 0) {
                                    volumeDown.running = true;
                                }
                            }

                            Process {
                                id: mutetoggle
                                running: false

                                command: ["sh", "-c", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"]
                            }

                            Process {
                                id: volumeUp

                                command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "-l", "1", "2%+"]
                            }

                            Process {
                                id: volumeDown

                                command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "2%-"]
                            }
                        }
                    }

                    // Gap betwen volume and microphone
                    Item {
                        Layout.preferredWidth: 7
                    }

                    // Microphone 
                    Microphone {
                        id: microphone

                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
        }
    }
}
