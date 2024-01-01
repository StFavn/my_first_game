local lib_love = require("love")

local screen_width = lib_love.graphics.getWidth()
local screen_height = lib_love.graphics.getHeight()

local function load_screen()
    lib_love.window.setMode(screen_width, screen_height)
    lib_love.window.setTitle("St_favn space_ship")
end

return {
    screen_width = screen_width,
    screen_height = screen_height,
    load_screen = load_screen
}
