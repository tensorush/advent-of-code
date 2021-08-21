use std::cmp::{max, Ordering};
use std::collections::BinaryHeap;

#[derive(Copy, Clone)]
struct Effect {
    mana: u32,
    turns: u32,
    damage: u32,
    armour: u32,
}

impl Effect {
    fn new(mana: u32, turns: u32, damage: u32, armour: u32) -> Effect {
        Effect {
            mana,
            turns,
            damage,
            armour,
        }
    }
}

#[derive(Copy, Clone)]
struct Spell {
    damage: u32,
    mana_cost: u32,
    hit_points: u32,
    effect_index: Option<usize>,
}

impl Spell {
    fn new(damage: u32, mana_cost: u32, hit_points: u32, effect_index: Option<usize>) -> Spell {
        Spell {
            damage,
            mana_cost,
            hit_points,
            effect_index,
        }
    }
}

#[derive(Copy, Clone, Eq, PartialEq)]
struct GameState {
    spent_mana: u32,
    remaining_mana: u32,
    boss_hit_points: u32,
    player_hit_points: u32,
    effects_timers: [u32; 3],
}

impl Ord for GameState {
    fn cmp(&self, other: &Self) -> Ordering {
        other.spent_mana.cmp(&self.spent_mana)
    }
}

impl PartialOrd for GameState {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

fn apply_effects(state: &mut GameState, effects: &[Effect]) -> Option<u32> {
    let mut enhanced_armour: u32 = 0;
    for (effect_index, effect) in effects.iter().enumerate() {
        if state.effects_timers[effect_index] > 0 {
            if effect.damage >= state.boss_hit_points {
                return None;
            }
            state.remaining_mana += effect.mana;
            enhanced_armour += effect.armour;
            state.boss_hit_points -= effect.damage;
            state.effects_timers[effect_index] -= 1;
        }
    }
    Some(enhanced_armour)
}

fn part_1(boss_stats: &str) -> u32 {
    let mut boss_damage: u32 = 0;
    let mut boss_hit_points: u32 = 0;
    for boss_stat in boss_stats.lines() {
        if let Some(value) = boss_stat.strip_prefix("Hit Points: ") {
            boss_hit_points = value.parse().unwrap();
        }
        if let Some(value) = boss_stat.strip_prefix("Damage: ") {
            boss_damage = value.parse().unwrap();
        }
    }
    let effects: [Effect; 3] = [
        Effect::new(0, 6, 0, 7),
        Effect::new(0, 6, 3, 0),
        Effect::new(101, 5, 0, 0),
    ];
    let spells: [Spell; 5] = [
        Spell::new(4, 53, 0, None),
        Spell::new(2, 73, 2, None),
        Spell::new(0, 113, 0, Some(0)),
        Spell::new(0, 173, 0, Some(1)),
        Spell::new(0, 229, 0, Some(2)),
    ];
    let mut states: BinaryHeap<GameState> = BinaryHeap::new();
    states.push(GameState {
        spent_mana: 0,
        remaining_mana: 500,
        boss_hit_points,
        player_hit_points: 50,
        effects_timers: [0, 0, 0],
    });
    let mut cur_state: GameState;
    let mut damage_to_player: u32;
    let mut min_mana_to_win: u32 = 0;
    let mut cur_state_after_spell: GameState;
    'outer: while let Some(state) = states.pop() {
        cur_state = state.clone();
        if apply_effects(&mut cur_state, &effects).is_none() {
            min_mana_to_win = cur_state.spent_mana;
            break;
        };
        for spell in spells.iter() {
            cur_state_after_spell = cur_state.clone();
            if spell.mana_cost > cur_state_after_spell.remaining_mana {
                continue;
            }
            cur_state_after_spell.remaining_mana -= spell.mana_cost;
            cur_state_after_spell.spent_mana += spell.mana_cost;
            if let Some(effect_index) = spell.effect_index {
                if cur_state_after_spell.effects_timers[effect_index] > 0 {
                    continue;
                } else {
                    cur_state_after_spell.effects_timers[effect_index] = effects[effect_index].turns;
                }
            }
            cur_state_after_spell.player_hit_points += spell.hit_points;
            if cur_state_after_spell.boss_hit_points <= spell.damage {
                min_mana_to_win = cur_state_after_spell.spent_mana;
                break 'outer;
            }
            cur_state_after_spell.boss_hit_points -= spell.damage;
            if let Some(enhanced_armour) = apply_effects(&mut cur_state_after_spell, &effects) {
                damage_to_player = max(1, boss_damage - enhanced_armour);
                if damage_to_player < cur_state_after_spell.player_hit_points {
                    cur_state_after_spell.player_hit_points -= damage_to_player;
                    states.push(cur_state_after_spell);
                }
            } else {
                min_mana_to_win = cur_state_after_spell.spent_mana;
                break 'outer;
            }
        }
    }
    min_mana_to_win
}

