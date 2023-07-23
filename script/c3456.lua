--地縛戒隷ジオクラーケン
function c3456.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x121f) or aux.TargetBoolFunction(Card.IsFusionSetCard,0x21),2,false)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3456,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c3456.condition)
	e1:SetTarget(c3456.target)
	e1:SetOperation(c3456.operation)
	c:RegisterEffect(e1)
end
function c3456.cfilter(c,tp)
	return c:IsControler(1-tp)
end
function c3456.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c3456.cfilter,1,nil,tp) and Duel.GetTurnPlayer()==tp
end
function c3456.dfilter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL--c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c3456.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c3456.dfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*800)
end
function c3456.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c3456.dfilter,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(g,REASON_EFFECT)
	if ct>0 then
		Duel.Damage(1-tp,ct*800,REASON_EFFECT)
	end
end
