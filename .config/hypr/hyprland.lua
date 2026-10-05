-- ~/.config/hypr/hyprland.lua
-- Migrated from hyprland.conf (hyprlang) to the Lua config API (Hyprland >= 0.55)
-- After installing: hyprctl reload && hyprctl configerrors

------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "eDP-1",
	mode = "1920x1200@60.00",
	position = "0x1200",
	scale = 1,
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@75.00",
	position = "0x0",
	scale = 1,
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local menu = "tofi-drun -c ~/.config/tofi/config --drun-launch=true"
local browser = "thorium-browser --enable-features=UseOzonePlatform --ozone-platform=wayland"
local notes = "obsidian"
local colorPicker = "hyprpicker"

-------------------
---- AUTOSTART ----
-------------------

-- Everything here runs once at startup (was exec-once)
hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("/usr/bin/dunst")
	hl.exec_cmd("waybar") -- topbar
	hl.exec_cmd("awww-daemon") -- wallpaper

	-- Clipboard: wipe history first, THEN start the watchers.
	-- (Previously the rm ran in parallel with the watchers and could race them.)
	hl.exec_cmd(
		'rm -f "$HOME/.cache/cliphist/db"; '
			.. "wl-paste --type text --watch cliphist store & "
			.. "wl-paste --type image --watch cliphist store"
	)

	hl.exec_cmd("hypridle")
	hl.exec_cmd("awww clear 000000FF && sleep 1 && awww img ~/MyDotfiles/wallpaper.png -t left --transition-duration=4")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Firefox
-- hl.env("MOZ_ENABLE_WAYLAND", "1")

-- Nvidia
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia") -- remove if firefox crashes
hl.env("NVD_BACKEND", "direct")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- QT
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- Toolkit backend variables
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

-- XDG specifications (XDG_SESSION_TYPE was set twice before; once is enough)
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,

		border_size = 2,

		col = {
			active_border = {
				colors = { "rgb(8aadf4)", "rgb(24273A)", "rgb(24273A)", "rgb(8aadf4)" },
				angle = 45,
			},
			inactive_border = {
				colors = { "rgb(24273A)", "rgb(24273A)", "rgb(24273A)", "rgb(27273A)" },
				angle = 45,
			},
		},

		resize_on_border = true,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,

		active_opacity = 1.0,
		inactive_opacity = 1.0,

		blur = {
			enabled = true,
			size = 3,
			passes = 3,
			new_optimizations = true,
			vibrancy = 0.1696,
			ignore_opacity = true,
		},
	},

	animations = {
		enabled = true,
	},

	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		vrr = 0,
	},
})

-- Curves (was: bezier = ...)
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })

-- Animations (was: animation = leaf, onoff, speed, curve, style)
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 6, bezier = "winIn", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5, bezier = "winOut", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })
hl.animation({ leaf = "border", enabled = true, speed = 1, bezier = "liner" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "liner", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })

-- master {} was empty in the old config, so nothing to migrate there.

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,
		-- force_no_accel = true,

		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad = {
			natural_scroll = true,
		},
	},
})

-- Per-device config (this is the placeholder from the stock config; delete if unused)
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(notes))
hl.bind(mainMod .. " + Q", hl.dsp.window.close()) -- was killactive (graceful close)
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + Space", hl.dsp.window.float({ action = "toggle" })) -- was togglefloating
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))

-- Move focus with mainMod + h/j/k/l
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- workspace 10 is on key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
-- hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
-- hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging (was bindm)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Move/resize windows with mainMod + Z/X held while moving the mouse (was bindm)
hl.bind(mainMod .. " + Z", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + X", hl.dsp.window.resize(), { mouse = true })

hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen()) -- toggles real fullscreen, like before

-- Resize windows (was binde -> repeating; resizeactive was relative, so relative = true)
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.resize({ x = 30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.resize({ x = -30, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.resize({ x = 0, y = -30, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.resize({ x = 0, y = 30, relative = true }), { repeating = true })

-- Clipboard
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | tofi -c ~/.config/tofi/config | cliphist decode | wl-copy"))

-- Colour picker
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(colorPicker .. " | wl-copy"))

-- Screen locking
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend-then-hibernate && hyprlock"))

-- wlogout
hl.bind("SUPER + Escape", hl.dsp.exec_cmd("wlogout"))

-- Toggle waybar
hl.bind("CTRL + Escape", hl.dsp.exec_cmd("killall waybar || waybar"))

-- Screenshots
hl.bind("ALT + Print", hl.dsp.exec_cmd("hyprshot -m window -z --clipboard-only"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m output -z --clipboard-only"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -m region -z --clipboard-only"))

-- Volume and media control
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"))
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("pamixer --default-source -m"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("pamixer -t"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

-- Screen brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s +1%"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 1%-"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
	name = "kitty-opacity",
	match = { class = "kitty" },
	opacity = "0.9 0.8", -- active, inactive
})

hl.window_rule({
	name = "feh-float",
	match = { class = "feh" },
	float = true,
})
