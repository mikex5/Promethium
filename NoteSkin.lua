local Nskin = {}

--Defining on which direction the other directions should be bassed on
--This will let us use less files which is quite handy to keep the noteskin directory nice
--Do remember this will Redirect all the files of that Direction to the Direction its pointed to
--If you only want some files to be redirected take a look at the "custom hold/roll per direction"
Nskin.ButtonRedir =
{
    ["Fret 1"] = "Fret 1",
    ["Fret 2"] = "Fret 2",
    ["Fret 3"] = "Fret 3",
    ["Fret 4"] = "Fret 4",
    ["Fret 5"] = "Fret 5",
    ["Fret 6"] = "Fret 6",
    ["Strum Up"] = "Strum"
}

-- Defined the parts to be rotated at which degree
Nskin.Rotate =
{
    ["Fret 1"] = 0,
    ["Fret 2"] = 0,
    ["Fret 3"] = 0,
    ["Fret 4"] = 0,
    ["Fret 5"] = 0,
    ["Fret 6"] = 0,
    ["Strum Up"] = 0
}


--Define elements that need to be redirected
Nskin.ElementRedir =
{
    ["Tap Fake"] = "Tap Note",
    ["Hold Head Inactive"] = "Tap Note",
    ["Hold Tapshead Inactive"] = "Tap Taps",
    ["Hold Hopohead Inactive"] = "Tap Hopo",
    ["Hold LiftTail Inactive"] = "Tap Hopo",
    ["Hold LiftTail Active"] = "Tap Hopo",
    ["Hold Head 1 Inactive"] = "Tap Note",
    ["Hold Tapshead 1 Inactive"] = "Tap Taps",
    ["Hold Hopohead 1 Inactive"] = "Tap Hopo",
    ["Hold Body 1 Active"] = "Hold Body Active",
    ["Hold Body 1 Inactive"] = "Hold Body Inactive",
    ["Tap Explosion Dim"] = "Tap Explosion",
    ["Tap Explosion Bright"] = "Tap Explosion",
    ["Roll Explosion"] = "Hold Explosion",
    ["Hold Bottomcap 1 Active"] = "Hold Bottomcap Active",
    ["Hold Bottomcap 1 Inactive"] = "Hold Bottomcap Inactive",
}

-- Parts of noteskins which we want to rotate
Nskin.PartsToRotate =
{}

-- Parts that should be Redirected to _Blank.png
-- you can add/remove stuff if you want
Nskin.Blank =
{
    ["Hold Head Active"] = true,
    ["Hold Tapshead Active"] = true,
    ["Hold Hopohead Active"] = true,
    ["Hold Tail Active"] = true,
    ["Hold Tail Inactive"] = true,
    ["Hold Topcap Active"] = true,
    ["Hold Topcap Inactive"] = true,
    ["Hold Head 1 Active"] = true,
    ["Hold Tapshead 1 Active"] = true,
    ["Hold Hopohead 1 Active"] = true,
    ["Hold Topcap 1 Active"] = true,
    ["Hold Topcap 1 Inactive"] = true,
}

--Between here we usally put all the commands the noteskin.lua needs to do, some are extern in other files
--If you need help with lua go to http://dguzek.github.io/Lua-For-SM5/API/Lua.xml there are a bunch of codes there
--Also check out common it has a load of lua codes in files there
--Just play a bit with lua its not that hard if you understand coding
--But SM can be an ass in some cases, and some codes jut wont work if you dont have the noteskin on FallbackNoteSkin=common in the metric.ini 
function Nskin.Load()
    local sButton = Var "Button"
    local sElement = Var "Element"
    local sPlayer = Var "Player"

    --Setting global button
    local Button = Nskin.ButtonRedir[sButton] or "Down"
                
    --Setting global element
    local Element = Nskin.ElementRedir[sElement] or sElement
    
    if string.find(Element, "Lift") then
        --We want to make this a global noteskin so we will use "Center" for fallback for unknown buttons.
        Button = Nskin.ButtonRedir[sButton] or "Center"
    end
    
    if string.find(Element, "Tap Note") or
       string.find(Element, "Tap Taps") or
       string.find(Element, "Tap Hopo") or
       string.find(Element, "Tap Explosion") or
       string.find(Element, "Hold Explosion") or
       string.find(Element, "Receptor") then
        Button = ""
    end

    --Returning first part of the code, The redirects, Second part is for commands
    local t = LoadActor(NOTESKIN:GetPath(Button,Element))
    
    --Set blank redirects
    if Nskin.Blank[sElement] then
        t = Def.Actor {}
        --Check if element is sprite only
        if Var "SpriteOnly" then
            t = LoadActor(NOTESKIN:GetPath("","_blank"))
        end
    end
    
    if Nskin.PartsToRotate[sElement] then
        t.BaseRotationZ = Nskin.Rotate[sButton] or nil
    end
            
    return t
end
-- >

-- dont forget to return cuz else it wont work >
return Nskin