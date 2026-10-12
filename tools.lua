--tools

function init_obj()
	stars={}
	star_types= {star1, star2, star3}
	tiros={}
	inimigos={}
	init_cronometro()
end



--shake screen

function  shake_init()
 shake=0
 shake_cai=0
end

function shake_screen(intensidade,caimento)
	shake=intensidade
	shake_cai=caimento
end

function shake_update()
 if shake > 0 then
	 shake-=shake_cai
 else
  shake=0
 end
end

--funcao antiga
--[[
function shake_screen()
	shake=5
	if screen_shake==true then
		camera(rnd(shake),rnd(shake))
		shake_timer-=1
  if shake_timer < 0 then
   shake_timer=15
   screen_shake=false
  end
	else
	 camera()
	end --if end
end --end funcao
]]--



function hud()
 --desenhar vida 
	for v = 1,3 do
		if v <= p1.hp then
		spr(16,(v*10)-5,8)
		else
		spr(32,(v*10)-5,8)
		end
	end
	rect(3,6,34,17,3)
	print("vida",4,2,7)
	spr(15,3,19)
	 --[[
	 rectfill(29,55,102,88,7)
	 pal(5,0)
	 spr(64,30,56,9,4)
  pal()
 ]]--
end


function init_cronometro()
	cronometro={}
	timer_base={t=0,n="base",r=0}
	add(cronometro,timer_base)
end

function update_cronometro()
	for t in all(cronometro) do
		t.t-=1
	end
end


function set_timer(tempo,nome)
	local resetar = tempo
	for t in all(cronometro) do
		if nome == t.n then return end
	end
	add(cronometro,{t=tempo,n=nome,r=resetar})
end

function reset_timer(nome)
	for t in all(cronometro) do
		if t.n == nome then
			t.t = t.r
		end
	end

end

function timer(nome)
	for t in all(cronometro) do
		if t.n == nome then
			if t.t < 0 then
				return true
			else
				return false
			end --se zerou
  		end --nome
	end --end loop
end --end funcao


function conta_tiro()
	local conta_tiro=0
	for t in all(tiros) do
		if t.nome == "tiro" then
			conta_tiro+=1
		end
	end
	c_tiro=conta_tiro
end

function tiro_foi_dado()
	local c=0
	for t in all(tiros) do
		if t.nome == "tiro" then 
			c+=1
		end
	end
	if c_tiro < c then
		return true
	else
		return false
	end
end