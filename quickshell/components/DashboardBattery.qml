import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Rectangle {
    id: root
    property bool checkbattery: UPower.displayDevice.isLaptopBattery
    property int totalSeconds: UPower.displayDevice.timeToEmpty
    property string charging: UPowerDeviceState.toString(UPower.displayDevice.state)
    property int chargeLevel: UPower.displayDevice.percentage * 100
    property int energyLevel: UPower.displayDevice.energyCapacity
    height: 140
    width: 254
    radius: 20
    color: Theme.customGray
    anchors {
        bottom: parent.bottom
        bottomMargin: 5
        left: parent.left
        leftMargin: 60
    }
    Rectangle {
        height: 57
        width: 57
        radius: 30
        color: "#29AB87"
        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: 10
        }

        Text {
            text: ""
            anchors.centerIn: parent
            font.pixelSize: 30
        }

        Text {
            text: "Battery"
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

    Text {
        text: root.energyLevel + "Wh" 

        font.pixelSize: 16
        anchors {
            left: parent.left
            leftMargin: 80
            top: parent.top
            topMargin: 40
        }
    }

    function formatTime(seconds) {
        let hours = Math.floor(seconds / 3600);
        let minutes = Math.floor((seconds % 3600) / 60);

        let hStr = String(hours).padStart(2, '0');
        let mStr = String(minutes).padStart(2, '0');

        return `${hStr}:${mStr}`;
    }
    Slider {
        id: control

        anchors{
            top: parent.top
            topMargin: 75
        }
        anchors.horizontalCenter: parent.horizontalCenter 

        from: 0
        to: 100
        value: root.chargeLevel
        enabled: false
        background: Rectangle {
            x: control.leftPadding
            y: control.topPadding + control.availableHeight / 2 - height / 2
            implicitWidth: 220
            implicitHeight: 15
            radius: 20
            color: Theme.modulefg
        }
        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: "#29AB87"
            radius: 20
        }

        handle: Item {
            visible: false
        }
    }
    Text{
        text: root.checkbattery ? (root.charging === "Charging" ? "" : "") : "No Battery" 
        font.pixelSize: 25
        anchors {
            left: parent.left
            leftMargin: 35
            top: parent.top
            topMargin: 100
        }
    }
    Text {
        text: root.checkbattery ? (root.charging === "Charging" ? "  Charging" : formatTime(UPower.displayDevice.timeToEmpty) + "m" + " remaining") : "No Battery"
        font.pixelSize: 16
        anchors {
            left: parent.left
            leftMargin: 52
            top: parent.top
            topMargin: 105
        }
    }

}
