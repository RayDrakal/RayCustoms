--キメラテック・フォートレス・ドラゴン
function c4379.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcCodeFunRep(c,70095154,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,63,true,true)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(aux.fuslimit)
	c:RegisterEffect(e2)
	--spsummon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c4379.sucop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c4379.tgop)
	c:RegisterEffect(e4)
	--battle indestructable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetCondition(c4379.indcon)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--damage val
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e6:SetCondition(c4379.indcon)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e7:SetCondition(c4379.indcon)
	e7:SetValue(1)
	c:RegisterEffect(e7)
	--Destroy
	local e8=Effect.CreateEffect(c)
	e8:SetCategory(CATEGORY_DESTROY)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e8:SetCode(EVENT_DAMAGE_STEP_END)
	e8:SetCondition(c4379.condition)
	e8:SetTarget(c4379.target)
	e8:SetOperation(c4379.operation)
	c:RegisterEffect(e8)
end
function c4379.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(c:GetMaterialCount()-1)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
end
function c4379.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c4379.indcon(e)
	return e:GetHandler()==Duel.GetAttacker()
end
function c4379.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()==e:GetHandler()
end
function c4379.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400)
end
function c4379.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
