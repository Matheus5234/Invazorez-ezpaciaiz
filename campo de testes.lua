
--main
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
			 if i.atirar==true then
			 	add(tiros,bola_azul:new({tx=i.x+2,ty=i.y+6}))
			  i.atirar=false
			 end
		 end
		end
 
 --tiro_update
 if timer_tiro <= 0 then
	 if btn(❎) then
			add(tiros,tiro:new({tx=px+6,ty=py+3}))
		 sfx(0)
		 timer_tiro=3
		end --input do tiro
	else
	 timer_tiro-=1
	end
	for tiro in all(tiros) do
		tiro:t_update()
  tiro.t_colisao={tiro.tx,tiro.ty,tiro.tx+3,tiro.ty+3}
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
 
 --draw personagens
 draw_personagens()
 
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
