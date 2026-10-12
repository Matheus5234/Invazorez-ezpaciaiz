--player

--essa funcao checa os botoes
--usa colisao na borda da tela
--e move o player

function init_p()
	player={}
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

	if timer("delay_tiro") then
		if btn(❎) then
			add(tiros,tiro:new({t.x=p.x+6,t.y=p.y+3}))
			sfx(0)
			reset_timer("delay_tiro")
		end --input do tiro
	end
	if colisao_1(npx,npy) then
		p.x=npx
		p.y=npy 
	end
end


function update_p()
	for p in all(player) do
		checkbutt(p)
		col_p(p)
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
			spr(48,px+4,py-8)
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

