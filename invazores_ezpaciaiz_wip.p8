pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
-- main

function _init()
	init_cronometro()
	init_obj()
	init_stars()
	init_p()
	shake_init() --tools
	pos_asteroide={130,-8}
	init_inimigos()
	
	--flash=0
	t=0
end


function _update()
 	conta_tiro()
		shake_update()
 	update_p()
 	obj_update()
 	col_update()
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
	hud()
 
end
-->8
--obj_player

function init_p()
	p1={x=56,y=108,sp=1,hp=3,htb={},inv=0}
	add(player,p1)
	set_timer(3,"delay_tiro")
	c_tiro=0
end


function checkbutt(p)
	npx=p.x
	npy=p.y
	if btn(⬆️) then
		npy-=1
	end
	if btn(⬇️) then
		npy+=1
	end
	if btn(⬅️) then
		npx-=2
	end
	if btn(➡️) then
		npx+=2
	end
 if colisao_1(npx,npy) then
		p.x=npx
		p.y=npy 
	end
 
	if timer("delay_tiro") then
		if btn(❎) then
			add(tiros,tiro:new({x=p.x+6,y=p.y+3}))
			sfx(0)
			reset_timer("delay_tiro")
		end --input do tiro
	end
	
end


function update_p()
	for p in all(player) do
		checkbutt(p)
		p.htb={p.x+3,p.y+5,p.x+12,p.y+15}
	end
end


function draw_p()
	for p in all(player) do
		if p.inv <= 0 then
			spr(p.sp,p.x,p.y,2,2)
		else
			pisca_p()
		end -- if inv
		if tiro_foi_dado() then
			spr(48,p.x+4,p.y-8)
		end
	end -- for
end-- funcao

--funcao para piscar player
function pisca_p(p)
	if sin(t/4) < -0.5 then
		for i = 1,15 do
			pal(i,7)
		end
	end 
	spr(p.sp,p.x,p.y,2,2)
	pal()
end

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
-->8
--obj_stars

--estrela base e e criacao
--da classe estrela
star={
  --parametros sao> posicao,
  --velocidade, raio, cor
  x=rnd(128), y=rnd(128),
  spd=1, rad=1, clr=7,
  --funcao para criar novas estrelas
  new=function(self,tbl)
    tbl=tbl or {}
    setmetatable(tbl,{__index=self})
    return tbl
  end,
  --estrela_update
  update=function(self)
    --faz se mover pra baixo
    self.y += self.spd
    --se sair da tela volta pra
    --cima em uma nova posicao
    if self.y-self.rad > 127 then
      self.y=-self.rad
      self.x=rnd(127)
    end --end if
  end, --end funcao
  --draw estrela
  draw=function(self)
    circfill(self.x,self.y,
    self.rad,self.clr)
  end
}

function init_stars()
  local used_y={}
 
  --essa funcao cria varias
  --estrelas de tipos aleatorios
  for i = 1,50 do
    local ny=flr(rnd(127))
    --randomiza posicao e faz
    --dnv caso posicao repetida
    while used_y[ny] do
    ny=flr(rnd(127))
    end --while end
--adciona a posicao das estrelas
--na lista de posicoes usadas  
  add(used_y,ny)
--randomiza os tipos de estrela
  local star_type=rnd(star_types)
--adciona estrelas na lista  
  add(stars,star_type:new({x=rnd(127),y=ny}))
  end -- for end
--loop pra estrelas grandes
  for i = 1,8 do
    local ny=flr(rnd(127))
    while used_y[ny] do
      ny=flr(rnd(127))
    end
    add(used_y,ny)
    add(stars,star4:new({x=rnd(127),y=rnd(127)}))
  end 
end

--tipos de estrelas

star_types= {star1, star2, star3,}

star1=star:new({rad=0,spd=1})

star2=star:new({rad=0,spd=0.7,clr=13})

star3=star:new({rad=0,clr=1,spd=0.4})

star4=star:new({rad=1,spd=1.75})

