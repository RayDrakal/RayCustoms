--魔術師の至言
function c3167.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c3167.target)
	e1:SetOperation(c3167.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c3167.handcon)
	c:RegisterEffect(e2)
	if not c3167.global_check then
		c3167.global_check=true
		c3167[0]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_DELAY)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c3167.checkcon)
		ge1:SetOperation(c3167.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c3167.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
function c3167.filter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c3167.checkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3167.filter,1,nil)
end
function c3167.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c3167.filter,nil)
	c3167[0]=c3167[0]+g:GetCount()
end
function c3167.clear(e,tp,eg,ep,ev,re,r,rp)
	c3167[0]=0
end
function c3167.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c3167[0]~=0 end
	local s=c3167[0]*300
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(s)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,s)
end
function c3167.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c3167.handcon(e)
	return Duel.GetTurnPlayer()==e:GetHandler():GetControler()
end
