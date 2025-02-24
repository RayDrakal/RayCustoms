--메타리온 킹 코브라스타
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,CARD_IMAG_ACT,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WIND))
	--"Lightsworn" monsters you control cannot be banished by card effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetTarget(s.rmlimit)
	c:RegisterEffect(e1)
	
end
function s.rmlimit(e,c,tp,r)
	return c:IsSetCard(SET_METARION) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
		and c:IsControler(e:GetHandlerPlayer()) and not c:IsImmuneToEffect(e) and r&REASON_EFFECT>0
end
