import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Rectangle {
    id: power
    height: 220
    width: 215
    radius: 20
    color: Theme.customGray

    anchors {
        top: parent.top
        topMargin: 40
        right: parent.right
        rightMargin: 10
    }
    Rectangle {
        height: 57
        width: 57
        radius: 30
        color: "#29AB87"
        anchors {
            top: parent.top
            topMargin: 15
            left: parent.left
            leftMargin: 10
        }
        Text {
            anchors.centerIn: parent
            text: "󰌪"
            color: "black"
            font.pixelSize: 35
        }
        Text {
            text: "Power Profile"
            font.pixelSize: 17
            color: Theme.white
            anchors {
                left: parent.left
                leftMargin: 70
                top: parent.top
                topMargin: 8
            }
        }
        Text {
            text: PowerProfile.toString(PowerProfiles.profile)
            font.pixelSize: 15
            anchors {
                left: parent.left
                leftMargin: 70
                top: parent.top
                topMargin: 30
            }
        }
    }

    ColumnLayout {
        spacing: 15
        anchors {
            top: parent.top
            topMargin: 100
            left: parent.left
            leftMargin: 20
        }
        Rectangle {
        id: performance
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            color: "transparent"
            border.width: 3
            border.color: Theme.modulefg
            radius: 20
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Quickshell.execDetached(["powerprofilesctl", "set", "performance"]);
                }
            }
            Rectangle {
                anchors.centerIn: parent
                visible: PowerProfile.toString(PowerProfiles.profile) === "Performance"
                height: 13
                width: 13
                radius: 10
                color: Theme.modulefg
            }
        }
        Rectangle {
        id: balanced
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            color: "transparent"
            border.width: 3
            border.color: Theme.modulefg
            radius: 20
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Quickshell.execDetached(["powerprofilesctl", "set", "balanced"]);
                }
            }
            Rectangle {
                anchors.centerIn: parent
                visible: PowerProfile.toString(PowerProfiles.profile) === "Balanced"
                height: 13
                width: 13
                radius: 10
                color: Theme.modulefg
            }
        }
        Rectangle {
        id: powersaver
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            color: "transparent"
            border.width: 3
            border.color: Theme.modulefg
            radius: 20
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    Quickshell.execDetached(["powerprofilesctl", "set", "power-saver"]);
                }
            }
            Rectangle {
                anchors.centerIn: parent
                visible: PowerProfile.toString(PowerProfiles.profile) === "PowerSaver"
                height: 13
                width: 13
                radius: 10
                color: Theme.modulefg
            }
        }
    }

    ColumnLayout {
        spacing: 15
        anchors {
            top: parent.top
            topMargin: 101
            left: parent.left
            leftMargin: 60
        }
        Text {
            text: "Performance"
            font.pixelSize: 17
        }
        Text {
            text: "Balanced"
            font.pixelSize: 17
        }
        Text {
            text: "Power Saver"
            font.pixelSize: 17
        }
    }
}
