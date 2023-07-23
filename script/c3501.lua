--幻影騎士団円卓裂破
function c3501.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c3501.cost)
	e1:SetCondition(c3501.condition)
	e1:SetTarget(c3501.target)
	e1:SetOperation(c3501.activate)
	c:RegisterEffect(e1)
		if not c3501.global_check then
		c3501.global_check=true
		c3501[0]=0
		c3501[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetCondition(c3501.condition)
		ge1:SetOperation(c3501.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c3501.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c3501.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c3501.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x10db)
end
function c3501.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3501.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c3501.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c3501.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c3501.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if Duel.Destroy(sg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
		e1:SetCountLimit(1)
		e1:SetOperation(c3501.damop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c3501.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(tp,c3501[tp]*800,REASON_EFFECT)
	Duel.Damage(1-tp,c3501[1-tp]*800,REASON_EFFECT)
end
function c3501.drcfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:GetPreviousControler()==tp
end
function c3501.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tpc1=eg:FilterCount(c3501.drcfilter,nil,tp)
	local tpc2=eg:FilterCount(c3501.drcfilter,nil,1-tp)
	if tpc1>0 then
		c3501[tp]=c3501[tp]+tpc1
	end
	if tpc2>0 then
		c3501[1-tp]=c3501[1-tp]+tpc2
	end
end
function c3501.clear(e,tp,eg,ep,ev,re,r,rp)
	c3501[0]=0
	c3501[1]=0
end
