rangedAttacks = {
 skellibone = ranged_attack:new({
    name = "Bonerang",
    description = "Throw your enemy a bone, literally!",
    projectile=true,
    projectile_name="skellibone",
    sound="bonerang",
    accuracy=70,
    best_distance_min=4,
    best_distance_max=5,
    accuracy_decay = 10,
    min_range=2
 }),

revolver = ranged_attack:new({
    name = "Revolver",
    description = "Even magical undead creatures usually fall before good old lead. Usually.",
    projectile=true,
    projectile_name="bullet",
    sound="gunshot",
    accuracy=80,
    best_distance_min=3,
    best_distance_max=6,
    accuracy_decay = 25,
  }),

dart = ranged_attack:new({
    name = "Dart",
    description = "Throw a dart.",
    projectile=true,
    projectile_name="dart",
    accuracy=100,
    best_distance_min=4,
    best_distance_max=7,
    accuracy_decay = 5,
    min_range=2
  }),

poisondart = ranged_attack:new({
    name = "Poison Dart",
    description = "Shoot a poison dart at your enemy. It doesn't do any damage itself, but on the plus side, it's relatively painless so the target might not notice you.",
    projectile = true,
    projectile_name="poisondart",
    accuracy = 95,
    best_distance_min=2,
    best_distance_max=7,
    accuracy_decay = 10,
  }),

dagger = ranged_attack:new({
    name = "Dagger",
    description = "Throw a dagger.",
    projectile=true,
    projectile_name="dagger",
    accuracy=85,
    best_distance_min=3,
    best_distance_max=6,
    accuracy_decay = 5,
    min_range=2
  }),

genericthrow = ranged_attack:new({
    name = "Throw",
    description = "Throw an item.",
    projectile=true,
    accuracy=60,
    best_distance_min=2,
    best_distance_max=5,
    accuracy_decay = 10,
  }),

thorns = ranged_attack:new({
    name = "Thorns",
    description = "Shoot a poison thorn at an enemy.",
    projectile = true,
    projectile_name="thorn",
    accuracy = 75,
    best_distance_min=3,
    best_distance_max=5,
    accuracy_decay = 10,
  }),

elephantgun = ranged_attack:new({
    name = "Elephant Gun",
    description = "A huge rifle used for hunting elephants. It can be used to shoot other things too, though.",
    projectile=true,
    projectile_name="bullet",
    sound="gunshot",
    accuracy=80,
    best_distance_min=4,
    best_distance_max=7,
    accuracy_decay = 25,
  }),

tranqdart = ranged_attack:new({
    name = "Tranquilizer Dart",
    description = "Shoot a tranquilizer dart at your enemy, slowing them down or possibly causing them to fall asleep.",
    projectile = true,
    projectile_name="tranqdart",
    accuracy = 80,
    best_distance_min=3,
    best_distance_max=6,
    accuracy_decay = 20,
  }),

firearrow = ranged_attack:new({
    name = "Fire Arrow",
    description = "Shoots a flaming arrow, possibly catching the target on fire.",
    projectile = true,
    projectile_name="firearrow",
    sound="bow",
    accuracy = 80,
    best_distance_min=3,
    best_distance_max=6,
    accuracy_decay = 20,
    min_range=2
  }),
icearrow = ranged_attack:new({
    name = "Icy Arrow",
    description = "Shoots an icy arrow, slowing the target down and possibly freezing them.",
    projectile = true,
    projectile_name="icearrow",
    sound="bow",
    accuracy = 80,
    best_distance_min=3,
    best_distance_max=6,
    accuracy_decay = 20,
    min_range=2
  }),
electricarrow = ranged_attack:new({
    name = "Electric Arrow",
    description = "Shoots an electric arrow, shocking the target and possibly stunning them.",
    projectile = true,
    projectile_name="electricarrow",
    sound="bow",
    accuracy = 80,
    best_distance_min=3,
    best_distance_max=6,
    accuracy_decay = 20,
    min_range=2
  }),
phasearrow = ranged_attack:new({
    name = "Phase Arrow",
    description = "Shoots a magic arrow that phases in and out of existence. It passes harmlessly through obstacles on the way to its target.",
    projectile = false,
    projectile_name="phasearrow",
    sound="bow",
    accuracy = 80,
    best_distance_min=3,
    best_distance_max=6,
    accuracy_decay = 20,
    min_range=2
  }),

centaurbow = ranged_attack:new({
    name = "Bow and Arrow",
    description = "Shoot an arrow at an enemy.",
    sound="bow",
    projectile = true,
    projectile_name="centaurarrow",
    accuracy = 80,
    best_distance_min=3,
    best_distance_max=6,
    accuracy_decay = 20,
    min_range=2
  }),

crossbow = ranged_attack:new({
    name = "Crossbow",
    description = "Shoot a bolt at an enemy.",
    sound="bow",
    projectile = true,
    projectile_name="bolt",
    accuracy = 50,
    best_distance_min=3,
    best_distance_max=8,
    accuracy_decay = 10,
    min_range=2
  }),

cherubbow = ranged_attack:new({
    name = "Holy Bow",
    description = "Shoot an arrow at an enemy.",
    sound="bow",
    projectile = true,
    projectile_name="cherubarrow",
    accuracy = 80,
    best_distance_min=3,
    best_distance_max=6,
    accuracy_decay = 20,
    min_range=2
  }),

smallfireball = ranged_attack:new({
    name = "Fireball",
    description = "Shoot a small fireball at your enemies.",
    projectile = true,
    projectile_name = "smallfireball",
    max_charges = 1,
    recharge_turns = 5,
    hide_charges = true,
    accuracy = 80,
    best_distance_min=3,
    best_distance_max=5,
    accuracy_decay = 10,
    sound="shoot_fireball"
  }),

meteor = ranged_attack:new({
    name = "Meteor",
    description = "Throw a meteor at your enemies.",
    projectile = true,
    projectile_name = "meteor",
    max_charges = 1,
    recharge_turns = 10,
    hide_charges = true,
    accuracy = 80,
    min_range=2,
    best_distance_min=3,
    best_distance_max=5,
    accuracy_decay = 10,
    sound="fireball_large"
  }),

electroplasm = ranged_attack:new({
    name = "Electroplasm",
    description = "Shoot a blast of electroplasm at your enemies.",
    projectile = true,
    projectile_name = "electroplasm",
    max_charges = 1,
    recharge_turns = 5,
    hide_charges = true,
    accuracy = 80,
    best_distance_min=3,
    best_distance_max=5,
    accuracy_decay = 10,
  }),

sewerglob = ranged_attack:new({
    name = "Sewer Glob",
    description = "Fling a glob of sewer muck. Disgusting",
    projectile = true,
    projectile_name = "sewerglob",
    sound = "spit",
    hide_charges = true,
    accuracy = 80,
    min_distance=2,
    best_distance_min=2,
    best_distance_max=7,
    accuracy_decay = 10,
  }),

autocrossbow = ranged_attack:new({
    name = "Auto-Crossbow",
    description = "Fire a bunch of crossbow bolts hapzardly at a general area.",
    projectile = true,
    projectile_name = "bolt"
  }),

throwbottle = ranged_attack:new({
    name = "Throw Bottle",
    description = "Throw a bottle of booze at someone who made you mad.",
    projectile_name = "bottle",
    accuracy = 70,
    best_distance_min=3,
    best_distance_max=5,
    accuracy_decay = 20
  }),

spitvenom = ranged_attack:new({
    name = "Spit Venom",
    description = "Spit venom at an enemy. It could poison them, and if it gets in their eyes it might even blind them.",
    projectile = true,
    projectile_name="venom",
    accuracy = 75,
    best_distance_min=3,
    best_distance_max=5,
    accuracy_decay = 30,
    sound="spit"
  }),

spitslime = ranged_attack:new({
    name = "Spit Slime",
    description = "Spit slime at an enemy. Gross.",
    projectile = true,
    projectile_name="slime",
    accuracy = 90,
    best_distance_min=1,
    best_distance_max=1,
    accuracy_decay = 25,
    cooldown=3,
    range=4,
    sound="spit"
  }),
}