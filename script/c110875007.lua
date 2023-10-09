--절멸의 용수 그라이포길라 보텍스
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(id)
	--xyz summon
	Xyz.AddProcedure(c,nil,12,4,s.ovfilter,aux.Stringid(id,0),99)
	--Special Summon 1 "Kshatri-la" monster from the Deck
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,{id,0})
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	c:RegisterEffect(e0)
	-- Decrease ATK/DEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--material
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,{id,1})
	e3:SetTarget(s.mttg)
	e3:SetOperation(s.mtop)
	c:RegisterEffect(e3)
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	--cannot be fusion or link material
	local e6=e4:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e6)
    local e7=e4:Clone()
    e7:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
    c:RegisterEffect(e7)
    --immuine effect
    local e8=e4:Clone()
    e8:SetCode(EFFECT_IMMUNE_EFFECT)
    e8:SetValue(s.efilter)
    c:RegisterEffect(e8)
	
end
s.listed_series={SET_DRAGONTREE}
function s.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp) and c:IsSetCard(0x425,xyzc,SUMMON_TYPE_XYZ,tp)
end
function s.atkval(e,c)
	return c:GetOverlayCount()*-200
end
function s.mttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) 
		and Duel.IsExistingTarget(Card.TRUE,tp,LOCATION_ONFIELD|LOCATION_GRAVE,LOCATION_ONFIELD|LOCATION_GRAVE,2,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.TRUE,tp,LOCATION_ONFIELD|LOCATION_GRAVE,LOCATION_ONFIELD|LOCATION_GRAVE,2,2,c)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local g=Duel.GetTargetCards(e)
		if #g>0 then
			Duel.Overlay(c,g)
		end
	end
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(SET_DRAGONTREE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
