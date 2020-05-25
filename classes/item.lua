---@classmod Item
Item = Class{}

---Create an instance of the item. Don't call this directly. Called via Item('itemID')
--@param type_name String. The ID of the item.
--@param info Anything. Argument to pass into the item's new() function.
--@param amt Number. The amount of the item to create.
--@param ignoreNewFunc Boolean. Whether to ignore the item's new() function
--@return Item. The item itself.
function Item:init(type_name,info,amt,ignoreNewFunc)
  local data = possibleItems[type_name]
	for key, val in pairs(data) do
    if type(val) ~= "function" then
      self[key] = data[key]
    end
	end
	if not ignoreNewFunc and (possibleItems[type_name].new ~= nil) then
		possibleItems[type_name].new(self,(info or nil))
	end
  self.id = self.id or type_name
	self.baseType = "item"
  self.itemType = self.itemType or "other"
  self.color = copy_table(self.color)
  if (self.stacks) then
    self.amount = amt or 1
  end
  if self.image_varieties and not self.image_name then
    self.image_variety = random(1,self.image_varieties)
    self.image_name = self.id .. self.image_variety
    if not images['item' .. self.image_name] then
      self.image_name = nil
    end
  end
	return self
end

---Clones an instance of the item. Don't call this directly. Called via Item('itemID')
--@param type_name String. The ID of the item.
--@param info Anything. Argument to pass into the item's new() function.
--@param amt Number. The amount of the item to create.
--@param ignoreNewFunc Boolean. Whether to ignore the item's new() function
--@return Item. The item itself.
function Item:clone()
  local newItem = Item(self.id,nil,nil,true)
	for key, val in pairs(self) do
    if type(val) ~= "function" and type(val) ~= "table" then
      newItem[key] = self[key]
    elseif type(val) == "table" then
      newItem[key] = copy_table(self[key])
    end
	end
  return newItem
end

---Get the description of the item.
--@param withName Boolean. Whether to also include the name of the item.
--@return String. The description of the item.
function Item:get_description(withName)
	return (withName and self:get_name(true) .. "\n"  or "") .. self.description
end

--Get the extended information of the item. Charges, damage, range, etc.
--@return String. The info text of the item.
function Item:get_info()
	local uses = ""
  if self.charges and not self.hide_charges then
    uses = uses .. (self.charge_name and ucfirst(self.charge_name) or "Charges") .. ": " .. self.charges
  end
	if (self.itemType == "weapon") then
		if self.damage then uses = uses .. "Melee Damage: " .. self.damage .. (self.damage_type and " (" .. self.damage_type .. ")" or "") end
    if self.armor_piercing then uses = uses .. "Armor Piercing: " .. self.armor_piercing end
		if self.accuracy then uses = uses .. "\nAccuracy Modifier: " .. self.accuracy .. "%" end
		if self.critical then uses = uses .. "\nCritical Hit Chance: " .. self.critical .. "%" end
  end
  if self.ranged_attack then
    local attack = rangedAttacks[self.ranged_attack]
    uses = uses .. "\nGrants Ranged Attack: " .. attack:get_name()
    uses = uses .. "\n" .. attack:get_description()
    uses = uses .. "\nBase Accuracy: " .. attack.accuracy .. "%"
    if attack.min_range or attack.range then uses = uses .. "\nRange: " .. (attack.min_range and attack.min_range .. " (min)" or "") .. (attack.min_range and attack.range and " - " or "") .. (attack.range and attack.range .. " (max)" or "") end
    if attack.best_distance_min or attack.best_distance_max then uses = uses .. "\nBest Range: " .. (attack.best_distance_min and attack.best_distance_min .. " (min)" or "") .. (attack.best_distance_min and attack.best_distance_max and " - " or "") .. (attack.best_distance_max and attack.best_distance_max .. " (max)" or "") end
    uses = uses .. "\n"
  end
  if self.projectile_name then
    local projectile = projectiles[self.projectile_name]
    uses = uses .. "\nShoots Projectile: " .. ucfirst(projectile.name)
    uses = uses .. "\n" .. projectile.description
    uses = uses .. "\nDamage: " .. projectile.damage .. (projectile.damage_type and " (" .. projectile.damage_type .. ")" or "")
  end
  if self.info then
    uses = uses .. "\n" .. self.info
  end
	return uses
