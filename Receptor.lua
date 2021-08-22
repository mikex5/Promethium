local sButton = Var "Button"
local sPlayer = Var "Player"
if not GHReceptor then GHReceptor = {} end
if not GHReceptor[sPlayer] then GHReceptor[sPlayer] = {} end
if not GHReceptor[sPlayer][sButton] then GHReceptor[sPlayer][sButton] = {} end

local Buttons = {
    "Fret 1",
    "Fret 2",
    "Fret 3",
    "Fret 4",
    "Fret 5"
}

local feverActive = false

if sButton == "Strum Up" then
    return Def.ActorFrame{
        Def.ActorFrame{ --Fever meter
            OnCommand=function(self) self:z(-5) end,
            Def.Quad{
                OnCommand=function(self)
                    self:zoomto(32,100):diffuse(0,0,0,1):xy(184,-48)
                end
            },
            Def.Quad{
                OnCommand=function(self)
                    self:zoomto(22,90):diffuse(1,.9,.3,1):xy(184,-48):croptop(1)
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    feverActive = params.Active
                    if params.Active then
                        self.Active = true
                        self:linear((self.Amount /125)*12.5):croptop(1)
                    else
                        self.Active = false
                    end
                end,
                FeverScoreMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    self.Amount = params.Amount;
                    self:stoptweening():linear(.1):croptop(1-(params.Amount /125))
                    if not self.Active then
                        if params.Amount >= 50 then 
                            self:diffuseshift():effectcolor1(.4,.9,1,1):effectcolor2(.8,1,1,1):effectperiod(.5)
                        else 
                            self:stopeffect():diffuse(1,.9,.3,1)
                        end
                    else
                        self:stoptweening():stopeffect():linear((self.Amount /125)*12.5):croptop(1)
                    end
                end
            },
            Def.Sprite{
                InitCommand=function(self)
                    self:xy(184,-48):draworder(110)
                end,
                Texture='feveroverlay.png'
            },
            PressCommand=function(self) --Function to make the receptors bop? why here?
                local FretActive = false
                for _,v in ipairs(Buttons) do
                    if GHReceptor[sPlayer][v][2] then
                        GHReceptor[sPlayer][v][3]:stoptweening():bounceend(.1):z(6):bounceend(.1):z(0)
                        GHReceptor[sPlayer][v][4]:stoptweening():bounceend(.1):z(6):bounceend(.1):z(0)
                        FretActive = true
                        end
                end
                if not FretActive then
                    for _,v in ipairs(Buttons) do
                        GHReceptor[sPlayer][v][1]:stoptweening():bounceend(.1):z(6):bounceend(.1):z(0)
                    end
                end
            end
        },
        Def.ActorFrame{ --Score and multiplier
            OnCommand=function(self) self:z(-5) end,
            Def.Quad{
                OnCommand=function(self) 
                    self:zoomto(80,100):diffuse(0,0,0,1):xy(-210,-48)
                end
            },
            Def.BitmapText{
                Text="1x",
                Font="Common Normal",
                OnCommand=function(self) self:zoom(2):halign(0):xy(-220,-70) end,
                ComboChangedMessageCommand=function(self,params)
                    if params.Player ~= sPlayer then return end
                    local curCombo = params.PlayerStageStats:GetCurrentCombo()
                    local percent = 1
                    self:diffuse(1,1,1,1)
                    
                    if curCombo >= 30 then
                        percent = 4
                        self:diffuse(.8,.1,1,1)
                    elseif curCombo >= 20 then
                        percent = 3
                        self:diffuse(.1,.8,.1,1)
                    elseif curCombo >= 10 then
                        percent = 2
                        self:diffuse(1,.8,.1,1)
                    end
                    
                    if feverActive then
                        percent = percent*2
                        self:diffuse(.4,1,1,1)
                    end
                    
                    self:settext("x"..percent)
                end
            },
            Def.BitmapText{
                Text="0",
                Font="Common Normal",
                OnCommand=function(self) self:zoom(.6):halign(1):xy(-175,-15) end,
                ComboChangedMessageCommand=function(self,params)
                    if params.Player ~= sPlayer then return end
                    self:settext(params.PlayerStageStats:GetScore())
                end
            },
            Def.BitmapText{
                Text="oooooooooo",
                Font="Common Normal",
                OnCommand=function(self) self:zoom(.65):halign(1):xy(-175,-38):diffuse(1,1,1,1) end,
                ComboChangedMessageCommand=function(self,params)
                    if params.Player ~= sPlayer then return end
                    local curCombo = params.PlayerStageStats:GetCurrentCombo()
                    if curCombo >= 30 then
                        self:diffuse(.8,.1,1,1)
                    elseif curCombo >= 20 then
                        self:diffuse(.1,.8,.1,1)
                    elseif curCombo >= 10 then
                        self:diffuse(1,.8,.1,1)
                    else
                        self:diffuse(1,1,1,1)
                    end
                    
                    if feverActive then
                        self:diffuse(.4,1,1,1)
                    end
                end
            },
            Def.BitmapText{
                Text="",
                Font="Common Normal",
                OnCommand=function(self) self:zoom(1.2):halign(0):xy(-246.5,-43):diffuse(1,1,1,1) end,
                ComboChangedMessageCommand=function(self,params)
                    if params.Player ~= sPlayer then return end
                    local curCombo = params.PlayerStageStats:GetCurrentCombo()
                    if curCombo >= 30 then
                        self:settext("..........")
                        self:diffuse(.8,.1,1,1)
                    elseif curCombo == 0 then
                        self:settext("")
                    else
                        local pips = curCombo % 10
                        if pips == 0 then pips = 10 end
                        self:settext(string.rep(".",pips))
                        
                        if curCombo >= 30 then
                            self:diffuse(.8,.1,1,1)
                        elseif curCombo >= 20 then
                            self:diffuse(.1,.8,.1,1)
                        elseif curCombo >= 10 then
                            self:diffuse(1,.8,.1,1)
                        else
                            self:diffuse(1,1,1,1)
                        end
                    end
                    
                    if feverActive then
                        self:diffuse(.4,1,1,1)
                    end
                end
            },
        },
        Def.ActorFrame{ --Highway
            OnCommand=function(self) self:z(-8) end,
            Def.Quad{
                OnCommand=function(self) 
                    self:zoomto(330,1100):diffuse(0,0,0,.65):diffusetopedge(0,0,0,0):xy(0,-530)
                end
            },
            Def.Quad{
                OnCommand=function(self) 
                    self:zoomto(330,64):diffuse(0,0,0,1):xy(0,-12)
                end
            },
            Def.Quad{ --Highway edges
                InitCommand=function(self)
                    self:xy(-166,-237):zoomto(2,512):diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:diffuse(.4,1,1,1):diffusetopedge(.4,1,1,0)
                    else
                        self:diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                    end
                end,
            },
            Def.Quad{
                InitCommand=function(self)
                    self:xy(166,-237):zoomto(2,512):diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                end,
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:diffuse(.4,1,1,1):diffusetopedge(.4,1,1,0)
                    else
                        self:diffuse(1,1,1,1):diffusetopedge(1,1,1,0)
                    end
                end,
            },
            Def.ActorFrame{ --Fever effects
                InitCommand=function(self)
                    self:y(-110):diffusealpha(0)
                end,
                Def.Sprite{
                    Texture="feversprite1.png",
                    InitCommand=function(self)
                        self:x(-102):diffuse(.4,1,1,1):zoom(4)
                    end
                },
                Def.Sprite{
                    Texture="feversprite1.png",
                    InitCommand=function(self)
                        self:x(102):zoomx(-4):zoomy(4):diffuse(.4,1,1,1)
                    end
                },
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:y(-110):diffusealpha(1):linear(0.5):y(-800):diffusealpha(0)
                    else
                        self:diffusealpha(0):y(-64)
                    end
                end,
            },
            Def.ActorFrame{ --More fever effects
                InitCommand=function(self)
                    self:y(-400):diffusealpha(0)
                end,
                Def.Quad{
                    InitCommand=function(self)
                        self:x(-150):zoomto(32,840):diffuse(.4,1,1,0):diffuselowerleft(.4,1,1,1)
                    end
                },
                Def.Quad{
                    InitCommand=function(self)
                        self:x(150):zoomto(-32,840):diffuse(.4,1,1,0):diffuselowerleft(.4,1,1,1)
                    end
                },
                FeverMessageCommand=function(self,params)
                    if params.pn ~= sPlayer then return end
                    if params.Active then
                        self:diffuseshift():diffusealpha(1):effectcolor1(1,1,1,1):effectcolor2(1,1,1,.5):effectperiod(1)
                    else
                        self:stopeffect():diffusealpha(0)
                    end
                end,
            }
        }
    }
