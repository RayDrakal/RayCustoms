--ＲＲ－ロック・チェーン
function c4126.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_SPSUMMON)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c4126.target1)
	e1:SetOperation(c4126.operation)
	c:RegisterEffect(e1)
	--pos
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c4126.target2)
	e2:SetOperation(c4126.operation)
	e2:SetLabel(1)
	c:RegisterEffect(e2)
end
function c4126.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	if res then
		local g=teg:Filter(c4126.filter1,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,94) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
			local tc=g:Select(tp,1,1,nil)
			Duel.SetTargetCard(tc)
			Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
			e:SetLabel(1)
			e:GetHandler():RegisterFlagEffect(4126,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
			e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(4126,1))
		end
	end
end
function c4126.rrfilter(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xba)
end
function c4126.filter1(c,e,tp)
	local tc=Duel.GetMatchingGroup(c4126.rrfilter,tp,LOCATION_MZONE,0,nil)
	return c:IsPosition(POS_FACEUP) and c:GetAttack()>tc:GetSum(Card.GetAttack)
	and c:IsControler(1-tp) and c:IsCanBeEffectTarget(e)
end
function c4126.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c4126.filter1,1,nil,e,tp)
	and e:GetHandler():GetFlagEffect(4126)==0  end
	local g=eg:Filter(c4126.filter1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=g:Select(tp,1,1,nil)
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
end
function c4126.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end
