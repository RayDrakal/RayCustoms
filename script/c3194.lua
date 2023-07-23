--オッドアイズ・エクシーズゲート`
function c3194.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
--	e1:SetCost(c3194.cost)
	e1:SetTarget(c3194.target)
	e1:SetOperation(c3194.activate)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
end
function c3194.cost(e,tp,eg,ep,ev,re,r,rp,chk)
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
	e2:SetTarget(c3194.splimit)
	Duel.RegisterEffect(e2,tp)
end
function c3194.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return se~=e:GetLabelObject()
end
function c3194.filtero(c,e,tp)
	return c:IsCode(16178681) and c:IsFaceup() and c:IsCanBeXyzMaterial(nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3194.filterx(c,e,tp,mg)
	return c:IsType(TYPE_XYZ) and c:IsCanBeXyzMaterial(nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c3194.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,mg:GetFirst(),c)
end
function c3194.spfilter(c,e,o,x)
	if not x then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_XYZ_LEVEL)
	e1:SetValue(7)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	x:RegisterEffect(e1)
	local mg=Group.FromCards(o,x)
	local bool=c:IsXyzSummonable(mg,2,2)
	e1:Reset()
	return c:IsType(TYPE_XYZ) and c:IsType(TYPE_PENDULUM) and bool
end
function c3194.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then
		local mg=Duel.GetMatchingGroup(c3194.filtero,tp,LOCATION_EXTRA,0,nil,e,tp)
		local mg2=Duel.GetMatchingGroup(c3194.filterx,tp,LOCATION_GRAVE,0,nil,e,tp,mg)
		return mg2 and mg2:GetCount()>0 and Duel.IsPlayerCanSpecialSummonCount(tp,2) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
			and not Duel.IsPlayerAffectedByEffect(tp,59822133)
	end
	local g=Duel.SelectTarget(tp,c3194.filtero,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local g2=Duel.SelectTarget(tp,c3194.filterx,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g)
	e:SetLabelObject(g2:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,0)
end
function c3194.activate(e,tp,eg,ep,ev,re,r,rp)
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
		e5:SetCode(EFFECT_XYZ_LEVEL)
		e5:SetValue(7)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		mg2:RegisterEffect(e5)
		Duel.SpecialSummonComplete()
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local sg=Duel.GetMatchingGroup(c3194.spfilter,tp,LOCATION_EXTRA,0,nil,e,mg1,mg2)
		if sg:GetCount()>0  then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg:IsContains(tc) then
				Duel.BreakEffect()
				local mg=Group.FromCards(mg1,mg2)
				Duel.XyzSummon(tp,tc,mg)
				c:SetCardTarget(tc)
				--3 gate
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_QUICK_O)
				e1:SetCode(EVENT_FREE_CHAIN)
				e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
				e1:SetRange(LOCATION_SZONE)
				e1:SetCost(c3194.gcost)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				e1:SetOperation(c3194.gop)
				c:RegisterEffect(e1)
				e1:SetLabelObject(tc)
			end
			tc:CompleteProcedure()
		end
	end
end
function c3194.gfilter(c,e)
	return c:IsAbleToRemoveAsCost() and (c:IsCode(3192,3193))
end
function c3194.gcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	local g=Duel.GetMatchingGroup(c3194.gfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2
		and c:IsAbleToRemoveAsCost() and tc
	end
	local sg1=g:Select(tp,1,1,nil)
	local sg2=g:Select(tp,1,1,sg1:GetFirst())
	sg1:Merge(sg2)
	sg1:AddCard(c)
	Duel.Remove(sg1,POS_FACEUP,REASON_COST)
end
function c3194.gop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		tc:RegisterEffect(e2)
	end
end
