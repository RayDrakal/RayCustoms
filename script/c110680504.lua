--FNo.107 프라이멀 갤럭시아이즈 타키온 드래곤
local s,id=GetID()
function s.initial_effect(c)
	--Xyz Summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON),10,4,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	--Unnafected by other cards' effects
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	
end
s.xyz_number=107
s.listed_series={SET_GALAXY_EYES_TACHYON_DRAGON}
function s.ovfilter(c,tp,xyzc)
	return c:IsSetCard(SET_GALAXY_EYES_TACHYON_DRAGON,xyzc,SUMMON_TYPE_XYZ,tp) and c:IsType(TYPE_XYZ,xyzc,SUMMON_TYPE_XYZ,tp) and not c:IsSummonCode(xyzc,SUMMON_TYPE_XYZ,tp,id) and c:IsFaceup()
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
