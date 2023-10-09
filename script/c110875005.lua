--파멸의 용수 그라이포길라
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	c:SetUniqueOnField(1,0,id)
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x425),9,2,nil,nil,99)
	--Summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.sumsuc)
	c:RegisterEffect(e1)
	-- Mill 5 cards from each Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,{id,1})
	e2:SetCondition(s.mlcon)
    e2:SetCost(aux.dxmcostgen(1,1,nil))
	e2:SetTarget(s.mltg)
	e2:SetOperation(s.mlop)
	c:RegisterEffect(e2)
	
end
s.listed_series={SET_DRAGONTREE}
function s.mlcon()
	return Duel.IsMainPhase()
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_XYZ) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetValue(s.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(s.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsOnField() and e:GetHandler()~=re:GetHandler()
end
function s.disable(e,c)
	return c~=e:GetHandler() and (not c:IsMonster() or (c:IsType(TYPE_EFFECT) or (c:GetOriginalType()&TYPE_EFFECT)==TYPE_EFFECT))
end
function s.mltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) and Duel.IsPlayerCanDiscardDeck(1-tp,5) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,5)
end
function s.mlop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.DiscardDeck(tp,5,REASON_EFFECT)+Duel.DiscardDeck(1-tp,5,REASON_EFFECT))<=0
		or not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,CARD_GRIPOSID) then return end
	local b1=Duel.IsPlayerCanDiscardDeck(tp,5)
	local b2=Duel.IsPlayerCanDiscardDeck(1-tp,5)
	if (b1 or b2) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
		local op=Duel.SelectEffect(tp,
			{b1,aux.Stringid(id,4)},
			{b2,aux.Stringid(id,5)})
		Duel.DiscardDeck(op==1 and tp or 1-tp,5,REASON_EFFECT)
	end
end
