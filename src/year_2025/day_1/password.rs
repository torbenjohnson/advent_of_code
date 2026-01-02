use super::rotation::Rotation;
use winnow::Parser as _;
use winnow::combinator::{repeat, terminated};

#[derive(Debug, displaydoc::Display, thiserror::Error, PartialEq)]
pub enum PasswordError {
    /// error
    Error,
}

#[derive(Debug, PartialEq)]
pub struct Password(pub u16);

impl TryFrom<&str> for Password {
    type Error = PasswordError;
    fn try_from(input: &str) -> Result<Self, PasswordError> {
        Ok(repeat(1.., terminated(Rotation::parse, '\n'))
            .fold(
                || (50_u8, 0_u16),
                |(position, count), rotation: Rotation| {
                    let new_position = rotation.apply(position);
                    let new_count = if new_position == 0 { count + 1 } else { count };
                    (new_position, new_count)
                },
            )
            .map(|(_, count)| Self(count))
            .parse(input)
            .unwrap())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn given_string_when_parse_then_password() {
        let input = "L68\nL30\nR48\nL5\nR60\nL55\nL1\nL99\nR14\nL82\n";

        let password = Password::try_from(input).unwrap();

        assert_eq!(Password(3), password);
    }
}
