import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Shapes

Item {
    id: root

    width: 170
    height: 170
    property real totalmemoryUsage: 0
    property real usedmemoryUsage: 0
    property real permemoryUsage: 0
    property real availableemoryUsage: 0


property real totalSweep: permemoryUsage* 3

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
        topMargin: 170
        left: parent.left
        leftMargin: 330
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
        text: root.permemoryUsage + " "
        font.pixelSize: 30
    }
    Text {
        anchors {
            top: parent.top
            topMargin: 105
            left: parent.left
            leftMargin: 50
        }
        text: "MEMU: " + root.usedmemoryUsage
        font.pixelSize: 15
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
                strokeColor: Theme.vibrantOrange
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
        id: memoryStats

        command: ["sh", "-c", "~/.config/quickshell/scripts/memoryusage.sh"]
        running: true

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    let data = JSON.parse(this.text.trim())
                    root.totalmemoryUsage=data.total_mem_gb
                    root.usedmemoryUsage=data.used_mem_gb
                    root.permemoryUsage=data.used_percent
                    root.availableemoryUsage=data.available_mem_gb

                } catch (e) {
                    console.log("JSON parse error")
                }
            }
        }
    }


    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: memoryStats.running = true
    }
}
