--서번트 아르기아스 쉐리
local s,id=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetHintTiming(TIMING_END_PHASE,TIMING_MAIN_END+TIMINGS_CHECK_MONSTER_E)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--Can be treated as Level 5
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SYNCHRO_LEVEL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetValue(s.chnslv)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_XYZ_LEVEL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetValue(s.chnxlv)
	c:RegisterEffect(e3)
end
s.listed_names={CARD_SUPERIOR_ARGOS}
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	return #g==0 or (#g>0 and (g:FilterCount(aux.FaceupFilter(Card.IsSetCard,SET_ARGEARS),nil)==#g or g:FilterCount(aux.FaceupFilter(Card.IsCode,CARD_SUPERIOR_ARGOS),nil)==#g))
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(1200)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
        c:RegisterEffect(e1)
	end
end
function s.chnslv(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsRace(RACE_CREATORGOD) then
		return 5*65536+lv
	else
		return lv
	end
end
function s.chnxlv(e,c,rc)
	if rc:IsRace(RACE_CREATORGOD) then
		return 5,e:GetHandler():GetLevel()
	else
		return e:GetHandler():GetLevel()
	end
end