fn part_2(boss_stats: &str) -> u32 {
    let mut boss_damage: u32 = 0;
    let mut boss_hit_points: u32 = 0;
    for boss_stat in boss_stats.lines() {
        if let Some(value) = boss_stat.strip_prefix("Hit Points: ") {
            boss_hit_points = value.parse().unwrap();
        }
        if let Some(value) = boss_stat.strip_prefix("Damage: ") {
            boss_damage = value.parse().unwrap();
        }
    }
    let effects: [Effect; 3] = [
        Effect::new(0, 6, 0, 7),
        Effect::new(0, 6, 3, 0),
        Effect::new(101, 5, 0, 0),
    ];
    let spells: [Spell; 5] = [
        Spell::new(4, 53, 0, None),
        Spell::new(2, 73, 2, None),
        Spell::new(0, 113, 0, Some(0)),
        Spell::new(0, 173, 0, Some(1)),
        Spell::new(0, 229, 0, Some(2)),
    ];
    let mut states: BinaryHeap<GameState> = BinaryHeap::new();
    states.push(GameState {
        spent_mana: 0,
        remaining_mana: 500,
        boss_hit_points,
        player_hit_points: 50,
        effects_timers: [0, 0, 0],
    });
    let mut cur_state: GameState;
    let mut damage_to_player: u32;
    let mut min_mana_to_win: u32 = 0;
    let mut cur_state_after_spell: GameState;
    'outer: while let Some(state) = states.pop() {
        cur_state = state.clone();
        cur_state.player_hit_points -= 1;
        if cur_state.player_hit_points == 0 {
            continue;
        }
        if apply_effects(&mut cur_state, &effects).is_none() {
            min_mana_to_win = cur_state.spent_mana;
            break;
        };
        for spell in spells.iter() {
            cur_state_after_spell = cur_state.clone();
            if spell.mana_cost > cur_state_after_spell.remaining_mana {
                continue;
            }
            cur_state_after_spell.remaining_mana -= spell.mana_cost;
            cur_state_after_spell.spent_mana += spell.mana_cost;
            if let Some(effect_index) = spell.effect_index {
                if cur_state_after_spell.effects_timers[effect_index] > 0 {
                    continue;
                } else {
                    cur_state_after_spell.effects_timers[effect_index] = effects[effect_index].turns;
                }
            }
            cur_state_after_spell.player_hit_points += spell.hit_points;
            if cur_state_after_spell.boss_hit_points <= spell.damage {
                min_mana_to_win = cur_state_after_spell.spent_mana;
                break 'outer;
            }
            cur_state_after_spell.boss_hit_points -= spell.damage;
            if let Some(enhanced_armour) = apply_effects(&mut cur_state_after_spell, &effects) {
                damage_to_player = max(1, boss_damage - enhanced_armour);
                if damage_to_player < cur_state_after_spell.player_hit_points {
                    cur_state_after_spell.player_hit_points -= damage_to_player;
                    states.push(cur_state_after_spell);
                }
            } else {
                min_mana_to_win = cur_state_after_spell.spent_mana;
                break 'outer;
            }
        }
    }
    min_mana_to_win
}

pub fn solve(boss_stats: &str) {
    println!("--- Day 22: Wizard Simulator 20XX ---");
    println!("Part 1: {}", part_1(boss_stats));
    println!("Part 2: {}", part_2(boss_stats));
}
