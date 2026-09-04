import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import "config.js" as Config

ColumnLayout {
    signal clickUnfocused();

    id: workspaceColumn
    spacing: 12

    Repeater {
        model: Hyprland.workspaces.values.length
        delegate: Rectangle {
            id: workspaceItem
            required property int index
            property var workspace: Hyprland.workspaces.values[index]
            property var focused: workspace == Hyprland.focusedWorkspace
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            radius: 14
            color: focused ? Config.colors.bg.light : Config.colors.bg.dark
            // border.color: Config.colors.border
            // border.width: 1

            Text {
                anchors.centerIn: parent
                text: workspaceItem.workspace.id
                color: workspaceItem.focused
                    ? Config.colors.fg.primary
                    : workspaceItem.workspace.monitor == Hyprland.focusedMonitor
                        ? Config.colors.fg.secondary : Config.colors.fg.red
                font.family: Config.font
                font.pixelSize: 14
                font.bold: true
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (workspaceItem.workspace.monitor != Hyprland.focusedMonitor) {
                        workspaceColumn.clickUnfocused();
                    }
                    workspaceItem.workspace.activate();
                }
            }
        }
    }
}
