--異界共鳴－シンクロ・フュージョン
function c3454.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3454,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c3454.target)
	e1:SetOperation(c3454.activate)
	c:RegisterEffect(e1)
end
function c3454.filter0(c,e,tp,mg)
	return mg:IsExists(c3454.filter1,1,nil,e,tp,c)
end
function c3454.filter1(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return Duel.IsExistingMatchingCard(c3454.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
end
function c3454.filter2(c,e,tp,mg)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,nil)
	and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
end
function c3454.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	mg=mg:Filter(Card.IsCanBeSynchroMaterial,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and mg:IsExists(c3454.filter0,1,nil,e,tp,mg)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_EXTRA)
end
function c3454.filter3(c,e,tp,mg)
	return not c:IsImmuneToEffect(e) and mg:IsExists(c3454.filter4,1,c,e,tp,c)
end
function c3454.filter4(c,e,tp,mc)
	local mg=Group.FromCards(c,mc)
	return not c:IsImmuneToEffect(e) and Duel.IsExistingMatchingCard(c3454.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
end
function c3454.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return end
	local mg=Duel.GetFusionMaterial(tp):Filter(Card.IsOnField,nil)
	mg=mg:Filter(Card.IsCanBeSynchroMaterial,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=mg:FilterSelect(tp,c3454.filter3,1,1,nil,e,tp,mg)
	if g1:GetCount()==0 then return end
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=mg:FilterSelect(tp,c3454.filter4,1,1,tc1,e,tp,tc1)
	g1:Merge(g2)
	local sg=Duel.SelectMatchingCard(tp,c3454.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,g1)
	local sg2=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil,g1)
	local tc=sg:GetFirst()
	local tc2=sg2:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	tc:SetMaterial(g1)
	tc2:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_FUSION+REASON_SYNCHRO+REASON_EFFECT)
	Duel.BreakEffect()
	Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(tc2,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummonComplete()
	tc:CompleteProcedure()
	tc2:CompleteProcedure()
end
