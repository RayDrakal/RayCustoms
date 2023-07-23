--次元領域決闘
function c3270.initial_effect(c)
	--Activate	
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,3270+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(0xff)
	e1:SetOperation(c3270.op)
	c:RegisterEffect(e1)
end
function c3270.rfilter(c)
	return c:IsCode(3270)
end
function c3270.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local sd=Duel.GetMatchingGroup(c3270.rfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	Duel.SendtoDeck(sd,nil,-2,REASON_RULE)
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht1<5 then
		Duel.Draw(tp,5-ht1,REASON_RULE)
	end
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(3270,0))
	--dimension summon
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_DECREASE_TRIBUTE)
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetValue(0x20002)
	Duel.RegisterEffect(e1,tp)
	--reduce
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetCondition(c3270.rdcon)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(1)
	Duel.RegisterEffect(e2,tp)
	--battle damage
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetOperation(c3270.recop)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(3270)
	e4:SetTargetRange(1,1)
	Duel.RegisterEffect(e4,tp)
end
function c3270.rdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	tc2=Duel.GetAttackTarget()
	return tc and tc2
end
function c3270.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst():GetBattleTarget()
	local atk=tc:GetAttack()
	if atk<0 then atk=0 end
	tp=tc:GetControler()
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(atk)
end
function c3270.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local tc2=Duel.GetAttackTarget()
	if tc2==nil then return end
	local atk=tc:GetAttack()
	if tc:IsPosition(POS_FACEUP_DEFENSE) then atk=tc:GetDefense() end
	local atk2=tc2:GetAttack()
	if tc2:IsPosition(POS_FACEUP_DEFENSE) then atk2=tc2:GetDefense() end
	if atk<0 then atk=0 end
	tp=tc:GetControler()
	if tc:IsStatus(STATUS_BATTLE_DESTROYED) then
		Duel.Damage(tp,atk,REASON_BATTLE)
	end
	if tc2:IsStatus(STATUS_BATTLE_DESTROYED) then
		Duel.Damage(1-tp,atk2,REASON_BATTLE)
	end
end
