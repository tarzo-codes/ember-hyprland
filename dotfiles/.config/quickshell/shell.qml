//@ pragma IconTheme Tela-orange-dark
import Quickshell
import QtQuick

// wallpaper, bar and dock on every screen
ShellRoot {
    KeybindGuide {}

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
