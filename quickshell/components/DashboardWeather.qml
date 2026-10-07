import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    height: 100
    width: 220
    radius: Theme.module_radius
    color: "transparent"

    property int weatherCode: -1
    property real temperature: 0

    function weatherIcon(code) {
        switch (code) {
        case 0:
            return "☀";
        case 1:
        case 2:
            return "";
        case 3:
            return "☁";
        case 45:
        case 48:
            return "󰖑";
        case 51:
        case 53:
        case 55:
            return ""
        case 61:
        case 63:
        case 65:
            return "🌧";
        case 80:
        case 81:
        case 82:
            return "🌦";
        case 95:
        case 96:
        case 99:
            return "";
        default:
            return "?";
        }
    }

    function weatherCondition(code) {
        switch (code) {
        case 0:
            return "Clear sky";
        case 1:
            return "Mainly clear";
        case 2:
            return "Partly cloudy";
        case 3:
            return "Overcast";
        case 45:
        case 48:
            return "Fog";
        case 51:
        case 53:
        case 55:
            return "Drizzle";
        case 61:
        case 63:
        case 65:
            return "Rain";
        case 71:
        case 73:
        case 75:
            return "Snow";
        case 80:
        case 81:
        case 82:
            return "Rain showers";
        case 95:
            return "Thunderstorm";
        case 96:
        case 99:
            return "TS w/ Hail";
        default:
            return "Unknown";
        }
    }

    anchors {
        top: parent.top
        topMargin: 10
        left: parent.left
        leftMargin: 50
    }

    Process {
        id: weatherProcess

        command: ["sh", "-c", "~/.config/quickshell/scripts/weather.sh"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text.trim());

                    root.weatherCode = Number(data.weathercode);
                    root.temperature = Number(data.temperature);
                } catch (e) {
                    console.log("JSON parse error:", e);
                }
            }
        }
    }
Timer {
    interval: 10000
    running: true
    repeat: false

    onTriggered: weatherProcess.running = true
}

    Timer {
        interval: 900000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: weatherProcess.running = true
    }

    Text {
        anchors {
            verticalCenter: parent.verticalCenter
            left: parent.left
            leftMargin: 20
        }

        text: root.weatherIcon(root.weatherCode)

        font.pixelSize: 60
        color: "transparent"
    }

    Text {
        anchors {
            top: parent.top
            topMargin: 20
            left: parent.left
            leftMargin: 90
        }

        text: Math.round(root.temperature)

        font.pixelSize: 35
        color: "#E6E6E6"
    }
    Text {
        anchors {
            top: parent.top
            topMargin: 20
            left: parent.left
            leftMargin: 130
        }

        text: " °C"

        font.pixelSize: 30
        color: "#E6E6E6"
    }
    Text {
        anchors {
            top: parent.top
            topMargin: 65
            left: parent.left
            leftMargin: 90
        }

        text: root.weatherCondition(root.weatherCode)
        color: "#E6E6E6"

        font.pixelSize: 15
    }
}
