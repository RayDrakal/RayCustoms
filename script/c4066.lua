--ワイゼルＧ
function c4066.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c4066.descon)
	c:RegisterEffect(e1)
	--change target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4066,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c4066.cbcon)
	e2:SetOperation(c4066.cbop)
	c:RegisterEffect(e2)
end
function c4066.sdfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x3013) or c:IsCode(4050,63468625))
end
function c4066.descon(e)
	return not Duel.IsExistingMatchingCard(c4066.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c4066.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local bt=eg:GetFirst()
	return bt~=e:GetHandler() and bt:IsControler(tp)
end
function c4066.cbop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local at=Duel.GetAttacker()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) and not c:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,c)
		end
	end
end
