--光の結界
function c4116.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_COIN)
	e1:SetTarget(c4116.cointg)
	e1:SetOperation(c4116.coinop)
	c:RegisterEffect(e1)
	--
	if not c4116.global_check then
	c4116.global_check=true
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(73206827)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetCondition(c4116.effectcon)
	Duel.RegisterEffect(e3,0)
	end
	--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4116,1))
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetTarget(c4116.rectg)
	e4:SetOperation(c4116.recop)
	c:RegisterEffect(e4)
end
function c4116.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c4116.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local res=1-Duel.SelectOption(tp,60,61)
	if res==1 then
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c4116.disable)
	e1:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e1)
	end
end
function c4116.effectcon(e)
	local c=e:GetHandler()
	return c:GetFlagEffect(73206828)==0 or c:IsHasEffect(EFFECT_CANNOT_DISABLE)
end
function c4116.reccon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	return rc:IsRelateToBattle() and rc:IsFaceup() and c:IsHasEffect(EFFECT_CANNOT_DISABLE)
end
function c4116.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=eg:GetFirst():GetBattleTarget()
	local atk=tc:GetBaseAttack()
	if atk<0 then atk=0 end
	tp=tc:GetControler()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(atk)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,atk)
end
function c4116.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c4116.disable(e,c)
	return (c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and not c:IsSetCard(0x5)
end
