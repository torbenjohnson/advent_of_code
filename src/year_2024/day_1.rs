#[must_use]
pub fn solve_part_1(input: &str) -> u32 {
    let (list_1, list_2) = parse_input_to_lists(input);
    calculate_lists_distance(list_1, list_2)
}

fn calculate_lists_distance(mut list_1: Vec<u32>, mut list_2: Vec<u32>) -> u32 {
    list_1.sort_unstable();
    list_2.sort_unstable();

    list_1
        .iter()
        .zip(list_2.iter())
        .map(|(a, b)| a.abs_diff(*b))
        .sum()
}

#[must_use]
pub fn solve_part_2(input: &str) -> u32 {
    let (list_1, list_2) = parse_input_to_lists(input);
    calculate_lists_similarity(list_1, list_2)
}

fn calculate_lists_similarity(list_1: Vec<u32>, list_2: Vec<u32>) -> u32 {
    let result: u32 = list_1
        .iter()
        .map(|element_1| {
            list_2.iter().fold(0, |acc, element_2| {
                if element_1 == element_2 {
                    acc + element_1
                } else {
                    acc
                }
            })
        })
        .sum();

    result
}

fn parse_input_to_lists(input: &str) -> (Vec<u32>, Vec<u32>) {
    input
        .lines()
        .filter_map(|line| {
            let mut parts = line.split_whitespace();
            let part1 = parts.next()?.parse::<u32>().ok()?;
            let part2 = parts.next()?.parse::<u32>().ok()?;
            Some((part1, part2))
        })
        .unzip()
}

#[cfg(test)]
mod tests {
    use super::*;

    const INPUT: &str = include_str!("../../inputs/2024/day1.txt");

    fn given_lists() -> (Vec<u32>, Vec<u32>) {
        let list_1: Vec<u32> = vec![3, 4, 2, 1, 3, 3];
        let list_2: Vec<u32> = vec![4, 3, 5, 3, 9, 3];

        (list_1, list_2)
    }

    #[test]
    fn given_input_when_solve_part_1_then() {
        let result = solve_part_1(INPUT);

        assert_eq!(result, 1834060)
    }

    #[test]
    fn given_input_when_solve_part_2_then() {
        let result = solve_part_2(INPUT);

        assert_eq!(result, 21607792);
    }

    #[test]
    fn given_lists_when_calculate_similarity_when_calculate_lists_distance_then_correct_output() {
        let (list_1, list_2) = given_lists();

        let result = calculate_lists_similarity(list_1, list_2);

        assert_eq!(result, 31);
    }

    #[test]
    fn given_lists_when_calculate_distance_when_calculate_lists_distance_then_correct_output() {
        let (list_1, list_2) = given_lists();

        let result = calculate_lists_distance(list_1, list_2);

        assert_eq!(result, 11);
    }

    #[test]
    fn given_two_positve_integer_when_absolute_difference_then_correct_value() {
        let a: u32 = 1;
        let b: u32 = 3;

        let result = a.abs_diff(b);

        assert_eq!(result, 2);
    }
}
