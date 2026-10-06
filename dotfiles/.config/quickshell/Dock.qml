import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: dock
    anchors.bottom: true
    margins.bottom: 10
    implicitWidth: row.implicitWidth + 28
    implicitHeight: 66
    exclusiveZone: 72
    color: "transparent"
    WlrLayershell.namespace: "qs-dock"

    property var apps: ["kitty", "firefox", "thunar", "org.xfce.mousepad", "nvim", "btop"]

    Rectangle {
        anchors.fill: parent
        radius: 20
        color: Theme.glass
        border.width: 1
        border.color: Theme.overlay

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 12

            Repeater {
                model: dock.apps
                delegate: Item {
                    id: app
                    required property string modelData
                    property var entry: {
                        DesktopEntries.applications.values
                        return DesktopEntries.heuristicLookup(modelData)
                    }
                    property bool running: {
                        const want = [modelData.toLowerCase(), entry ? (entry.startupClass || "").toLowerCase() : ""]
                        for (const t of Hyprland.toplevels.values) {
                            const c = ((t.wayland && t.wayland.appId) || (t.lastIpcObject && t.lastIpcObject.class) || "").toLowerCase()
                            if (c !== "" && want.includes(c)) return true
                        }
                        return false
                    }
                    width: 50
                    height: 50

                    IconImage {
                        anchors.centerIn: parent
                        implicitSize: hover.containsMouse ? 50 : 42
                        source: Quickshell.iconPath(app.entry ? app.entry.icon : app.modelData, "application-x-executable")
                        Behavior on implicitSize { NumberAnimation { duration: 140; easing.type: Easing.OutCubic } }
                    }

                    Rectangle {
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.top: parent.bottom
                        anchors.topMargin: 1
                        width: app.running ? 14 : 4
                        height: 4
                        radius: 2
                        color: app.running ? Theme.clay : Theme.subtext
                        opacity: app.running ? 1 : 0.35
                        Behavior on width { NumberAnimation { duration: 160 } }
                    }

                    MouseArea {
                        id: hover
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (!app.entry) return
                            if (app.entry.runInTerminal)
                                Quickshell.execDetached(["kitty", "-e"].concat(app.entry.command))
                            else
                                app.entry.execute()
                        }
                    }
                }
            }
        }
    }
}
