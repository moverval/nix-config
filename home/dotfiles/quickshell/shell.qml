import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls

import "config.js" as Config

PanelWindow {
    id: root
    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true
    aboveWindows: true
    focusable: shown
    visible: false
    color: "transparent"

    property bool shown: false

    onShownChanged: {
        if (root.shown) {
            root.visible = true;
            flyin.shown = true;
        } else {
            flyin.shown = false;
            hideTimer.restart();
        }
    }

    Timer {
        id: hideTimer
        interval: 100
        onTriggered: root.visible = false
    }

    HoverHandler {
        onHoveredChanged: {
            if (!hovered) {
                root.shown = false;
            }
        }
    }

    TileScroll {
        anchors.fill: parent
        id: monitor

        Flyin {
            id: flyin
            implicitWidth: monitor.width
            implicitHeight: monitor.height
            onClose: {
                root.shown = false;
            }
        }        

        Item {
            id: extra
            implicitHeight: monitor.height
            implicitWidth: monitor.width

            BackgroundDimmer {
                anchors.fill: parent
                backgroundEnabled: root.shown
            }

            Item {
                id: extraContent
                width: parent.width * 0.8
                height: parent.height * 0.8
                anchors.centerIn: parent

                ColumnLayout {
                    Text {
                        id: text
                        text: "Extra"
                        color: "white"
                        font.pixelSize: 50
                        font.weight: 700
                    }

                    Text {
                        text: "Extensive Launcher, Research, Settings, RFC, ..."
                        color: "white"
                    }
                }
            }

        }        
    }

    Item {
        id: workspaceAnimation
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        width: workspaceColumn.width
        height: workspaceColumn.height

        WorkspaceColumn {
            id: workspaceColumn
            onClickUnfocused: {
                flyin.shown = false;
            }
        }

        transform: Translate {
            x: flyin.shown ? 0 : -200
            Behavior on x {
                SpringAnimation {
                    damping: 0.2
                    spring: 2
                }
            }
        }
    }
    
    IpcHandler {
        target: "overlay"

        function toggle() {
            root.shown = !root.shown;
        }
    }
}
