---------------------------------------------
-- Generated from Mirana Compiler version 1.0.0
-- Do not modify
-- https://github.com/AaronSong321/Mirana
---------------------------------------------
local utility = require(GetScriptDirectory().."/utility")
require(GetScriptDirectory().."/ability_item_usage_generic")
local fun1 = require(GetScriptDirectory().."/util/AbilityAbstraction")
local debugmode = false
local npcBot = GetBot()
local Talents = {}
local Abilities = {}
local AbilitiesReal = {}
ability_item_usage_generic.InitAbility(Abilities, AbilitiesReal, Talents)
local AbilityToLevelUp = {
    Abilities[2],
    Abilities[1],
    Abilities[2],
    Abilities[3],
    Abilities[2],
    Abilities[6],
    Abilities[2],
    Abilities[3],
    Abilities[3],
    "talent",
    Abilities[3],
    Abilities[6],
    Abilities[1],
    Abilities[1],
    "talent",
    Abilities[1],
    "nil",
    Abilities[6],
    "nil",
    "talent",
    "nil",
    "nil",
    "nil",
    "nil",
    "talent",
}
local TalentTree = {
    function()
        return Talents[2]
    end,
    function()
        return Talents[3]
    end,
    function()
        return Talents[6]
    end,
    function()
        return Talents[7]
    end,
}
utility.CheckAbilityBuild(AbilityToLevelUp)
function AbilityLevelUpThink()
    ability_item_usage_generic.AbilityLevelUpThink2(AbilityToLevelUp, TalentTree)
end
local cast = {}
cast.Desire = {}
cast.Target = {}
cast.Type = {}
local Consider = {}
local CanCast = {
    function(t)
        return fun1:StunCanCast(t, AbilitiesReal[1], false, false, true, false)
    end,
    fun1.PhysicalCanCastFunction,
    utility.NCanCast,
    utility.NCanCast,
    utility.NCanCast,
    function(t)
        return fun1:StunCanCast(t, AbilitiesReal[6], false, false, true, true)
    end,
}
local enemyDisabled = utility.enemyDisabled
function GetComboDamage()
    return ability_item_usage_generic.GetComboDamage(AbilitiesReal)
end
function GetComboMana()
    return ability_item_usage_generic.GetComboMana(AbilitiesReal)
end
local xMarkTarget
local xMarkTime
local xMarkLocation
local xMarkDuration
local useTorrentAtXMark
local useTorrentAtXMarkTime
local xMarkTargetWasTeleporting
local function XMarksEnemy()
    return xMarkTarget ~= nil and xMarkTarget:GetTeam() ~= npcBot:GetTeam()
