//@ pragma UseQApplication
//@ pragma IconTheme Papirus

import QtQuick
import Quickshell
import Quickshell.Io
import "components"

ShellRoot {
    id: root

    Bar {}
    Activatelinux {}
    Applauncher {}
    Lockscreen {}

    NotificationSystem {}
    Wallpaper {}

    LazyLoader {
        id: wallpaperswitcherLoader
        active: false

        component: WallpaperSwitcher {
            closeSwitcher: () => wallpaperswitcherLoader.active = false
        }
    }

    IpcHandler {
        target: "wallpaperswitcher"

        function toggle(): void {
            wallpaperswitcherLoader.active = !wallpaperswitcherLoader.active;
        }
    }
}
