import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Controls

Rectangle {
    id: background
    property bool wifiEnabled: true
    property string currentSsid: "  "
    property string currentState: "offline"
    property int currentSignal: 0

    height: 105
    width: 254
    color: Theme.customGray
    radius: 20

    anchors {
        top: parent.top
        topMargin: 40
        left: parent.left
        leftMargin: 60
    }

    Switch {
        id: control
        checked: background.wifiEnabled
        z: 1

        onToggled: {
            background.wifiEnabled = control.checked;
            Quickshell.execDetached(["rfkill", "toggle", "wifi"]);
        }
          HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

        anchors {
            top: parent.top
            topMargin: 10
            right: parent.right
        }

        indicator: Rectangle {
            implicitWidth: 55
            implicitHeight: 26
            x: control.leftPadding
            y: parent.height / 2 - height / 2
            radius: height / 2
            color: control.checked ? Theme.blue : Theme.modulefg
            border.color: control.checked ? "#1976D2" : "#BDBDBD"

            Rectangle {
                x: control.checked ? parent.width - width - 2 : 2

                y: parent.height / 2 - height / 2
                width: 22
                height: 22
                radius: 15
                color: "#FFFFFF"

                Behavior on x {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }
        }
    }

    Rectangle {
        height: 57
        width: 57
        radius: 30
        color: background.wifiEnabled ? Theme.blue : "#a6a6a6"
        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: 10
        }

        Text {
            text: ""
            anchors.centerIn: parent
            font.pixelSize: 30
        }

        Text {
            text: "Wi-Fi"
            font.pixelSize: 17
            color: Theme.white
            anchors {
                left: parent.left
                leftMargin: 70
                top: parent.top
                topMargin: 8
            }
        }
    }
    Process {
        id: networkfrontend
        running: true

        command: ["sh", "-c", "~/.config/quickshell/scripts/network.sh"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    // Trim \n
                    let data = JSON.parse(this.text.trim());

                    background.currentSsid = data.ssid;
                    background.currentState = data.state;
                    background.currentSignal = data.signal;
                } catch (e) {
                    console.log("JSON parse error");
                }
            }
        }
    }

    Text {
        text: background.currentSsid
        font.pixelSize: 15
        anchors {
            left: parent.left
            leftMargin: 80
            top: parent.top
            topMargin: 40
        }
    }

    Text {
        font.pixelSize: 15
        anchors {
            left: parent.left
            leftMargin: 80
            top: parent.top
            topMargin: 60
        }
    }
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: networkfrontend.running = true
    }

    Text {
        text: background.wifiEnabled ? "›" : ""
        font.pixelSize: 35
        anchors {
            left: parent.left
            leftMargin: 220
            top: parent.top
            topMargin: 50
        }
        MouseArea {
            id: menuopener
            anchors.fill: parent
            //Todo make menu opener when clicked >
        }
    }
}
