--エン・ムーン
function c2816.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c2816.condition)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0x34,0x34)
	e2:SetTarget(c2816.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--change type
	local e3=e2:Clone()
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetValue(TYPE_NORMAL+TYPE_MONSTER)
	c:RegisterEffect(e2)
end
function c2816.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) or bit.band(c:GetOriginalType(),TYPE_FUSION)==TYPE_FUSION
end
function c2816.cfilter2(c)
	return c:IsFaceup() and c:IsCode(2817)
end
function c2816.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2816.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil)
		and Duel.IsExistingMatchingCard(c2816.cfilter2,tp,LOCATION_SZONE,0,1,nil)
end
function c2816.disable(e,c)
	return bit.band(c:GetOriginalType(),TYPE_FUSION)==TYPE_FUSION
end
