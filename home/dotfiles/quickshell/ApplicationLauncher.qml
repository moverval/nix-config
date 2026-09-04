import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import "config.js" as Config

ColumnLayout {
    signal execute()
    property var applications
    property var selected: 0
    property var maxApplications: 5
    id: applicationLauncher
    layoutDirection: RowLayout.Bottom

    onApplicationsChanged: {
        selected = 0;
    }

    function selectNext() {
        if (selected < Math.min(applications.length - 1, maxApplications - 1)) {
            selected += 1;
        }
    }

    function selectPrevious() {
        if (selected > 0) {
            selected -= 1;
        }
    }

    function tryLaunch() {
        if (applications.length == 0) {
            return false;
        }

        applications[selected].execute();
        return true;
    }

    Repeater {
        model: Math.min(applicationLauncher.maxApplications, applicationLauncher.applications.length)
        Rectangle {
            id: desktopItem
            required property int index
            property var application: applicationLauncher.applications[index]
            Layout.topMargin: 5
            implicitWidth: 400
            implicitHeight: 75
            radius: 10
            color: Config.colors.bg.dark
            clip: true
            border.width: 1
            border.color: desktopItem.index == applicationLauncher.selected ? Config.colors.bg.light : "transparent"

            Behavior on border.color {
                ColorAnimation {
                    duration: 25
                }
            }

            RowLayout {
                anchors.fill: parent
                // Das kontrolliert den Abstand zwischen Icon und Text (auf 10 Pixel reduziert)
                spacing: 10 

                // Item {
                //     implicitWidth: 50
                //     implicitHeight: 50
                //     Layout.leftMargin: 10
                //     Layout.alignment: Qt.AlignVCenter

                //     Image {
                //         id: sourceImage
                //         anchors.fill: parent
                //         source: DesktopEntries.applications.values[desktopItem.index].icon
                //         fillMode: Image.PreserveAspectCrop
                //         visible: false
                //     }

                //     Item {
                //         id: maskItem
                //         anchors.fill: parent
                //         visible: false
                //         layer.enabled: true
                //         Rectangle {
                //             anchors.fill: parent
                //             radius: 10
                //             color: "white"
                //         }
                //     }

                //     MultiEffect {
                //         anchors.fill: parent
                //         source: sourceImage
                //         maskEnabled: true
                //         maskSource: maskItem
                //         opacity: 0.9
                //     }
                // }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.leftMargin: 30
                    Layout.rightMargin: 30

                    implicitHeight: textColumn.implicitHeight
                    color: "transparent"

                    ColumnLayout {
                        id: textColumn
                        implicitWidth: parent.width
                        implicitHeight: parent.height

                        Text {
                            text: desktopItem.application.name
                            color: "white"
                            font.family: "Roboto"

                            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                            Layout.fillWidth: true 
                        }

                        Item {
                            implicitWidth: textColumn.width
                            implicitHeight: textItem.height
                            id: comment

                            Text {
                                id: textItem
                                width: textColumn.width
                                text: desktopItem.application.comment
                                color: "gray"
                                font.family: "Roboto"
                                layer.enabled: true
                                visible: false
                            }

                            Item {
                                id: textMask
                                anchors.fill: comment
                                visible: false
                                layer.enabled: true

                                Rectangle {
                                    color: "blue"
                                    anchors.fill: parent

                                    gradient: Gradient {
                                        orientation: Gradient.Horizontal
                                        GradientStop {
                                            position: 0.0
                                            color: "black"
                                        }
                                        GradientStop {
                                            position: 0.8
                                            color: "black"
                                        }
                                        GradientStop {
                                            position: 1.0
                                            color: "transparent"
                                        }
                                    }
                                }
                            }

                            MultiEffect {
                                source: textItem
                                maskEnabled: true
                                maskSource: textMask
                                maskThresholdMin: 0.5
                                maskThresholdMax: 1.0
                                maskSpreadAtMin: 1.0
                                maskSpreadAtMax: 0.0
                                anchors.fill: comment
                            }
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                onClicked: {
                    applicationLauncher.execute(desktopItem.application)
                    desktopItem.application.execute();
                }
            }

            HoverHandler {
                onHoveredChanged: {
                    if (hovered) {
                        applicationLauncher.selected = desktopItem.index
                    }
                }
            }
        }
    }
}
