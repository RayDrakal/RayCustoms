--スキエルＧ
function c4061.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c4061.descon)
	c:RegisterEffect(e1)
	--Negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c4061.discon)
	e2:SetOperation(c4061.disop)
	c:RegisterEffect(e2)
end
function c4061.sdfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x3013) or c:IsCode(4050,63468625))
end
function c4061.descon(e)
	return not Duel.IsExistingMatchingCard(c4061.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c4061.discon(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp)
end
function c4061.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
