--obj_inimigos

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
  set_timer("alien_azul",120,1)
  set_timer("a_a_tiro",30,1)
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