end
Consider[1] = function()
    local abilityNumber = 1
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetAOERadius()
    local CastPoint = 2
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange, true)
    local WeakestCreep,CreepHealth = utility.GetWeakestUnit(creeps)
    for _, npcEnemy in pairs(enemys) do
        if npcEnemy:IsChanneling() then
            return BOT_ACTION_DESIRE_HIGH - 0.1, npcEnemy:GetLocation()
        end
    end
    if XMarksEnemy() and CanCast[1](xMarkTarget) and DotaTime() - xMarkTime <= 0.8 then
        return BOT_ACTION_DESIRE_VERYHIGH, xMarkLocation
    end
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) and WeakestEnemy:HasModifier("modifier_kunkka_x_marks_the_spot") then
                if WeakestEnemy:GetModifierRemainingDuration(WeakestEnemy:GetModifierByName('modifier_kunkka_x_marks_the_spot')) < 1.6 then
                    return BOT_ACTION_DESIRE_HIGH + 0.15, WeakestEnemy:GetExtrapolatedLocation(-2.5)
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot:GetActiveModeDesire() >= BOT_MODE_DESIRE_HIGH then
        for _, npcEnemy in pairs(enemys) do
            if npcBot:WasRecentlyDamagedByHero(npcEnemy, 2.0) then
                if CanCast[abilityNumber](npcEnemy) then
                    return BOT_ACTION_DESIRE_MODERATE, npcEnemy:GetExtrapolatedLocation(CastPoint + 0.5)
                end
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_FARM then
        if (ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana) then
            local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0)
            if locationAoE.count >= 3 then
                return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_PUSH_TOWER_BOT or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_TOP or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_MID or npcBot:GetActiveMode() == BOT_MODE_DEFEND_TOWER_BOT then
        if (ManaPercentage > 0.4 or npcBot:GetMana() > ComboMana) then
            local locationAoE = npcBot:FindAoELocation(true, false, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0)
            if locationAoE.count >= 4 then
                return BOT_ACTION_DESIRE_LOW, locationAoE.targetloc
            end
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local locationAoE = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), CastRange, Radius, CastPoint, 0)
        if locationAoE.count >= 2 then
            return BOT_ACTION_DESIRE_MODERATE, locationAoE.targetloc
        end
        local npcTarget = npcBot:GetTarget()
        if npcTarget ~= nil then
            if CanCast[abilityNumber](npcTarget) and npcTarget:HasModifier("modifier_kunkka_x_marks_the_spot") then
                if npcTarget:GetModifierRemainingDuration(npcTarget:GetModifierByName('modifier_kunkka_x_marks_the_spot')) < 1.6 then
                    return BOT_ACTION_DESIRE_HIGH + 0.15, npcTarget:GetExtrapolatedLocation(-2.5)
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
Consider[3] = function()
    local ability = AbilitiesReal[3]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = ability:GetCastRange()
    local Damage = ability:GetAbilityDamage()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    for _, enemy in pairs(enemys) do
        if enemy:IsChanneling() and CanCast[3](enemy) and not enemy:IsSilenced() then
            return BOT_ACTION_DESIRE_HIGH, enemy
        end
    end
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[3](WeakestEnemy) and ManaPercentage > 0.5 then
                if (HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) or npcBot:GetMana() > ComboMana) then
                    return BOT_ACTION_DESIRE_HIGH, WeakestEnemy
                end
            end
        end
    end
    local npcTarget = npcBot:GetTarget()
    if npcTarget ~= nil then
        if CanCast[3](npcTarget) then
            if GetComboDamage() * (0.85 + 0.15 * #allys) > npcTarget:GetHealth() and GetUnitToUnitDistance(npcTarget, npcBot) < (CastRange + 200) then
                return BOT_ACTION_DESIRE_HIGH, npcTarget
            end
        end
    end
    local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK)
    if #tableNearbyAttackingAlliedHeroes >= 2 then
        local npcMostDangerousEnemy = nil
        local nMostDangerousDamage = 0
        local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE)
        for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
            if CanCast[3](npcEnemy) and not npcEnemy:IsSilenced() then
                local Damage = npcEnemy:GetEstimatedDamageToTarget(false, npcBot, 3.0, DAMAGE_TYPE_ALL)
                if Damage > nMostDangerousDamage then
                    nMostDangerousDamage = Damage
                    npcMostDangerousEnemy = npcEnemy
                end
            end
        end
        if npcMostDangerousEnemy ~= nil then
            return BOT_ACTION_DESIRE_HIGH, npcMostDangerousEnemy
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcTarget = npcBot:GetTarget()
        if npcTarget ~= nil then
            if CanCast[3](npcTarget) and not npcTarget:IsSilenced() and GetUnitToUnitDistance(npcBot, npcTarget) < CastRange then
                return BOT_ACTION_DESIRE_HIGH, npcTarget
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
Consider[6] = function()
    local abilityNumber = 6
    local ability = AbilitiesReal[abilityNumber]
    if not ability:IsFullyCastable() then
        return BOT_ACTION_DESIRE_NONE, 0
    end
    local CastRange = 1600
    local Damage = ability:GetAbilityDamage()
    local Radius = ability:GetAOERadius() - 300
    local CastPoint = ability:GetCastPoint()
    local allys = npcBot:GetNearbyHeroes(1200, false, BOT_MODE_NONE)
    local enemys = npcBot:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE)
    local WeakestEnemy,HeroHealth = utility.GetWeakestUnit(enemys)
    local creeps = npcBot:GetNearbyCreeps(CastRange, true)
    local WeakestCreep,CreepHealth = utility.GetWeakestUnit(creeps)
    if npcBot:GetActiveMode() ~= BOT_MODE_RETREAT then
        if WeakestEnemy ~= nil then
            if CanCast[abilityNumber](WeakestEnemy) then
                if HeroHealth <= WeakestEnemy:GetActualIncomingDamage(GetComboDamage(), DAMAGE_TYPE_MAGICAL) and npcBot:GetMana() > ComboMana then
                    if not AbilitiesReal[1]:IsFullyCastable() or WeakestEnemy:GetModifierRemainingDuration(WeakestEnemy:GetModifierByName('modifier_kunkka_x_marks_the_spot')) < 1.2 then
                        return BOT_ACTION_DESIRE_HIGH, WeakestEnemy:GetExtrapolatedLocation(-2.9)
                    end
                end
            end
        end
    end
    local tableNearbyAttackingAlliedHeroes = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_ATTACK)
    if #tableNearbyAttackingAlliedHeroes >= 2 then
        local npcMostDangerousEnemy = nil
        local nMostDangerousDamage = 0
        local tableNearbyEnemyHeroes = npcBot:GetNearbyHeroes(CastRange, true, BOT_MODE_NONE)
        for _, npcEnemy in pairs(tableNearbyEnemyHeroes) do
            if CanCast[abilityNumber](npcEnemy) and not enemyDisabled(npcEnemy) then
                local Damage2 = npcEnemy:GetEstimatedDamageToTarget(false, npcBot, 3.0, DAMAGE_TYPE_ALL)
                if Damage2 > nMostDangerousDamage then
                    nMostDangerousDamage = Damage2
                    npcMostDangerousEnemy = npcEnemy
                end
            end
        end
        if npcMostDangerousEnemy ~= nil then
            return BOT_ACTION_DESIRE_LOW, npcMostDangerousEnemy:GetLocation()
        end
    end
    if npcBot:GetActiveMode() == BOT_MODE_ROAM or npcBot:GetActiveMode() == BOT_MODE_TEAM_ROAM or npcBot:GetActiveMode() == BOT_MODE_DEFEND_ALLY or npcBot:GetActiveMode() == BOT_MODE_ATTACK then
        local npcEnemy = fun1:GetTargetIfGood(npcBot)
        if npcEnemy ~= nil then
            if CanCast[abilityNumber](npcEnemy) then
                if not AbilitiesReal[1]:IsFullyCastable() or npcEnemy:GetModifierRemainingDuration(npcEnemy:GetModifierByName('modifier_kunkka_x_marks_the_spot')) < 1.2 then
                    return BOT_ACTION_DESIRE_HIGH, npcEnemy:GetExtrapolatedLocation(-2.9)
                end
            end
        end
    end
    return BOT_ACTION_DESIRE_NONE, 0