end

---Get the name of the item.
--@param full Boolean. If false, the item will be called "a dagger", if true, the item will be called "Dagger".
--@param amount Number. The number of items in question. (optional)
--@return String. The name of the item
function Item:get_name(full,amount)
  amount = amount or self.amount or 1
  local prefix = ""
  local suffix = ""
  if self.enchantments then
    for ench,_ in pairs(self:get_enchantments()) do
      local enchantment = enchantments[ench]
      if enchantment.prefix then
        prefix = prefix .. enchantment.prefix .. " "
      end
      if enchantment.suffix then
        suffix = suffix .. " " .. enchantment.suffix
      end
    end
  end --end enchantment info
	if (full == true) then
		if (self.properName ~= nil) then
			return self.properName .. " (" .. prefix .. self.name .. suffix .. ")"
		else
      if self.stacks and amount > 1 then
        if self.pluralName then
          return amount .. " " .. ucfirst(prefix .. self.pluralName .. suffix)
        else
          return amount .. " x " .. ucfirst(prefix .. self.name .. suffix)
        end
      else
        return ucfirst(prefix .. self.name .. suffix)
      end
		end
	elseif (self.properName ~= nil) then
		return self.properName
	else
    if self.stacks and amount > 1 then
      if self.pluralName then
          return amount .. " " .. prefix .. self.pluralName .. suffix
        else
          return amount .. " x " .. prefix .. self.name .. suffix
        end
    else
      return (vowel(prefix .. self.name) and "an " or "a " ) .. prefix .. self.name .. suffix
    end
	end
end

---"Use" the item. Calls the item's use() code.
--@param target Entity. The target of the item's use. Might be another creature, a tile, even the user itself.
--@param user Creature. The creature using the item.
--@return Boolean.Whether the use was successful.
function Item:use(target,user)
	if possibleItems[self.id].use then
    return possibleItems[self.id].use(self,target,user)
  end
  --Generic item use here:
end

---Find out how much damage an item will deal. Defaults to the item's damage value + the wielder's strength, but might be overridden by an item's get_damage() code
--@param target Entity. The target of the item's attack.
--@param wielder Creature. The creature using the item.
--@return Number. The damage the item will deal.
function Item:get_damage(target,wielder)
  if possibleItems[self.id].get_damage then
    return possibleItems[self.id].get_damage(self,target,wielder)
  end
  return (self.damage or 0) + self:get_enchantment_bonus('damage') + (wielder.strength or 0)
end

