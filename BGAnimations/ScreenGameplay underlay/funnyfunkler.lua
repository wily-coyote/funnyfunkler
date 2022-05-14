local allowedCustomization = playerConfig:get_data(pn_to_profile_slot(PLAYER_1)).CustomizeGameplay
local enabled = true
if enabled then
t = Def.ActorFrame{
	Name="Funklers",
	InitCommand=function(self)
		self:draworder(0)
		self:valign(0.5)
		self:halign(0.5)
		self:pulse():effectmagnitude(1, 1.025, 1):effecttiming(0, 0, 0.75, 0.25):effectclock("beat")
	end,
	OnCommand=function(self)
		self:draworder(0)
	end,
	Def.ActorFrame{
		Name="Background",
		InitCommand = function(self)
			self:zoom(0.5)
			self:pulse():effectmagnitude(1, 1.0125, 1):effecttiming(0, 0, 0.75, 0.25):effectclock("beat")
		end,
		Def.Sprite{
			Texture=THEME:GetPathG("", "fnf/stageback.png"),
		},
		Def.Sprite{
			Texture=THEME:GetPathG("", "fnf/stagefront.png"),
			InitCommand = function(self)
				self:zoom(1)
				self:valign(1)
				self:y(650)
			end,
		},
		Def.Sprite{
			Texture=THEME:GetPathG("", "fnf/stagecurtains.png"),
			InitCommand = function(self)
				self:zoom(1)
				self:valign(1)
				self:y(650)
			end,
		},
		Def.Sprite{
			Texture=THEME:GetPathG("", "fnf/Gf/dance"),
			Frames=Sprite.LinearFrames(30, 2),
			InitCommand = function(self)
				self:zoom(1)
				self:valign(1)
				self:y(180)
				self:effectclock("beat")
			end,
		}
	},
	LoadActor("funkler"),
}

t.OnCommand=function(self)
	-- self:xy(MovableValues.FunklerX, MovableValues.FunklerY)
	self:xy(SCREEN_CENTER_X, SCREEN_CENTER_Y)
end

-- SCREENMAN:GetTopScreen():GetChild("PlayerP1"):GetChild("NoteField"):GetChild("Board"):visible(false)

return t
end