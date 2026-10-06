pragma Singleton
import QtQuick
import Quickshell

// Ember palette - one place for every colour in the shell
Singleton {
    readonly property color base: "#191715"
    readonly property color glass: Qt.rgba(0.098, 0.090, 0.082, 0.78)
    readonly property color overlay: "#2e2a26"
    readonly property color text: "#ece5da"
    readonly property color subtext: "#a89f93"
    readonly property color clay: "#d97757"
    readonly property color sage: "#8fae8b"
    readonly property color sand: "#e0b872"
    readonly property string font: "Inter"
    readonly property string icons: "JetBrainsMono Nerd Font"
}
