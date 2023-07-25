--로드 슈페리얼 아르고스=제로버스
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttackAbove,2400),5,2)
	--Name is treated as "Superior Argos"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE|LOCATION_GRAVE|LOCATION_REMOVED)
	e1:SetValue(CARD_SUPERIOR_ARGOS)
	c:RegisterEffect(e1)
end
s.listed_names={CARD_SUPERIOR_ARGOS}
