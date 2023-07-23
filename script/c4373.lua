--E・HERO ゴッド・ネオス
function c4373.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_FUSION_MATERIAL)
	e0:SetCondition(c4373.fuscon)
	e0:SetOperation(c4373.fusop)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c4373.splimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c4373.sprcon)
	e2:SetOperation(c4373.sprop)
	c:RegisterEffect(e2)
	--copy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(4373,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c4373.copytg)
	e3:SetOperation(c4373.copyop)
	c:RegisterEffect(e3)
end
c4373.material_setcode=0x8
function c4373.neosfilter(c,fc)
	return c:IsFusionCode(89943723) and c:IsOnField() and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
end
function c4373.ffilter(c,cat,fc)
	return c:IsFusionSetCard(cat) and not c:IsHasEffect(6205579) and c:IsCanBeFusionMaterial(fc)
	and (c:IsOnField() or c:GetLocation()==0x10)
end
function c4373.fuscon(e,g,gc,chkf)
	if g==nil then return false end
	if gc then return false end
	local g1=g:Filter(c4373.neosfilter,nil,e:GetHandler())
	local c1=g1:GetCount()
	local g2=g:Filter(c4373.ffilter,nil,0x1f,e:GetHandler())
	local c2=g2:GetClassCount(Card.GetCode)
	local ag=g1:Clone()
	ag:Merge(g2)
	if chkf~=PLAYER_NONE then return false end
	return c1>0 and c2>5
end
function c4373.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	if gc then return end
	local g1=eg:Filter(c4373.neosfilter,nil,e:GetHandler())
	local g2=eg:Filter(c4373.ffilter,nil,0x1f,e:GetHandler())
	local ag=g1:Clone()
	ag:Merge(g2)
	local tc=nil
	local mg=Group.CreateGroup()
	--neos
	if chkf~=PLAYER_NONE then tc=g1:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf):GetFirst()
	else tc=g1:Select(tp,1,1,nil):GetFirst() end
	mg:AddCard(tc)
	--N
	for i=1,6 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		if i==1 and chkf~=PLAYER_NONE then
			tc=g2:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf):GetFirst()
		else tc=g2:Select(tp,1,1,nil):GetFirst() end
		g2:Remove(Card.IsCode,nil,tc:GetCode())
		mg:AddCard(tc)
	end
	Duel.SetFusionMaterial(mg)
end
function c4373.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c4373.filter(c)
	return c:IsSetCard(0x1f) and c:IsType(TYPE_MONSTER)
		and not c:IsForbidden() and c:IsAbleToRemove()
end
function c4373.spfilter(c)
	return c:IsFusionSetCard(0x1f) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c4373.spfilter2(c)
	return c:IsFusionCode(89943723) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c4373.sprcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	local hg=Duel.GetMatchingGroup(c4373.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c4373.spfilter2,tp,LOCATION_MZONE,0,1,nil)
		and hg:GetClassCount(Card.GetCode)>=6
end
function c4373.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.GetMatchingGroup(c4373.spfilter2,tp,LOCATION_MZONE,0,c)
	local hg=Duel.GetMatchingGroup(c4373.spfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,c)
	local rg=Group.CreateGroup()
	local gs=g:Select(tp,1,1,nil)
	rg:AddCard(gs:GetFirst())
	for i=1,6 do
		local g=hg:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		rg:AddCard(tc)
		hg:Remove(Card.IsCode,nil,tc:GetCode())
	end
	tc=rg:GetFirst()
	Duel.SendtoDeck(rg,nil,2,REASON_COST)
end
function c4373.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_DECK) and chkc:IsControler(tp) and c4373.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c4373.filter,tp,LOCATION_DECK,0,1,nil)
		and e:GetHandler():GetFlagEffect(4373)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c4373.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c4373.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=1 then	return end
		if code==4373 then
			c:RegisterFlagEffect(4373,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		end
		local code=tc:GetOriginalCode()
		local cid=c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(4373,1))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e2:SetLabel(cid)
		e2:SetOperation(c4373.rstop)
		c:RegisterEffect(e2)
	end
end
function c4373.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=e:GetLabel()
	c:ResetEffect(cid,RESET_COPY)
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
