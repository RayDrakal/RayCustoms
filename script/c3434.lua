--ＤＤＤエクシーズ
function c3434.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3434.target)
	e1:SetOperation(c3434.activate)
	c:RegisterEffect(e1)
end
function c3434.filter(c,e,tp)
	return c:IsSetCard(0x10af) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c3434.xyzfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,2,ct)
end
function c3434.mfilter1(c,mg,exg,ct)
	return mg:IsExists(c3434.mfilter2,1,nil,Group.FromCards(c),mg,exg,ct)
end
function c3434.mfilter2(c,g,mg,exg,ct)
	local tc=g:GetFirst()
	while tc do
		if c==tc then return false end
		tc=g:GetNext()
	end
	g:AddCard(c)
	local result=exg:IsExists(Card.IsXyzSummonable,1,nil,g,g:GetCount(),g:GetCount())
		or (g:GetCount()<ct and mg:IsExists(c3434.mfilter2,1,nil,g,mg,exg,ct))
	g:RemoveCard(c)
	return result
end
function c3434.ddfilter1(c,e,tp)
	return Duel.IsExistingMatchingCard(c3434.ddfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	and c:IsCode(47198668) and c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c3434.ddfilter2(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x10af) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and c:GetRank()==8 and not c:IsFaceup() 
end
function c3434.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local mg=Duel.GetMatchingGroup(c3434.filter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	local dd=mg:IsExists(c3432.ddfilter1,1,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local exg=Duel.GetMatchingGroup(c3434.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,ct)
	local b1=0
	local b2=0
	if ct>1 and mg:IsExists(c3434.mfilter1,1,nil,mg,exg,ct) and not Duel.IsPlayerAffectedByEffect(tp,59822133) then b1=1 end
	if dd and ct>0 then b2=1 end
	local op=0
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and (b1==1 or b2==1) end
	if b1==1 and b2==1 then op=Duel.SelectOption(tp,aux.Stringid(3434,0),aux.Stringid(3434,1))
	elseif b1==1 then op=Duel.SelectOption(tp,aux.Stringid(3434,0))
	else op=Duel.SelectOption(tp,aux.Stringid(3434,1))+1 end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=mg:FilterSelect(tp,c3434.mfilter1,1,1,nil,mg,exg,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=mg:FilterSelect(tp,c3434.mfilter2,1,1,nil,sg1,mg,exg,ct)
		sg1:Merge(sg2)
		while sg1:GetCount()<ct and mg:IsExists(c3434.mfilter2,1,nil,sg1,mg,exg,ct)
			and (not exg:IsExists(Card.IsXyzSummonable,1,nil,sg1,sg1:GetCount(),sg1:GetCount()) or Duel.SelectYesNo(tp,aux.Stringid(3434,0))) do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg3=mg:FilterSelect(tp,c3434.mfilter2,1,1,nil,sg1,mg,exg,ct)
			sg1:Merge(sg3)
		end
			Duel.SetTargetCard(sg1)
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,sg1,sg1:GetCount(),0,0)
	else
		local g=Duel.SelectMatchingCard(tp,c3434.ddfilter1,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetTargetCard(g)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	e:SetLabel(op)
end
function c3434.filter2(c,e,tp)
	return c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3434.spfilter(c,mg,ct)
	return c:IsXyzSummonable(mg,ct,ct)
end
function c3434.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c3434.filter2,nil,e,tp)
	local tc=g:GetFirst()
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	if e:GetLabel()==0 then
		local xyzg=Duel.GetMatchingGroup(c3434.spfilter,tp,LOCATION_EXTRA,0,nil,g,ct)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		if xyzg:GetCount()>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,g)
		end
	else
		local xyzg=Duel.GetMatchingGroup(c3434.ddfilter2,tp,LOCATION_EXTRA,0,nil,e,tp)
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=xyzg:Select(tp,1,1,nil):GetFirst()
			tc:SetMaterial(g)
			Duel.Overlay(tc,g)
			Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
