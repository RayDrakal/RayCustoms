--覇王無礼
function c2812.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCondition(c2812.condition)
	e1:SetTarget(c2812.target)
	e1:SetOperation(c2812.activate)
	c:RegisterEffect(e1)
end
function c2812.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x20f8)
end
function c2812.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c2812.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c2812.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	local ct=Duel.GetMatchingGroupCount(c2812.cfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,ct)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c2812.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	local ct=Duel.GetMatchingGroupCount(c2812.cfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	if g:GetCount()>0 and ct>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_DISCARD)
		local sg=g:Select(p,1,ct,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
		Duel.Damage(1-tp,sg:GetCount()*300,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
	end
end
