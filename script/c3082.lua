--レジェンド・オブ・ハート
function c3082.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c3082.cost)
	e1:SetTarget(c3082.target)
	e1:SetOperation(c3082.activate)
	c:RegisterEffect(e1)
end
function c3082.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_WARRIOR) end
	Duel.PayLPCost(tp,1000)
	local sg=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_WARRIOR)
	Duel.Release(sg,REASON_COST)
end
function c3082.rmfilter(c)
	return c:IsSetCard(0xa1) and c:IsType(TYPE_SPELL) and c:IsAbleToDeck()
end
function c3082.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c3082.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,nil)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c3082.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,3,nil)
		and g:GetClassCount(Card.GetCode)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c3082.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<3 then return end
	local rmg=Duel.GetMatchingGroup(c3082.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_ONFIELD,0,nil)
	if rmg:GetClassCount(Card.GetCode)>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg1=rmg:Select(tp,1,1,nil)
		rmg:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg2=rmg:Select(tp,1,1,nil)
		rmg:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg3=rmg:Select(tp,1,1,nil)
		sg1:Merge(sg2)
		sg1:Merge(sg3)
		local dm=sg1:GetFirst()
	while dm do
	Duel.MoveToField(dm,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true)
	dm=sg1:GetNext()
	end	
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(3082,0))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(3082,1))
	Duel.Hint(HINT_MESSAGE,tp,aux.Stringid(3082,2))
	Duel.SendtoDeck(sg1,nil,tp-2,REASON_RULE)
	local token=Duel.CreateToken(tp,3083,nil,nil,nil,nil,nil,nil)		
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(token,0,tp,tp,true,true,POS_FACEUP)
	local token2=Duel.CreateToken(tp,3084,nil,nil,nil,nil,nil,nil)		
	Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(token2,0,tp,tp,true,true,POS_FACEUP)
	local token3=Duel.CreateToken(tp,3085,nil,nil,nil,nil,nil,nil)		
	Duel.SpecialSummonStep(token3,0,tp,tp,false,false,POS_FACEUP)
	Duel.SpecialSummon(token3,0,tp,tp,true,true,POS_FACEUP)
	Duel.SpecialSummonComplete()
	end
end
