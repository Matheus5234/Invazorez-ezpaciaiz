
--main
--[[***There is an initialization-order issue in main.lua: _init() calls
init_p() before init_obj(), but init_obj() initializes cronometro,
which set_timer() needs. Call init_obj() before init_p() to avoid a
runtime error when setting the timer.
]]--

--[[
* abelha e todo seu sistema
* funcao para inimigos piscarem
* inimigos explodirem

]]--


function obj_update()
	
	-- star_update
	for star in all(stars) do
  		star:update()
 	end
 
 --inimigo_update
	for i in all(inimigos) do
		if i.nome=="asteroide" then 
		 	i:update()
		elseif i.nome=="alien_azul" then	 	
			i:update()
			--codigo pro inimigo atirar
			if i.atirar==true then
			 	add(tiros,bola_azul:new({tx=i.x+2,ty=i.y+6}))
				i.atirar=false
			end
		end
	end
 
 
	for tiro in all(tiros) do
		tiro:t_update()
		tiro.htb={tiro.x,tiro.y,tiro.x+3,tiro.y+3}
		if tiro.dead then
			del(tiros, tiro)
		end --se sai do map del tiro
 	end --end laco tiros
end --end_funcao


function obj_draw()
 
 --draw star
 for star in all(stars) do
  star:draw()
 end
 
 --draw inimigos
 for inimigo in all(inimigos) do
 	inimigo:draw()
 end
 
 --draw tiros
 for tiro in all(tiros) do
		tiro:t_draw()
 end

end --end_funcao




--particulas

function flash_et_azul()
 
end