---Attack another entity.
--@param target Entity. The creature (or feature) they're attacking
--@param wielder Creature. The creature attacking with the item.
--@param forceHit Boolean. Whether to force the attack instead of rolling for it. (optional)
--@param ignore_callbacks Boolean. Whether to ignore any of the callbacks involved with attacking (optional)
--@param forceBasic Boolean. Whether to ignore the weapon's attacked_with and attack_hits code and just do a basic attack. (optional)
--@return Number. How much damage (if any) was done
function Item:attack(target,wielder,forceHit,ignore_callbacks,forceBasic)
  local txt = ""
  if not forceBasic and possibleItems[self.id].attacked_with then
    local result, damage, text = possibleItems[self.id].attacked_with(self,target,wielder)
    if result == false then
      if text then output:out(text) end
      return damage
    end
    if text then txt = txt .. text end
  end
  
  --Basic attack:
  if target.baseType == "feature" and wielder:touching(target) then
    return target:damage(self:get_damage(target,wielder),wielder,self.damage_type)
	elseif wielder:touching(target) and (ignore_callbacks or wielder:callbacks('attacks',target) and target:callbacks('attacked',self)) then
    local result,dmg="miss",0
    if possibleItems[self.id].calc_attack then
      result,dmg = possibleItems[self.id].calc_attack(self,target,wielder)
    else
      result,dmg = calc_attack(wielder,target,nil,self)
    end
    if forceHit == true then result = 'hit' end
		local hitConditions = self:get_hit_conditions()
    local critConditions = self:get_crit_conditions()
		txt = txt .. (string.len(txt) > 0 and " " or "") .. ucfirst(wielder:get_name()) .. " attacks " .. target:get_name() .. " with " .. self:get_name() .. ". "

		if (result == "miss") then
			txt = txt .. ucfirst(wielder:get_pronoun('n')) .. " misses."
      dmg = 0
      if player:can_see_tile(self.x,self.y) or player:can_see_tile(target.x,target.y) and player:does_notice(wielder) and player:does_notice(target) then
        output:out(txt)
      end
		else
      if not forceBasic and possibleItems[self.id].attack_hits then
        return possibleItems[self.id].attack_hits(self,target,wielder,dmg,result)
      end
			if (result == "critical") then txt = txt .. "CRITICAL HIT! " end
      local bool,ret = wielder:callbacks('calc_damage',target,dmg)
      if (bool ~= false) and #ret > 0 then --handle possible returned damage values
        local count = 0
        local amt = 0
        for _,val in pairs(ret) do --add up all returned damage values
          if type(val) == "number" then count = count + 1 amt = amt + val end
        end
        if count > 0 then dmg = math.ceil(amt/count) end --final damage is average of all returned damage values
      end
			dmg = target:damage(dmg,wielder,self.damage_type,self:get_armor_piercing(wielder))
			if dmg > 0 then txt = txt .. ucfirst(wielder:get_pronoun('n')) .. " hits " .. target:get_pronoun('o') .. " for " .. dmg .. (self.damage_type and " " .. self.damage_type or "") .. " damage."
      else txt = txt .. ucfirst(wielder:get_pronoun('n')) .. " hits " .. target:get_pronoun('o') .. " for no damage." end
      local xMod,yMod = get_unit_vector(wielder.x,wielder.y,target.x,target.y)
      target.xMod,target.yMod = target.xMod+(xMod*5),target.yMod+(yMod*5)
      if target.moveTween then
        Timer.cancel(target.moveTween)
      end
      target.moveTween = tween(.1,target,{xMod=0,yMod=0},'linear',function() target.doneMoving = true end)
      if player:can_see_tile(wielder.x,wielder.y) or player:can_see_tile(target.x,target.y) and player:does_notice(wielder) and player:does_notice(target) then
        output:out(txt)
      end
      if possibleItems[self.id].after_damage then
        possibleItems[self.id].after_damage(self,target,wielder)
      end
			wielder:callbacks('damages',target,dmg)
      local cons = (result == "critical" and critConditions or hitConditions)
			for _, condition in pairs (cons) do
				if (random(1,100) < condition.chance) then
          local turns = ((condition.minTurns and condition.maxTurns and random(condition.minTurns,condition.maxTurns)) or tweak(condition.turns))
					target:give_condition(condition.condition,turns,wielder)
				end -- end condition chance
			end	-- end condition forloop
		end -- end hit if
		return dmg
	else -- if not touching target
		return false
	end
end

