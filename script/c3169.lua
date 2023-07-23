--女帝の冠
function c3169.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SPSUMMON)
	e1:SetTarget(c3169.target)
	e1:SetOperation(c3169.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c3169.handcon)
	c:RegisterEffect(e2)
end
function c3169.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO)
end
function c3169.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(c3169.cfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,g*2) and g>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(g*2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g*2)
end
function c3169.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c3169.cfilter2(c,tp)
	return c:IsFaceup() and c:IsControler(1-tp) and c:IsType(TYPE_SYNCHRO)
end
function c3169.handcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	if res then
		local g=teg:Filter(c3169.cfilter2,nil,tp)
		if g:GetCount()>0 then
			return true
		end
	end
end
