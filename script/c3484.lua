--二重露光
function c3484.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--level
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCost(c3484.cost)
	e2:SetTarget(c3484.lvtg)
	e2:SetOperation(c3484.lvop)
	c:RegisterEffect(e2)
end
function c3484.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c3484.filter(c,tp)
	return c:IsFaceup() and c:IsLevelBelow(6) and Duel.IsExistingTarget(c3484.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,c:GetCode())
end
function c3484.cfilter(c,code)
	return c:IsFaceup() and c:IsLevelBelow(6) and c:IsCode(code)
end
function c3484.filter2(c,tp)
	return c:IsFaceup() and Duel.IsExistingTarget(Card.IsFaceup,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c3484.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	local b1=Duel.IsExistingTarget(c3484.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
	local b2=Duel.IsExistingTarget(c3484.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,2,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(3484,0),aux.Stringid(3484,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(3484,0))
	else op=Duel.SelectOption(tp,aux.Stringid(3484,1))+1 end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g1=Duel.SelectTarget(tp,c3484.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
		local tc=g1:GetFirst()
		e:SetLabelObject(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectTarget(tp,c3484.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc,tc:GetCode())
		g1:Merge(g2)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g1=Duel.SelectTarget(tp,c3484.filter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
		local tc=g1:GetFirst()
		e:SetLabelObject(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectTarget(tp,Card.IsFaceup,tc:GetControler(),LOCATION_MZONE,0,1,1,tc)
		g1:Merge(g2)
	end
end
function c3484.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if not c:IsRelateToEffect(e) or g:GetCount()==0 then return end
	local tc=e:GetLabelObject()
	local tc2=g:Filter(Card.IsRelateToEffect,tc,e):GetFirst()
	if e:GetLabel()==0 then
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsLevelBelow(6) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(tc:GetLevel()*2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
		if tc2:IsFaceup() and tc2:IsRelateToEffect(e) and tc2:IsLevelBelow(6) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetValue(tc2:GetLevel()*2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc2:RegisterEffect(e1)
		end
	else
		if not g:GetCount()==2 then return end
		if tc:IsFaceup() and tc2:IsFaceup() and tc:IsRelateToEffect(e) then
			local code=tc2:GetCode()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_CODE)
			e1:SetValue(code)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
		end
	end
end
