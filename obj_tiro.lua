--obj_tiro

--tiro base e seus argumentos

--classe tiro
--posicao,morto,velocidade,
--sprite,colisao(lista vazia)
tiro = {x=0,y=0,dead=false,
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
		self.ty+=self.tspd
		if self.ty < -4 or  self.ty > 124 then
			self.dead=true
		end --se sair da tela = morto
	end,
	--draw tiro
	t_draw=function(self)
		spr(self.tspr,self.tx,self.ty)
	end,
}

bola_azul=tiro:new({tspr=53,tspd=3})
