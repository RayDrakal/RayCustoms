--カオスエンド・ルーラー 開闢と終焉の支配者
function c3387.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3387,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c3387.spcon)
	e2:SetOperation(c3387.spop)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3387,1))
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c3387.sgcost)
	e3:SetTarget(c3387.sgtg)
	e3:SetOperation(c3387.sgop)
	c:RegisterEffect(e3)
end
function c3387.spfilter(c,att,race)
	return c:IsAttribute(att) and c:IsRace(race) and c:IsAbleToRemoveAsCost()
end
function c3387.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3387.spfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_LIGHT,RACE_WARRIOR)
		and Duel.IsExistingMatchingCard(c3387.spfilter,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_DARK,RACE_FIEND)
end
function c3387.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c3387.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_LIGHT,RACE_WARRIOR)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c3387.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_DARK,RACE_FIEND)
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c3387.sgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c3387.damfilter(c,p)
	return c:GetOwner()==p and c:IsAbleToRemove()
end
function c3387.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,0,0x1e)
	local dc=g:FilterCount(c3387.damfilter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,dc*500)
end
function c3387.sgfilter(c,p)
	return c:IsLocation(LOCATION_REMOVED) and c:IsControler(p)
end
function c3387.sgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,0x1e)
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(c3387.sgfilter,nil,1-tp)
	if ct>0 then
		Duel.Damage(1-tp,ct*500,REASON_EFFECT)
	end
end
