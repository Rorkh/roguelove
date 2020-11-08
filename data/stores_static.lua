stores_static = {}

local healthstore = {
  name = "Healthe & Well-ness Apotheckarie",
  description = "A ramshackle booth, stacked with potions.",
  sells_items = {{item="healthpotionminor",cost=10,amount=5},{item="dart",cost=1},{item="dagger",amount=5,cost=1},{item="scroll",amount=10,cost=1,passed_info="blink"},{item="scroll",amount=10,cost=1}}, --The items sold by the shop
  noBuy = false, --If the store buys things or not
  buys_items = {healthpotionminor=5,scroll=1},
  buys_tags = {"magic"}, --Tags for non-predefined items that will be bought by the shop
  currency_item = nil --The item to use as currency, instead of money
}
stores_static['healthstore'] = healthstore

local weaponstore = {
  name = "Weapons R Us",
  description = "A ramshackle booth, filled with dangerous implements.",
  sells_tags = {"weapon"}, --Tags for items that will be sold by the shop
  buys_tags = {"weapon"},
  markup=2, --Randomly-selected items' values will be multiplied by this number to determine how much this shop will sell the items for
  random_item_amount=10, --How many random items to fill the shop with
  min_artifacts=1,
  artifact_chance=1
}
stores_static['weaponstore'] = weaponstore