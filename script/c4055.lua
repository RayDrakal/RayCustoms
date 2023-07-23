--グランエルＡ
function c4055.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c4055.descon)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c4055.eqcon)
	e2:SetTarget(c4055.eqtg)
	e2:SetOperation(c4055.eqop)
	c:RegisterEffect(e2)
	--equip-battle
	--local e3=Effect.CreateEffect(c)
	--e3:SetType(EFFECT_TYPE_QUICK_O)
	--e3:SetCode(EVENT_FREE_CHAIN)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	--e3:SetCondition(c4055.sccon)
	--e3:SetTarget(c4055.sctg)
	--e3:SetOperation(c4055.scop)
	--c:RegisterEffect(e3)
	--pierce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PIERCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3013) or c:IsCode(4050,63468625))
	c:RegisterEffect(e4)
end
function c4055.sdfilter(c)
	return c:IsFaceup() and (c:IsSetCard(0x3013) or c:IsCode(4050,63468625))
end
function c4055.descon(e)
	return not Duel.IsExistingMatchingCard(c4055.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c4055.eqfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==1-tp
		and c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE) and c:IsCanBeEffectTarget(e) and c:IsType(TYPE_SYNCHRO)
end
function c4055.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c4055.sdfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c4055.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c4055.eqfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and eg:IsExists(c4055.eqfilter,1,nil,e,tp) end
	local g=eg:Filter(c4055.eqfilter,nil,e,tp)
	local tc=nil
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		tc=g:Select(tp,1,1,nil):GetFirst()
	else
		tc=g:GetFirst()
	end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,tc,1,0,0)
end
function c4055.eqlimit(e,c)
	return (c:IsSetCard(0x3013) or c:IsCode(4050))
end
function c4055.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c4055.sdfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	local gtc=Duel.GetFirstTarget()
	if gtc and tc:IsRelateToEffect(e) then
		if not Duel.Equip(tp,tc,gtc,false) then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c4055.eqlimit)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(4055,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c4055.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) and Duel.GetCurrentChain()==0
end
function c4055.filter(c,e,tp)
	return c:IsFaceup() and c:GetFlagEffect(4055)~=0
end
function c4055.sctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and chkc:IsControler(tp) and c4055.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c4055.filter,tp,LOCATION_SZONE,0,1,nil,e,tp) 
	and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil,e,tp) end
end
function c4055.scop(e,tp,eg,ep,ev,re,r,rp)
	local t=Duel.SelectMatchingCard(tp,c4055.filter,tp,LOCATION_SZONE,0,1,1,nil,e,tp)
	local tc=t:GetFirst()
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	local gtc=g:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(tc:GetAttack())
	e:GetHandler():RegisterEffect(e1)
	
	Duel.CalculateDamage(e:GetHandler(),gtc)
end
