import QtQuick
import QtQuick.Layouts

import "config.js" as Config

Rectangle {
    // color: Config.colors.bg.dark
    color: "transparent"
    radius: 10
    width: itemsContainer.width
    height: itemsContainer.height

    Item {
        id: itemsContainer
        width: items.width + 60
        height: items.height + 60

        ColumnLayout {
            id: items
            anchors.centerIn: parent

            Rectangle {
                implicitWidth: volume.width

                RowLayout {
                    id: volume

                    Slider {
                        
                    }
                }
            }
        }
    }
}
