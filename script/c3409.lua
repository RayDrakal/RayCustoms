--デストーイ・マーチ
function c3409.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c3409.condition)
	e1:SetTarget(c3409.target)
	e1:SetOperation(c3409.activate)
	c:RegisterEffect(e1)
end
function c3409.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xad)
end
function c3409.condition(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c3409.filter,1,nil,tp)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER))
end
function c3409.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local tc=g:Select(tp,1,1,nil)
	Duel.HintSelection(tc)
	Duel.SetTargetCard(tc)
end
function c3409.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xad)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and ( c:IsCode(3401) or c:IsCode(3402) or c:IsCode(83866861) or c:IsCode(80889750) ) 
		and Duel.IsExistingMatchingCard(c3409.grfilter,tp,LOCATION_EXTRA,0,1,c,e,tp,lv)
end
function c3409.grfilter(c,e,tp,lv)
	return c:IsType(TYPE_FUSION) and c:GetLevel()==lv and c:IsSetCard(0xad)
end
function c3409.grfilter2(c,e,tp,lv)
	return c:IsType(TYPE_FUSION) and c:GetLevel()==lv and c:IsSetCard(0xad)
	and Duel.IsExistingMatchingCard(c3409.spfilter,tp,LOCATION_EXTRA,0,1,c,e,tp,lv)
end
function c3409.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c3409.filter,nil,tp)
	Duel.NegateActivation(ev)
	local tc=Duel.GetFirstTarget()
	if re:GetHandler():IsRelateToEffect(re) then
		local tg=g:Filter(Card.IsRelateToEffect,nil,re)
		local sg=Duel.GetMatchingGroup(c3409.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,tc:GetLevel())
		local gr=Duel.GetMatchingGroup(c3409.grfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,tc:GetLevel())
		if sg:GetCount()>0 and gr:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(3409,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local gc=gr:Select(tp,1,1,nil):GetFirst()
			if Duel.SendtoGrave(gc,REASON_EFFECT)==0 then return end
			sg:RemoveCard(gc)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sc=sg:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummon(sc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		end
	end
end
