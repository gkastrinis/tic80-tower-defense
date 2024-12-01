function BOOT()
	Game={tower=288,towerOK=288,towerFire=320,poor=258,slave=259,bad3=260}
	Game.over=false

	HQ={x=108,y=48,hp=13,gold=5}
	Path1={0,56,24,56,24,88,64,88,64,56,108,56}
	-- Path2={112,1,112,48}
	Path3={208,112,208,32,184,32,184,64,152,64,152,48,116,48}
	Enemies={}
	-- Track time
	t=0
end

function Remap(tile,x,y)
	local flip,rotate=0,0
	if (x>=0 and x<=2 and y==7) or
		(x>=4 and x<=7 and y==11) or
		(x>=8 and x<=13 and y==7) or
		(x>=15 and x<=18 and y==6) or
		(x>=20 and x<=22 and y==8) or
		(x>=22 and x<=25 and y==4) then
		rotate=1
	elseif (x==3 and y==7) or
		(x==19 and y==6) then
		rotate=2
	elseif (x==8 and y==11) or
		(x==23 and y==8) then
		flip=1
	elseif x==26 and y==4 then
		flip=1;rotate=1
	end
	return tile,flip,rotate
end

function TIC()
	Input()
	Update()
	Draw()
	-- local mx,my,a,b,c,d,e,f=mouse()
	-- if mx==nil then ;
	-- else print(mx.." "..my,50,120) end
	-- spr(256,e.x//2,e.y,0,1,1,0,2,2)
end

function Input()
	if btnp(4) then HQ.hp=HQ.hp-1 end
	if btnp(5) then HQ.hp=HQ.hp+1 end
end

function Update()
	if HQ.hp==0 then
		Game.tower=Game.towerFire
		Game.over=true
		return
	end

	if t==0 then
		local en={id=Game.poor,p=Path1,idx=1,flip=1}
		en.x=en.p[en.idx]
		en.y=en.p[en.idx+1]
		table.insert(Enemies,en)
	elseif t==60 then
		local en={id=Game.slave,p=Path3,idx=1,flip=0}
		en.x=en.p[en.idx]
		en.y=en.p[en.idx+1]
		table.insert(Enemies,en)
	end

	for i,e in ipairs(Enemies) do
		local p,idx=e.p,e.idx
		local aX,aY,bX,bY=p[idx],p[idx+1],p[idx+2],p[idx+3]
		if e.idx==#p-1 then
			HQ.hp=HQ.hp-1
			table.remove(Enemies,i)
		else
			if aX == bX then
				if aY < bY then e.y=e.y+1 else e.y=e.y-1 end
			else
				if aX < bX then e.x=e.x+1 else e.x=e.x-1 end
			end
			if e.x==bX and e.y==bY then e.idx=idx+2 end
		end
	end

	t=t<120 and t+1 or 0
end

function Draw()
	map(0,0,30,17,0,0,-1,1,Remap)
	spr(Game.tower,HQ.x,HQ.y,0,1,0,0,2,2)

	if not Game.over then
		local fullHearts=math.floor(HQ.hp/4)
		for i=1,fullHearts do
			spr(292,240-16*i,120,0,1,0,0,2,2)
		end
		local rest,restX=math.fmod(HQ.hp,4),240-16*fullHearts-8
		if rest==1 then
			spr(293,restX,120,0,1,0,0,1,1)
		elseif rest==2 then
			spr(293,restX,120,0,1,0,0,1,2)
		elseif rest==3 then
			spr(292,restX-8,120,0,1,0,0,1,1)
			spr(293,restX,120,0,1,0,0,1,2)
		end

		spr(290,0,120,0,1,0,0,2,2)
		print(HQ.gold,16,124,12,false,2)
	else
		print("Game Over",68,124,2,false,2)
	end

	for i,e in ipairs(Enemies) do
		spr(e.id,e.x,e.y,0,1,e.flip,0,1,1)
	end
end

-- <TILES>
-- 016:6766666677766666777666666366766666677766666777666666366666666666
-- 032:6666666666666666666666666666666666666666666666666666666666666666
-- 048:6434c44663344446634c4d466444de466444e4466444444664ed44c664e44c46
-- 064:644444766444c47764c44777644444446e444c446fee444466fe444c66666666
-- </TILES>

-- <SPRITES>
-- 000:00000000000000000000000000000ccc0000cccc0000cccc000c32cc000c32cc
-- 001:00000000000000000000000044400000c4430000cc4400003244300032443000
-- 002:0ffffff0ffcccddffcccccdf02c22cdffcfcccdffccccdff0fcfcdf00ffffff0
-- 003:0ffffff0f222221ff323221ff323211ff222211ffcc2211ff2f211ff0ffffff0
-- 005:000002330000224200324320ccccc320fcfcc420cfcc3200ccc3200003420000
-- 016:000ccc3c0000cc3c00000ccc00004343000044c4000004440000000000000000
-- 017:cc443000c4433000c343000044400000c4300000400000000000000000000000
-- 018:000000000ff0ff00fc3f32f0f33322f00f332f0000f2f000000f000000000000
-- 019:0000000000344400034222400343324003433240034332400034440000000000
-- 020:0044420004233420423423424244424242444242423423420423342000444200
-- 032:00000000000e0ee0000eeeee000ddddd0e0edede0eeeeeee0ddddd2c0d84dd2c
-- 033:00000000e0e0f000eeeef000dddff000edeff0f0eeeefff02ddddff02d84ddf0
-- 034:0000000000000044000000440000444400044433000443000004440000034444
-- 035:0000000000000000000000004400000044400000344000000330000044000000
-- 036:0000000000000000000000000012220000222220012222220122222201222222
-- 037:00000000000000000000000002221000222220002cc2220022cc2200222c2200
-- 048:0d89dd220d89ddd20d88dddd0dddddff0ddddfef0d7ddfef0777dfff77777766
-- 049:2d89dff0dd89dff0dd88ddf0fddddff0efdddff0efdddf70ffddd77066677777
-- 050:0000344400000333000440000004440000034444000033440000004400000033
-- 051:4440000034400000044000004440000044300000330000000000000000000000
-- 052:0112222200122222001122220001122200001122000001120000001100000000
-- 053:2222220022222000222220002222000022200000220000002000000000000000
-- 064:00000000000e0ee0000eeeee000ddddd0e0edede0eeeee2e0dddd2220dffdd22
-- 065:00000000e0002000eee23020dd234200ee2342f02eeef2f01ddddff01dffddf0
-- 080:0df2d2220df2d2320dff22320dd223320dd233430d723443077734c4777773c4
-- 081:1d8fdff0d2ffdff0d2ffddf02ddddff022dddff032dddf7032ddd77036677777
-- </SPRITES>

-- <MAP>
-- 000:010101010101010101010101010103010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:010101020202020202020202020203020202020202020202020202020101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:010102020202020202020202020203020202020202020202020201020101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:010202020202020202020202020103010202020202020202020202020201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:010202020102020202020202020203020102020202020204030304020201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:010202020102020202020202010203010102020202020203020103020201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:010202020202020202020201020203030303030402020203020203020201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:030303040202020204030303030302020201020302020203020203010201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:010201030202020203020202020202020202020403030304020203020201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:010202030202020203020202020202020202020202020202020203020201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:010202030202020203020202020202020202010202020202020203020101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:010202040303030304010202020202020201020202020202020203020201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:010202020202020202020202020202020202020202020202020203020201000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:010202020201010101020202020201020202020202020101020203020101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:010101010101010101010101010101010101010101010101010103010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>
