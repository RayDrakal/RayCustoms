--パワー・ウォール
function c4381.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c4381.condition)
	e1:SetTarget(c4381.target)
	e1:SetOperation(c4381.activate)
	c:RegisterEffect(e1)
end
function c4381.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end
function c4381.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1)
	and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_AVOID_BATTLE_DAMAGE) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,g)
end
function c4381.activate(e,tp,eg,ep,ev,re,r,rp)
	local t={}
	local i=1
	local p=1
	for i=1,Duel.GetFieldGroupCount(tp,LOCATION_DECK,0) do
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	local val=(Duel.AnnounceNumber(tp,table.unpack(t)))
	Duel.DiscardDeck(tp,val,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<1 then return end
	local dm=Duel.GetBattleDamage(tp)-og:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)*100
	if dm<0 then dm=0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetOperation(c4381.damop)
	e1:SetLabel(dm)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c4381.damop(e,tp,eg,ep,ev,re,r,rp)
	local dm=e:GetLabel()
	Duel.ChangeBattleDamage(tp,dm)
end
