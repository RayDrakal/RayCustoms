--로드 슈페리얼 아르고스=제로버스
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttackAbove,2400),5,2)
	--Name is treated as "Superior Argos"
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE|LOCATION_GRAVE|LOCATION_REMOVED)
	e1:SetValue(CARD_SUPERIOR_ARGOS)
	c:RegisterEffect(e1)
	--Each player draws 1 card and attaches 1 card to this card
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.xcon)
	e2:SetTarget(s.xtg)
	e2:SetOperation(s.xop)
	c:RegisterEffect(e2)
	--Add xyz material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.ovcon)
	e3:SetCost(s.ovcost)
	e3:SetOperation(s.ovop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	-- Banish 1 card
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_REMOVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E|TIMING_MAIN_END)
	e5:SetCost(aux.dxmcostgen(2,2))
	e5:SetTarget(s.rmtg)
	e5:SetOperation(s.rmop)
	c:RegisterEffect(e5)
end
s.listed_names={CARD_SUPERIOR_ARGOS}
function s.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function s.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function s.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ps={}
	local pc=false
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		table.insert(ps,tp)
		pc=true
	end
	if Duel.Draw(1-tp,1,REASON_EFFECT)>0 then
		table.insert(ps,1-tp)
		pc=true
	end
	if not (pc and c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	Duel.BreakEffect()
	for _,p in pairs(ps) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACH)
		local tc=Duel.SelectMatchingCard(p,s.filter,p,LOCATION_HAND|LOCATION_ONFIELD,0,1,1,c):GetFirst()
		if tc then
			tc:CancelToGrave()
			Duel.Overlay(c,tc,true)
		end
	end
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsCode(CARD_SUPERIOR_ARGOS)
end
function s.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,tp)
end
function s.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 and c:IsType(TYPE_XYZ) end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.ovfilter(c,xc,tp,e)
	return c:IsCanBeXyzMaterial(xc,tp,REASON_EFFECT) and not c:IsImmuneToEffect(e)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.ovfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil,c,tp,e)
	if #g>0 then
		Duel.HintSelection(g,true)
		Duel.Overlay(c,g)
	end
end
function s.rmfilter(c)
	return c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	if #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
