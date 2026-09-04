import Quickshell
import QtQuick

Item {
    signal close()

    id: flyin

    property var filteredApps: []
    property var searchText: ""
    property var shown: false

    onShownChanged: {
        if (shown) {
            filteredApps = [];
            searchText = "";
        } else {
            close();
        }
    }
    
    function filterApps(text) {
        let trimmedText = text.trim();

        if (trimmedText === "") {
            flyin.filteredApps = [];
            return;
        }
    
        let applications = DesktopEntries.applications.values;
        let filteredApplications = applications.filter(
            (application) =>
                application.name.toLowerCase()
                                .includes(text.toLowerCase())
                && !application.noDisplay
        );

        flyin.filteredApps = filteredApplications;
    }

    BackgroundDimmer {
        backgroundEnabled: flyin.shown
        onPressed: {
            flyin.shown = false;
        }
    }

    Item {
        id: clockAnimation
        anchors.top: parent.top
        anchors.topMargin: 200
        anchors.horizontalCenter: parent.horizontalCenter
        width: clock.width
        height: clock.height

        Clock {
            id: clock
        }

        opacity: flyin.shown ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 100
                easing.type: flyin.shown ? Easing.OutQuart : Easing.InOutQuart
            }
        }        
    }
    
    Item {
        id: searchFieldAnimation
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 200
        anchors.horizontalCenter: parent.horizontalCenter
        width: searchField.width
        height: searchField.height

        SearchField {
            id: searchField
            text: flyin.searchText
            onInput: (text) => {
                flyin.searchText = text;
                flyin.filterApps(text);
            }
            onDone: {
                flyin.shown = !applicationLauncher.tryLaunch();
            }
            onExit: {
                flyin.shown = false;
            }
            onDown: {
                applicationLauncher.selectNext();
            }
            onUp: {
                applicationLauncher.selectPrevious();
            }
        }

        opacity: flyin.shown ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 100
                easing.type: flyin.shown ? Easing.OutQuart : Easing.InOutQuart
            }
        }
    }

    Item {
        id: applicationLauncherAnimation
        anchors.centerIn: parent
        width: applicationLauncher.width
        height: applicationLauncher.height

        ApplicationLauncher {
            id: applicationLauncher
            applications: flyin.filteredApps
            onExecute: {
                flyin.shown = false;
            }
        }

        opacity: flyin.shown ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 100
                easing.type: flyin.shown ? Easing.OutQuart : Easing.InOutQuart
            }
        }
    }

    // Item {
    //     id: settingAnimation
    //     anchors.right: parent.right
    //     anchors.top: parent.top
    //     anchors.rightMargin: 20
    //     anchors.topMargin: 20
    //     width: settings.width
    //     height: settings.height

    //     SettingsOverview {
    //         id: settings
    //     }
    // }
}
