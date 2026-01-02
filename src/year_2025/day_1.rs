mod password;
mod rotation;

use password::Password;
pub fn solve_part_1(input: &str) -> u16 {
    Password::try_from(input).unwrap().0
}

pub fn solve_part_2(_input: &str) {
    todo!();
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = include_str!("../../inputs/2025/day_1.txt");

    #[test]
    fn given_input_when_solve_part_1_then() {
        let result = solve_part_1(INPUT);

        assert_eq!(1074, result);
    }
}
