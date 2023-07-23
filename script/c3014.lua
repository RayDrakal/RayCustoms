--光の創造神 ホルアクティ
function c3014.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c3014.spcon)
	e1:SetOperation(c3014.spop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--special summon-2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c3014.op)
	c:RegisterEffect(e4)
	--Yugioh
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PREDRAW)
		ge1:SetOperation(c3014.sdop)
		ge1:SetCountLimit(1,3014)
		ge1:SetCondition(c3014.sdcon)
		Duel.RegisterEffect(ge1,0)
end
function c3014.spfilter(c,code)
	local code1,code2=c:GetOriginalCodeRule()
	return code1==code or code2==code
end
function c3014.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and Duel.CheckReleaseGroup(tp,c3014.spfilter,1,nil,3016)
		and Duel.CheckReleaseGroup(tp,c3014.spfilter,1,nil,3017)
		and Duel.CheckReleaseGroup(tp,c3014.spfilter,1,nil,3018)
end
function c3014.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c3014.spfilter,1,1,nil,3016)
	local g2=Duel.SelectReleaseGroup(tp,c3014.spfilter,1,1,nil,3017)
	local g3=Duel.SelectReleaseGroup(tp,c3014.spfilter,1,1,nil,3018)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Release(g1,REASON_COST)
	local WIN_REASON_CREATORGOD = 0x13
	Duel.Win(tp,WIN_REASON_CREATORGOD)
end
function c3014.op(e,tp,eg,ep,ev,re,r,rp,c)
	local WIN_REASON_CREATORGOD = 0x13
	Duel.Win(tp,WIN_REASON_CREATORGOD)
end
function c3014.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler():GetOwner()
	if Duel.SelectYesNo(c,aux.Stringid(3014,0)) then
	local g=Duel.SelectMatchingCard(c,nil,c,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveSequence(tc,0)
	end
	end
end
function c3014.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetOwner()==Duel.GetTurnPlayer() and Duel.GetTurnCount()~=1
end
