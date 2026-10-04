import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root
    Timer {
    interval: 60000
    running: true
    repeat: true

    onTriggered: root.currentDate = new Date()
}

    property var currentDate: new Date()

    property int date: currentDate.getDate()
    property int month: currentDate.getMonth()
    property int year: currentDate.getFullYear()
    property int day: currentDate.getDay()

    height: 100
    width: 220
    radius: 30
    color: Theme.customGray
    anchors {
        top: parent.top
        topMargin: 40
        left: parent.left
        leftMargin: 310
    }

    Text {
    anchors {
        top: parent.top
        topMargin: 15
        left: parent.left
        leftMargin: 15
    }
    text: root.currentDate.toLocaleDateString(Qt.locale(), "MMMM yy").toUpperCase()
        font.pixelSize: 15
    }

    Text {
        text: root.date
    anchors {
        top: parent.top
        topMargin: 15
        left: parent.left
        leftMargin: 145
    }
        font.pixelSize: 15
    }
    Text {
        text: "[" + root.currentDate.toLocaleDateString(Qt.locale(), "ddd").toUpperCase() + "]"
    anchors {
        top: parent.top
        topMargin: 15
        left: parent.left
        leftMargin: 165
    }
        font.pixelSize: 15
    }

    Rectangle{
        anchors.centerIn: parent
        color: Theme.black
    Text {
    text: "······························"
    anchors.centerIn: parent
     font.pixelSize: 25
}
    }

Row {
    anchors {
        top: parent.top
        topMargin: 65
        left: parent.left
        leftMargin: 10
    }

    spacing: 12

    Repeater {
        model: 7

        delegate: Text {
            property var calendarDate: {
                var d = new Date(root.year, root.month, root.date - 3 + index)
                return d
            }

            property bool isToday:
                calendarDate.getDate() === root.date &&
                calendarDate.getMonth() === root.month &&
                calendarDate.getFullYear() === root.year

            text: isToday
                ? `[${calendarDate.getDate()}]`
                : `${calendarDate.getDate()}`

            font.pixelSize: 15
        }
    }
}
}
