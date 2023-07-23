--ダークネス
function c3053.initial_effect(c)
	--seed
	local e0=Effect.CreateEffect(c)
	c3053[0]=0	
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetCountLimit(1,3053+EFFECT_COUNT_CODE_DUEL)
	e0:SetRange(LOCATION_DECK+LOCATION_HAND)
	e0:SetOperation(c3053.seed)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetTarget(c3053.target)	
	e1:SetOperation(c3053.activate)
	c:RegisterEffect(e1)
	--Reset
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_REPEAT)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetOperation(c3053.reset)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	--selfdes
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(c3053.thcon)
	e3:SetTarget(c3053.thtg)
	e3:SetOperation(c3053.thop)
	c:RegisterEffect(e3)
end
function c3053.seed(e,tp,eg,ep,ev,re,r,rp,chk)
	local dc=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local g=Duel.GetDecktopGroup(tp,dc)
	local i
	g:GetFirst():RegisterFlagEffect(3053,0,0,1)
	Duel.ShuffleDeck(tp)
	local seq=g:GetFirst():GetSequence()
	Duel.RegisterFlagEffect(tp,3053,0,0,seq)
	c3053[tp]=seq
end
function c3053.dfilter(c)
	local code=c:GetCode()
	return c:IsCode(3051,3052,3054,3055,3056)
end
function c3053.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c3053.setfilter(c,code)
	return c:IsCode(code)
end
function c3053.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
    --destroy
    local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,c)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(c3053.dfilter,tp,LOCATION_DECK+LOCATION_HAND,0,nil)
	if g:GetClassCount(Card.GetCode)<5 then return end
	local sg1=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg1:GetFirst():GetCode())
	local sg2=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg2:GetFirst():GetCode())
	local sg3=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg3:GetFirst():GetCode())
	local sg4=g:Select(tp,1,1,nil)
	g:Remove(Card.IsCode,nil,sg4:GetFirst():GetCode())
	local sg5=g:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	sg1:Merge(sg3)
	sg1:Merge(sg4)
	sg1:Merge(sg5)
	--random set
    local v=0 local j=0
    local tbl={0,0,0,0,0}
    local randomtbl={3051,3052,3054,3055,3056}
    local dg=Group.CreateGroup()
    --Linear congruential generators
    for v=0,4 do
		local seq=c3053[tp]
		local rnumber = (48828125*seq+1)%16384
		local h=math.floor(rnumber)%#randomtbl+1
		--Debug.Message(tostring(h))
		local rg=sg1:Filter(Card.IsCode,nil,randomtbl[h]):GetFirst()
		Duel.SSet(tp,rg)
		table.remove(randomtbl,h)
		c3053[tp]=rnumber
	end
end
function c3053.reset(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	if not e:GetHandler():IsRelateToEffect(e) then return end
   	local g=Duel.GetMatchingGroup(c3053.dfilter,tp,LOCATION_DECK,0,nil)
   	if g:GetClassCount(Card.GetCode)<5 then return end
	--random set
    local v=0 local j=0
    local randomtbl={3051,3052,3054,3055,3056}
    local dg=Group.CreateGroup()
    --Linear congruential generators
    for v=0,4 do
		local seq=c3053[tp]
		local rnumber = (48828125*seq+1)%16384
		local h=math.floor(rnumber)%#randomtbl+1
		--Debug.Message(tostring(h))
		local rg=g:Filter(Card.IsCode,nil,randomtbl[h]):GetFirst()
		Duel.SSet(tp,rg)
		table.remove(randomtbl,h)
		c3053[tp]=rnumber
	end
end
function c3053.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_SZONE) and c:GetPreviousControler()==tp
end
function c3053.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3053.cfilter,1,nil,tp) and re and (re:GetOwner()~=e:GetHandler() and not re:GetOwner():IsCode(3064))
end
function c3053.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c3053.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_SZONE,0,nil)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
