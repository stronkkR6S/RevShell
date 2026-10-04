// pragma Singleton
import Quickshell
import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Effects

Slider {
    id: slider

    property color handleColor: Theme.blue
    property color textColor: Theme.blue
    property color backgroundColor: Theme.customGray
    property int rounding: 7

    from: 0
    to: 100

    height: Theme.dashboard_slider_height
    width: Theme.dashboard_slider_width

    background: Rectangle {
        color: slider.backgroundColor
        radius: slider.rounding
        height: slider.height

        Rectangle {
            width: slider.visualPosition * parent.width
            height: slider.height
            radius: parent.radius
            color: slider.handleColor
        }
    }

    handle: Item {

        x: slider.visualPosition * (slider.availableWidth - width +8 )

        y: slider.topPadding + slider.availableHeight / 2 - height / 2

        Rectangle {
            id: handle
            visible: !slider.pressed
            anchors.centerIn: parent
            height: 45
            width: 5
            color: slider.handleColor
            radius: 10

        }

        AnimatedImage {
            anchors.centerIn: parent

            width: 26
            height: 26

            visible: slider.pressed
            playing: slider.pressed

            source: "../icons/kurukuru.gif"
        }
    }
}
