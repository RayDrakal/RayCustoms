--TG ハルバード・キャノン
function c4091.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO),aux.NonTuner(Card.IsType,TYPE_SYNCHRO),2)
	c:EnableReviveLimit()
	--Negate summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(4091,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c4091.discon)
	e1:SetTarget(c4091.distg)
	e1:SetCost(c4091.mtcost)
	e1:SetOperation(c4091.disop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(4091,1))
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(4091,2))
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
	--Negate effect
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCost(c4091.mtcost)
	e4:SetCondition(c4091.discon2)
	e4:SetTarget(c4091.distg2)
	e4:SetOperation(c4091.disop2)
	c:RegisterEffect(e4)	
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c4091.descon)
	e5:SetTarget(c4091.destg)
	e5:SetOperation(c4091.desop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e7)
	--disable
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(3244,2))
	e8:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e8:SetCode(EVENT_CHAINING)
	e8:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCondition(c4091.mtdiscon)
	e8:SetTarget(c4091.mtdistg)
	e8:SetOperation(c4091.mtdisop)
	c:RegisterEffect(e8)
	--material check
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_MATERIAL_CHECK)
	e9:SetValue(c4091.valcheck)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	e10:SetCondition(c4091.valcon)
	e10:SetOperation(c4091.valop)
	c:RegisterEffect(e10)
	e9:SetLabelObject(e10)
end
function c4091.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c4091.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c4091.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.NegateSummon(eg)
	Duel.Destroy(eg,REASON_EFFECT)
end
function c4091.discon2(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsChainNegatable(ev) then return false end
	if not re:IsActiveType(TYPE_MONSTER) and not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)
end
function c4091.distg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c4091.disop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c4091.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=g:GetCount()
	e:GetLabelObject():SetLabel(ct)
end
function c4091.valcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO and e:GetLabel()>0
end
function c4091.valop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local i=0
	while i<ct do
	e:GetHandler():RegisterFlagEffect(40910,RESET_EVENT+0x1fc0000,0,1)
	i=i+1
	--Debug.Message(tostring(i))
	end
end
function c4091.mtcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetFlagEffect(40910)
	local ct2=c:GetFlagEffect(40911)
	if chk==0 then return ct2<ct end
	e:GetHandler():RegisterFlagEffect(40911,RESET_EVENT+0x1fc0000,0,1)
end
function c4091.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if ct<1 then return false end
end
function c4091.spfilter(c,e,tp)
	return c:IsCode(4090) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c4091.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c4091.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c4091.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c4091.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c4091.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c4091.mtfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsControler(tp)
end
function c4091.mtdiscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not Duel.IsChainNegatable(ev) then return end
	local ex1,tg1,tc1=Duel.GetOperationInfo(ev,0x1)
	local ex2,tg2,tc2=Duel.GetOperationInfo(ev,0x2)
	local ex3,tg3,tc3=Duel.GetOperationInfo(ev,0x4)
	local ex4,tg4,tc4=Duel.GetOperationInfo(ev,0x8)
	local ex5,tg5,tc5=Duel.GetOperationInfo(ev,0x10)
	local ex6,tg6,tc6=Duel.GetOperationInfo(ev,0x20)
	local ex7,tg7,tc7=Duel.GetOperationInfo(ev,0x2000)
	return (ex1 and tg1~=nil and tc1+tg1:FilterCount(c4091.mtfilter,nil,tp)-tg1:GetCount()>0)
	or (ex2 and tg2~=nil and tc2+tg2:FilterCount(c4091.mtfilter,nil,tp)-tg2:GetCount()>0)
	or (ex3 and tg3~=nil and tc3+tg3:FilterCount(c4091.mtfilter,nil,tp)-tg3:GetCount()>0)
	or (ex4 and tg4~=nil and tc4+tg4:FilterCount(c4091.mtfilter,nil,tp)-tg4:GetCount()>0)
	or (ex5 and tg5~=nil and tc5+tg5:FilterCount(c4091.mtfilter,nil,tp)-tg5:GetCount()>0)
	or (ex6 and tg6~=nil and tc6+tg6:FilterCount(c4091.mtfilter,nil,tp)-tg6:GetCount()>0)
	or (ex7 and tg7~=nil and tc7+tg7:FilterCount(c4091.mtfilter,nil,tp)-tg7:GetCount()>0)
end
function c4091.mtdistg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c4091.mtdisop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-800)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