end

local Push = Def.ActorFrame{
    Def.Model {
        InitCommand=function(self)
            self:diffusealpha(0):rotationx(90)
            GHReceptor[sPlayer][sButton][3] = self
        end,
        PressCommand=function(self)
            if feverActive == false then
                self:diffusealpha(1)
            end
        end,
        LiftCommand=function(self) self:diffusealpha(0) end,
        Meshes=NOTESKIN:GetPath("_receptor","inner.txt"),
        Materials=NOTESKIN:GetPath("resource/"..sButton,"mat.txt"),
        Bones=NOTESKIN:GetPath("_receptor","inner.txt")
    },
    Def.Model {
        InitCommand=function(self)
            self:diffusealpha(0):rotationx(90)
            GHReceptor[sPlayer][sButton][4] = self
        end,
        PressCommand=function(self)
            if feverActive == true then
                self:diffusealpha(1)
            end
        end,
        LiftCommand=function(self) self:diffusealpha(0) end,
        Meshes=NOTESKIN:GetPath("_receptor","inner.txt"),
        Materials=NOTESKIN:GetPath("resource/Fret 6","mat.txt"),
        Bones=NOTESKIN:GetPath("_receptor","inner.txt")
    }
}

return Def.ActorFrame {
    InitCommand=function(self)
        GHReceptor[sPlayer][sButton][1] = self
        GHReceptor[sPlayer][sButton][2] = false
    end,
    PressCommand=function(self)
        GHReceptor[sPlayer][sButton][2] = true
    end,
    LiftCommand=function(self)
        GHReceptor[sPlayer][sButton][2] = false
    end,
    Def.Model {
        InitCommand=function(self) self:rotationx(90) end,
        Meshes=NOTESKIN:GetPath("_receptor","outer.txt"),
        Materials=NOTESKIN:GetPath("resource/"..sButton,"mat.txt"),
        Bones=NOTESKIN:GetPath("_receptor","outer.txt"),
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffusealpha(0)
            else
                self:diffusealpha(1)
            end
        end
    },
    Def.Model {
        InitCommand=function(self) self:rotationx(90):diffusealpha(0) end,
        Meshes=NOTESKIN:GetPath("_receptor","outer.txt"),
        Materials=NOTESKIN:GetPath("resource/Fret 6","mat.txt"),
        Bones=NOTESKIN:GetPath("_receptor","outer.txt"),
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active then
                self:diffusealpha(1)
            else
                self:diffusealpha(0)
            end
        end
    },
    Push
}