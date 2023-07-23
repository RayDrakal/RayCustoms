--ＣＮｏ.１０００ 夢幻虚神ヌメロニアス
function c4027.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,5)
	c:EnableReviveLimit()
	--can not attack CNo or CX
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetTarget(c4027.dt)
	c:RegisterEffect(e1)
	--disable CNo or CX
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--No
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetValue(c4027.indval)
	c:RegisterEffect(e3)
	--bp
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c4027.tg)
	e4:SetOperation(c4027.op)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetDescription(aux.Stringid(4027,0))
	e5:SetTarget(c4027.drtg)
	e5:SetOperation(c4027.drop)
	c:RegisterEffect(e5)
	--destroy and Sp
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCountLimit(1)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCost(c4027.xcost)
	e6:SetTarget(c4027.xtarget)
	e6:SetOperation(c4027.xoperation)
	c:RegisterEffect(e6)
end
function c4027.indval(e,c)
	return not c:IsSetCard(0x48)
end
function c4027.dt(e,c)
	return c:IsSetCard(0x1048) or c:IsSetCard(0x1073)
end
function c4027.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c4027.opfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_TOKEN)
end
function c4027.op(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local ct=Duel.Destroy(sg,REASON_EFFECT)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
		if ct>0 then
			local og=Duel.GetOperatedGroup()
			sg=og:FilterSelect(tp,c4027.opfilter,ft,ft,nil,e,tp)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
end
function c4027.drop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
end
function c4027.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(c4027.repfilter,tp,LOCATION_MZONE,0,1,c) end
	if Duel.SelectYesNo(tp,aux.Stringid(4027,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c4027.repfilter,tp,LOCATION_MZONE,0,1,1,c)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function c4027.repfilter(c)
	return c:IsFaceup() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c4027.xcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c4027.xtarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c4027.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c4027.xoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
		local p=tc:GetControler()
	if tc:IsRelateToEffect(e) then
	    if Duel.Destroy(tc,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			if p~=tp then
				local fg=Duel.GetFieldGroup(p,0,LOCATION_EXTRA)
				Duel.ConfirmCards(tp,fg)
			end
			local g=Duel.SelectMatchingCard(tp,c4027.spfilter,p,LOCATION_EXTRA,0,1,1,nil,e,tp)
				if g:GetCount()>0 then
					Duel.SpecialSummonStep(g:GetFirst(),0,tp,p,true,false,POS_FACEUP)
				end
		end
		Duel.SpecialSummonComplete()
	end
end
function c4027.spfilter(c,e,tp)
	return c:IsSetCard(0x1048) or c:IsSetCard(0x1073) or c:IsCode(15862758) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
