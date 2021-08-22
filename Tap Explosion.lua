local sButton = Var "Button"

local Explosion = Def.ActorFrame{}

local ExploCom = function(self) 
    if string.find(sButton, "Strum") then
        self:stoptweening():z(5):diffuse(.8,0,.8,1):zoom(1):linear(.15):z(30):diffuse(.6,0,.6,1):zoom(.5):decelerate(.15):z(50):diffuse(.5,0,.5,0):zoom(.3)
    else
        self:stoptweening():z(5):diffuse(1,1,1,1):zoom(1):linear(.15):z(math.random(30,50)):diffuse(1,.8,.1,1):zoom(.5):decelerate(.15):z(math.random(50,80)):diffuse(.5,.1,0,0):zoom(math.random(1,5)/10)
    end
end

for i = 1,12 do
    Explosion[#Explosion+1] = Def.ActorFrame{
        InitCommand=function(self)
            self:diffusealpha(0):zoom(1)
            if string.find(sButton, "Strum") then
                self:xy((30*i) - 195, 15)
            else
                self:xy((2.5*i) - 16.25, 15)
            end
        end,
        W1Command=ExploCom,
        W2Command=ExploCom,
        W3Command=ExploCom,
        W4Command=ExploCom,
        W5Command=ExploCom,
        Def.Sprite {
            InitCommand=function(self) self:rotationx(90) end,
            Texture=string.find(sButton, "Strum") and 'partstrum.png' or 'particle.png',
            Frames=Sprite.LinearFrames( 1, 1 ),
        }
    }
end

return Explosion