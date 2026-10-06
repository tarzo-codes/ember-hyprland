import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: bar
    anchors { top: true; left: true; right: true }
    margins { top: 10; left: 14; right: 14 }
    implicitHeight: 40
    exclusiveZone: 44
    color: "transparent"
    WlrLayershell.namespace: "qs-bar"

    // a clickable Nerd Font glyph
    component Glyph: Text {
        id: g
        signal clicked()
        property bool hot: false
        font.family: Theme.icons
        font.pixelSize: 16
        color: hot ? Theme.clay : Theme.text
        Behavior on color { ColorAnimation { duration: 120 } }
        MouseArea {
            anchors.fill: parent
            anchors.margins: -5
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: g.hot = true
            onExited: g.hot = false
            onClicked: g.clicked()
        }
    }

    property var sink: Pipewire.defaultAudioSink
    PwObjectTracker { objects: [bar.sink] }

    property string net: "..."
    Process {
        id: netProc
        command: ["sh", "-c", "nmcli -t -f TYPE,STATE device | grep -m1 ':connected$' | cut -d: -f1"]
        stdout: StdioCollector { onStreamFinished: bar.net = this.text.trim() }
    }
    Timer { interval: 10000; running: true; repeat: true; triggeredOnStart: true; onTriggered: netProc.running = true }

    SystemClock { id: clock; precision: SystemClock.Minutes }

    Rectangle {
        anchors.fill: parent
        radius: 14
        color: Theme.glass
        border.width: 1
        border.color: Theme.overlay

        // left: launcher + workspaces
        RowLayout {
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Glyph {
                text: "\uf303"
                color: hot ? Theme.sand : Theme.clay
                font.pixelSize: 17
                onClicked: Quickshell.execDetached(["fuzzel"])
            }

            Repeater {
                model: Hyprland.workspaces
                delegate: Rectangle {
                    id: ws
                    required property var modelData
                    visible: modelData.id > 0
                    implicitWidth: modelData.focused ? 26 : 10
                    implicitHeight: 10
                    radius: 5
                    color: modelData.focused ? Theme.clay : Theme.subtext
                    opacity: modelData.focused ? 1 : 0.55
                    Behavior on implicitWidth { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -6
                        onClicked: ws.modelData.activate()
                    }
                }
            }
        }

        // centre: the clock
        Text {
            anchors.centerIn: parent
            text: Qt.formatDateTime(clock.date, "ddd d MMM   HH:mm")
            color: Theme.text
            font.family: Theme.font
            font.pixelSize: 14
            font.weight: Font.DemiBold
        }

        // right: tray, network, volume, power
        RowLayout {
            anchors.right: parent.right
            anchors.rightMargin: 14
            anchors.verticalCenter: parent.verticalCenter
            spacing: 14

            Repeater {
                model: SystemTray.items
                delegate: IconImage {
                    id: trayIcon
                    required property var modelData
                    source: modelData.icon
                    implicitSize: 16
                    MouseArea {
                        anchors.fill: parent
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: mouse => {
                            if (mouse.button === Qt.LeftButton) {
                                trayIcon.modelData.activate()
                            } else {
                                const p = trayIcon.mapToItem(null, 0, trayIcon.height)
                                trayIcon.modelData.display(bar, p.x, p.y + 8)
                            }
                        }
                    }
                }
            }

            Glyph {
                text: bar.net === "" ? "\uf127" : (bar.net === "wifi" ? "\uf1eb" : "\udb80\ude00")
                color: bar.net === "" ? Theme.subtext : (hot ? Theme.clay : Theme.sage)
                onClicked: Quickshell.execDetached(["kitty", "-e", "sh", "-c", "NEWT_COLORS='root=white,black window=white,black border=red,black title=red,black button=black,red actbutton=black,yellow listbox=white,black actlistbox=black,red actsellistbox=black,red entry=white,black' nmtui"])
            }

            Glyph {
                property var audio: bar.sink && bar.sink.audio
                text: !audio || audio.muted ? "\uf026" : "\uf028  " + Math.round(audio.volume * 100) + "%"
                onClicked: Quickshell.execDetached(["pavucontrol"])
                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    onWheel: wheel => {
                        if (parent.audio) parent.audio.volume = Math.max(0, Math.min(1, parent.audio.volume + (wheel.angleDelta.y > 0 ? 0.05 : -0.05)))
                    }
                }
            }

            Glyph {
                text: "\uf059"
                color: hot ? Theme.clay : Theme.subtext
                onClicked: Quickshell.execDetached(["qs", "ipc", "call", "keybinds", "toggle"])
            }

            Glyph {
                text: "\uf011"
                color: hot ? Theme.clay : Theme.subtext
                onClicked: Quickshell.execDetached(["sh", "-c", "$HOME/.local/bin/powermenu"])
            }
        }
    }
}
