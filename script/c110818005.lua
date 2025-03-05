--청파룡 펄서 드레이크
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
	--Link Summon procedure
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsAttribute,ATTRIBUTE_WATER),2)
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0xff,0xff)
	e1:SetValue(LOCATION_REMOVED)
	e1:SetCondition(s.rmcon)
	e1:SetTarget(s.rmtg)
	c:RegisterEffect(e1)
	-- Mill 5 cards from each Deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetCategory(CATEGORY_DECKDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(s.mlcon)
	e2:SetTarget(s.mltg)
	e2:SetOperation(s.mlop)
	c:RegisterEffect(e2)
	
end
function s.rmcon(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function s.rmtg(e,c)
	return Duel.IsPlayerCanRemove(e:GetHandlerPlayer(),c)
end
function s.mlcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.mltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.IsPlayerCanDiscardDeck(1-tp,3) end
end
function s.mlop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardDeck(tp,3,REASON_EFFECT)
	Duel.DiscardDeck(1-tp,3,REASON_EFFECT)
end
