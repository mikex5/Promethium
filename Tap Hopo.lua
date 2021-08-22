local sButton = Var "Button"
local sEffect = Var "Effect"
local sPlayer = Var "Player"

local feverActive = false

return Def.ActorFrame {
    Def.Model { --non fever powered fever note
        InitCommand=function(self)
            self:rotationx(90)
            if tonumber(sEffect) > 0 then
                self:diffusealpha(1)
            end
        end,
        --If this is not a fever note from the get-go, don't even bother loading the real model
        Meshes=(tonumber(sEffect) <= 0 and NOTESKIN:GetPath("non","non.txt")) or (string.find(sButton, "Strum") and NOTESKIN:GetPath("strum","tap hopo.txt")) or NOTESKIN:GetPath("fret","fever hopo.txt"),
        Materials=NOTESKIN:GetPath("resource/"..sButton,"mat.txt"),
        Bones=NOTESKIN:GetPath("fret","fever hopo.txt"),
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Active then
                    self:diffusealpha(0)
                else
                    self:diffusealpha(1)
                end
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if not params.Missed and not feverActive then
                    self:diffusealpha(1)
                else
                    self:diffusealpha(0)
                end
            end
        end
    },
    Def.Model { --fever powered fever note
        InitCommand=function(self)
            self:rotationx(90)
            if tonumber(sEffect) > 0 then
                self:diffusealpha(0)
            end
        end,
        --If this is not a fever note from the get-go, don't even bother loading the real model
        Meshes=(tonumber(sEffect) <= 0 and NOTESKIN:GetPath("non","non.txt")) or (string.find(sButton, "Strum") and NOTESKIN:GetPath("strum","tap hopo.txt")) or NOTESKIN:GetPath("fret","fever hopo.txt"),
        Materials=string.find(sButton, "Strum") and NOTESKIN:GetPath("resource/"..sButton,"fever mat.txt") or NOTESKIN:GetPath("resource/Fret 6","mat.txt"),
        Bones=NOTESKIN:GetPath("fret","fever hopo.txt"),
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Active then
                    self:diffusealpha(1)
                else
                    self:diffusealpha(0)
                end
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if feverActive and not params.Missed then
                    self:diffusealpha(1)
                else
                    self:diffusealpha(0)
                end
            end
        end
    },
    Def.Model { --non fever powered note
        InitCommand=function(self)
            self:rotationx(90)
            if tonumber(sEffect) > 0 then
                self:diffusealpha(0)
            else
                self:diffusealpha(1)
            end
        end,
        Meshes=string.find(sButton, "Strum") and NOTESKIN:GetPath("strum","tap hopo.txt") or NOTESKIN:GetPath("fret","tap hopo.txt"),
        Materials=NOTESKIN:GetPath("resource/"..sButton,"mat.txt"),
        Bones=NOTESKIN:GetPath("fret","tap hopo.txt"),
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            feverActive = params.Active
            if tonumber(sEffect) > 0 or params.Active then
                self:diffusealpha(0)
            else
                self:diffusealpha(1)
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed and not feverActive then
                    self:diffusealpha(1)
                else
                    self:diffusealpha(0)
                end
            end
        end
    },
    Def.Model { --fever powered note
        InitCommand=function(self)
            self:rotationx(90)
            self:diffusealpha(0)
        end,
        Meshes=string.find(sButton, "Strum") and NOTESKIN:GetPath("strum","tap hopo.txt") or NOTESKIN:GetPath("fret","tap hopo.txt"),
        Materials=string.find(sButton, "Strum") and NOTESKIN:GetPath("resource/"..sButton,"fever mat.txt") or NOTESKIN:GetPath("resource/Fret 6","mat.txt"),
        Bones=NOTESKIN:GetPath("fret","tap hopo.txt"),
        FeverMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if params.Active and tonumber(sEffect) <= 0 then
                self:diffusealpha(1)
            else
                self:diffusealpha(0)
            end
        end,
        FeverMissedMessageCommand=function(self,params)
            if params.pn ~= sPlayer then return end
            if tonumber(sEffect) > 0 then
                if params.Missed and feverActive then
                    self:diffusealpha(1)
                else
                    self:diffusealpha(0)
                end
            end
        end
    }
}