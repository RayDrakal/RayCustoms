--ダークネス2
function c3055.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3055,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCondition(c3055.condition)
	e1:SetOperation(c3055.desop)
	c:RegisterEffect(e1)
end
function c3055.condition(e,tp,eg,ep,ev,re,r,rp)
	return false
end
function c3055.dfilter(c)
	return c:IsFaceup() and c:IsCode(3054,3055,3056)
end
function c3055.atkfilter(c)
	return c:IsFaceup()
end
function c3055.desop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c3055.dfilter,tp,LOCATION_SZONE,0,nil)
	if ct==0 then return end
	local g=Duel.SelectMatchingCard(tp,c3055.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(1000*ct)
		g:GetFirst():RegisterEffect(e1)
	end
end
