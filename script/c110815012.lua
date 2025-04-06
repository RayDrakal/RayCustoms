--혼합시귀 데스티아 키마이라
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_ZOMBIE),9,2,nil,nil,99)
	
end
