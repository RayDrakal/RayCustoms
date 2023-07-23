--降雷皇ハモン
function c3067.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c3067.spcon)
	e1:SetOperation(c3067.spop)
	c:RegisterEffect(e1)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3067,0))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCondition(c3067.damcon)
	e3:SetTarget(c3067.damtg)
	e3:SetOperation(c3067.damop)
	c:RegisterEffect(e3)
	--unaffectable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetValue(c3067.efilter)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetValue(c3067.efilter2)
	c:RegisterEffect(e6)	
	--no damage
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetCondition(c3067.ndcon)
	e7:SetOperation(c3067.ndop)
	c:RegisterEffect(e7)
	--activate check
	if not c3067.globle_check then
		c3067.globle_check=true
		c3067[1]=Group.CreateGroup()
		c3067[1]:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCountLimit(1)
		ge1:SetCode(EVENT_PHASE+PHASE_END)
		ge1:SetOperation(c3067.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--code
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetCode(EFFECT_CHANGE_CODE)
	e9:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e9:SetValue(32491822)
	c:RegisterEffect(e9)
end
function c3067.spfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost()
end
function c3067.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<-2 then return false end
	if ft<=0 then
		local ct=-ft+1
		return Duel.IsExistingMatchingCard(c3067.spfilter,tp,LOCATION_MZONE,0,ct,nil)
			and Duel.IsExistingMatchingCard(c3067.spfilter,tp,LOCATION_ONFIELD,0,3,nil)
	else
		return Duel.IsExistingMatchingCard(c3067.spfilter,tp,LOCATION_ONFIELD,0,3,nil)
	end
end
function c3067.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=Duel.GetMatchingGroup(c3067.spfilter,tp,LOCATION_ONFIELD,0,nil)
		local ct=-ft+1
		local g1=sg:FilterSelect(tp,Card.IsLocation,ct,ct,nil,LOCATION_MZONE)
		if ct<3 then
			sg:Sub(g1)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g2=sg:Select(tp,3-ct,3-ct,nil)
			g1:Merge(g2)
		end
		Duel.SendtoGrave(g1,REASON_COST)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c3067.spfilter,tp,LOCATION_ONFIELD,0,3,3,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end
end
function c3067.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsReason(REASON_BATTLE) and bc:IsType(TYPE_MONSTER)
end
function c3067.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c3067.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c3067.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c3067.efilter2(e,te)
	return te:IsActiveType(TYPE_MONSTER+TYPE_SPELL) and te:GetOwner()~=e:GetOwner() and te:GetOwner():GetFlagEffect(3067)~=0
end
function c3067.ndcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_DEFENSE)
end
function c3067.ndop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c3067.cfilter(c)
	return c:IsFaceup()
end
function c3067.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c3067.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		tc:RegisterFlagEffect(3067,RESET_EVENT+0x1fe0000,0,1)
		tc=g:GetNext()
	end
end
