//@ pragma UseQApplication
//@ pragma IconTheme Papirus

import QtQuick
import Quickshell
import "components"

Scope {
    id: root

    Bar {}
    Activatelinux {}
    Applauncher {}
    Lockscreen {}

    NotificationSystem {}
    Wallpaper{}
}
