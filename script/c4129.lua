--RR－バニシング・レイニアス
function c4129.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c4129.spcon)
	e1:SetOperation(c4129.spop)
	c:RegisterEffect(e1)
	--xyz summon
	if not c4129.global_check then
		c4129.global_check=true
		c4129[0]=0
		c4129[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetLabel(4129)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetOperation(aux.sumreg)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge2:SetLabel(4129)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(c4129.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
function c4129.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(4129)>0
end
function c4129.spop(e,tp,eg,ep,ev,re,r,rp)
	c4129[tp]=c4129[tp]+1
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,c:GetControler(),0xb7,0,nil)
	local tc=g:GetFirst()
	while tc do
		local tck=Duel.CreateToken(tp,4129)
		if tc:GetFlagEffect(4129)==0 then
			--special summon
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetDescription(aux.Stringid(4129,0))
			e1:SetCode(EFFECT_SPSUMMON_PROC)
			e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
			e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_HAND)
			e1:SetValue(SUMMON_TYPE_SPECIAL)
			e1:SetCondition(c4129.spcon2)
			e1:SetOperation(c4129.spop2)
			e1:SetReset(RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			end
		tc=g:GetNext()
	end
end
function c4129.clear(e,tp,eg,ep,ev,re,r,rp)
	c4129[0]=0
	c4129[1]=0
end
function c4129.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c4129[tp]>0 and c:IsCode(4129)
end
function c4129.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	c4129[tp]=c4129[tp]-1
end
