--テイク・オーバー5
function c4374.initial_effect(c)
	--discard deck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c4374.distarget)
	e1:SetOperation(c4374.disop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(4374,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetLabelObject(e1)
	e2:SetCondition(c4374.drcon)
	e2:SetOperation(c4374.drop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_TO_GRAVE)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetTargetRange(LOCATION_DECK,0)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_DISCARD_DECK)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
end
function c4374.distarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,5)
end
function c4374.filter(c)
	return c:IsCode(4374) and c:IsAbleToRemove()
end
function c4374.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p,val=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.DiscardDeck(p,val,REASON_EFFECT)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_STANDBY then
		e:SetLabel(Duel.GetTurnCount())
		c:RegisterFlagEffect(4374,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,2)
	else
		e:SetLabel(0)
		c:RegisterFlagEffect(4374,RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,0,1)
	end	
end
function c4374.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return e:GetLabelObject():GetLabel()~=Duel.GetTurnCount() and tp==Duel.GetTurnPlayer() and c:GetFlagEffect(4374)>0
	and Duel.IsExistingMatchingCard(c4374.filter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,1,nil)
end
function c4374.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(4374,0)) then
	local g=Duel.GetMatchingGroup(c4374.filter,tp,LOCATION_GRAVE+LOCATION_DECK+LOCATION_HAND,0,nil)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	c:ResetFlagEffect(4374)
end
