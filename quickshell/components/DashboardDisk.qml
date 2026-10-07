import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import QtQuick.Shapes

Item {
    id: root

    width: 170
    height: 170
    property real totaldiskUsage: 0
    property real useddiskUsage: 0
    property real perdiskUsage: 0
    property real availabldiskUsage: 0


property real totalSweep: perdiskUsage* 3

Behavior on totalSweep {
    NumberAnimation {
        duration: 800
        easing.type: Easing.OutCubic
    }
}

property real firstAngle: Math.min(totalSweep, 100)
property real secondAngle: Math.min(Math.max(totalSweep - 100, 0), 100)
property real thirdAngle: Math.min(Math.max(totalSweep - 200, 0), 100)

    anchors {
        top: parent.top
        topMargin: 370
        left: parent.left
        leftMargin: 210
    }

    Shape {
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            strokeColor: Theme.customGray
            strokeWidth: 10
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap

            PathAngleArc {
                centerX: 85
                centerY: 85
                radiusX: 80
                radiusY: 80
                startAngle: -90
                sweepAngle: 100
            }

            PathAngleArc {
                centerX: 85
                centerY: 85
                radiusX: 80
                radiusY: 80
                startAngle: 30
                sweepAngle: 100
            }

            PathAngleArc {
                centerX: 85
                centerY: 85
                radiusX: 80
                radiusY: 80
                startAngle: 150
                sweepAngle: 100
            }
        }
    }

    Text {
        anchors.centerIn: parent
        text: root.perdiskUsage + "  "
        font.pixelSize: 30
    }
    ColumnLayout {
    Text {
        text: "DISK: " + root.useddiskUsage + "G"
        font.pixelSize: 15

        Layout.topMargin: 105
        Layout.leftMargin: 50
    }
}
    Item {

        width: 170
        height: 170

        anchors {
            centerIn: parent
        }

        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                strokeColor: Theme.cyan
                strokeWidth: 10
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                PathAngleArc {
                    centerX: 85
                    centerY: 85
                    radiusX: 80
                    radiusY: 80
                    startAngle: -90
                    sweepAngle: root.firstAngle
                }

                PathAngleArc {
                    centerX: 85
                    centerY: 85
                    radiusX: 80
                    radiusY: 80
                    startAngle: 30
                    sweepAngle: root.secondAngle
                }

                PathAngleArc {
                    centerX: 85
                    centerY: 85
                    radiusX: 80
                    radiusY: 80
                    startAngle: 150
                    sweepAngle: root.thirdAngle
                }
            }
        }
    }

    Process {
        id: diskStats

        command: ["sh", "-c", "~/.config/quickshell/scripts/diskusage.sh"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text.trim())
                    root.totaldiskUsage=data.total
                    root.perdiskUsage=data.use_percent
                    root.useddiskUsage=data.used


                } catch (e) {
                    console.log("JSON parse error")
                }
            }
        }
    }


    Timer {
        interval: 300000
        running: true
        repeat: true

        onTriggered: diskStats.running = true
    }
}
