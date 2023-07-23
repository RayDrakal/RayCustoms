--ＤＤＤフュージョン
function c3432.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3432.target)
	e1:SetOperation(c3432.activate)
	c:RegisterEffect(e1)
end
function c3432.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c3432.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x10af) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c3432.ddfilter1(c,e,tp)
	return Duel.IsExistingMatchingCard(c3432.ddfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	and c:IsCode(47198668)
end
function c3432.ddfilter2(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x10af) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function c3432.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(c3432.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c3432.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
			end
		end
		local dd=mg1:IsExists(c3432.ddfilter1,1,nil,e,tp)
		return res or dd
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c3432.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c3432.filter1,nil,e)
	local sg1=Duel.GetMatchingGroup(c3432.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=nil
	local sg2=nil
	local dd=mg1:IsExists(c3432.ddfilter1,1,nil,e,tp)
	local ce=Duel.GetChainMaterial(tp)
	local loc=LOCATION_HAND+LOCATION_MZONE
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c3432.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
		loc=LOCATION_MZONE+LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK
	end
	local b1=0
	local b2=0
	if dd and e:GetHandler():IsOnField() then b1=1 end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then b2=1 end
	local op=0
	if b1==1 and b2==1 then op=Duel.SelectOption(tp,aux.Stringid(3432,0),aux.Stringid(3432,1))
	elseif b1==1 then op=Duel.SelectOption(tp,aux.Stringid(3432,0))
	else op=Duel.SelectOption(tp,aux.Stringid(3432,1))+1 end
	if op==0 then
		local dg1=Duel.SelectMatchingCard(tp,c3432.ddfilter1,tp,loc,0,1,1,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local dg2=Duel.SelectMatchingCard(tp,c3432.ddfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		local tc=dg2:GetFirst()
		local mat1=Group.CreateGroup()
		mat1:AddCard(dg1:GetFirst())
		mat1:AddCard(e:GetHandler())
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	else
		if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end
			tc:CompleteProcedure()
		end
	end
end
