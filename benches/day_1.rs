#![allow(
    unused_must_use,
    reason = "benchmark functions don't need to use return values"
)]

use advent_of_code::{solve_part_1, solve_part_2};

const INPUT: &str = include_str!("../inputs/2024/day_1.txt");

fn main() {
    divan::main();
}

#[divan::bench]
fn part_1() {
    solve_part_1(INPUT);
}

#[divan::bench]
fn part_2() {
    solve_part_2(INPUT);
}
