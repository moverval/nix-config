import Quickshell
import QtQuick

import "config.js" as Config

// Background dimmer
Rectangle {
    signal pressed()
    id: backgroundDimmer
    property var backgroundEnabled: false
    anchors.fill: parent
    color: Config.colors.bg.dark
    opacity: enabled ? 1 : 0

    Behavior on opacity {
        NumberAnimation {
            duration: 100
            easing.type: backgroundDimmer.backgroundEnabled ? Easing.OutCubic : Easing.InOutQuart
        }
    }

    // Image {
    //     id: backgroundImage
    //     source: "file:///home/moritz/Pictures/wallpapers/01/05.jpg"
    //     anchors.fill: parent
    //     fillMode: Image.PreserveAspectCrop
    //     smooth: true

    //     Rectangle {
    //         anchors.fill: parent
    //         color: "#5532302f"
    //     }
    // }

    MouseArea {
        anchors.fill: parent
        enabled: backgroundDimmer.backgroundEnabled
        onClicked: {
            backgroundDimmer.pressed()
        }
    }
}

