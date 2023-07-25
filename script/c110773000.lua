--로드 슈페리얼 아르고스=스카이아
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsCode,CARD_SUPERIOR_ARGOS),1,1,Synchro.NonTunerEx(Card.IsAttackAbove,2400),1,1)
    --Name is treated as "Superior Argos"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE|LOCATION_GRAVE|LOCATION_REMOVED)
	e1:SetValue(CARD_SUPERIOR_ARGOS)
	c:RegisterEffect(e1)
end
s.material={CARD_SUPERIOR_ARGOS}
s.listed_names={CARD_SUPERIOR_ARGOS}
