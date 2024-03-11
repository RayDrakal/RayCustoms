--DEUS EX MACHINA the ARGOS
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	-- 5 Level 13 monsters, or 1 Rank 12 monster with 10+ Xyz materials
	Xyz.AddProcedure(c,nil,13,5,s.ovfilter,aux.Stringid(id,0))
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.val)
	c:RegisterEffect(e2)
    local e3=e2:Clone()
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    c:RegisterEffect(e3)
	--Multiple attacks
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_EXTRA_ATTACK)
	e4:SetValue(s.matkval)
	c:RegisterEffect(e4)
	-- Attach 1 banished card
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DESTROY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(s.ovcost)
	e5:SetOperation(s.ovop)
	c:RegisterEffect(e5)
end
function s.ovfilter(c,tp,lc)
	return c:IsFaceup() and c:IsRank(12) and c:GetOverlayCount()>=10
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.val(e,c)
	return c:GetOverlayCount()*500
end
function s.matkval(e,c)
	local oc=e:GetHandler():GetOverlayCount()
	return math.max(0,oc-1)
end
function s.ovcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 and c:IsType(TYPE_XYZ) end
	c:RegisterFlagEffect(id,RESET_CHAIN,0,1)
end
function s.ovfilter(c,xc,tp,e)
	return c:IsCanBeXyzMaterial(xc,tp,REASON_EFFECT) and not c:IsImmuneToEffect(e)
end
function s.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,s.ovfilter,tp,LOCATION_GRAVE|LOCATION_REMOVED,LOCATION_GRAVE|LOCATION_REMOVED,1,1,nil,c,tp,e)
	if #g>0 then
		Duel.HintSelection(g,true)
		Duel.Overlay(c,g)
	end
end
