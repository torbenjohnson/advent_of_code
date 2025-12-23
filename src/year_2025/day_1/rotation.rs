use winnow::{
    Parser as _,
    ascii::dec_uint,
    combinator::{alt, fail, preceded},
};

#[derive(PartialEq, Eq, Debug)]
pub struct Rotation(i16);

impl Rotation {
    pub fn parse(input: &mut &str) -> winnow::Result<Self> {
        alt((
            preceded('L', dec_uint.map(|x: u16| x.cast_signed())),
            preceded('R', dec_uint.map(|x: u16| -x.cast_signed())),
            fail,
        ))
        .map(Self)
        .parse_next(input)
    }

    pub fn apply(self, position: u8) -> u8 {
        u8::try_from((i16::from(position) + self.0).rem_euclid(100))
            .expect("modulo 100 should always fit in a u8")
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use rstest::rstest;

    #[rstest]
    #[case("L68", Rotation(68))]
    #[case("R48", Rotation(-48))]
    #[case("L1", Rotation(1))]
    fn given_string_when_parse_then_rotation(#[case] input: &str, #[case] expected: Rotation) {
        let mut input = input;

        let rotation = Rotation::parse(&mut input).unwrap();

        assert_eq!(expected, rotation);
    }

    #[rstest]
    #[case("100")]
    #[case("algcraoeui")]
    #[case("L")]
    #[case("L-40")]
    #[case("R-40")]
    fn given_string_when_parse_then_error(#[case] input: &str) {
        let mut input = input;

        Rotation::parse(&mut input).unwrap_err();
    }
}
