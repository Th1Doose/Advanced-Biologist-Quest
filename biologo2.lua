quest biologo2 begin
	state start begin
	end

	state run begin
		function secondsToTime(seconds, begin_phrase, end_phrase) --Alterar o nome da função sempre que adicionar a uma nova dung.
			local real_seconds = seconds - get_time()
			local hours = string.format("%02.f", math.floor(real_seconds/3600));
			local mins = string.format("%02.f", math.floor(real_seconds/60 - (hours*60)));
			local secs = string.format("%02.f", math.floor(real_seconds - hours*3600 - mins *60));
			return(""..begin_phrase.." "..hours.."h. "..mins.." min. "..secs.."secs."..end_phrase)
		end
		when login or levelup with pc.get_level() >= 35 begin
			set_state("orc_biolog_f2")
		end
	end

	state orc_biolog_f2 begin
		when letter begin
			send_letter("Second Biologist")
		end

		when button or info begin
			say_title("Orc Tooth+")
			say("Hi Soldier.")
			say("I'm the hidden searcher.")
			say("I'm here to ask for 15 orc tooth+.")
			say("Are you willing to do that for me?")
			local s = select("Yes","No")
			if s == 1 then
				set_state("orc_biolog_f2_1")
				clear_letter()
				pc.setqf("tooth_count_plus", 15)
			elseif s == 2 then
				return
			end
		end
	end

	state orc_biolog_f2_1 begin
		when letter begin
			send_letter("Orc Tooth+")
		end

		when button or info begin
			local pctg = number(1,2)
			say_title("Orc Tooth+")
			say("Deliver Orc Tooth+.")
			local s = select("Yes","No")
			if s == 1 then
				if pc.getqf("tooth_deliver_delayplus") > get_global_time() then
					say_title("Time")
					say("You need to wait 15 minutes.")
					say("")
					say_reward(string.format(biologo2.secondsToTime(pc.getqf("tooth_deliver_delayplus"), "Remaining time: ", "")))
					return
				elseif pc.count_item(30077) < 1 then
					say_title("Orc Tooth+")
					say("You don't have Orc Tooth+.")
				elseif pc.count_item(30077) >= 1 then
					if pctg == 1 then
						pc.setqf("tooth_count_plus", pc.getqf("tooth_count_plus") - 1)
						if pc.getqf("tooth_count_plus") >= 1 then
							say_title("Orc Tooth+")
							say("This tooth+ is in perfect condition.")
							pc.remove_item(30077, 1)
							say_reward(string.format("There is "..pc.getqf("tooth_count_plus").." orc tooth+ left to deliver."))
							pc.setqf("tooth_deliver_delayplus", get_global_time() + 60*15)
						else
							say_title("Orc Tooth+")
							say("It was the last Tooth+.")
							say("Good Job!!")
							say("Here is your reward")
							say_reward("5% Against Monsters.")
							-- affect . add_collect ( 60 , 10 , 60 * 60 * 24 * 365 * 60 ) -- Escolher o bonus para dar. 60 -> bonus, 10 -> %.
							clear_letter()
							set_state("orc_biolog_f2_2")
							--set_quest_state("biologo2","run") -- Para quando começar a quest das maldições.
						end
					elseif pctg != 1 then
						say_title("Orc Tooth+")
						say("It was the wrong one.")
						say("Try again in 15 minutes.")
						pc.remove_item(30077, 1)
						say_reward(string.format("Left to deliver: "..pc.getqf("tooth_count_plus").." orc tooth+."))
						pc.setqf("tooth_deliver_delayplus", get_global_time() + 60*15)
					end
				end
			--elseif s == 2 then
			--	if pc.count_item(31030) < 1 then
			--		say_title("Remove Time")
			--		say("You don't have the item.")
			--	elseif pc.getqf("tooth_deliver_delayplus") > 0 then
			--		pc.setqf("tooth_deliver_delayplus", get_global_time() * 0)
			--		pc.remove_item(31030, 1)
			--		chat("You reseted the cooldown of mission.")
			--	elseif pc.getqf("tooth_deliver_delayplus") <= 0 then
			--		chat("Cooldown already reseted.")
			--	end
			elseif s == 2 then
				return
			end
		end
	end

	state orc_biolog_f2_2 begin
	end

end