-->8
--obj_tiro


--tiro base e seus argumentos

--classe tiro
--posicao,morto,velocidade,
--sprite,colisao(lista vazia)
tiro = {x=0,y=0,dead=false,nome="tiro",
	spd=-8,sp=0,htb={},
	--cria novo tiro
	new=function(self,tbl)
		tbl=tbl or {}
		setmetatable(tbl,{__index=self})
		return tbl
	end,
	--tiro update
	t_update=function(self)
		--move pra cima
		self.y+=self.spd
		if self.y < -4 or  self.y > 124 then
			self.dead=true
		end --se sair da tela = morto
	end,
	--draw tiro
	t_draw=function(self)
		spr(self.tspr,self.tx,self.ty)
	end,
}

bola_azul=tiro:new({sp=53,spd=3,nome="bola_azul"})

-->8
--obj_inimigo


--essa funcao move o inimigo e
--usa colisao na borda da tela
function move_enemy()
	--laco inimigos
	for i in all(inimigos) do
	 --delay pra mover
	 etime+=1
	 --direcoes
	 rx={8,-8}
	 --nix e pra verificar colisao
	 local nix=i.ix
	 --reseta timer a cada meio 
	 --segungo e se move 
	  if etime>15 then
	   etime=0
	 --randomiza a direcao da move
	   nix+=rnd(rx)
	   --se dentro da borda move
	   if colisao_1(nix,50) then
	    i.ix=nix
	   end --if colisao
	  end --if timer
	 end --laco inimigos
end --end funcao



inimigo = {nome="asteroide",
  x=0,y=0,spd=1,vida=1,
  sp=36,htb={},
  new=function(self,tbl)
    tbl=tbl or {}
    setmetatable(tbl,{__index=self})
    return tbl
  end,
  update=function(self)
    if self.vida <= 0 then del(inimigos,self) end
    --converte velocidade pra sempre descer
    if self.spd <  0 then
      self.y-=self.spd
    else
      self.y+=self.spd
    end

    self.x+=self.spd
    self.htb={self.x,self.y,self.x+7,self.y+7}
  end,
  draw=function(self)
    spr(self.sp,self.x,self.y,1,1)
  end
}


function init_inimigos()
  set_timer(120,"alien_azul")
  set_timer(30,"a_a_tiro")
  for i =1,5 do
    add(inimigos,inimigo:new({x=rnd(pos_asteroide),y=rnd(40)-20,spd=flr(rnd(3)+1)}))
  end
  for i in all(inimigos) do
    if i.x > 128 then i.spd=i.spd*-1 end
  end
  for i=1,11 do
 		add(inimigos,alien_azul:new({x=i*10,y=8}))
	end
end

alien_azul=inimigo:new({nome="alien_azul",
  hp=3,sp=51,r_timer={150,180,210,240},
  timer=150,atirar=false,flash=0,
  update=function(self)
    if self.vida <= 0 then del(inimigos,self) end
    self.timer-=1
    if self.timer < 0 then
      self.sp+=1
      self.timer=3030
      sfx(2)
    end
    if self.timer==3000 then
      self.sp-=1
      self.timer=rnd(self.r_timer)
      self.atirar=true
    end
    self.htb={self.x,self.y,self.x+7,self.y+7}
  end,
 draw=function(self)
  spr(self.sp,self.x,self.y,1,1)
  if self.timer > 2500 then
 	 circfill(self.x+4,self.y+8,self.flash,7)
 	 self.flash+=0.1
 	else
 	 self.flash=0
  end
 end
})

-->8
--colisao


--essa funcao e o sistema de
--colisao utilizado para os 2
--personagens (16x16) 
function colisao_1(colx,coly)
 if colx < 113 and colx > -1
 and coly > -1 and coly < 113 then
  return true
 else
  return false
 end
end


