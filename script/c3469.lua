--ＣＣＣ武融化身ウォーター・ソード
function c3469.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c3469.matfilter,aux.FilterBoolFunction(Card.IsFusionCode,3465),true)
	--attack
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetTarget(c3469.target)
	e1:SetOperation(c3469.operation)
	c:RegisterEffect(e1)
end
function c3469.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and (c:GetLevel()==5 or c:GetLevel()==6)
end
function c3469.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c3469.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c3469.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if chk==0 then return g:GetSum(Card.GetAttack)>0 end
end
function c3469.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c3469.filter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if g:GetCount()>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=0
		local tc=g:GetFirst()
		while tc do
			atk=atk+tc:GetAttack()
			tc=g:GetNext()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
