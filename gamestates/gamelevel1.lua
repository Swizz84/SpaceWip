
-- Import our libraries.
local Gamestate = require 'libs.hump.gamestate'
local Class = require 'libs.hump.class'

-- Grab our base class
local LevelBase = require 'gamestates.LevelBase'

-- Import the Entities we will build.
local Player = require 'entities.player'
local camera = require 'libs.camera'

-- Declare a couple immportant variables
player = nil

math.randomseed(os.time())
math.random()
math.random()
math.random()


local gameLevel1 = Class{
  __includes = LevelBase
}

function gameLevel1:init()
  LevelBase.init(self, 'assets/levels/level_1.lua')
  
  --Parallax Scrolling test
   camera.layers = {}
  
  for i = .5, 3, .5 do
    local rectangles = {}
    
    for j = 1, math.random(2, 15) do
      table.insert(rectangles, {
        math.random(0, 1600),
        math.random(0, 1600),
        math.random(50, 400),
        math.random(50, 400),
        color = { math.random(0, 255), math.random(0, 255), math.random(0, 255) }
      })
    end
    
    camera:newLayer(i, function()
      for _, v in ipairs(rectangles) do
        love.graphics.setColor(v.color)
        love.graphics.rectangle('fill', unpack(v))
        love.graphics.setColor(255, 255, 255)
      end
    end)
  end
end

function gameLevel1:enter()
  player = Player(self.world,  32, 64)
  LevelBase.Entities:add(player)
  
	--music = love.audio.newSource("assets/audio/music/Evan King - 20XX - 18 Aeon Prime.mp3") -- if "static" is omitted, LÖVE will stream the file from disk, good for longer music tracks
	--music:setLooping(true)
	--music:play()
end

function gameLevel1:update(dt)
  self.map:update(dt) -- remember, we inherited map from LevelBase
  LevelBase.Entities:update(dt) -- this executes the update function for each individual Entity

  LevelBase.positionCamera(self, player, camera)
end

function gameLevel1:draw()
  -- Attach the camera before drawing the entities
  --camera:draw()
  camera:set()


  self.map:draw(-camera.x, -camera.y) -- Remember that we inherited map from LevelBase
  LevelBase.Entities:draw() -- this executes the draw function for each individual Entity

  camera:unset()
  -- Be sure to detach after running to avoid weirdness
end

-- All levels will have a pause menu
function gameLevel1:keypressed(key)
  LevelBase:keypressed(key)
end

return gameLevel1
