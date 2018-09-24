local song
local loopStart, loopEnd, loopLength

function love.load()
  -- mp3 files can't "wrap" precisely, due to how they work, so don't use them.
  song = love.audio.newSource("song.ogg")
  -- good for this kind of custom loop points
  song:setLooping(true)
  -- only doing this for show really, setting the loop points this way makes it always work :3
  local duration = song:getDuration('samples')
  -- you can support both types of loops, whether they go around the file's end or not
  loopStart = 515161 --my loop points in samples
  loopEnd = 4131460 --make sure to leave a few seconds at the end for more precise looping
  loopLength = loopEnd-loopStart
  --The song will now play from the beginning, and jump to loopStart when it reaches loopEnd
  song:play()
end

function love.update(dt)
  -- note that with vsync on, this might not be fast enough for the code to be precise enough.
  local now = song:tell("samples")
  if(now >= loopEnd) then
    song:seek(song:tell("samples")-loopLength ,"samples")
	--have it recalculate the current position, and jump backwards relatively. this helps make the loop more seamless
  end
end
--With it looping from the current spot, relative to the starting spot, it makes the loop pretty seamless (I didn't notice any skipping in the music when it looped).

/*
Copyright (c) 2011, Bart van Strien and Tommy Brunn
All rights reserved.
 
Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the <organization> nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.
 
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
soundmanager = {}
soundmanager.queue = {}
soundmanager.playlist = {}
soundmanager.currentsong = -1
 
local function shuffle(a, b)
   return math.random(1, 2) == 1
end
 
--do the magic
function soundmanager:play(sndData)
   --make a source out of the sound data
   local src = love.audio.newSource(sndData, "static")
   --put it in the queue
   table.insert(self.queue, src)
   --and play it
   love.audio.play(src)
end
 
--do the music magic
function soundmanager:playMusic(first, ...)
   --stop all currently playing music
   for i, v in ipairs(self.playlist) do
      love.audio.stop(v)
   end
   --decide if we were passed a table or a vararg,
   --and assemble the playlist
   if type(first) == "table" then
      self.playlist = first
   else
      self.playlist = {first, ...}
   end
   self.currentsong = 1
   --play
   love.audio.play(self.playlist[1])
end
 
--do some shufflin'
function soundmanager:shuffle(first, ...)
   local playlist
   if type(first) == "table" then
      playlist = first
   else
      playlist = {first, ...}
   end
   table.sort(playlist, shuffle)
   return unpack(playlist)
end
 
--update
function soundmanager:update(dt)
   --check which sounds in the queue have finished, and remove them
   local removelist = {}
   for i, v in ipairs(self.queue) do
      if v:isStopped() then
         table.insert(removelist, i)
      end
   end
   --we can't remove them in the loop, so use another loop
   for i, v in ipairs(removelist) do
      table.remove(self.queue, v-i+1)
   end
   --advance the playlist if necessary
   if self.currentsong ~= -1 and self.playlist and self.playlist[self.currentsong]:isStopped() then
      self.currentsong = self.currentsong + 1
      if self.currentsong > #self.playlist then
         self.currentsong = 1
      end
      love.audio.play(self.playlist[self.currentsong])
   end
end