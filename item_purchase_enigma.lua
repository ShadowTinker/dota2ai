----------------------------------------------------------------------------
--	Ranked Matchmaking AI v1.6b
--	Author: adamqqq		Email:adamqqq@163.com
----------------------------------------------------------------------------
local ItemPurchaseSystem = dofile(GetScriptDirectory() .. "/util/ItemPurchaseSystem")

local ItemsToBuy =
{
	"item_tango",
	"item_clarity",
	"item_magic_wand", --大魔棒7.14
	"item_arcane_boots", --秘法鞋
	"item_blink", --跳刀
	"item_black_king_bar", --bkb
	"item_guardian_greaves", --卫士胫甲
	"item_aghanims_shard",
	"item_vitality_booster",
	"item_energy_booster",
	"item_recipe_aeon_disk", -- 永恒之盘
	"item_ultimate_scepter", --蓝杖
	"item_octarine_core", --玲珑心
	"item_ultimate_scepter_2",
	"item_refresher",
	"item_arcane_blink",
}

ItemPurchaseSystem:CreateItemInformationTable(GetBot(), ItemsToBuy)


function ItemPurchaseThink()
	ItemPurchaseSystem.BuySupportItem() --购买辅助物品	对于辅助英雄保留这一行
	ItemPurchaseSystem:ItemPurchaseExtend()

end
