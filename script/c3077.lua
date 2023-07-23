--古代の機械混沌融合
function c3077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3077.target)
	e1:SetCost(c3077.cost)
	e1:SetOperation(c3077.activate)
	c:RegisterEffect(e1)
end
function c3077.filter0(c,e,tp)
	return c:IsCanBeFusionMaterial() and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and c:IsType(TYPE_MONSTER)
end
function c3077.filter1(c)
	return c:IsAbleToRemove() and c:GetSummonLocation()==LOCATION_EXTRA and c:IsPreviousLocation(LOCATION_MZONE)
end
function c3077.filter2(c,e,tp,mg,f,chkf)
	local fcount=0
	fcount=c.material_count
	local mg2=mg:Clone()
	if c:IsCode(12652643) then fcount=3 end
	if c:IsCode(3362) then fcount=4 end
	if c:IsCode(51788412) then fcount=4 end
	if c:IsCode(87182127) then fcount=2 end
	if fcount==0 or fcount==nil then return false end
	local rg=Duel.GetMatchingGroup(c3077.filter1,tp,LOCATION_GRAVE,0,c)
	if mg2:IsContains(c) then mg2:RemoveCard(c) end
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:IsSetCard(0x7)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=fcount
		and rg:IsExists(c3077.filtermat,1,nil,e,tp,c,fcount-1,mg2,rg,chkf)
end
function c3077.filtermat(c,e,tp,fm,fcount,mg,rg,chkf)
	local mg2=mg:Clone()
	local rg2=rg:Clone()
	if mg2:IsContains(fm) then mg2:RemoveCard(fm) end
	if mg2:IsContains(c) then mg2:RemoveCard(c) end
	if rg2:IsContains(c) then rg2:RemoveCard(c) end
	if fcount>0 then
		return fm:CheckFusionMaterial(mg2,nil) and rg2:IsExists(c3077.filtermat,1,nil,e,tp,fm,fcount-1,mg2,rg2,chkf)
	else
		return fm:CheckFusionMaterial(mg2,nil)
	end
end
function c3077.fusionfilter(c,fm)
	return fm:CheckFusionMaterial(nil,c)
end
function c3077.cfilter(c)
	return c:GetSummonLocation()==LOCATION_EXTRA
end
function c3077.cofilter(c)
	return c:IsCode(24094653) and c:IsAbleToGraveAsCost()
end
function c3077.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3077.cofilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)  end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c3077.cofilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c3077.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local loc=LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK
		local mg=Duel.GetMatchingGroup(c3077.filter0,tp,loc,0,nil,e,tp)
		local res=Duel.IsExistingMatchingCard(c3077.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,tp,loc)
end
function c3077.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local loc=LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_DECK
	local mg=Duel.GetMatchingGroup(c3077.filter0,tp,loc,0,nil,e,tp)
	local rg=Duel.GetMatchingGroup(c3077.filter1,tp,LOCATION_GRAVE,0,nil)
	local sg=Duel.GetMatchingGroup(c3077.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	if sg:GetCount()>0 and rg:GetCount()>0 and mg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg:IsContains(tc) then
			--remove
			local fcount=0
			fcount=tc.material_count
			if tc:IsCode(12652643) then fcount=3 end
			if tc:IsCode(3362) then fcount=4 end
			if tc:IsCode(51788412) then fcount=4 end
			if tc:IsCode(87182127) then fcount=2 end
			local g=Group.CreateGroup()
			while fcount>0 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
				local g2=rg:FilterSelect(tp,c3077.filtermat,1,1,nil,e,tp,tc,fcount-1,mg,rg,chkf)
				if g2:GetCount()==0 then return end
				g:Merge(g2)
				local tc2=g2:GetFirst()
				mg:RemoveCard(tc2)
				rg:RemoveCard(tc2)
				fcount=fcount-1
			end
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			mg=Duel.GetMatchingGroup(c3077.filter0,tp,loc,0,tc,e,tp)
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			tc:SetMaterial(mat1)
			--sp
			local ftc=mat1:GetFirst()
			while ftc do
				Duel.SpecialSummonStep(ftc,0,tp,tp,true,true,POS_FACEUP)
				local c=e:GetHandler()
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				ftc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE_EFFECT)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				ftc:RegisterEffect(e3)
				ftc=mat1:GetNext()
			end
			Duel.SpecialSummonComplete()
			mat1:KeepAlive()
			--
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		end
	end
end
