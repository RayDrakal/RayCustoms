--잔향의 세이렌 테레사
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	--Xyz Summon Procedure: 2+ Level 3 "Zankya" monsters
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_ZANKYA),3,2,nil,nil,99)
	
end
