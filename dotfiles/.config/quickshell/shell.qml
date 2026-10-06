//@ pragma IconTheme Tela-orange-dark
import Quickshell
import QtQuick
import Quickshell.Io

// wallpaper, bar and dock on every screen
ShellRoot {
    KeybindGuide {}

    // `qs ipc call panels bar|dock|both|setDock <true|false>`
    IpcHandler {
        target: "panels"
        function bar(): void { Theme.barShown = !Theme.barShown }
        function dock(): void { Theme.dockShown = !Theme.dockShown }
        function both(): void {
            const show = !(Theme.barShown || Theme.dockShown)
            Theme.barShown = show
            Theme.dockShown = show
        }
        function setDock(show: bool): void { Theme.dockShown = show }
    }

    Variants {
        model: Quickshell.screens

        Scope {
            id: scope
            required property var modelData

            Wallpaper { screen: scope.modelData }
            Bar { screen: scope.modelData }
            Dock { screen: scope.modelData }
        }
    }
}
