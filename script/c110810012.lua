--수호의 거신 라브리스
local s,id=GetID()
function s.initial_effect(c)
	--Negate activations in lower chain links and shuffle the cards into the D3eck
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Can be activated from the hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
	--Special summon itself from GY as a monster
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E+TIMING_MAIN_END)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	
end
s.listed_names={CARD_YOUTH_BERK}
function s.filter(e,c)
	return c:IsCode(CARD_YOUTH_BERK) or (c:ListsCode(CARD_YOUTH_BERK) and c:IsType(TYPE_LINK))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil) then return false end
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsMonsterEffect() or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			return true
		end
	end
	return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ng=Group.CreateGroup()
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsMonsterEffect() or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(i) then
			local tc=te:GetHandler()
			ng:AddCard(tc)
			if tc:IsOnField() and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
				dg:AddCard(tc)
			end
		end
	end
	Duel.SetTargetCard(dg)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,ng,#ng,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,dg,#dg,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Group.CreateGroup()
	for i=1,ev do
		local te,tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
		if tgp~=tp and (te:IsMonsterEffect() or te:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.NegateActivation(i) then
			local tc=te:GetHandler()
			if tc:IsRelateToEffect(e) and tc:IsRelateToEffect(te) and not tc:IsHasEffect(EFFECT_CANNOT_TO_DECK) and Duel.IsPlayerCanSendtoDeck(tp,tc) then
				tc:CancelToGrave()
				dg:AddCard(tc)
			end
		end
	end
	Duel.SendtoDeck(dg,nil,2,REASON_EFFECT)
end
function s.filter2(e,c)
	return c:ListsCode(CARD_YOUTH_BERK) and c:IsType(TYPE_LINK)
end
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.filter2,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x11,1000,3000,7,RACE_MACHINE,ATTRIBUTE_LIGHT) end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,id,0,0x11,1000,3000,7,RACE_MACHINE,ATTRIBUTE_LIGHT) then
		c:AddMonsterAttribute(TYPE_NORMAL)
		c:AssumeProperty(ASSUME_RACE,RACE_MACHINE)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		c:AddMonsterAttributeComplete()
		Duel.SpecialSummonComplete()
	end
end
function s.efilter(e,re)
	return re:IsActiveType(TYPE_MONSTER)
end
