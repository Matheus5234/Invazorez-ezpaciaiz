function _init()
	init_p()
	init_obj()
	init_stars() --stars
	vida_p=3
	hitbox_p={}
	player_timer=0
	pisca=1
	timer_pisca=10
	--screen_shake=false
	--shake_timer=15
	shake_init() --tools
	timer_tiro=0
	pos_asteroide={130,-8}
	init_asteroides()
	for i=1,11 do
 		add(inimigos,alien_azul:new({x=i*10,y=8}))
	end
	--flash=0
	t=0
end


function _update()
 	conta_tiro()
	shake_update()
 	update_p()
 	obj_update()
	colisao_update()
	--flash do alien azul
	for i in all(inimigos) do
	 	if i.nome == "alien_azul" then
	  		if i.timer > 2500 then
	   			flash+=0.1
	  		else
	   			flash=0
	  		end
	 	end
	end
	t+=1
	update_cronometro()
end


function _draw()
	cls()
	camera(shake/2-rnd(shake),shake/2-rnd(shake))
	draw_p()
	obj_draw()
 --print("tiros: "..#tiros, 0, 0, 7)

-- hitbox player debug
--[[ 
 circ(px+3,py+5,0,8)
 circ(px+12,py+15,0,8)
 circ(px+3,py+15,0,8)
 circ(px+12,py+5,0,8)
]]--
--[[
 for i in all(inimigos) do
 	if i.nome == "alien_azul" then
 	 if i.timer > 2500 then
 	 	circfill(61,16,flash,7)
   end
  end
 end
]]-- 
	 if btnp(❎) then
	  spr(48,px+4,py-8)
	 end
	 
	 hud()
 
end