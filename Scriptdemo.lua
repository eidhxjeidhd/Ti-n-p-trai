loadstring(game:HttpGet(("https://raw.githubusercontent.com/daucobonhi/Ui-Redz-V2/refs/heads/main/UiREDzV2.lua")))()

       local Window = MakeWindow({
         Hub = {
         Title = "Gà gaming",
         Animation = "Youtube: gà gaming"
         },
        Key = {
        KeySystem = false,
        Title = "get key",
        Description = "",
        KeyLink = "",
        Keys = {""},
        Notifi = {
        Notifications = true,
        CorrectKey = "Running the Script...",
       Incorrectkey = "The key is incorrect",
       CopyKeyLink = "Copied to Clipboard"
      }
    }
  })

       MinimizeButton({
       Image = "http://www.roblox.com/asset/?id=105960850525996",
       Size = {30, 30},
       Color = Color3.fromRGB(10, 10, 10),
       Corner = true,
       Stroke = false,
       StrokeColor = Color3.fromRGB(255, 0, 0)
      })
      
------ Tab
     local Tab1o = MakeTab({Name = "Script farm"})
     local Tab2o = MakeTab({Name = "Script kaitun"})
------- BUTTON
    
    AddButton(Tab1o, {
     Name = "ARC Hub",
    Callback = function()
	  loadstring(game:HttpGet("https://luaegis.net/scripts/v4/loaders/f4c0252a-28e4-487c-9cbb-0f45aa6aa629.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "Simple Hub",
    Callback = function()
	  loadstring(game:HttpGet("https://luaegis.net/scripts/v4/loaders/0c015d0c-50d2-45de-a49a-c374dadda5f8.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "Star Hub",
    Callback = function()
	  loadstring(game:HttpGet("https://luaegis.net/scripts/v4/loaders/cc4aad69-ff81-454a-9a1b-aebb5b5ff2ef.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "Wind Hub",
    Callback = function()
	  loadstring(game:HttpGet("https://luaegis.net/scripts/v4/loaders/f0d52eba-b48f-4cba-805d-d1e4534fd18d.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "Quantum Hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/flazhy/QuantumOnyx/refs/heads/main/QuantumOnyx.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "Lava Hub",
    Callback = function()
	  loadstring(game:HttpGet("https://luaegis.net/scripts/v4/loaders/95688543-726e-4d60-b29b-8c37d92881a9.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "Hoho Hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "ather hub",
    Callback = function()
	  loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/2529a5f9dfddd5523ca4e22f21cceffa.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "teddy Hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/napun87/Blox-Fruits-/refs/heads/main/teddy.lua"))()
  end
  })
  
  AddButton(Tab2o, {
     Name = "VNTK",
    Callback = function()
	  loadstring(game:HttpGet("https://matrixmod.site/loader/49"))() 
  end
  })
  
  AddButton(Tab1o, {
     Name = "Dragon X hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/Tdk-Dragon/DragonX.lua/refs/heads/main/DragonX.lua.txt"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "Redz Hub",
    Callback = function()
	  loadstring(game:HttpGet("https://raw.githubusercontent.com/fakekuri/idk-hub/refs/heads/main/RedzHub.luau"))()
  end
  })
  
  AddButton(Tab2o, {
     Name = "Realkid Hub",
    Callback = function()
	  if not game:IsLoaded() then
 repeat
 game.Loaded:Wait()
 until game:IsLoaded()
end
getgenv().Configs = {
 ["Quest"] = {
 ["Evo Race V1"] = true;
 ["Evo Race V2"] = true;
 ["RGB Haki"] = true;
 ["Pull Lerver"] = true;
 };
 Sword = {
 "Dual-Headed Blade";
 "Smoke Admiral";
 "Wardens Sword";
 "Cutlass";
 "Katana";
 "Dual Katana";
 "Triple Katana";
 "Iron Mace";
 "Saber";
 "Pole (1st Form)";
 "Gravity Blade";
 "Longsword";
 "Rengoku";
 "Midnight Blade";
 "Soul Cane";
 "Bisento";
 "Yama";
 "Tushita";
 "Cursed Dual Katana";
 };
 Gun = {
 "Skull Guitar";
 "Kabucha";
 "Venom Bow";
 "Musket";
 "Flintlock";
 "Refined Slingshot"; 
 "Magma Blaster";
 "Dual Flintlock";
 "Cannon";
 "Bizarre Revolver";
 "Bazooka";
 };
 ["FPS Booster"] = false;
 ["Tween Speed"] = 350;
 ["Bypass TP"] = true;
 ["Auto Active Race V4"] = true;
};
loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/kaitun.lua"))()
  end
  })
  
  AddButton(Tab2o, {
     Name = "Night Hub",
    Callback = function()
	  getgenv().Config = {
 Team = "Pirates",
 FarmConfig = {
 ["Out game when done all"] = true,
 ["Bypass Teleport"] = true,
 ["Double Quest(RISK)"] = true
 },
 Items = {
 ["Saber"] = true,
 ["Pole (1st form)"] = true,
 ["Skull Guitar"] = true,
 ["Cursed Dual Katana"] = true,
 ["Godhuman"] = true
 },
 Webhook = {
 ["Enabled"] = false,
 ["Url"] = ""
 }
}
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/d6c7959dcc94cd24467080d82a56dcf9.lua"))()
  end
  })
  
  AddButton(Tab1o, {
     Name = "real kid hub",
    Callback = function()
	   getgenv().Configs = {
    ["Quest"] = {
        ["Evo Race V1"] = true;
        ["Evo Race V2"] = true;
        ["RGB Haki"] = true;
        ["Pull Lerver"] = true;
    };
    Sword = {
        "Dual-Headed Blade";
        "Smoke Admiral";
        "Wardens Sword";
        "Cutlass";
        "Katana";
        "Dual Katana";
        "Triple Katana";
        "Iron Mace";
        "Saber";
        "Pole (1st Form)";
        "Gravity Blade";
        "Longsword";
        "Rengoku";
        "Midnight Blade";
        "Soul Cane";
        "Bisento";
        "Yama";
        "Tushita";
        "Cursed Dual Katana";
    };
    Gun = {
        "Skull Guitar";
        "Kabucha";
        "Venom Bow";
        "Musket";
        "Flintlock";
        "Refined Slingshot";
        "Magma Blaster";
        "Dual Flintlock";
        "Cannon";
        "Bizarre Revolver";
        "Bazooka";
    };
    ["Bypass TP"] = true;
    ["Auto Active Race V4"] = true;
};
loadstring(game:HttpGet("https://raw.githubusercontent.com/realkidhub/realkid/refs/heads/main/kaitun.lua"))() 
  end
  })