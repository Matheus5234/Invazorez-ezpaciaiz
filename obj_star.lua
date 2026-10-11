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
