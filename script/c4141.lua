--ディメンション・エクシーズ`
function c4141.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4141.target)
	e1:SetOperation(c4141.activate)
	c:RegisterEffect(e1)
end
function c4141.filter(c,tp)
	return Duel.IsExistingMatchingCard(c4141.filter2,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,2,c,c:GetCode())
end
function c4141.filter2(c,code)
	return c:IsCode(code)
end
function c4141.xyzfilter(c,mg)
	return c:IsXyzSummonable(mg,3,3)
end
function c4141.xmfilter(c,xyz,tp)
	local mg=Duel.GetMatchingGroup(c4141.filter2,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil,c:GetCode())
	return mg:GetCount()>2 and xyz:IsXyzSummonable(mg,nil)
end
function c4141.xm2filter(c,code,tp)
	return c:IsCode(code) and Duel.IsExistingMatchingCard(c4141.filter2,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,2,c,code)
end
function c4141.mfilter1(c,mg,exg)
	return mg:IsExists(c4141.mfilter2,1,c,c,exg)
end
function c4141.mfilter2(c,mc,exg)
	return exg:IsExists(Card.IsXyzSummonable,1,nil,Group.FromCards(c,mc))
end
function c4141.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c4141.filter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	local exg=Duel.GetMatchingGroup(c4141.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if chk==0 then return
		Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and exg:GetCount()>0
		and mg:GetCount()>2 end

	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c4141.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local mg=Duel.GetMatchingGroup(c4141.filter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)
	local exg=Duel.GetMatchingGroup(c4141.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg)
	if mg:GetCount()<3 or exg:GetCount()<1 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=exg:Select(tp,1,1,nil):GetFirst()
	local g=mg:FilterSelect(tp,c4141.xmfilter,1,1,nil,tc,tp)
	local g2=mg:FilterSelect(tp,c4141.xm2filter,2,2,g:GetFirst(),g:GetFirst():GetCode(),tp)
	g:Merge(g2)
	if tc then
		tc:SetMaterial(g)
		Duel.Overlay(tc,g)
		Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
