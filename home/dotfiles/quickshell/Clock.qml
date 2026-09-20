import Quickshell
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

Item {
    id: clock

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 0

        Text {
            id: clockText
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatTime(new Date(), "hh:mm")
            color: Config.colors.fg.primary
            font.family: "Roboto"
            font.pixelSize: 80
            font.weight: Font.Bold
            renderType: Text.NativeRendering
        }

        Text {
            id: dateText
            Layout.alignment: Qt.AlignHCenter
            text: Qt.formatDate(new Date(), "dddd, dd. MMMM")
            color: Config.colors.fg.secondary
            font.family: "Roboto"
            font.pixelSize: 15
            font.weight: Font.Medium
            renderType: Text.NativeRendering
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            clockText.text = Qt.formatTime(new Date(), "hh:mm");
            dateText.text = Qt.formatDate(new Date(), "dddd, dd. MMMM");
        }
    }
}
