--갤럭시아이즈 타키온 마스터
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.selfspcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET,EFFECT_FLAG2_CHECK_SIMULTANEOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_HAND|LOCATION_GRAVE)
	e2:SetCountLimit(1,{id,2})
	e2:SetTarget(s.attachtg)
	e2:SetOperation(s.attachop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetCondition(s.xyzcon)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.atkval)
	c:RegisterEffect(e3)
end
function s.selfspconfilter(c)
	return c:IsLevel(8) and c:IsRace(RACE_DRAGON) and c:IsFaceup()
end
function s.selfspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.selfspconfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSetCard(SET_GALAXY_EYES_TACHYON_DRAGON)
end
function s.attachfilter(c,e,tp)
	return c:IsSummonPlayer(tp) and c:IsRace(RACE_DRAGON) and c:IsType(TYPE_XYZ) and c:IsFaceup()
		and c:IsCanBeEffectTarget(e) and c:IsLocation(LOCATION_MZONE)
end
function s.attachtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.attachfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(s.attachfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,s.attachfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	local c=e:GetHandler()
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,c,1,tp,0)
	end
end
function s.attachfilter2(c,tp)
	return c:IsRace(RACE_DRAGON) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function s.xyzfilter(c,mc,tp)
	return c:IsType(TYPE_XYZ) and c:IsRace(RACE_DRAGON) and c:IsFaceup() and mc:IsCanBeXyzMaterial(c,tp,REASON_EFFECT)
end
function s.attachop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) 
    and not tc:IsImmuneToEffect(e) then
        Duel.Overlay(tc,c)
        if Duel.IsExistingMatchingCard(s.attachfilter2,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACH)
            local mc=Duel.SelectMatchingCard(tp,s.attachfilter2,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
            local xyzc=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil,mc,tp):GetFirst()
            if not xyzc:IsImmuneToEffect(e) then
                Duel.BreakEffect()
                Duel.Overlay(xyzc,mc)
            end
        end
    end 
end
function s.atkval(e,c)
	local g=c:GetOverlayGroup()
	local sum=g:GetSum(Card.GetLevel)+g:GetSum(Card.GetRank)
	return sum*100
end
