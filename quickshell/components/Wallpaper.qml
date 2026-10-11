import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: wallpaper

    property url wallpaperPath: Qt.resolvedUrl("../wallpapers/wallpaper.png")
    property int wallpaperVersion: 0
    property bool updatingBackground: false

    IpcHandler {
        target: "wallpaper"

        function reload(): void {
            wallpaper.wallpaperVersion++;

            fade.stop();
            overlay.opacity = 0;
            overlay.source = wallpaper.wallpaperPath + "?" + wallpaper.wallpaperVersion;
        }
    }

    anchors {
        left: true
        right: true
        top: true
        bottom: true
    }

    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Background

    Image {
        id: background
        anchors.fill: parent
        source: wallpaper.wallpaperPath
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false

        onStatusChanged: {
            if (status === Image.Ready && wallpaper.updatingBackground) {
                wallpaper.updatingBackground = false;
                overlay.opacity = 0;
            }
        }
    }

    Image {
        id: overlay
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        opacity: 0

        onStatusChanged: {
            if (status === Image.Ready)
                fade.start();
        }
    }

    NumberAnimation {
        id: fade
        target: overlay
        property: "opacity"
        from: 0
        to: 1
        duration: 600
        easing.type: Easing.InOutCubic

        onFinished: {
            wallpaper.updatingBackground = true;
            background.source = overlay.source;
        }
    }
}
