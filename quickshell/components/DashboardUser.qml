import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell

Rectangle {
    id: welcomeCard
    property int hour: new Date().getHours()

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: hour = new Date().getHours()
    }

    color: Theme.customGray
    radius: Theme.dashboard_modules_radius

    Text {
        id: timeGreeting

        text: {
            if (hour < 12)
                return "Good Morning";
            else if (hour < 17)
                return "Good Afternoon";
            else if (hour < 21)
                return "Good Evening";
            else
                return "Good Night";
        }

        anchors {
        horizontalCenter: parent.horizontalCenter
          horizontalCenterOffset: 200
            top: parent.top
            topMargin: 18
        }

        font.pixelSize: 15
        font.italic: true
        color: Theme.gray
    }

    Text {
        id: username

        text: "Hello, " + Quickshell.env("USER").charAt(0).toUpperCase() + Quickshell.env("USER").slice(1) + "!"

        anchors {
            top: timeGreeting.bottom
            topMargin: 4
        horizontalCenter: parent.horizontalCenter
          horizontalCenterOffset: 280
        }

        font.pixelSize: 23
        font.bold: true
        font.italic: true
        color: Theme.black
    }

    Text {
        text: "Welcome back."

        anchors {
            top: username.bottom
            topMargin: 5
        horizontalCenter: parent.horizontalCenter
          horizontalCenterOffset: 350
        }

        font.pixelSize: 15
        color: Theme.gray
        font.italic: true
    }

    // Image {
    //     source: "../icons/deer.png"

    //     width: 75
    //     height: 75

    //     anchors {
    //         right: parent.right
    //         verticalCenter: parent.verticalCenter
    //         rightMargin: 12
    //     }

    //     fillMode: Image.PreserveAspectFit
    // }
}
