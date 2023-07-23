--地縛戒隷ジオグラシャ＝ラボラス
function c3459.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c3459.mfilter1,c3459.mfilter2,true)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c3459.adcon)
	e1:SetOperation(c3459.adop)
	c:RegisterEffect(e1)
end
function c3459.mfilter1(c)
	return (c:IsFusionSetCard(0x21) or c:IsFusionSetCard(0x121f)) and c:IsFusionType(TYPE_FUSION)
end
function c3459.mfilter2(c)
	return (c:IsFusionSetCard(0x21) or c:IsFusionSetCard(0x121f)) and c:IsFusionType(TYPE_SYNCHRO)
end
function c3459.adcon(e,tp,eg,ep,ev,re,r,rp)
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup() and (bc:IsType(TYPE_FUSION) or bc:IsType(TYPE_SYNCHRO))
	and not ((f1==nil or not f1:IsFaceup()) and (f2==nil or not f2:IsFaceup()))
end
function c3459.adop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
	end
end
