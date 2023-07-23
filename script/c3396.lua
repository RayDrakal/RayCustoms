--マアト
function c3396.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,57116033,47297616,true,true)
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DRAW)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c3396.addc)
	c:RegisterEffect(e1)
	--announce 3 cards
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3396,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c3396.anctg)
	e3:SetCost(c3396.anccost)
	e3:SetCondition(c3396.anccon)
	e3:SetOperation(c3396.ancop)
	c:RegisterEffect(e3)
	--???
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c3396.rop)
	c:RegisterEffect(e2)
end
function c3396.addc(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(eg:GetCount()*1000)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c3396.rop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	tc:ReverseInDeck()
end
function c3396.anctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		if not Duel.IsPlayerCanDraw(tp,1) then return false end
		local g=Duel.GetDecktopGroup(tp,1)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c3396.anccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(3396,RESET_PHASE+PHASE_END,0,1)
end
function c3396.anccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(3396)==0
end
function c3396.ancop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDraw(tp,1) then return end
	local c=e:GetHandler()
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		Duel.ConfirmCards(1-tp,tc)
		if tc:IsCode(ac) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_SOLVED)
			e1:SetCondition(c3396.sccon)
			e1:SetOperation(c3396.scop)
			e1:SetRange(LOCATION_MZONE)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetLabel(ac)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_SUMMON_SUCCESS)
			e2:SetCondition(c3396.sccon2)
			e2:SetOperation(c3396.scop)
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e2:SetLabel(ac)
			Duel.RegisterEffect(e2,tp)
			local e3=e2:Clone()
			e3:SetCode(EVENT_SPSUMMON_SUCCESS)
			Duel.RegisterEffect(e3,tp)
		end
	end	
end
function c3396.sccon(e,tp,eg,ep,ev,re,r,rp)
	local tc
	if re then tc=re:GetHandler() return tc~=e:GetHandler() and tc:IsCode(e:GetLabel()) end
	return false
end
function c3396.sccon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsCode(e:GetLabel())
end
function c3396.scop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	e:GetHandler():ResetFlagEffect(3396)
end
