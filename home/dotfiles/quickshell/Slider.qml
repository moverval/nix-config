import QtQuick
import QtQuick.Controls
import QtQuick.Effects

import "config.js" as Config

Slider {
    id: slider
    from: 0
    to: 100
    stepSize: 1

    implicitWidth: 300
    implicitHeight: 30

    HoverHandler {
        id: hoverHandler
    }

    background: Rectangle {
        id: background
        x: slider.leftPadding
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: slider.height
        border.width: 1
        border.color: hoverHandler.hovered ? Config.colors.bg.light : "transparent"

        Behavior on border.color {
            ColorAnimation {
                duration: 200
            }
        }

        radius: 5
        color: "#10000000"
        
        Item {
            anchors.left: background.left
            anchors.top: background.top
            anchors.bottom: background.bottom
            anchors.right: background.right

            Item {
                anchors.fill: parent
                visible: false
                layer.enabled: true
                id: sliderSource

                Rectangle {
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    implicitWidth: slider.availableWidth * slider.visualPosition
                    color: Config.colors.bg.light
                }
            }

            Item {
                id: sliderMask
                anchors.fill: parent
                visible: false
                layer.enabled: true

                Rectangle {
                    anchors.fill: parent
                    radius: background.radius
                }
            }

            MultiEffect {
                anchors.fill: parent
                source: sliderSource
                maskSource: sliderMask
                maskEnabled: true
                maskThresholdMin: 0.5
                maskSpreadAtMin: 1.0
            }
        }
    }

    handle: Item {}
}
