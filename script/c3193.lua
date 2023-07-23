--オッドアイズ・シンクロゲート`
function c3193.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
--	e1:SetCost(c3193.cost)
	e1:SetTarget(c3193.target)
	e1:SetOperation(c3193.activate)
	c:RegisterEffect(e1)
	--gate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c3193.gcon)
	e2:SetTarget(c3193.gtg)
	e2:SetOperation(c3193.gop)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
function c3193.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetLabelObject(e)
	e2:SetTarget(c3193.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c3193.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject()
end
function c3193.filtero(c,e,tp)
	return c:IsCode(16178681) and c:IsFaceup() and c:IsCanBeSynchroMaterial() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3193.filters(c,e,tp,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsCanBeSynchroMaterial() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c3193.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,mg:GetFirst(),c)
end
function c3193.spfilter(c,e,o,s)
	local code=c:GetOriginalCode()
	local mt=_G["c" .. code]
	if (not o ) or (not s) then return false end
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_PENDULUM)
		and c:GetLevel()==s:GetSynchroLevel(c)+1
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
		and ( ((mt.f1 and mt.f1(o)) or (mt.f2 and mt.f2(o))) or ((mt.f1 and mt.f1(s)) or (mt.f2 and mt.f2(s))) )
end
function c3193.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c3193.filtero,tp,LOCATION_EXTRA,0,nil,e,tp)
		local mg2=Duel.GetMatchingGroup(c3193.filters,tp,LOCATION_GRAVE,0,nil,e,tp,mg)
		return mg2 and mg2:GetCount()>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	end
	local g=Duel.SelectTarget(tp,c3193.filtero,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local g2=Duel.SelectTarget(tp,c3193.filters,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g)
	e:SetLabelObject(g2:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c3193.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local mg1=g:GetFirst()
	local mg2=g:GetNext()
	if g:GetCount()==2 then
		Duel.SpecialSummonStep(mg1,182,tp,tp,false,false,POS_FACEUP) 
		Duel.SpecialSummonStep(mg2,182,tp,tp,false,false,POS_FACEUP) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		mg1:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		mg1:RegisterEffect(e2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		mg2:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		mg2:RegisterEffect(e2)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_LEVEL)
		e5:SetValue(1)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		mg1:RegisterEffect(e5)
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_ADD_TYPE)
		e6:SetReset(RESET_EVENT+0x1fe0000)
		e6:SetValue(TYPE_TUNER)
		mg1:RegisterEffect(e6)
		Duel.SpecialSummonComplete()
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local sg=Duel.GetMatchingGroup(c3193.spfilter,tp,LOCATION_EXTRA,0,nil,e,mg1,mg2)
		if sg:GetCount()>0  then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg:IsContains(tc) then
				Duel.BreakEffect()
				local mg=Group.FromCards(mg1,mg2)
				Duel.SynchroSummon(tp,tc,nil,mg)
				c:SetCardTarget(tc)
			end
			tc:CompleteProcedure()
		end
	end
end
function c3193.gcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY+REASON_BATTLE+REASON_EFFECT)
end
function c3193.tfilter(c)
	return c:IsAbleToHand() and c:IsCode(3194)
end
function c3193.gtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.IsExistingMatchingCard(c3193.tfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c3193.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.Destroy(c,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c3193.tfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
