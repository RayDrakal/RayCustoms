--ランクアップ・アドバンテージ
function c3337.initial_effect(c)
	--advantage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3337,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c3337.sdcon)
	e1:SetTarget(c3337.sdtg)
	e1:SetOperation(c3337.sdop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3337,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c3337.negcon)
	e3:SetOperation(c3337.negop)
	c:RegisterEffect(e3)
	--rum xyz
	if not c3337.global_check then
		c3337.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c3337.checkop)
		ge1:SetCondition(c3337.sdcon)
		Duel.RegisterEffect(ge1,0)
	end
end
function c3337.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsSetCard(0x95) and re:GetHandler():IsType(TYPE_SPELL)
end
function c3337.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c3337.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.AnnounceCard(tp)
	Duel.SetTargetParam(tc)
	local token=Duel.CreateToken(tp,tc,nil,nil,nil,nil,nil,nil)	
	if token then
		Duel.SendtoDeck(token,nil,0,REASON_RULE)
	Duel.SetTargetParam(1)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c3337.negop(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e2)
	end
end
function c3337.negcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	return a:IsControler(tp) and bit.band(a:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and a:GetFlagEffect(3337)~=0
end
function c3337.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_XYZ) then
			tc:RegisterFlagEffect(3337,RESET_EVENT+0x1fe0000,0,1)
		end
		tc=eg:GetNext()
	end
end
