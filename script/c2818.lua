--エン・バーズ
function c2818.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c2818.condition)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0x34,0x34)
	e2:SetTarget(c2818.disable)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--change type
	local e3=e2:Clone()
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetValue(TYPE_NORMAL+TYPE_MONSTER)
	c:RegisterEffect(e2)
end
function c2818.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) or bit.band(c:GetOriginalType(),TYPE_XYZ)==TYPE_XYZ
end
function c2818.cfilter2(c)
	return c:IsFaceup() and c:IsCode(2815)
end
function c2818.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2818.cfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,3,nil)
		and Duel.IsExistingMatchingCard(c2818.cfilter2,tp,LOCATION_SZONE,0,1,nil)
end
function c2818.disable(e,c)
	return bit.band(c:GetOriginalType(),TYPE_XYZ)==TYPE_XYZ
end

