--îeâ§·≈ó≥É_Å[ÉNÉîÉãÉÄ
function c2805.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c2805.condition)
	e1:SetOperation(c2805.operation)
	c:RegisterEffect(e1)
	--P negate attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c2805.condition2)
	e2:SetOperation(c2805.operation2)
	c:RegisterEffect(e2)
end
function c2805.indfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x20f8)
end
function c2805.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2805.filter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c2805.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
function c2805.condition2(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsControler(tp) and d:IsFaceup() and d:IsSetCard(0x20f8)
end
function c2805.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
