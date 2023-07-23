--ダークネス・ネオスフィア
function c3064.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c3064.spcon)
	e2:SetCost(c3064.spcost)
	e2:SetTarget(c3064.sptg)
	e2:SetOperation(c3064.spop)
	c:RegisterEffect(e2)
	--battle indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3064,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c3064.thtg)
	e4:SetOperation(c3064.thop)
	c:RegisterEffect(e4)
	--LP
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c3064.lcon)
	e5:SetOperation(c3064.lop)
	c:RegisterEffect(e5)
    --set
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(3064,1))
	e6:SetCategory(CATEGORY_TOHAND)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(c3064.settg)
	e6:SetOperation(c3064.setop)
	c:RegisterEffect(e6)
end
function c3064.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c3064.cfilter1(c)
	return c:IsFaceup() and c:IsRace(RACE_FIEND) and c:IsAbleToGraveAsCost()
end
function c3064.cfilter2(c)
	return c:IsRace(RACE_FIEND) and c:IsAbleToGraveAsCost()
end
function c3064.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3064.cfilter1,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c3064.cfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c3064.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c3064.cfilter2,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	g1:Merge(g2)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c3064.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c3064.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,true,false,POS_FACEUP)~=0 then
		e:GetHandler():CompleteProcedure()
	end
end
function c3064.filter(c)
	return c:IsAbleToHand() and c:IsType(TYPE_TRAP+TYPE_SPELL) and c:GetSequence()<5
end
function c3064.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3064.filter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c3064.filter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c3064.rfilter(c)
	return c:IsLocation(LOCATION_HAND)
end
function c3064.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c3064.filter,tp,LOCATION_SZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		if not tc:IsStatus(STATUS_SET_TURN) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e1:SetReset(RESET_EVENT+0x65C0000+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
		tc=g:GetNext()
	end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c3064.lcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	return Duel.GetLP(p)<4000
end
function c3064.lop(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetControler()
	Duel.SetLP(tp,4000,REASON_EFFECT)
end
function c3064.setfilter(c)
	return c:IsFaceup() and c:IsSSetable() and c:GetSequence()<5
end
function c3064.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c3064.setfilter,tp,0,LOCATION_SZONE,1,nil) end
end
function c3064.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c3064.setfilter,tp,0,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEDOWN)
	end	
end