--essa funcao checa a colisao
--entre 2 hitbox que sao guarda-
--das em listas com 4 numeros
--colisao entre sprites (obj2
--deve ser sempre menor que obj1
function check_colisao(obj1,obj2)
	local cx=false
	local cy=false
 --se uma das posicoes x se
 --alinharem cx = true
	if (obj2[1] >= obj1[1] and  obj2[1] <= obj1[3]) or (obj2[3] >= obj1[1] and  obj2[3] <= obj1[3]) then
  		cx=true
 	end
 --se uma das posicoes y se
 --alinharem cy = true
 	if  (obj2[2] >= obj1[2] and  obj2[2] <= obj1[4]) or (obj2[4] >= obj1[2] and  obj2[4] <= obj1[4]) then
  		cy=true
 	end
 --se cx e cy forem ambos true
 --a funcao retorna true pra
 --colisao, senao false
 	if cx == true and cy == true then
  		return true
 	else
  		return false
 	end
end


--colisao  antiga, vai ser
--util para os power ups

--for i in all(inimigos) do
 --for t in all(tiros) do
 	--if abs(i.ix-t.tx) < 8 and abs(i.iy-t.ty) < 8 then
 		--del(inimigos,i)
 	--end
 --end
--end


--player


function col_p()
 for p in all(player) do
		-- tiro x player
	 	if p.inv <= 0 then
			for t in all(tiros) do
				if check_colisao(p.htb,t.htb) then
					p.inv=70
					sfx(1)
					shake_screen(15,0.5)
					p.hp-=1
					del(tiros,t)
					break
				end --if colisao
			end --  for
		else
			p.inv-=1
		end --if else
		
		--player x inimigos menores
		if p.inv <= 0 then
			for i in all(inimigos) do 
				if check_colisao(p.htb,i.htb) then
		  			i.hp-=1
		   			p.inv=70
		  			sfx(1)
		  			shake_screen(15,0.5)
		  			p.hp-=1
					break
		  		end
	  		end
		else
			p.inv-=1
		end
		
		--player x inimigos maiores 
		if p.inv<=0 then
	  		for i in all(inimigos) do 
				if check_colisao(i.htb,p.htb) then
		  			i.hp-=1
		  			p.inv=70
		  			sfx(1)
		  			shake_screen(15,0.5)
		  			p.hp-=1
					break
				end
			end
		end
	end --loop
end --end funcao


function col_inimigos()
--colisao tiro x inimigo
  for i in all(inimigos) do
    for t in all(tiros) do
      if t.nome=="tiro" then
        if check_colisao(i.htb,t.htb) then
          del(tiros,t)
          i.vida-=1
        end --if colisao
      end --  if tiro
    end --laco tiros
  end --laco inimigos
end --end_funcao

function col_update()
 col_p()
 col_inimigos()
end
-->8
--tools


function init_obj()
	player={}
	stars={}
	star_types= {star1, star2, star3}
	tiros={}
	inimigos={}
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
	timer_base={t=10,n="base",r=10}
	add(cronometro,timer_base)
end

function update_cronometro()
	if timer("base") then
		reset_timer("base")
	end
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

function reset_timer(nome,newset)
	for t in all(cronometro) do
		if t.n == nome then
			t.t = newset or t.r
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
			 	add(tiros,bola_azul:new({x=i.x+2,y=i.y+6}))
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


__gfx__
0dd000000000000550000000000000055000000000000007700000000000cccccccc000000000000000000000000000000000000000000006666666666666666
da7d000000000056650000000000005665000000000000777700000000cc00000000cc0000000000000000000000000000000000000000006000000660777706
d7ad00000000000550000000000000055000000000000007700000000c000070777700c0000000000000000000000000000000000000000060aa000667cccc76
d99d00000000001661000000000000166100000000000077770000000c000000707070c0000000000000000000000000000000000000000060aaaa0667caac76
0dd00000000000dddd000000000000dddd0000000000007777000000c00000000707070c00000000000000000000000000000000000000006099aa0667ccac76
00000000000000dccd000000000000dccd0000000000007777000000c00000000070700c000000000000000000000000000000000000000060009906607cc706
0000000000000dc1c1d0000000000dc1c1d000000000077777700000c0d000000000700c00000000000000000000000000000000000000006000000660077006
0000000000000dc71cd0000000050dc71cd050000000077777700000c00000000000700c00000000000000000000000000000000000000006666666666666666
077007700000d3dc7d3d0000005653dc7d3565000000777777770000c0d000000000700c00000000000000000000000000000000000000000000000000000000
78877887000d335dd533d0000005035dd53050000007777777777000c00d00000000700c00000000000000000000000000000000000000000000000000000000
7888888700d5335335335d0000565353353565000077777777777700c0ddd0000000700c00000000000000000000000000000000000000000000000000000000
788888870d353535835533d00d555535833555d00777777777777770c0dddd000000000c00000000000000000000000000000000000000000000000000000000
788888870d538338833853d00d538338833853d007777777777777700c0dd0d0000000c000000000000000000000000000000000000000000000000000000000
07888870d66688d88d88666dd66688d88d88666d77777777777777770c000d0dd0d000c000000000000000000000000000000000000000000000000000000000
0078870069896808008698966989680800869896777777070077777700cc00000000cc0000000000000000000000000000000000000000000000000000000000
000770000a0a00000000a0a00a0a00000000a0a007070000000070700000cccccccc000000000000000000000000000000000000000000000000000000000000
07700770888888888888888800500500005666500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70077007800000000000000800500500065566550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
70000007800000000000000800088000566665660000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
700000078000088888800008005555006566655d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7000000780008000000800080088880065566ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0700007080080000000080080765567056dddd5d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070080080080000080087678876705d5dd550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700080080880088080086760067600d55d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000800808808880800800aaaa0000aaaa000ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000008000800000088008011aa110011aa110c777c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000008000880000880008aaaaaaaaaaaaaaaac777c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000800008080880000811a11a1111a11a11c777c00000000000000000000000000000000000000000000000000000000000000000000000000000000000
000aa0008000080808800008055aa550055aa5500ccc000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00aaaa00800008888880000801511510115115110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0aa77aa0800000000000000810000001100000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a7777a0888888888888888801100110010000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055555555005555555005555005555555555555555555550555555550555555555555500000000000000000000000000000000000000000000000000000000
0005ccc5cc5505cc5cc5005cc5005cc5cccccccc55cccccc505cccccc505cccc5cccccc500000000000000000000000000000000000000000000000000000000
0005ccc5ccc505cc5cc5055cc505ccc5cccccccc55cccccc505cccccc505cccc5cccccc500000000000000000000000000000000000000000000000000000000
0005ccc5ccc505cc5cc505ccc55cccc5555555cc55cc555c505cc555c555cc5555555cc500000000000000000000000000000000000000000000000000000000
00555555cccc55cc5cc505ccc55cccc500005cc55ccc555c555cc505c55ccc500055cc5500000000000000000000000000000000000000000000000000000000
005ccc5ccccc55cc5cc555cc55cc5cc500055cc55ccc55cc555c5005c55cc5500055cc5000000000000000000000000000000000000000000000000000000000
005ccc5cccccc5cc5cc55ccc55cc5cc50055cc555cc555cc55cc5005c55cc500055ccc5000000000000000000000000000000000000000000000000000000000
055ccc5cc5ccc5cc5cc55cc55ccc5cc5005ccc555cc555cc55cc555cc5ccc500055cc55000000000000000000000000000000000000000000000000000000000
05ccc55cc5ccc5cc5cc5ccc55cc55cc5055cc555ccc55ccc5ccccccc55cc555555ccc50000000000000000000000000000000000000000000000000000000000
05ccc5ccc55cc5cc5cc5ccc5ccc55cc505ccc505cc555cc55ccc5cc55ccc5cc55ccc550000000000000000000000000000000000000000000000000000000000
55ccc5cc555cc5cc5cc5cc55cc555cc555cc5005cc555cc55cc55cc55cc5ccc55cc5500000000000000000000000000000000000000000000000000000000000
5cccc5cc5055cccc5ccccc5ccc5cccc55cc50005cc555cc55cc55cc55cc55555ccc5500000000000000000000000000000000000000000000000000000000000
5ccc55cc5005cccc5cccc55cc55cccc55cc5005cc555ccc5ccc55cc5ccc50055cc55000000000000000000000000000000000000000000000000000000000000
5ccc5ccc50055ccc5cccc5ccc5555cc5cc55555cc555cc55cc555cc5cc55555ccc55555000000000000000000000000000000000000000000000000000000000
5ccc5cc550005ccc5cccc5cc55005cc5cccccc5ccccccc55cc505cc5cccccc5ccccccc5000000000000000000000000000000000000000000000000000000000
5ccc5cc5000055cc5ccc55cc50005cc5cccccc5ccccccc55cc505cc5cccccc5ccccccc5000000000000000000000000000000000000000000000000000000000
55555555555555555555555555555555555555555555555555555555555555555555555000000000000000000000000000000000000000000000000000000000
5ccccc5ccccccc5ccccccccc55ccccc5ccccccccc5cc55cccccc55cc5cccccccccc5000000000000000000000000000000000000000000000000000000000000
5ccccc5ccccccc5ccccccccc5ccc5cc5ccccccccc5cc55ccccccc5cc5cccccccccc5000000000000000000000000000000000000000000000000000000000000
5cc5555cc555555cc5555cc55cc55cc5cc55555cc55555cccc5cc55555ccc5555555000000000000000000000000000000000000000000000000000000000000
5cc5005ccc50005ccc555cc5ccc55cc5cc50005555cc555ccc5cc55cc55ccc550000000000000000000000000000000000000000000000000000000000000000
5cc55055cc550055cc55cc55cc505cc5cc50000005ccc55ccc5ccc5cc555ccc55000000000000000000000000000000000000000000000000000000000000000
5ccc5005ccc55005cc5cc55ccc505cc5cc500000055cc55ccc55cc5ccc555ccc5500000000000000000000000000000000000000000000000000000000000000
55cc55555ccc5505cccc505cc5005cc5cc500000005cc55ccc55cc55cc5555ccc550000000000000000000000000000000000000000000000000000000000000
05cc5cc555ccc5555cc5005cc5055cc5cc500000005ccc5ccc55ccc5ccc5055ccc55000000000000000000000000000000000000000000000000000000000000
05cc5ccc555ccc555cc505ccc55cccc5cc5000000055cc55cc555cc55cc50055ccc5500000000000000000000000000000000000000000000000000000000000
05cc55555555ccc55ccc55cc55ccccc5cc5000000005cc55ccc55cc55ccc50055ccc550000000000000000000000000000000000000000000000000000000000
05ccc50000055ccc55cc55cc55555cc5cc5000005555ccc5cccc5ccc55cc500055ccc55000000000000000000000000000000000000000000000000000000000
055cc555555555ccc5cc5ccc50005cc5cc5555555cc55cc5cc5555cc55ccc555555ccc5500000000000000000000000000000000000000000000000000000000
005cccccc5ccccccc5cc5cc550005cc5ccccccccccc55cc5cc5005cc55ccc5ccccccccc500000000000000000000000000000000000000000000000000000000
005cccccc5ccccccc5cc5cc500005cc5ccccccccccc55cc5cc5005cc55ccc5ccccccccc500000000000000000000000000000000000000000000000000000000
00555555555555555555555555555555555555555555555555500555555555555555555500000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000101000000000000000000000000000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001415011770107200e7200a720077200672002720017200470002700007000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000400002465020650070401764016640060301463013630060300862006620056200462004610026100261003600016000060000600000000000000000000000000000000000000000000000000000000000000
00070000040100601007010090100b0100d0100f010100101301015010306001f630167300f700201002530025300261001a6000700008000080000800009000090000a0000a0000b0000b0000b0000b0000b000
