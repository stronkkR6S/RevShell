import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

PanelWindow {
    id: wallpaper

property url wallpaperPath: Qt.resolvedUrl("../wallpapers/wallpaper.png")

    property int wallpaperVersion: 0
    FileView {
        path: wallpaper.wallpaperPath
        watchChanges: true
        onFileChanged:  wallpaper.wallpaperVersion++;
        
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
        id: image
        anchors.fill: parent
        source: wallpaper.wallpaperPath + "?" + wallpaper.wallpaperVersion
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        onStatusChanged: {
            if (image.status === Image.Error)
                console.warn("Failed to load wallpaper:", image.source);
        }
    }
}
