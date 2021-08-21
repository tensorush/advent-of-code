mod days;

pub fn solve(day_number: u8) -> fn(&str) {
    return match day_number {
        1 => days::day_01::solve,
        2 => days::day_02::solve,
        3 => days::day_03::solve,
        4 => days::day_04::solve,
        5 => days::day_05::solve,
        6 => days::day_06::solve,
        7 => days::day_07::solve,
        8 => days::day_08::solve,
        9 => days::day_09::solve,
        10 => days::day_10::solve,
        11 => days::day_11::solve,
        12 => days::day_12::solve,
        13 => days::day_13::solve,
        14 => days::day_14::solve,
        15 => days::day_15::solve,
        16 => days::day_16::solve,
        17 => days::day_17::solve,
        18 => days::day_18::solve,
        19 => days::day_19::solve,
        20 => days::day_20::solve,
        21 => days::day_21::solve,
        22 => days::day_22::solve,
        23 => days::day_23::solve,
        24 => days::day_24::solve,
        25 => days::day_25::solve,
        _ => panic!("Failed to find solution for day: {}", day_number),
    };
}
