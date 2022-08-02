use itertools::Itertools;
use std::cmp::max;

pub fn solve(boss_stats: &str) {
    println!("--- Day 21: RPG Simulator 20XX ---");
    println!("Part 1: {}", part_1(boss_stats));
    println!("Part 2: {}", part_2(boss_stats));
}

#[derive(Copy, Clone)]
struct Item {
    cost: u16,
    damage: i16,
    armour: i16,
}

impl Item {
    pub fn new(cost: u16, damage: i16, armour: i16) -> Item {
        Item {
            cost,
            damage,
            armour,
        }
    }
}

#[derive(Copy, Clone)]
struct Character {
    hit_points: i16,
    damage: i16,
    armour: i16,
}

impl Character {
    fn new(hit_points: i16, damage: i16, armour: i16) -> Self {
        Character {
            hit_points,
            damage,
            armour,
        }
    }
    pub fn equip_item(&mut self, item: &Item) {
        self.damage += item.damage;
        self.armour += item.armour;
    }
}

fn part_1(boss_stats: &str) -> u16 {
    let weapons = [
        Item::new(8, 4, 0),
        Item::new(10, 5, 0),
        Item::new(25, 6, 0),
        Item::new(40, 7, 0),
        Item::new(74, 8, 0),
    ];
    let armour = [
        Item::new(0, 0, 0),
        Item::new(13, 0, 1),
        Item::new(31, 0, 2),
        Item::new(53, 0, 3),
        Item::new(75, 0, 4),
        Item::new(102, 0, 5),
    ];
    let rings = [
        Item::new(0, 0, 0),
        Item::new(25, 1, 0),
        Item::new(50, 2, 0),
        Item::new(100, 3, 0),
        Item::new(20, 0, 1),
        Item::new(40, 0, 2),
        Item::new(80, 0, 3),
    ];
    let mut boss_damage = 0;
    let mut boss_armour = 0;
    let mut boss_hit_points = 0;
    for boss_stat in boss_stats.lines() {
        if let Some(value) = boss_stat.strip_prefix("Hit Points: ") {
            boss_hit_points = value.parse().unwrap();
        }
        if let Some(value) = boss_stat.strip_prefix("Damage: ") {
            boss_damage = value.parse().unwrap();
        }
        if let Some(value) = boss_stat.strip_prefix("Armor: ") {
            boss_armour = value.parse().unwrap();
        }
    }
    let mut cost;
    let mut boss;
    let mut player;
    const PLAYER_DAMAGE: i16 = 0;
    const PLAYER_ARMOUR: i16 = 0;
    const PLAYER_HIT_POINTS: i16 = 100;
    let mut costs = std::collections::HashSet::new();
    for weapon in weapons.iter() {
        for armour in armour.iter() {
            for couple_rings in rings.iter().combinations(2) {
                boss = Character::new(boss_hit_points, boss_damage, boss_armour);
                player = Character::new(PLAYER_HIT_POINTS, PLAYER_DAMAGE, PLAYER_ARMOUR);
                player.equip_item(weapon);
                player.equip_item(armour);
                player.equip_item(couple_rings[0]);
                player.equip_item(couple_rings[1]);
                if does_player_win(player, boss) {
                    cost = weapon.cost + armour.cost + couple_rings[0].cost + couple_rings[1].cost;
                    costs.insert(cost);
                }
            }
        }
    }
    let min_cost_to_win = *costs.iter().min().unwrap();
    min_cost_to_win
}

fn part_2(boss_stats: &str) -> u16 {
    let weapons = [
        Item::new(8, 4, 0),
        Item::new(10, 5, 0),
        Item::new(25, 6, 0),
        Item::new(40, 7, 0),
        Item::new(74, 8, 0),
    ];
    let armour = [
        Item::new(0, 0, 0),
        Item::new(13, 0, 1),
        Item::new(31, 0, 2),
        Item::new(53, 0, 3),
        Item::new(75, 0, 4),
        Item::new(102, 0, 5),
    ];
    let rings = [
        Item::new(0, 0, 0),
        Item::new(25, 1, 0),
        Item::new(50, 2, 0),
        Item::new(100, 3, 0),
        Item::new(20, 0, 1),
        Item::new(40, 0, 2),
        Item::new(80, 0, 3),
    ];
    let mut boss_damage = 0;
    let mut boss_armour = 0;
    let mut boss_hit_points = 0;
    for boss_stat in boss_stats.lines() {
        if let Some(value) = boss_stat.strip_prefix("Hit Points: ") {
            boss_hit_points = value.parse().unwrap();
        }
        if let Some(value) = boss_stat.strip_prefix("Damage: ") {
            boss_damage = value.parse().unwrap();
        }
        if let Some(value) = boss_stat.strip_prefix("Armor: ") {
            boss_armour = value.parse().unwrap();
        }
    }
    let mut cost;
    let mut boss;
    let mut player;
    const PLAYER_DAMAGE: i16 = 0;
    const PLAYER_ARMOUR: i16 = 0;
    const PLAYER_HIT_POINTS: i16 = 100;
    let mut costs = std::collections::HashSet::new();
    for weapon in weapons.iter() {
        for armour in armour.iter() {
            for couple_rings in rings.iter().combinations(2) {
                boss = Character::new(boss_hit_points, boss_damage, boss_armour);
                player = Character::new(PLAYER_HIT_POINTS, PLAYER_DAMAGE, PLAYER_ARMOUR);
                player.equip_item(weapon);
                player.equip_item(armour);
                player.equip_item(couple_rings[0]);
                player.equip_item(couple_rings[1]);
                if !does_player_win(player, boss) {
                    cost = weapon.cost + armour.cost + couple_rings[0].cost + couple_rings[1].cost;
                    costs.insert(cost);
                }
            }
        }
    }
    let max_cost_to_lose = *costs.iter().max().unwrap();
    max_cost_to_lose
}

fn does_player_win(mut player: Character, mut boss: Character) -> bool {
    let boss_damage: i16 = max(1, boss.damage.saturating_sub(player.armour));
    let player_damage: i16 = max(1, player.damage.saturating_sub(boss.armour));
    loop {
        boss.hit_points -= player_damage;
        if boss.hit_points < 1 {
            return true;
        }
        player.hit_points -= boss_damage;
        if player.hit_points < 1 {
            return false;
        }
    }
}
