--クロス・オーバー
function c4300.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--auto activate	
	local e1=Effect.CreateEffect(c)
	c4300[0]=0	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1,4300+EFFECT_COUNT_CODE_DUEL)
	e1:SetRange(LOCATION_DECK+LOCATION_HAND)
	e1:SetOperation(c4300.op)
	c:RegisterEffect(e1)
	--action card
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c4300.adcon4)
	e2:SetOperation(c4300.acop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(c4300.acop2)
	e3:SetCondition(c4300.adcon)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_CHAINING)
	e5:SetOperation(c4300.acop3)
	e5:SetCondition(c4300.adcon3)
	c:RegisterEffect(e5)
	--unaffectable
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c4300.efilter)
	c:RegisterEffect(e6)
end
function c4300.rfilter(c)
	return c:IsCode(4300)
end
function c4300.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetDecktopGroup(tp,dc)
	local i
	g:GetFirst():RegisterFlagEffect(4300,0,0,1)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_FZONE,POS_FACEUP,true) 
	Duel.ShuffleDeck(tp)
	local seq=g:GetFirst():GetSequence()
	Duel.RegisterFlagEffect(tp,4300,0,0,seq)
	c4300[tp]=seq
	local sd=Duel.GetMatchingGroup(c4300.rfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	Duel.SendtoDeck(sd,nil,-2,REASON_RULE)
	local ht1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	if ht1<5 then
		Duel.Draw(tp,5-ht1,REASON_RULE)
	end
end
function c4300.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c4300.acop(e,tp,eg,ep,ev,re,r,rp)
	--sp && attack
	local seq=c4300[tp]
    local atable={4301,4301,4302,4302,4304,4304,4305,4306}
    --Linear congruential generators
    local rnumber = (48828125*seq+1)%16384
    local rnumber2=math.floor(rnumber)%5
    --Debug.Message(tostring(rnumber2))
    local h=rnumber2%5+1
    if h==1 then--10%
    h=rnumber%8+1
    --Debug.Message(tostring(h))
	local token=Duel.CreateToken(tp,atable[h],nil,nil,nil,nil,nil,nil)
	Duel.SendtoHand(token,nil,REASON_RULE)
	end
	c4300[tp]=rnumber
end
function c4300.acop2(e,tp,eg,ep,ev,re,r,rp)
	--destroy
	local seq=c4300[tp]
    local atable={4301,4302,4303,4304,4305,4306,4303,4303}
    --Linear congruential generators
    local rnumber = (48828125*seq+1)%16384
    local rnumber2=math.floor(rnumber)%5
    local h=rnumber2%10+1
    if h<=5 then--50%
    h=rnumber%8+1
	local token=Duel.CreateToken(tp,atable[h],nil,nil,nil,nil,nil,nil)
	Duel.SendtoHand(token,nil,REASON_RULE)
	end
	c4300[tp]=rnumber
end
function c4300.acop3(e,tp,eg,ep,ev,re,r,rp)
	--burn
	local seq=c4300[tp]
    local atable={4301,4302,4304,4305,4306,4307,4307,4307,4307}
    --Linear congruential generators
    local rnumber = (48828125*seq+1)%16384
    local rnumber2=math.floor(rnumber)%5
    local h=rnumber2%10+1
    if h<=5 then--50%
    h=rnumber%9+1
	local token=Duel.CreateToken(tp,atable[h],nil,nil,nil,nil,nil,nil)
	Duel.SendtoHand(token,nil,REASON_RULE)
	end
	c4300[tp]=rnumber
end
function c4300.acfilter(c)
	return c:IsCode(4301) or c:IsCode(4302) or c:IsCode(4303) or c:IsCode(4304) or c:IsCode(4305) or c:IsCode(4306) or c:IsCode(4307) 
end
function c4300.adcon(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc>0 and ep~=tp and not Duel.IsExistingMatchingCard(c4300.acfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil)
end
function c4300.adcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and not Duel.IsExistingMatchingCard(c4300.acfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil)
end
function c4300.adcon3(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and aux.damcon1(e,tp,eg,ep,ev,re,r,rp) and not Duel.IsExistingMatchingCard(c4300.acfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil)
end
function c4300.adcon4(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c4300.acfilter,tp,LOCATION_HAND+LOCATION_SZONE,0,1,nil)
end
