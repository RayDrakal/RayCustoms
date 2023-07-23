--フェニックス・グラビテーション
function c3129.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c3129.condition)
	e1:SetTarget(c3129.target)
	e1:SetOperation(c3129.activate)
	c:RegisterEffect(e1)
end
function c3129.cfilter(c)
	return c:IsFaceup() and c:IsCode(3115,3116,3117,3118,3119,3120,3121,3122,3123,3124,3125,3126)
end
function c3129.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c3129.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c3129.filter(c,e,tp)
	return c:IsCode(3115,3116,3117,3118,3119,3120,3121,3122,3123,3124,3125,3126) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3129.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c3129.filter(chkc,e,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>3
		and Duel.IsExistingTarget(c3129.filter,tp,LOCATION_GRAVE,0,4,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c3129.filter,tp,LOCATION_GRAVE,0,4,4,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,4,0,0)
end
function c3129.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<4 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
