--ヌメロン・カオス・リチューアル
function c4012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c4012.target)
	e1:SetOperation(c4012.activate)
	c:RegisterEffect(e1)
end
function c4012.filter(c,e,tp)
	return c:IsCode(89477759) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c4012.tfilter(c)
	return c:IsSetCard(0x14a) and c:IsType(TYPE_XYZ) and c:IsCanOverlay() and c:IsFaceup()
end
function c4012.tfilter2(c)
	return c:IsCode(41418852) and c:IsCanOverlay() and c:IsFaceup()
end
function c4012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4012.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c4012.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
		and Duel.IsExistingMatchingCard(c4012.tfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c4012.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c4012.tfilter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g3=Duel.SelectTarget(tp,c4012.tfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
end
function c4012.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=5 or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	tc=g:GetFirst()
	local spg=Duel.SelectMatchingCard(tp,c4012.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if Duel.SpecialSummonStep(spg:GetFirst(),SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP) then
		while tc do
			Duel.Overlay(spg:GetFirst(),tc)
			tc=g:GetNext()
		end
		spg:GetFirst():CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end
