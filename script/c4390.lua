--未来への希望
function c4390.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4390.target)
	e1:SetOperation(c4390.activate)
	c:RegisterEffect(e1)
end
function c4390.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c4390.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c4390.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:CheckFusionMaterial(m,nil,chkf)
end
function c4390.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=true and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c4390.filter0,tp,LOCATION_DECK,0,nil)
		local res=Duel.IsExistingMatchingCard(c4390.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c4390.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c4390.filter0,tp,LOCATION_DECK,0,nil)
	local sg1=Duel.GetMatchingGroup(c4390.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	if sg1:GetCount()>0 then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		end
		tc:CompleteProcedure()
	end
end
