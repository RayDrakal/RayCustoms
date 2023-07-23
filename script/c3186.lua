--相生の魔術師
function c3186.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--rank
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c3186.rktg)
	e1:SetOperation(c3186.rkop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c3186.atktg)
	e2:SetOperation(c3186.atkop)
	c:RegisterEffect(e2)
end
function c3186.rkfilter(c,tp)
	local level=c:GetLevel()
	if c:IsType(TYPE_XYZ) then level=c:GetRank() end
	return c:IsFaceup() and Duel.IsExistingTarget(c3186.lvfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,level)
end
function c3186.lvfilter(c,tp,level)
	if c:IsType(TYPE_XYZ) then level=c:GetRank() end
	return c:IsFaceup() and c:GetLevel()~=level
end
function c3186.rktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c3186.rkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c3186.rkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
end
function c3186.rkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local g=Duel.SelectMatchingCard(tp,c3186.rkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc)
		if g:GetCount()==0 then return end
			Duel.HintSelection(g)
		local tcg=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		if tc:IsType(TYPE_XYZ) then e1:SetCode(EFFECT_CHANGE_RANK)
		else e1:SetCode(EFFECT_CHANGE_LEVEL) end
		if tcg:IsType(TYPE_XYZ) then e1:SetValue(tcg:GetRank())
		else e1:SetValue(tcg:GetLevel()) end
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c3186.slcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
end
function c3186.atkfilter(c,atk)
	return c:IsFaceup() and c:GetAttack()~=atk
end
function c3186.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc~=c and c3186.atkfilter(chkc,atk) end
	if chk==0 then return Duel.IsExistingTarget(c3186.atkfilter,tp,LOCATION_MZONE,0,1,nil,atk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c3186.atkfilter,tp,LOCATION_MZONE,0,1,1,nil,atk)
end
function c3186.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
