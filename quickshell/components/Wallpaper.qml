import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: wallpaper

    property url wallpaperPath: Qt.resolvedUrl("../wallpapers/wallpaper.png")
    property int wallpaperVersion: 0
    property bool frontActive: true
    property bool transitioning: false
    property bool pendingReload: false

    function reloadWallpaper() {
        if (transitioning) {
            pendingReload = true;
            return;
        }

        transitioning = true;
        wallpaperVersion++;

        let next = frontActive ? backImage : frontImage;
        next.opacity = 0;
        next.z = 1;

        let current = frontActive ? frontImage : backImage;
        current.z = 0;

        next.source = wallpaperPath + "?" + wallpaperVersion;
    }

    function finishTransition() {
        frontActive = !frontActive;
        transitioning = false;

        if (pendingReload) {
            pendingReload = false;
            reloadWallpaper();
        }
    }

    IpcHandler {
        target: "wallpaper"

        function reload(): void {
            wallpaper.reloadWallpaper();
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
        id: frontImage
        anchors.fill: parent
        source: wallpaper.wallpaperPath
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        opacity: 1

        onStatusChanged: {
            if (status === Image.Ready &&
                wallpaper.transitioning &&
                !wallpaper.frontActive) {
                fadeFront.start();
            }
        }
    }

    Image {
        id: backImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        opacity: 0

        onStatusChanged: {
            if (status === Image.Ready &&
                wallpaper.transitioning &&
                wallpaper.frontActive) {
                fadeBack.start();
            }
        }
    }

    NumberAnimation {
        id: fadeFront
        target: frontImage
        property: "opacity"
        from: 0
        to: 1
        duration: 600
        easing.type: Easing.InOutCubic

        onFinished: wallpaper.finishTransition()
    }

    NumberAnimation {
        id: fadeBack
        target: backImage
        property: "opacity"
        from: 0
        to: 1
        duration: 300
        easing.type: Easing.InOutCubic

        onFinished: wallpaper.finishTransition()
    }
}
