--ラーの翼神竜
function c3016.initial_effect(c)
	--summon with 3 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c3016.ttcon)
	e1:SetDescription(aux.Stringid(3016,3))
	e1:SetOperation(c3016.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	e2:SetCondition(c3016.setcon)
	c:RegisterEffect(e2)
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e3)
	--summon success
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetOperation(c3016.sumsuc)
	c:RegisterEffect(e4)
	--unaffectable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(c3016.efilter)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e6)
	--One Turn Kill
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(3016,1))
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_QUICK_O)
	e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EVENT_FREE_CHAIN)
	e7:SetCost(c3016.atkcost)
	e7:SetOperation(c3016.atkop)
	c:RegisterEffect(e7)
	--God Fenix
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(3016,0))
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetType(EFFECT_TYPE_IGNITION)
	e8:SetRange(LOCATION_MZONE)
	e8:SetCost(c3016.descost)
	e8:SetTarget(c3016.destg)
	e8:SetOperation(c3016.desop)
	c:RegisterEffect(e8)	
    --tribute check
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_MATERIAL_CHECK)
	e9:SetValue(c3016.valcheck)
	c:RegisterEffect(e9)
	--tribute check def
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_MATERIAL_CHECK)
	e10:SetValue(c3016.valcheck)
	c:RegisterEffect(e10)
	--give atk effect only when  summon
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetCode(EFFECT_SUMMON_COST)
	e11:SetOperation(c3016.facechk)
	e11:SetLabelObject(e9,e10)--(e9)
	c:RegisterEffect(e11)
	--atkup
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(3016,2))
	e12:SetCategory(CATEGORY_ATKCHANGE)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetRange(LOCATION_MZONE)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetCost(c3016.atkcost2)
	e12:SetOperation(c3016.atkop2)
	c:RegisterEffect(e12)
	--to grave flg
	local e13=Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	e13:SetProperty(EFFECT_FLAG_DELAY)
	e13:SetCondition(c3016.fcon)
	e13:SetOperation(c3016.fop)
	c:RegisterEffect(e13)
	--add code
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_SINGLE)
	e14:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e14:SetCode(EFFECT_ADD_CODE)
	e14:SetValue(10000010)
	c:RegisterEffect(e14)
end
function c3016.valcheck(e,c)
	local g=c:GetMaterial()
	local tc=g:GetFirst()
	local atk=0
	local def=0
	while tc do
		local catk=tc:GetTextAttack()
		atk=atk+(catk>=0 and catk or 0)
		local catd=tc:GetTextDefense()
		def=def+(catd>=0 and catd or 0)
		tc=g:GetNext()
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		--atk continuous effect
		local e10=Effect.CreateEffect(c)
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetCode(EFFECT_SET_ATTACK)
		e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e10:SetRange(LOCATION_MZONE)
		e10:SetValue(atk)
		e10:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e10)
		--def continuous effect
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_SET_DEFENSE)
		e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e11:SetRange(LOCATION_MZONE)
		e11:SetValue(def)
		e11:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e11)
	end
end

function c3016.facechk(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(1)
end

function c3016.ttcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-3 and Duel.GetTributeCount(c)>=3
end
function c3016.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
	Duel.Hint(HINT_SELECTMSG,1-tp,e:GetDescription())
end
function c3016.setcon(e,c)
	if not c then return true end
	return false
end
function c3016.genchainlm(c)
	return	function (e,rp,tp)
	return e:GetHandler()==c end
end
function c3016.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(c3016.genchainlm(e:GetHandler()))
end
function c3016.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(tp)>100 end
	local lp=Duel.GetLP(tp)
	e:SetLabel(lp-100)
	Duel.PayLPCost(tp,lp-100)
end
function c3016.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e2)
	end
end
function c3016.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c3016.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c3016.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.Destroy(g,REASON_RULE)
end
function c3016.atkcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,nil,1,1,e:GetHandler())
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Release(g,REASON_COST)
end
function c3016.atkop2(e,tp,eg,ep,ev,re,r,rp)
	    local c=e:GetHandler()
	    if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
		local e12=Effect.CreateEffect(c)
		e12:SetType(EFFECT_TYPE_SINGLE)
		e12:SetCode(EFFECT_UPDATE_ATTACK)
		e12:SetValue(e:GetLabel())
		e12:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e12)
end

function c3016.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c3016.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c3016.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SendtoGrave(c,REASON_EFFECT)
	end
end
function c3016.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c3016.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c3016.fcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsType(TYPE_SPELL)
end
function c3016.fop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(3016,3))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCondition(c3017.tgcon)
	e1:SetTarget(c3017.tgtg)
	e1:SetOperation(c3017.tgop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
