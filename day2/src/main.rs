use std::{fs, ops::RangeInclusive};

const FILE_NAME: &str = "input.txt";

fn main() {
    let input = fs::read_to_string(FILE_NAME).unwrap();

    let ans = input
        .trim()
        .split(",")
        .map(str_to_range)
        .flatten()
        .fold(0, |acc, l| {
            let lstr = l.to_string();
            let n = lstr.len();
            if is_invalid(lstr, n) { acc + l } else { acc }
        });

    dbg!(ans);
}

fn str_to_range(r: &str) -> RangeInclusive<u64> {
    let ends = r
        .split("-")
        .map(str::parse::<u64>)
        .map(Result::unwrap)
        .collect::<Vec<_>>();
    (ends[0]..=ends[1]).into_iter()
}

fn is_invalid(s: String, n: usize) -> bool {
    for i in 1..=(n / 2) {
        let r = n / i;
        if r * i != n {
            continue;
        }
        let mut invalid = true;
        for j in 1..r {
            if s[0..i] != s[(i * j)..(i * (j + 1))] {
                invalid = false;
            }
        }

        if invalid {
            dbg!(s);
            return true;
        }
    }

    false
}
