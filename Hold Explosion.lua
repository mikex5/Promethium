local sButton = Var "Button"

local HoldExplosion = Def.ActorFrame{}

for i = 1,16 do
    HoldExplosion[#HoldExplosion+1] = Def.ActorFrame{
        InitCommand=function(self)
            if string.find(sButton, "Strum") then
                self:diffusealpha(0):zoom(math.random(10,20)/10):xyz((22*i) - 176,-5,3):rotationx(90)
            else
                self:diffusealpha(0):zoom(math.random(10,20)/10):xyz(0,0,3):rotationx(90)
            end
        end,
        HoldingOnCommand=function(self) self:diffusealpha(1) end,
        HoldingOffCommand=function(self)
            self:stoptweening():diffusealpha(0)
        end,
        Def.Sprite {
            InitCommand=function(self)
                local period = math.random(20,50) / 100
                if string.find(sButton, "Strum") then
                    self:diffuse(.8,0,.8,1):y(-5)
                    self:bounce():effectclock("timer"):effectperiod(period):effectmagnitude(0,0,-20)
                    self:SetAllStateDelays(period / 8)
                else
                    local offset = math.rad(math.random(-80,80))
                    self:bounce():effectclock("timer"):effectperiod(period):effectmagnitude(20 * math.sin(offset),0,-75 * math.cos(offset))
                    self:SetAllStateDelays(period / 8)
                end
            end,
            Texture='spark 8x1.png'
        }
    }
end

return Def.ActorFrame {
    Def.Sprite {
        Texture='particle.png',
        InitCommand=function(self)
            self:diffusealpha(0):zoomx(1.8):zoomy(0.2):xy(0,0):rotationx(90)
        end,
        HoldingOnCommand=function(self)
            if not string.find(sButton, "Strum") then
                self:diffusealpha(1):pulse(2,2.5):effectclock("timer"):effectperiod(0.2):effectmagnitude(0.9,1,1)
            end
        end,
        HoldingOffCommand=function(self)
            self:stoptweening():diffusealpha(0)
        end,
    },
    HoldExplosion
}