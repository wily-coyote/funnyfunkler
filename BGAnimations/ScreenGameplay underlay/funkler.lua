local allowedCustomization = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).CustomizeGameplay

local t = Def.ActorFrame{
	Name = "FunnyFunkler"
}
local player = "Taz"
local opponent = "Bf"
chars = {
	["taz"] = {
		["mirror_as_opponent"] = false,
		["idle"] = 12,
		["left"] = 10,
		["up"] = 10,
		["down"] = 10,
		["right"] = 10,
		["offset"] = {[0]=0, [1]=20},
	},
	["marvin"] = {
		["mirror_as_opponent"] = true,
		["idle"] = 12,
		["left"] = 5,
		["up"] = 5,
		["down"] = 5,
		["right"] = 5,
		["offset"] = {[0]=0, [1]=0},
	},
	["bf"] = {
		["mirror_as_opponent"] = true,
		["idle"] = 12,
		["left"] = 4,
		["up"] = 4,
		["down"] = 4,
		["right"] = 4,
		["offset"] = {[0]=0, [1]=0},
	},
	["dad"] = {
		["mirror_as_opponent"] = false,
		["idle"] = 13,
		["left"] = 3,
		["up"] = 3,
		["down"] = 3,
		["right"] = 3,
		["offset"] = {[0]=0, [1]=-80},
	},
}
function PlayOnce(NumFrames, Seconds)
	local Frames = Sprite.LinearFrames(NumFrames, Seconds)
	Frames[#Frames]["Delay"] = 0
	return Frames
end
function charprop(char, what)
	return chars[string.lower(char)][what]
end
function pos(char)
	-- cant use table.unpack here :(
	return charprop(char, "offset")[0], charprop(char, "offset")[1]
end
function makeState(path, frames, track)
	return Def.Sprite{
		Texture = THEME:GetPathG("", path),
		Frames = PlayOnce(frames, frames*(1/24)),
		InitCommand = function(self)
			self:loop(false)
			self:diffusealpha(0)
		end,
		JudgmentMessageCommand = function(self, msg)
			if (msg.Type == "Tap" or msg.Type == "Hold") then
				self:setstate(0)
				self:loop(false)
				if msg.Judgment == "TapNoteScore_Miss" or (msg.Type == "Hold" and msg.Judgment == "HoldNoteScore_LetGo" or msg.Judgment == "HoldNoteScore_Held") then
					if self:GetParent() ~= nil then
					self:GetParent():queuecommand("ResetAnim") end
					return
				end
				if (msg.FirstTrack%4)+1 == track then
					self:diffusealpha(1)
				else
					self:diffusealpha(0)
				end
			end
			if msg.Type == "Mine" then
				if self:GetParent() ~= nil then
				self:GetParent():queuecommand("ResetAnim") end
			end
		end,
	}
end

function static_funkler(char)
	return Def.ActorFrame{
		InitCommand=function(self)
			self:valign(1):zoom(0.5):xy(pos(char))
		end,
		Character=char,
		Def.Sprite{
			Texture = THEME:GetPathG("", "fnf/"..char.."/idle"),
			Frames = Sprite.LinearFrames(charprop(char, "idle"), 1),
			InitCommand = function(self)
				self:loop(false)
				self:diffusealpha(1)
				self:effectclock("beat")
			end,
		},
	}
end

function funkler(char)
	local f = Def.ActorFrame{
		InitCommand=function(self)
			self:valign(1):zoom(0.5):xy(pos(char))
		end,
		ResetAnimCommand=function(self)
			for i, v in pairs(self:GetChildren()) do
				v:setstate(0):diffusealpha(0)
			end
			self:GetChild("Idle"):setstate(0):diffusealpha(1)
		end,
		Def.Sprite{
			Name="Idle",
			Texture = THEME:GetPathG("", "fnf/"..char.."/idle"),
			Frames = Sprite.LinearFrames(charprop(char, "idle"), 1),
			InitCommand = function(self)
				self:loop(false)
				self:diffusealpha(1)
				self:effectclock("beat")
			end,
			JudgmentMessageCommand = function(self, msg)
				if (msg.Type == "Tap" or msg.Type == "Hold") then
					self:setstate(0)
					self:diffusealpha(0)
				end
			end,
		},
		makeState("fnf/"..char.."/left", charprop(char, "left"), 1) .. {
			Name="Left",
		},
		makeState("fnf/"..char.."/down", charprop(char, "down"), 2) .. {
			Name="Down",
		},
		makeState("fnf/"..char.."/up", charprop(char, "up"), 3) .. {
			Name="Up",
		},
		makeState("fnf/"..char.."/right", charprop(char, "right"), 4) .. {
			Name="Right",
		},
	}
	if charprop(char, "mirror_as_opponent") == true then
		-- dirty hack
		f[#f+1] = Def.Actor{
			Name="mirror_as_opponent"
		}
	end
	return f
end

t[#t+1] = funkler(opponent) .. {
	Name="Opponent",
	OnCommand = function(self)
		if self:GetChild("mirror_as_opponent") ~= nil then
			self:basezoomx(-1)
		end
	end
}
t[#t+1] = funkler(player) .. {
	Name="Player",
	OnCommand = function(self)
		if self:GetChild("mirror_as_opponent") == nil then
			self:basezoomx(-1)
		end
	end
}
t[#t+1] = MovableBorder(240, 240, 1, 0, 0)

t.OnCommand = function(self)
	-- MovableValues.FunklerX, MovableValues.FunklerY
	self:xy(0, 0):zoom(MovableValues.FunklerZoom)
	self:GetChild("Opponent"):x(-(MovableValues.FunklerGap/2))
	self:GetChild("Player"):x(MovableValues.FunklerGap/2)
-- if allowedCustomization then
-- 	Movable.DeviceButton_m.element = self
-- 	Movable.DeviceButton_g.element = self
-- 	Movable.DeviceButton_m.condition = true
-- 	Movable.DeviceButton_g.condition = true
-- 	Movable.DeviceButton_m.Border = self:GetChild("Border")
-- 	Movable.DeviceButton_g.Border = self:GetChild("Border")
-- end
end

return t