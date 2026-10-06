-- Ember: a Hyprland setup by Claude
-- warm charcoal, clay accents, rounded and calm

local terminal = "kitty"
local launcher = "fuzzel"
local files    = "thunar"
local browser  = "firefox"
local mod      = "SUPER"

-- set your own output/mode here; "auto" scale picked 2x on a 1080p VM, so it is fixed at 1
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.on("hyprland.start", function()
    hl.exec_cmd("quickshell")
    hl.exec_cmd("mako")
    hl.exec_cmd("hypridle")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GTK_THEME", "adw-gtk3-dark")

hl.config({
    general = {
        gaps_in = 6,
        gaps_out = 14,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(d97757ff)", "rgba(e0b872ff)" }, angle = 45 },
            inactive_border = "rgba(2e2a26ff)",
        },
        resize_on_border = true,
        layout = "dwindle",
    },
    decoration = {
        rounding = 14,
        rounding_power = 2,
        inactive_opacity = 0.94,
        shadow = { enabled = true, range = 18, render_power = 3, color = 0x66000000 },
        blur = { enabled = true, size = 6, passes = 2, vibrancy = 0.2 },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true },
    misc = { force_default_wallpaper = 0, disable_hyprland_logo = true },
    input = { kb_layout = "us", follow_mouse = 1 },
})

hl.curve("ember", { type = "bezier", points = { {0.22, 1}, {0.36, 1} } })
hl.animation({ leaf = "windows",    enabled = true, speed = 4, bezier = "ember", style = "popin 90%" })
hl.animation({ leaf = "border",     enabled = true, speed = 6, bezier = "ember" })
hl.animation({ leaf = "fade",       enabled = true, speed = 4, bezier = "ember" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "ember", style = "slidefade 12%" })
hl.animation({ leaf = "layers",     enabled = true, speed = 4, bezier = "ember", style = "fade" })

-- blur behind the bar and the dock
hl.layer_rule({ name = "bar-blur",  match = { namespace = "^qs-bar$" },  blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ name = "dock-blur", match = { namespace = "^qs-dock$" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ name = "menu-blur", match = { namespace = "^launcher$" }, blur = true })

hl.window_rule({ name = "float-mixer", match = { class = "^(org.pulseaudio.pavucontrol)$" },
    float = true, size = "720 480", center = true })
hl.window_rule({ name = "no-max", match = { class = ".*" }, suppress_event = "maximize" })

-- apps
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Q",      hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Space",  hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + E",      hl.dsp.exec_cmd(files))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + L",      hl.dsp.exec_cmd("hyprlock"))
hl.bind("Print",            hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))

-- windows
hl.bind(mod .. " + C", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + M", hl.dsp.exit())
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

for _, dir in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(mod .. " + " .. dir, hl.dsp.focus({ direction = dir }))
end

for i = 1, 9 do
    hl.bind(mod .. " + " .. i,             hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i,     hl.dsp.window.move({ workspace = i }))
end

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- panels: hide the top bar, the dock, or both
hl.bind(mod .. " + T", hl.dsp.exec_cmd("qs ipc call panels bar"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("qs ipc call panels dock"))
hl.bind(mod .. " + H", hl.dsp.exec_cmd("qs ipc call panels both"))

-- fake fullscreen: keep the top bar, drop the dock, windows edge to edge
local focusMode = false
hl.bind(mod .. " + SHIFT + F", function()
    focusMode = not focusMode
    hl.config({
        general = { gaps_in = focusMode and 0 or 6, gaps_out = focusMode and 0 or 14 },
        decoration = { rounding = focusMode and 0 or 14 },
    })
    hl.exec_cmd("qs ipc call panels setDock " .. (focusMode and "false" or "true"))
end)

-- cursor
hl.env("XCURSOR_THEME", "Bibata-Modern-Amber")
hl.on("hyprland.start", function() hl.exec_cmd("hyprctl setcursor Bibata-Modern-Amber 24") end)

-- keybind guide
hl.bind(mod .. " + slash", hl.dsp.exec_cmd("qs ipc call keybinds toggle"))
