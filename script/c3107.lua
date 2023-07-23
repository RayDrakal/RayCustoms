--邪神ゲー
function c3107.initial_effect(c)
	c:EnableReviveLimit()
	--atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(99999999)
	c:RegisterEffect(e1)
	local e8=e1:Clone()
	e8:SetCode(EFFECT_SET_BASE_DEFENSE)
	e8:SetValue(99999999)
	c:RegisterEffect(e8)
	--damege
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c3107.con)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e3:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e3,true)
	--Leave Field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c3107.leaveop)
	e4:SetReset(RESET_EVENT+0xc020000)
	c:RegisterEffect(e4)
	--attack cost
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_ATTACK_COST)
	e5:SetCost(c3107.atcost)
	e5:SetOperation(c3107.atop)
	c:RegisterEffect(e5)
	--cannot special summon
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SPSUMMON_CONDITION)
	e6:SetValue(aux.FALSE)
	c:RegisterEffect(e6)
	--unaffectable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_IMMUNE_EFFECT)
	e7:SetValue(c3107.efilter)
	c:RegisterEffect(e7)
	--infinity ilmit
	local e9=Effect.CreateEffect(c)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_ADJUST)
	e9:SetRange(LOCATION_MZONE)
	e9:SetOperation(c3107.limit)
	c:RegisterEffect(e9)
end
function c3107.con(e)
	return e:GetHandlerPlayer()==e:GetOwnerPlayer()
end
function c3107.leaveop(e,tp,eg,ep,ev,r,rp)
	Duel.SetLP(tp,0,REASON_RULE)
end
function c3107.atop(e,tp,eg,ep,ev,re,r,rp)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,10) end
	Duel.DiscardDeck(tp,10,REASON_COST)
end
function c3107.atcost(e,c,tp)
	return Duel.IsPlayerCanDiscardDeckAsCost(tp,10)
end
function c3107.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c3107.atktg(e,c)
	return c:GetAttack()>99999999
end
function c3107.atkval(e,c)
	return 99999999
end
function c3107.deftg(e,c)
	return c:GetDefense()>99999999
end
function c3107.defval(e,c)
	return 99999999
end
function c3107.limfilter(c)
	return c:GetAttack()>99999999 or c:GetDefense()>99999999
end
function c3107.limit(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c3107.limfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		if tc:GetAttack()>99999999 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetDescription(aux.Stringid(3086,0))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetValue(99999999-tc:GetAttack())
			e1:SetReset(RESET_PHASE+0x3ff)
			tc:RegisterEffect(e1)
		end
		if tc:GetDefense()>99999999 then
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			e2:SetDescription(aux.Stringid(3086,0))
			e2:SetProperty(EFFECT_FLAG_CLIENT_HINT+EFFECT_FLAG_IGNORE_IMMUNE)
			e2:SetValue(99999999-tc:GetDefense())
			e2:SetReset(RESET_PHASE+0x3ff)
			tc:RegisterEffect(e2)
		end
		tc=g:GetNext()
	end
end
