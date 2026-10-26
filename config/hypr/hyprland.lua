-- Standalone Lua equivalent of the staged Hyprland configuration.
-- Derived from config/hypr/hyprland.conf; requires Hyprland's Lua config API.

local mainMod = "SUPER"
local terminal = "uwsm-app -- ghostty"
local fileManager = "uwsm-app -- nautilus"
local launcher = "fuzzel --show drun"
local localBin = os.getenv("HOME") .. "/.local/bin/"

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
hl.env("GDK_SCALE", "2")

hl.config({
    input = {
        kb_layout = "us",
        kb_options = "caps:escape",
        follow_mouse = 1,
        sensitivity = 0,
        repeat_rate = 40,
        repeat_delay = 250,
        numlock_by_default = true,
        touchpad = {
            natural_scroll = false,
            clickfinger_behavior = true,
            scroll_factor = 0.4,
        },
    },
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(cba6f7ee)", "rgba(89b4faee)" }, angle = 45 },
            inactive_border = "rgba(45475aaa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },
    decoration = {
        rounding = 0,
        shadow = { enabled = false },
        blur = { enabled = false },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true, force_split = 2 },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        disable_scale_notification = true,
        focus_on_activate = true,
        anr_missed_pings = 3,
        on_focus_under_fullscreen = 1,
        initial_workspace_tracking = 0,
    },
    cursor = { hide_on_key_press = true, warp_on_change_workspace = 1 },
})

local curves = {
    { "easeOutQuint", { 0.23, 1, 0.32, 1 } },
    { "easeInOutCubic", { 0.65, 0.05, 0.36, 1 } },
    { "almostLinear", { 0.5, 0.5, 0.75, 1.0 } },
    { "quick", { 0.15, 0, 0.1, 1 } },
}
for _, curve in ipairs(curves) do
    hl.curve(curve[1], { type = "bezier", points = { { curve[2][1], curve[2][2] }, { curve[2][3], curve[2][4] } } })
end

local animations = {
    { "global", 10, "default" },
    { "border", 5.39, "easeOutQuint" },
    { "windows", 3.79, "easeOutQuint" },
    { "windowsIn", 4.1, "easeOutQuint", "popin 87%" },
    { "windowsOut", 1.49, "linear", "popin 87%" },
    { "fadeIn", 1.73, "almostLinear" },
    { "fadeOut", 1.46, "almostLinear" },
    { "fade", 3.03, "quick" },
    { "layers", 3.81, "easeOutQuint" },
    { "layersIn", 4, "easeOutQuint", "fade" },
    { "layersOut", 1.5, "linear", "fade" },
    { "fadeLayersIn", 1.79, "almostLinear" },
    { "fadeLayersOut", 1.39, "almostLinear" },
    { "workspaces", 0, "default" },
}
for _, animation in ipairs(animations) do
    hl.animation({
        leaf = animation[1],
        enabled = animation[2] > 0,
        speed = math.max(animation[2], 1),
        bezier = animation[3],
        style = animation[4],
    })
end

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + CTRL + V", hl.dsp.exec_cmd(localBin .. "clipboard-picker"))
hl.bind(mainMod .. " + CTRL + Delete", hl.dsp.exec_cmd(localBin .. "toggle-internal-display"))
hl.bind(mainMod .. " + CTRL + W", hl.dsp.exec_cmd(localBin .. "network-menu"))
hl.bind(mainMod .. " + CTRL + B", hl.dsp.exec_cmd(localBin .. "bluetooth-menu"))
hl.bind(mainMod .. " + CTRL + P", hl.dsp.exec_cmd(localBin .. "power-profile-cycle"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("makoctl dismiss"))
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.exec_cmd("makoctl dismiss --all"))
hl.bind(mainMod .. " + CTRL + comma", hl.dsp.exec_cmd("makoctl mode -t do-not-disturb"))

hl.bind("Print", hl.dsp.exec_cmd(localBin .. "screenshot-region"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(localBin .. "screenshot-full"))
hl.bind("ALT + Print", hl.dsp.exec_cmd(localBin .. "screen-record-toggle"))

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("hyprctl dispatch togglefloating"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0"))
hl.bind(mainMod .. " + J", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg togglesplit"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprctl dispatch pseudo"))
for _, direction in ipairs({ "left", "right", "up", "down" }) do
    hl.bind(mainMod .. " + " .. direction, hl.dsp.focus({ direction = direction }))
    hl.bind(mainMod .. " + SHIFT + " .. direction, hl.dsp.window.move({ direction = direction }))
end

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
