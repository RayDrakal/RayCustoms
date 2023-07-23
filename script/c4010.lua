--ヌメロン・ネットワーク
function c4010.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)
    ----unaffectable
    --local e2=Effect.CreateEffect(c)
    --e2:SetType(EFFECT_TYPE_SINGLE)
    --e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    --e2:SetRange(LOCATION_SZONE)
    --e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    --e2:SetValue(c4010.efilter)
    --e2:SetCondition(c4010.ufcon)
    --c:RegisterEffect(e2)
    --numeron
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_FREE_CHAIN)
    e3:SetRange(LOCATION_FZONE)
    e3:SetCountLimit(1)
    e3:SetDescription(aux.Stringid(4010,0))
    e3:SetHintTiming(0x3c0)
    e3:SetTarget(c4010.target)
    e3:SetCost(c4010.cost)
    e3:SetCondition(c4010.condition)
    e3:SetOperation(c4010.nmop)
    c:RegisterEffect(e3)
    local e4=Effect.CreateEffect(c)
    e4:SetDescription(aux.Stringid(4010,1))
    e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetRange(LOCATION_SZONE)
    e4:SetCode(EVENT_CHAINING)
    e4:SetCondition(c4010.condition2)
    e4:SetCountLimit(1)
    e4:SetCost(c4010.cost)
    e4:SetTarget(c4010.target2)
    e4:SetOperation(c4010.nmop)
    c:RegisterEffect(e4)
    --Auto activate 
    local e5=Effect.CreateEffect(c) 
    e5:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
    e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e5:SetCode(EVENT_PHASE_START+PHASE_DRAW)
    e5:SetCountLimit(1)
    e5:SetRange(LOCATION_HAND)
    e5:SetCondition(c4010.autocondition)
    e5:SetOperation(c4010.op)
    c:RegisterEffect(e5)
end
function c4010.op(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
    if fc then
        Duel.SendtoGrave(fc,REASON_RULE)
        Duel.BreakEffect()
    end
    Duel.MoveToField(c,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
    local te=c:GetActivateEffect()
    local tep=c:GetControler()
    local cost=te:GetCost()
    if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
    Duel.RaiseEvent(c,EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
end
function c4010.sfilter(c)
    local code=c:GetCode()
    return ((code==41418852) or (code==100278032) or (code==77402960)or (code==41850466) or (code==4014)) and c:CheckActivateEffect(false,false,false)~=nil
end
function c4010.sfilter2(c,e,tp,eg,ep,ev,re,r,rp)
    local code=c:GetCode()
    if  ((code==41418852) or (code==100278032) or (code==77402960) or (code==41850466) or (code==4014)) and c:IsAbleToGraveAsCost() then
        if c:CheckActivateEffect(false,true,false)~=nil then return true end
        local te=c:GetActivateEffect()
        if te:GetCode()~=EVENT_CHAINING then return false end
        local con=te:GetCondition()
        if con and not con(e,tp,eg,ep,ev,re,r,rp) then return false end
        local tg=te:GetTarget()
        if tg and not tg(e,tp,eg,ep,ev,re,r,rp,0) then return false end
        return true
    else return false end
end
function c4010.cfilter(c)
    return c:GetSequence()<5
end
function c4010.condition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.CheckEvent(EVENT_CHAINING) and not Duel.IsExistingMatchingCard(c4010.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
    and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c4010.condition2(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.IsExistingMatchingCard(c4010.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
    and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c4010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    e:SetLabel(1)
    if chk==0 then return e:GetHandler():GetFlagEffect(4010)==0 end
    e:GetHandler():RegisterFlagEffect(4010,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c4010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chk==0 then
        if e:GetLabel()==0 then return false end
        e:SetLabel(0)
        return  Duel.IsExistingMatchingCard(c4010.sfilter,tp,LOCATION_DECK,0,1,nil)
    end
    e:SetLabel(0)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c4010.sfilter,tp,LOCATION_DECK,0,1,1,nil)
    local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
    Duel.SendtoGrave(g,REASON_COST)
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    local tg=te:GetTarget()
    if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c4010.nmop(e,tp,eg,ep,ev,re,r,rp)
    local te=e:GetLabelObject()
    if not te then return end
    e:SetLabelObject(te:GetLabelObject())
    local op=te:GetOperation()
    if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c4010.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if e:GetLabel()==0 then return false end
        e:SetLabel(0)
            return Duel.IsExistingMatchingCard(c4010.sfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g=Duel.SelectMatchingCard(tp,c4010.sfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
    local tc=g:GetFirst()
    local te,ceg,cep,cev,cre,cr,crp
    local fchain=c4010.sfilter(tc)
    if fchain then
        te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
    else
        te=tc:GetActivateEffect()
    end
    Duel.SendtoGrave(g,REASON_COST)
    e:SetCategory(te:GetCategory())
    e:SetProperty(te:GetProperty())
    local tg=te:GetTarget()
    if tg then
        if fchain then
            tg(e,tp,ceg,cep,cev,cre,cr,crp,1)
        else
            tg(e,tp,eg,ep,ev,re,r,rp,1)
        end
    end
    te:SetLabelObject(e:GetLabelObject())
    e:SetLabelObject(te)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,0)
end
function c4010.efilter(e,te)
    return te:GetOwner()~=e:GetOwner()
end
function c4010.autocondition(e,tp,eg,ep,ev,re,r,rp)
    return not Duel.CheckEvent(EVENT_CHAINING) and not Duel.IsExistingMatchingCard(c4010.cfilter,tp,LOCATION_SZONE,0,1,e:GetHandler())
    and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler()) and ep~=tp
end
function c4010.ufcon(e,c)
    return not Duel.IsExistingMatchingCard(c4010.uffilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) 
end
function c4010.uffilter(c)
    return c:IsFaceup() and (c:IsCode(200000009) or c:IsCode(200000000))
end