---Set the item as the thing currently being used to target (so it'll display as targeting in the game UI)
function Item:target()
  action = "targeting"
  actionResult = self
  actionItem = self
end

---Reload an item.
--@param possessor Creature. The creature using the item.
--@return Boolean. Whether the reload was successful.
function Item:reload(possessor)
  if self.charges > 1 and self.usingAmmo then
    local it,id,amt = possessor:has_item(self.usingAmmo)
    amt = math.min((amt or 0),self.max_charges - self.charges) --don't reload more than the item can hold
    if amt > 0 then
      self.charges = self.charges + amt
      possessor:delete_item(it,amt)
      if player:can_sense_creature(possessor) then
        output:out(possessor:get_name() .. " reloads " .. self:get_name() .. " with " .. it:get_name(false,amt) .. ".")
      end
    else
      if possessor == player then output:out("You don't have any more of the specific type of ammo that is loaded in" .. self:get_name() .. ".") end
      return false
    end
  else --not using specific ammo, or empty
    --First use whatever's equipped:
    local usedAmmo = nil
    if possessor.equipment.ammo and #possessor.equipment.ammo > 0 then
      for _,ammo in ipairs(possessor.equipment.ammo) do
        if ammo.ammoType == self.usesAmmo then
          usedAmmo = ammo
          break
        end
      end
    end
    --if there's not a usable ammo equipped, select a random type from the inventory, with preference to ammo types the player is holding enough of to reload
    if not usedAmmo then 
      local ammoTypes = {}
      for id,it in ipairs(possessor.inventory) do
        if it.ammoType == self.usesAmmo then
          ammoTypes[#ammoTypes+1] = it
        end --end ammotype match
      end --end inventory for
      --Do you even have any ammo that matches?
      if #ammoTypes < 1 then
        if possessor == player then output:out("You don't have any more ammo for " .. self:get_name() .. ".") end
        return false
      end
      --If you do have ammo, use it:
      ammoTypes = shuffle(ammoTypes) --do this so it picks a random one
      usedAmmo = ammoTypes[random(1,#ammoTypes)] --pick a random one at first, not paying attention to the amount the possessor has
      for _,ammo in ipairs(ammoTypes) do --loop through and pick the first one you see that fills the item to full
        if (ammo.amount or 1) >= (self.max_charges - self.charges) then --if 
          usedAmmo = ammo
          break
        end
      end
    end
    --Now actually do the reloading, with whatever ammo you've decided on:
    local amt = math.min((usedAmmo.amount or 1),self.max_charges - self.charges) --don't reload more than the item can hold
    self.charges = self.charges + amt
    possessor:delete_item(usedAmmo,amt)
    self.usingAmmo = usedAmmo.id
    self.projectile_name = usedAmmo.projectile_name
    if player:can_sense_creature(possessor) then
      output:out(possessor:get_name() .. " reloads " .. self:get_name() .. " with " .. usedAmmo:get_name(false,amt) .. ".")
    end
  end --end if using specific ammo
end

---Apply an enchantment to an item
--@param enchantment Text. The ID of the enchantment
--@param turns Number. The number of turns to apply the enchantment, if applicable. What "turns" refers to will vary by enchantment, and some are always permanent, and so this number will do nothing. Add a -1 to make force this enchantment to be permanent.
function Item:apply_enchantment(enchantment,turns)
  turns = turns or 1
  if not self.enchantments then self.enchantments = {} end
  local currEnch = self.enchantments[enchantment]
  if currEnch == -1 then
    --do nothing
  elseif turns == -1 then --if making it permanent, always make it permanent
    self.enchantments[enchantment] = -1
  elseif currEnch then --if you currently have this enchantment, add turns
    self.enchantments[enchantment] = currEnch+turns
  else --if you don't currently have this enchantment, set it to the passed turns value
    self.enchantments[enchantment] = turns
  end
end

---Return a list of all enchantments currently applied to an item
--@return Table. The list of enchantments
function Item:get_enchantments()
  return self.enchantments or {}
end

---Returns the total value of the bonuses of a given type provided by enchantments.
--@param bonusType Text. The bonus type to look at
--@return Number. The bonus
function Item:get_enchantment_bonus(bonusType)
  local total = 0
  for e,_ in pairs(self:get_enchantments()) do
    local enchantment = enchantments[e]
    if enchantment.bonuses and enchantment.bonuses[bonusType] then
      total = total + enchantment.bonuses[bonusType]
    end --end if it has the right bonus
  end --end enchantment for
  return total
end

---Check what hit conditions an item can inflict
--@return Table. The list of hit conditions
function Item:get_hit_conditions()
  local cons = self.hit_conditions or {}
	for e,_ in pairs(self:get_enchantments()) do
    local ench = enchantments[e]
    if ench.hit_conditions then
      for _,con in ipairs(ench.hit_conditions) do
        local already = false
        for i, c in ipairs(cons) do --check current conditions, and if we already have this condition, use the maximum values between the condition we have and the condition applied by the enchantment
          if c.condition == con.condition then --c is the current condition, con is the new condition
            already = true
            c.minTurns = math.max(c.minTurns or 0,con.minTurns or 0)
            c.maxTurns = math.max(c.maxTurns or 0,con.maxTurns or 0)
            c.turns = math.max(c.turns or 0,con.turns or 0)
            if c.minTurns == 0 then c.minTurns = nil end
            if c.maxTurns == 0 then c.maxTurns = nil end
            if c.turns == 0 then c.turns = nil end
            c.chance = math.max(c.chance,con.chance)
          end
        end --end loopthrough of own conditions
        if not already then
          cons[#cons+1] = con
        end
      end --end ehcnatment's conditions loop
    end --end if the enchantment has hit conditions
  end --end enchantment loop
  return cons
end

---Check what conditions an item can inflict on a critical hit
--@return Table. The list of hit conditions
function Item:get_crit_conditions()
	local cons = self.crit_conditions or self.hit_conditions or {}
	for e,_ in pairs(self:get_enchantments()) do
    local ench = enchantments[e]
    if ench.crit_conditions or ench.hit_conditions then
      for _,con in ipairs((ench.crit_conditions or ench.hit_conditions)) do
        local already = false
        for i, c in ipairs(cons) do --check current conditions, and if we already have this condition, use the maximum values between the condition we have and the condition applied by the enchantment
          if c.condition == con.condition then --c is the current condition, con is the new condition
            already = true
            c.minTurns = math.max(c.minTurns or 0,con.minTurns or 0)
            c.maxTurns = math.max(c.maxTurns or 0,con.maxTurns or 0)
            c.turns = math.max(c.turns or 0,con.turns or 0)
            if c.minTurns == 0 then c.minTurns = nil end
            if c.maxTurns == 0 then c.maxTurns = nil end
            if c.turns == 0 then c.turns = nil end
            c.chance = math.max(c.chance,con.chance)
          end
        end --end loopthrough of own conditions
        if not already then
          cons[#cons+1] = con
        end
      end --end ehcnatment's conditions loop
    end --end if the enchantment has hit conditions
  end --end enchantment loop
  return cons
end

---Checks the armor-piercing quality of a weapon.
--@param wielder Creature. The creature wielding the weapon.
--@return Number. The armor piercing value.
function Item:get_armor_piercing(wielder)
	return (self.armor_piercing or 0) + (wielder and wielder:get_bonus('armor_piercing') or 0)
end

---Returns the accuracy (modifier to the hit roll) of a weapon.
--@return Number. The accuracy of the weapon.
function Item:get_accuracy()
  return (self.accuracy or 0)+self:get_enchantment_bonus('hit_chance')
end

---Checks the critical chance of a weapon.
--@return Number. The crit chance of the weapon.
function Item:get_critical_chance()
  return (self.critical_chance or 0)+self:get_enchantment_bonus('critical_chance')
end

---Checks if an item has a descriptive tag.
--@param tag String. The tag to check for
--@return Boolean. Whether or not it has the tag.
function Item:has_tag(tag)
  if self.tags and in_table(tag,self.tags) then
    return true
  end
  return false
end