import Quickshell
import QtQuick
import QtQuick.Layouts

import "config.js" as Config

Item {
    signal input(string text)
    signal exit()
    signal done()
    signal down()
    signal up()

    property var text: ""

    id: searchField
    width: column.width
    height: column.height

    ColumnLayout {
        id: column

        Text {
            text: "Run Application"
            color: Config.colors.fg.primary
        }

        Item {
            implicitWidth: 400
            implicitHeight: 50

            Rectangle {
                id: applicationSearchField
                anchors.fill: parent
                color: Config.colors.bg.dark
                radius: 10
                border.color: Config.colors.bg.light

                TextInput {
                    text: searchField.text
                    id: applicationSearch
                    color: "white"
                    focus: true
                    font.pixelSize: 20
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    clip: true
                    anchors.verticalCenter: parent.verticalCenter
                    font.family: "Roboto"
                    font.weight: Font.Bold

                    onTextEdited: searchField.input(applicationSearch.text)
                    Keys.enabled: true
                    Keys.onReturnPressed: searchField.done()
                    Keys.onEscapePressed: searchField.exit()
                    Keys.onDownPressed: searchField.down()
                    Keys.onUpPressed: searchField.up()

                    Component.onCompleted: {
                        applicationSearch.forceActiveFocus()
                    }
                }
            }
        }
    }
}
