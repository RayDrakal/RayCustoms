--ＮＯ１３ エーテリック・アメン
function c3335.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c3335.splimit)
	c:RegisterEffect(e1)
	--sp
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3335,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c3335.target)
	e2:SetOperation(c3335.operation)
	c:RegisterEffect(e2)
	--sp2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c3335.atkcon)
	e3:SetOperation(c3335.atkop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c3335.atkval)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
end
--target check is in RUM magic cards
function c3335.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x95) and se:GetHandler():IsType(TYPE_SPELL)
end
function c3335.filter(c)
	return c:IsFaceup()
end
function c3335.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	if Duel.IsExistingTarget(c3335.filter,tp,0,LOCATION_MZONE,1,nil) then
		local g1=Duel.SelectTarget(tp,c3335.filter,tp,0,LOCATION_MZONE,1,1,nil)
	end
end
function c3335.hfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsFaceup()
end
function c3335.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	local lr=0
	local clr=c:GetRank()
	if tc then
		if tc:IsType(TYPE_XYZ) then lr=tc:GetRank() else lr=0 end
	lr=math.abs(lr-clr)
	Duel.DisableShuffleCheck()
	local g=Duel.GetDecktopGroup(1-tp,lr)
	local gtc=g:GetFirst()
	while gtc do
	Duel.Overlay(c,Group.FromCards(gtc))
	gtc=g:GetNext()
	end
	end
end
function c3335.atkfilter(c,e,tp)
	return c:IsControler(tp)
end
function c3335.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3335.atkfilter,1,nil,nil,1-tp) and eg:GetCount()==1
end
function c3335.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c3335.atkfilter,nil,e,1-tp)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local lr=0
	local clr=c:GetRank()
	if tc then
		if tc:IsType(TYPE_XYZ) then lr=tc:GetRank() else lr=0 end
	lr=math.abs(lr-clr)
	Duel.DisableShuffleCheck()
	local g=Duel.GetDecktopGroup(1-tp,lr)
	local gtc=g:GetFirst()
	while gtc do
	Duel.Overlay(c,Group.FromCards(gtc))
	gtc=g:GetNext()
	end
	end
end
function c3335.atkval(e,c)
	return c:GetOverlayCount()*100
end
