--ＣＣＣ武融化身ソニック・ハルバード
function c3470.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c3470.matfilter,aux.FilterBoolFunction(Card.IsFusionCode,3465),true)
	--multi attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c3470.val)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c3470.effop)
	c:RegisterEffect(e2)
end
function c3470.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsLevelAbove(7)
end
function c3470.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WIND)
end
function c3470.val(e,c)
	if Duel.IsExistingMatchingCard(c3470.filter,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) then
		return 2
	else
		return 1
	end
end
function c3470.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		c:RegisterEffect(e2)
	end
end
