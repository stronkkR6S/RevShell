pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Services.Pam

ShellRoot {
    id: root

    FileView {
        path: root.wallpaperPath

        watchChanges: true

        onFileChanged: {
            root.wallpaperVersion++;
        }
    }
    property bool locked: false
    property string passwordText: ""
    property int wallpaperVersion: 0
    property string wallpaperPath: Quickshell.env("HOME") + "/.config/quickshell/wallpapers/wallpaper.png"

    signal clearPassword

    function authenticate(text) {
        if (text.length === 0)
            return;
        root.passwordText = text;
        pam.start();
    }

    IpcHandler {
        target: "lockscreen"

        function toggle() {
            root.locked = true;
        }
    }

    PamContext {
        id: pam

        config: "login"

        onPamMessage: {
            if (responseRequired)
                pam.respond(root.passwordText);
        }

        onCompleted: result => {
            if (result === PamResult.Success) {
                root.passwordText = "";
                root.locked = false;
            } else {
                root.passwordText = "";
                root.clearPassword();
            }
        }

        onError: error => {
            console.log("PAM error:", error);

            root.passwordText = "";
            root.clearPassword();
        }
    }

    WlSessionLock {
        id: lock

        locked: root.locked

        onLockedChanged: {
            if (locked)
                root.clearPassword();
        }

        WlSessionLockSurface {
            id: surface
            Rectangle {
                anchors.fill: parent
                color: "#000000"

                clip: true

                Image {
                    id: wallpaper

                    source: root.wallpaperPath + "?" + root.wallpaperVersion

                    anchors.fill: parent
                    anchors.margins: -40

                    fillMode: Image.PreserveAspectCrop

                    smooth: true
                    asynchronous: false
                    // cache: true
                    visible: false
                }

                MultiEffect {
                    id: blurWall

                    anchors.fill: parent
                    source: wallpaper

                    blurEnabled: true
                    blur: 0.6
                    blurMax: 32
                }

                Rectangle {
                    anchors.fill: parent
                    color: "#000000"
                    opacity: 0.20
                }
                Text {
                    text: "TYPE YOUR PASSWORD"
                    font.family: "Orbitron"
                    font.weight: Font.Bold
                    visible: !password.text.length > 0
                    opacity: 0.15
                    font.pixelSize: 20
                    color: Theme.white
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 90
                        right: parent.right
                        rightMargin: 80
                    }
                }
                Text {
                    // i was here
                    text: Quickshell.env("USER").toUpperCase()
                    opacity: 0.8
                    color: "white"
                    font.family: "Orbitron"
                    font.weight: Font.Bold
                    font.letterSpacing: 5
                    font.pixelSize: 35
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 150
                        right: parent.right
                        rightMargin: 80
                    }
                }
                Row {
                    id: clock

                    spacing: 10

                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 230
                        right: parent.right
                        rightMargin: 90
                    }

                    Text {
                        id: hour

                        text: Qt.formatTime(new Date(), "hh")

                        opacity: 0.75
                        color: "white"
                        font.family: "Orbitron"
                        font.letterSpacing: 10
                        font.pixelSize: 35
                    }

                    Text {
                        id: minute

                        text: Qt.formatTime(new Date(), "mm")

                        opacity: 0.75
                        color: "white"
                        font.family: "Orbitron"
                        font.letterSpacing: 10
                        font.pixelSize: 35
                    }

                    Timer {
                        interval: 6000
                        running: true
                        repeat: true

                        onTriggered: {
                            hour.text = Qt.formatTime(new Date(), "hh");
                            minute.text = Qt.formatTime(new Date(), "mm");
                        }
                    }
                }
                Rectangle {
                    //holder for text
                    clip: true

                    width: 200
                    height: 50
                    radius: 20
                    anchors {
                        bottom: parent.bottom
                        bottomMargin: 90
                        right: parent.right
                        rightMargin: 65
                    }
                    // anchors.horizontalCenter: parent.horizontalCenter
                    color: "transparent"

                    TextInput {
                        id: password

                        anchors.centerIn: parent
                        anchors.leftMargin: 15
                        anchors.rightMargin: 15
                        font.pixelSize: 18
                        font.family: "Orbitron"
                        font.weight: Font.Bold
                        color: "#E8EEEE"
                        cursorDelegate: password.text.length > 0 ? defaultCursor : hiddenCursor

                        Component {
                            id: hiddenCursor
                            Item {} // Invisible cursor
                        }

                        Component {
                            id: defaultCursor
                            Item {
                                width: 8
                                height: password.font.pixelSize

                                Rectangle {
                                    x: 2
                                    width: 3
                                    height: parent.height
                                    color: password.color

                                    SequentialAnimation on opacity {
                                        loops: Animation.Infinite
                                        NumberAnimation {
                                            to: 0
                                            duration: 500
                                        }
                                        NumberAnimation {
                                            to: 1
                                            duration: 500
                                        }
                                    }
                                }
                            }
                        }

                        verticalAlignment: TextInput.AlignVCenter
                        focus: true
                        echoMode: TextInput.Password
                        passwordCharacter: "◆"
                        font.letterSpacing: 10

                        onTextChanged: {
                            if (text !== root.passwordText && root.passwordText === "")
                                return;
                        }

                        Connections {
                            target: root

                            function onClearPassword() {
                                password.clear();
                                password.forceActiveFocus();
                            }
                        }

                        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                root.authenticate(text);
                                event.accepted = true;
                            }
                        }

                        Component.onCompleted: {
                            forceActiveFocus();
                        }
                    }
                }
            }
        }
    }
}
