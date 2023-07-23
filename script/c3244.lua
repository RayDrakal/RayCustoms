--No.99 希望皇龍ホープドラグーン
function c3244.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,10,3,c3244.ovfilter,aux.Stringid(3244,0),3,c3244.xyzop)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3244,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c3244.sptg)
	e1:SetOperation(c3244.spop)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3244,2))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c3244.discon)
	e2:SetCost(c3244.discost)
	e2:SetTarget(c3244.distg)
	e2:SetOperation(c3244.disop)
	c:RegisterEffect(e2)
	--No
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c3244.indval)
	c:RegisterEffect(e3)
end
c3244.xyz_number=99
function c3244.cfilter(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c3244.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x107f)
end
function c3244.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3244.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c3244.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c3244.filter(c,e,tp)
	return c:IsSetCard(0x48) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3244.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c3244.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c3244.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c3244.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c3244.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
function c3244.discon(e,tp,eg,ep,ev,re,r,rp)
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
	return (ex1 and tg1~=nil and tc1+tg1:FilterCount(c3244.cfilter,nil,tp,c)-tg1:GetCount()>0)
	or (ex2 and tg2~=nil and tc2+tg2:FilterCount(c3244.cfilter,nil,tp,c)-tg2:GetCount()>0)
	or (ex3 and tg3~=nil and tc3+tg3:FilterCount(c3244.cfilter,nil,tp,c)-tg3:GetCount()>0)
	or (ex4 and tg4~=nil and tc4+tg4:FilterCount(c3244.cfilter,nil,tp,c)-tg4:GetCount()>0)
	or (ex5 and tg5~=nil and tc5+tg5:FilterCount(c3244.cfilter,nil,tp,c)-tg5:GetCount()>0)
	or (ex6 and tg6~=nil and tc6+tg6:FilterCount(c3244.cfilter,nil,tp,c)-tg6:GetCount()>0)
	or (ex7 and tg7~=nil and tc7+tg7:FilterCount(c3244.cfilter,nil,tp,c)-tg7:GetCount()>0)
end
function c3244.cfilter(c,tp,s)
	return c==s and s.IsOnField
end
function c3244.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c3244.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c3244.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	Duel.BreakEffect()
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
	local dg=Duel.GetOperatedGroup()
		local tc=dg:GetFirst()
		local atk=0
		while tc do
			local tatk=tc:GetTextAttack()
			if tatk>0 then atk=atk+tatk end
			tc=dg:GetNext()
		end
		Duel.Damage(1-tp,atk,REASON_EFFECT)
end
function c3244.indval(e,c)
	return not c:IsSetCard(0x48)
end
