import Quickshell // for PanelWindow
import Quickshell.Wayland
import QtQuick // for Text

import "config.js" as Config

PanelWindow {
    id: root
    anchors {
        left: true
        bottom: true
        right: true
    }
    color: "transparent"
    implicitHeight: 30

    Rectangle {
        id: bottomPanel
        anchors.centerIn: parent
        width: 250
        height: 30
        color: Config.colors.background
        topLeftRadius: 15
        topRightRadius: 15

        Rectangle {
            color: "transparent"

            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            Text {
                anchors.centerIn: bottomPanel
                text: "Hello World"
                color: "white"
            }
        }
    }
}
