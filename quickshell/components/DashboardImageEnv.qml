import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Rectangle {
    id: root

    property int wallpaperVersion: 0
    property string wallpaperPath: Quickshell.env("HOME") + "/.config/quickshell/wallpapers/wallpaper.png"

    anchors {
        top: parent.top
        topMargin: 40
        left: parent.left
        leftMargin: 70
    }

    height: 140
    width: 450
    radius: Theme.module_radius
    color: "transparent"
    clip: true

    FileView {
        path: root.wallpaperPath
        watchChanges: true

        onFileChanged: {
            root.wallpaperVersion++;
        }
    }

    Image {
        id: image

        anchors.fill: parent
        //internally wallpaper.png?1 2 3...
        source: root.wallpaperPath + "?" + root.wallpaperVersion
        cache: true
        smooth: true
        fillMode: Image.PreserveAspectCrop
        visible: false
    }

    OpacityMask {
            id: radiusImage
        anchors.fill: parent

        source: blurredImage

        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: root.radius
        }
    }
    MultiEffect {
        id: blurredImage

        anchors.fill: parent

        source: image

        blurEnabled: true
        blur: 0.3
        blurMax: 32

        visible: false
    }

    Rectangle {
        id: overlay

        anchors.fill: parent
        radius: root.radius

        anchors {
            left: parent.left
            top: parent.top
        }

        gradient: Gradient {
            orientation: Gradient.Horizontal

            GradientStop {
                position: 0.0
                color: "#C0000000"
            }

            GradientStop {
                position: 0.6
                color: "#60000000"
            }

            GradientStop {
                position: 0.7
                color: "transparent"
            }
        }
    }
    DashboardEnv{}
    DashboardWeather{}
}
