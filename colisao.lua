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


function col_p(p)
 
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
end --end funcao


function col_inimigos()
--colisao tiro x inimigo
  for i in all(inimigos) do
    for t in all(tiros) do
      if t.nome="tiro" then
        if check_colisao(i.htb,t.htb) then
          del(tiros,t)
          i.vida-=1
        end --if colisao
      end --  if tiro
    end --laco tiros
  end --laco inimigos
end --end_funcao