end
Consider[4] = function()
    local ability = AbilitiesReal[4]
    if not ability:IsFullyCastable() or ability:IsHidden() then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local castRange = ability:GetCastRange() + 200
    local radius = ability:GetAOERadius()
    local enemies = fun1:GetNearbyHeroes(npcBot, castRange + radius)
    local realEnemies = fun1:Filter(enemies, function(t)
        return fun1:MayNotBeIllusion(npcBot, t)
    end)
    local targettableEnemies = fun1:Filter(enemies, function(t)
        return fun1:NormalCanCast(t, false) and not fun1:CannotBeAttacked(t)
    end)
    local target = npcBot:GetTarget()
    if fun1:GetEnemyHeroNumber(npcBot, enemies) >= 2 then
        return RemapValClamped(fun1:GetEnemyHeroNumber(npcBot, enemies), 2, 4, BOT_ACTION_DESIRE_LOW + 0.1, BOT_ACTION_DESIRE_VERYHIGH)
    end
    if fun1:Contains(targettableEnemies, target) then
        return BOT_ACTION_DESIRE_MODERATE
    end
    return 0
end
Consider[5] = function()
    local ability = AbilitiesReal[5]
    if not ability:IsFullyCastable() or ability:IsHidden() then
        return 0
    end
    local abilityLevel = ability:GetLevel()
    local radius = ability:GetAOERadius() - 100
    local castPoint = ability:GetCastPoint()
    local manaCost = ability:GetManaCost()
    local duration = ability:GetDuration()
    local damage = ability:GetAbilityDamage()
    local castRange = ability:GetCastRange()
    local enemies = fun1:GetNearbyNonIllusionHeroes(npcBot, castRange)
    local enmeyCount = fun1:GetEnemyHeroNumber(npcBot, enemies)
    return 0
