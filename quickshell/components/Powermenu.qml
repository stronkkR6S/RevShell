import QtQuick
import QtQuick.Effects
import Quickshell

Rectangle{
    id: logo
    anchors.right: parent.right
    anchors.rightMargin: 15
    anchors.verticalCenter: parent.verticalCenter

    height: 34
    width:  48
    radius: 40
    // property bool isClicked: false
    // color : root.isClicked ? Theme.vibrantYellow : Theme.gray
    color: Theme.vibrantOrange

// Image {
//     anchors.centerIn: parent

//     width: 40
//     height: 24

//     source: Qt.resolvedUrl("../icons/power.svg")
//     fillMode: Image.PreserveAspectFit

//     smooth: true
//     asynchronous: true

//     sourceSize: Qt.size(25, 25)
//     layer.enabled: true
//     layer.effect: MultiEffect {
//     colorization: 1.0
//     colorizationColor: Theme.background 

//     }
Text{
    anchors.centerIn: parent
    text: ""
    font.pixelSize: 25

}
Loader {
    id: powermenupop
    active: false
    source: "Powermenupop.qml"

    onLoaded: item.closeRequested.connect(closeMenu)
}

function closeMenu() {
    powermenupop.active = false
}

MouseArea {
    onClicked: powermenupop.active =!powermenupop.active
    anchors.fill: parent

   }

}
