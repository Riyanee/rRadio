local pma = exports["pma-voice"]
local open = false
local Radio = {Tick = false, Bruitages = true, Volume = 1}

local Menu_rRadio = RageUI.CreateMenu(Config.Menu.Title, Config.Menu.Subtitle)
Menu_rRadio.Closed = function() open = false end
Menu_rRadio.EnableMouse = true

MenuRadio = function()
	RageUI.Visible(Menu_rRadio, true)
	Citizen.CreateThread(function()
		while open do
            RageUI.IsVisible(Menu_rRadio, function()
				RageUI.Button("Allumer / Eteindre", "Vous permet d'allumer ou d'éteindre la radio", {RightLabel = "→→→"}, true, {onSelected = function()
					if not Radio.Tick then 
						Radio.Tick = true 
						pma:setVoiceProperty("radioEnabled", true)
						ESX.ShowNotification("~p~Radio Allumée !")
					else
						Radio.Tick = false
						pma:setVoiceProperty("radioEnabled", false)
						ESX.ShowNotification("~r~Radio Eteinte !")
					end
				end})

				if Radio.Tick then
					RageUI.Separator("Radio: ~g~Allumée")
	
					if Radio.Bruitages then 
						RageUI.Separator("Bruitages: ~g~Activés")
					else
						RageUI.Separator("Bruitages: ~r~Désactivés")
					end
	
					if Radio.Volume*100 <= 20 then 
						ColorRadio = "~g~" 
					elseif Radio.Volume*100 <= 45 then 
						ColorRadio ="~y~" 
					elseif Radio.Volume*100 <= 65 then 
						ColorRadio ="~o~" 
					elseif Radio.Volume*100 <= 100 then 
						ColorRadio ="~r~" 
					end 
	
					RageUI.Separator("Volume: "..ColorRadio..ESX.Math.Round(Radio.Volume*100).."~s~ %")
					RageUI.Button("Se connecter à une fréquence ", "Choissisez votre fréquence", {RightLabel = Radio.Frequence}, true, {onSelected = function()
						local verif, Frequence = CheckQuantity(KeyboardInput("Frequence", "Frequence", "", 10))
						
						if Frequence <= 999 then
							Radio.Frequence = Frequence
							pma:setRadioChannel(Frequence)
							ESX.ShowNotification("~b~Fréquence définie sur "..Frequence.." MHZ")
						else
							ESX.ShowNotification("~r~Vous devez mettre une fréquence entre 1 et 999")
						end
					end})
	
					RageUI.Button("Se déconnecter de la fréquence", "Vous permet de déconnecter de votre fréquence actuelle", {RightLabel = "→→→"}, true, {onSelected = function()
						pma:setRadioChannel(0)
						Radio.Frequence = "0"
						ESX.ShowNotification("Vous vous êtes déconnecter de la fréquence")
					end})
	
					RageUI.Button("Activer les bruitages", "Vous permet d'activer les bruitages", {RightLabel = "→→→"}, true, {onSelected = function()
						if Radio.Bruitages then 
							Radio.Bruitages = false
							pma:setVoiceProperty("micClicks", false)
							ESX.ShowNotification("Bruitages radio désactives")
						else
							Radio.Bruitages = true 
							ESX.ShowNotification("Bruitages radio activés")
							pma:setVoiceProperty("micClicks", true)
						end
					end})
				else
					RageUI.Separator("Radio: ~r~Eteinte")
				end
			end, function()
				RageUI.PercentagePanel(Radio.Volume, 'Volume', '0%', '100%', {onProgressChange = function(Percentage)	
					Radio.Volume = Percentage
					pma:setRadioVolume(Percentage)
				end}, 5) 
			end)

            if not open then
                RMenu:DeleteType(Menu_rRadio)
            end

            Citizen.Wait(1.25)
        end
    end)
end

Keys.Register(Config.Menu.KeyToOpenMenu, 'MenuRadio', 'Menu Radio', function()
	if open then 
		return
	else
        if Config.Item.NeedItem then
			ESX.TriggerServerCallback('rRadio:getItem', function(qtty)
				if qtty >= 1 then
					open = true
					MenuRadio()
				else
					ESX.ShowNotification("~r~Vous n'avez pas de radio")
				end
			end, Config.Item.NameItem)
		else
			open = true
			MenuRadio()
		end
	end
end)