import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

PanelWindow {
    id: root
    anchors {
        left: true
        top: true
        right: true
    }
    margins {
        top: 16
    }
    exclusiveZone: 0
    implicitHeight: 64
    color: "transparent"

    Rectangle {
        id: bar
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        width: 260
        height: 56
        radius: 20
        color: Config.colors.bg
        border.color: Config.colors.border
        border.width: 1

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 0

            Text {
                id: clockText
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatTime(new Date(), "hh:mm")
                color: Config.colors.fg
                font.family: "monospace"
                font.pixelSize: 26
                font.weight: Font.Bold
                renderType: Text.NativeRendering
            }

            Text {
                id: dateText
                Layout.alignment: Qt.AlignHCenter
                text: Qt.formatDate(new Date(), "dddd, dd. MMMM")
                color: Config.colors.dim
                font.family: "monospace"
                font.pixelSize: 11
                font.weight: Font.Medium
                renderType: Text.NativeRendering
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clockText.text = Qt.formatTime(new Date(), "hh:mm")
            dateText.text = Qt.formatDate(new Date(), "dddd, dd. MMMM")
        }
    }
}
