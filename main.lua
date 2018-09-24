
-- Pull in Gamestate from the HUMP library
Gamestate = require 'libs.hump.gamestate'

-- Pull in each of our game states
local mainMenu = require 'gamestates.mainMenu'
local gameLevel1 = require 'gamestates.gamelevel1'
local pause = require 'gamestates.pause'

function love.load()
  Gamestate.registerEvents()
  Gamestate.switch(gameLevel1)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.push("quit")
  end
end

--function love.draw()
--love.graphics.print("Hello World!", 400, 300)
--end
