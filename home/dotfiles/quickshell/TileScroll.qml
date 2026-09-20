import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ScrollView {
    default property alias innerElements: scrollColumn.data
    id: tileScroll
    contentWidth: width
    ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    ScrollBar.vertical.policy: ScrollBar.AlwaysOff
    contentHeight: scrollColumn.height
    wheelEnabled: false
    property var scrollDistance: height

    Flickable {
        id: flickable
        boundsBehavior: Flickable.StopAtBounds

        Behavior on contentY {
            NumberAnimation {
                id: scrollAnimation
                duration: 500
                easing.type: Easing.OutCubic
            }
        }
    }

    MouseArea {
        id: scrollController
        anchors.fill: parent

        propagateComposedEvents: true

        onWheel: (wheel) => {
            let currentTargetY = scrollAnimation.running ? scrollAnimation.to : flickable.contentY                    

            let direction = wheel.angleDelta.y > 0 ? -1 : 1;
            let newTargetY = currentTargetY + (direction * tileScroll.scrollDistance);
            let maxScroll = flickable.contentHeight - tileScroll.height;
            newTargetY = Math.max(0, Math.min(newTargetY, maxScroll));
            flickable.contentY = newTargetY;
            wheel.accepted = true;
        }
    }

    ColumnLayout {
        id: scrollColumn
        spacing: 0
    }
}

