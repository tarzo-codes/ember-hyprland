import QtQuick
import Quickshell
import Quickshell.Wayland

// the wallpaper, drawn by the shell itself on the background layer
PanelWindow {
    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.namespace: "qs-wallpaper"
    color: Theme.base

    Image {
        anchors.fill: parent
        source: "file://" + Quickshell.env("HOME") + "/Pictures/ember.png"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }
}
