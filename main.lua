-- main.lua

-- LIBS --
local lib_love = require("love")
local mod_camera = require("libs/camera")

-- MY MODS --
local mod_player_ship = require("player_ship")
local mod_player = require("player")
local mod_screen = require("screen")
local mod_view_params = require("view_params")
local mod_handle_input = require("handle_input")
local mod_background = require("background")
local mod_state = require("state")
local mod_main_menu = require("/menu/main_menu")

-- VARIABLES --
local cam = mod_camera()
local params = {
  ship_x = nil,
  ship_y = nil,
  ship_speed = nil
}

-- LOADS --
function lib_love.load()
  mod_player_ship.load_player_ship()
  mod_player.load_player()
  mod_screen.load_screen()
  mod_main_menu.load_main_menu()
end

-- UPDATES --
local function update_player_ship_view_params()
  params = {
    -- Смещаю центр координат на центр отображаемой карты и превожу координаты корабля в соответствие с этим
    ship_x = mod_player_ship.ship.x - mod_background.map_x_center,
    ship_y = mod_player_ship.ship.y - mod_background.map_y_center,
    ship_speed = mod_player_ship.ship.speed
  }
end

function lib_love.update(dt)
  if mod_state.state_pause then
    mod_main_menu.update_main_menu()
    return
  end

  update_player_ship_view_params()
  mod_handle_input.handle_input(dt)
  mod_player_ship.update_player_ship(dt)
  mod_player.update_player(dt)
  if mod_player_ship.ship.trust then
    mod_player_ship.update_player_ship_animation(dt)
  end

  if mod_state.state == "ship" then
    cam:lookAt(mod_player_ship.ship.x, mod_player_ship.ship.y)
  end
  if mod_state.state == "player" then
    cam:lookAt(mod_player.player.x, mod_player.player.y)
  end
end

-- KEY PRESSED --
function lib_love.keypressed(key)
  if key == "escape" then
    if mod_state.state_pause then
      mod_main_menu.callback_menu_deactivate()
    elseif mod_state.state == "ship" or mod_state.state == "player" then
      mod_main_menu.callback_menu_activate()
    end

  elseif key == "e" then
    if mod_state.state == "ship" then
      mod_state.state = "player"
      cam:zoom(mod_state.player_zoom)
      cam:rotate(-mod_player_ship.ship.angle)
    elseif mod_state.state == "player" then
      mod_state.state = "ship"
      cam:zoom(mod_state.ship_zoom)
      cam:rotate(mod_player_ship.ship.angle)
    end
  end
end

function lib_love.mousepressed(x, y, button)
  if button == 1 then
    if mod_state.state_pause then
      mod_main_menu.mousepressed_left_pause()
    end
  end
end

-- DRAW --
function lib_love.draw()
  cam:attach()
    mod_background.draw_bacground()
    if mod_state.state == "ship" then
      mod_player_ship.draw_player_ship_state_ship()
    end
    if mod_state.state == "player" then
      mod_player_ship.draw_player_ship_state_player()
      mod_player.draw_player()
    end
  cam:detach()
  mod_view_params.view_params(params)

  if mod_state.state_pause then
    mod_main_menu.draw_main_menu()
  end
  --lib_love.graphics.print("FPS: " .. lib_love.timer.getFPS(), 10, 10)
end
