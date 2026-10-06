import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

// Super + / : every keybind on one card. Esc or a click anywhere closes it.
PanelWindow {
    id: guide
    visible: false
    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "qs-keybinds"
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    color: Qt.rgba(0, 0, 0, 0.45)

    IpcHandler {
        target: "keybinds"
        function toggle(): void { guide.visible = !guide.visible }
    }

    property var groups: [
        { title: "Apps", keys: [
            ["Super  Return", "terminal"], ["Super  Space", "launcher"], ["Super  E", "files"],
            ["Super  B", "browser"], ["Super  L", "lock"], ["Print", "screenshot to clipboard"] ] },
        { title: "Windows", keys: [
            ["Super  C", "close"], ["Super  F", "fullscreen"], ["Super  V", "float"],
            ["Super  J", "flip split"], ["Super  Arrows", "move focus"], ["Super  Drag", "move / resize"] ] },
        { title: "Workspaces", keys: [
            ["Super  1-9", "go to workspace"], ["Super Shift  1-9", "send window"] ] },
        { title: "Layout", keys: [
            ["Super  T", "top bar on / off"], ["Super  D", "dock on / off"],
            ["Super  H", "both on / off"], ["Super Shift  F", "fake fullscreen"] ] },
        { title: "System", keys: [
            ["Super  /", "this guide"], ["Volume keys", "volume"], ["Super  M", "leave Hyprland"] ] }
    ]

    MouseArea { anchors.fill: parent; onClicked: guide.visible = false }

    Rectangle {
        id: card
        anchors.centerIn: parent
        width: 760
        height: content.implicitHeight + 64
        radius: 22
        color: Theme.base
        border.width: 2
        border.color: Theme.clay
        focus: true
        Keys.onEscapePressed: guide.visible = false
        MouseArea { anchors.fill: parent }

        ColumnLayout {
            id: content
            anchors.fill: parent
            anchors.margins: 32
            spacing: 22

            Text {
                text: "Ember  /  keybinds"
                color: Theme.clay
                font.family: Theme.font
                font.pixelSize: 22
                font.weight: Font.Bold
            }

            GridLayout {
                columns: 2
                columnSpacing: 48
                rowSpacing: 22

                Repeater {
                    model: guide.groups
                    delegate: ColumnLayout {
                        required property var modelData
                        spacing: 8
                        Layout.alignment: Qt.AlignTop

                        Text {
                            text: modelData.title.toUpperCase()
                            color: Theme.sand
                            font.family: Theme.font
                            font.pixelSize: 12
                            font.weight: Font.Bold
                            font.letterSpacing: 1.5
                        }

                        Repeater {
                            model: modelData.keys
                            delegate: RowLayout {
                                required property var modelData
                                spacing: 14
                                Rectangle {
                                    implicitWidth: 150
                                    implicitHeight: 26
                                    radius: 8
                                    color: Theme.overlay
                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData[0]
                                        color: Theme.text
                                        font.family: Theme.icons
                                        font.pixelSize: 12
                                    }
                                }
                                Text {
                                    text: modelData[1]
                                    color: Theme.subtext
                                    font.family: Theme.font
                                    font.pixelSize: 13
                                }
                            }
                        }
                    }
                }
            }

            Text {
                text: "Esc to close"
                color: Theme.subtext
                opacity: 0.6
                font.family: Theme.font
                font.pixelSize: 11
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}