end
Consider[7] = function()
    local abilityNumber = 7
    local ability = AbilitiesReal[abilityNumber]
    if useTorrentAtXMarkTime then
        print("use torrent time "..useTorrentAtXMarkTime..", should recall at "..(useTorrentAtXMarkTime + AbilitiesReal[1]:GetSpecialValueFloat("delay") - ability:GetCastPoint()))
    end
    if not ability:IsFullyCastable() or ability:IsHidden() or xMarkTarget == nil or not xMarkTarget:HasModifier("modifier_kunkka_x_marks_the_spot") then
        return 0
    end
    if xMarkTarget:IsChanneling() then
        if xMarkTarget:HasModifier "modifier_teleporting" then
            xMarkTargetWasTeleporting = true
            return 0
        end
        return BOT_ACTION_DESIRE_VERYHIGH
    end
    if xMarkTargetWasTeleporting then
        xMarkTargetWasTeleporting = nil
        return BOT_ACTION_DESIRE_VERYHIGH
    end
    if XMarksEnemy() and npcBot:GetActiveMode() ~= BOT_MODE_RETREAT and GetUnitToUnitDistance(npcBot, xMarkTarget) >= 1800 then
        return BOT_ACTION_DESIRE_HIGH
    end
    if XMarksEnemy() and npcBot:GetActiveMode() == BOT_MODE_RETREAT and (GetUnitToUnitDistance(npcBot, xMarkTarget) <= 300 or npcBot:WasRecentlyDamagedByHero(xMarkTarget, 1)) and DotaTime() > 1 + xMarkTime and GetUnitToLocationDistance(xMarkTarget, xMarkLocation) then
        return BOT_ACTION_DESIRE_HIGH
    end
    if XMarksEnemy() and useTorrentAtXMark then
        print("use torrent time "..useTorrentAtXMarkTime..", should recall at "..(useTorrentAtXMarkTime + AbilitiesReal[1]:GetSpecialValueFloat("delay") - ability:GetCastPoint()))
        local timing = useTorrentAtXMarkTime + AbilitiesReal[1]:GetSpecialValueFloat("delay") - ability:GetCastPoint()
        if DotaTime() >= timing - 0.1 then
            return BOT_ACTION_DESIRE_VERYHIGH
        end
    end
end
fun1:AutoModifyConsiderFunction(npcBot, Consider, AbilitiesReal)
function AbilityUsageThink()
    if npcBot:IsUsingAbility() or npcBot:IsChanneling() or npcBot:IsSilenced() then
        return
    end
    ComboMana = GetComboMana()
    AttackRange = npcBot:GetAttackRange()
    ManaPercentage = npcBot:GetMana() / npcBot:GetMaxMana()
    HealthPercentage = npcBot:GetHealth() / npcBot:GetMaxHealth()
    cast = ability_item_usage_generic.ConsiderAbility(AbilitiesReal, Consider)
    if debugmode == true then
        ability_item_usage_generic.PrintDebugInfo(AbilitiesReal, cast)
    end
    if xMarkTarget and (not npcBot:IsAlive() or not xMarkTarget:IsAlive() or not xMarkTarget:HasModifier("modifier_kunkka_x_marks_the_spot")) then
        xMarkTarget = nil
        xMarkTime = nil
        xMarkLocation = nil
        useTorrentAtXMark = false
        useTorrentAtXMarkTime = nil
    end
    local index,target = ability_item_usage_generic.UseAbility(AbilitiesReal, cast)
    if index == 3 and target ~= nil then
        xMarkTarget = target
        xMarkTime = DotaTime() + AbilitiesReal[3]:GetCastPoint()
        xMarkLocation = target:GetLocation()
        if target:GetTeam() == npcBot:GetTeam() then
            xMarkDuration = AbilitiesReal[3]:GetSpecialValueFloat("allied_duration") or 8
        else
            xMarkDuration = AbilitiesReal[3]:GetSpecialValueFloat("duration") or 4
        end
    elseif index == 1 and xMarkTarget then
        useTorrentAtXMark = true
        useTorrentAtXMarkTime = DotaTime() + AbilitiesReal[1]:GetCastPoint()
        print("torrent time after a x mark: "..useTorrentAtXMarkTime)
    end
end
function CourierUsageThink()
    ability_item_usage_generic.CourierUsageThink()
end
