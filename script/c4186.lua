--カオス・クロス・バリア
function c4186.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4186.target)
	e1:SetOperation(c4186.activate)
	c:RegisterEffect(e1)
end
function c4186.filter(c)
	return c:IsFaceup() and (c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or c:IsCode(4028))
end
function c4186.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c4186.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4186.filter,tp,LOCATION_MZONE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c4186.filter,tp,LOCATION_MZONE,0,2,2,nil)
end
function c4186.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() then
			e:GetHandler():SetCardTarget(tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			tc:RegisterEffect(e2)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_CANNOT_REMOVE)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
