import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Effects

Rectangle {
    id: root
    property bool isNightLight: false
    property int gammastepvalue: 3500
    height: 125
    width: 254
    radius: 20
    anchors {
        bottom: parent.bottom
        bottomMargin: 155
        left: parent.left
        leftMargin: 60
    }

    Process {
        id: gammastepProcess

        command: ["gammastep", "-O", Math.round(slider.value).toString()]
        running: root.isNightLight
        onRunningChanged: {
            if (!running && root.isNightLight) {
                running = true;
            }
        }
    }

    Process {
        id: resetProcess
        command: ["gammastep", "-x"]
        running: !root.isNightLight
    }
    color: Theme.customGray

    Rectangle {
        height: 57
        width: 57
        radius: 30
        color: root.isNightLight ? "#9B8CF4" : Theme.modulefg
        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: 10
        }

        Text {
            text: "󰖔"
            anchors.centerIn: parent
            font.pixelSize: 35
        }

        Text {
            text: "Night Light"
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

    Switch {
        id: control
        checked: root.isNightLight
        z: 1

        onToggled: {
            root.isNightLight = control.checked;

if (gammastepProcess.running) {
                gammastepProcess.running = false;
                gammastepProcess.running = true;
            }
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
    Text {
        text: "󰖨"
        color: root.isNightLight ? "#9B8CF4" : "#E8F0F0"
        font.pixelSize: 25
        anchors {
            top: parent.top
            topMargin: 78
            left: parent.left
            leftMargin: 7
        }
    }
    Slider {
        id: slider

        width: 180
        height: 15
        enabled: root.isNightLight

        anchors {
            top: parent.top
            topMargin: 87
            horizontalCenter: parent.horizontalCenter
        }

        from: 3000
        to: 6500
        value: 3500
        stepSize: 100
        onValueChanged: {
        root.gammastepvalue = Math.round(slider.value);
        if (gammastepProcess.running) {
                gammastepProcess.running = false;
                gammastepProcess.running = true;
            }
        }

        background: Rectangle {
            anchors.fill: parent

            radius: 20
            color: Theme.modulefg

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height

                radius: 20
                color: "#9B8CF4"
            }
        }

        handle: Rectangle {
            visible: root.isNightLight
            x: slider.leftPadding - 5 + slider.visualPosition * (slider.availableWidth - width + 10)

            y: slider.topPadding + slider.availableHeight / 2 - height / 2

            width: 25
            height: 25
            radius: 20

            color: "#E8F0F0"
        }
    }
}
