--TGドリル・フィッシュ
function c4088.initial_effect(c)
	--diratk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(c4088.dircon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4088,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c4088.condition)
	e2:SetTarget(c4088.target)
	e2:SetOperation(c4088.operation)
	c:RegisterEffect(e2)
end
function c4088.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x27)
end
function c4088.dircon(e)
	return Duel.IsExistingMatchingCard(c4088.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c4088.filter(c)
	return c:IsDestructable()
end
function c4088.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil
end
function c4088.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c4088.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4088.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c4088.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4088.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
