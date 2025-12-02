import file_streams/file_stream
import gleam/int
import gleam/io
import gleam/result
import gleam/string

pub fn main() -> Nil {
  let assert Ok(file) = file_stream.open_read("input.txt")

  file
  |> run(50, 0)
  |> int.to_string()
  |> io.println()
}

// Steps:
// Read Lines
// Parse
// Apply and keep count
//
// Use an actor for the recursion

fn run(file: file_stream.FileStream, count: Int, acc: Int) -> Int {
  case
    file
    |> file_stream.read_line()
    |> result.map(string.trim)
    |> result.map(decode(_, count))
  {
    Ok(#(new_count, to_add)) -> {
      new_count |> int.to_string() |> io.println()
      acc + to_add |> int.to_string() |> io.println()
      io.println("")

      run(file, new_count, acc + to_add)
    }
    Error(_) -> acc
  }
}

fn decode(msg: String, count: Int) -> #(Int, Int) {
  case msg {
    "L" <> n -> {
      let assert Ok(n) = int.parse(n)

      let assert Ok(new_count) =
        count - n
        |> int.modulo(100)

      let assert Ok(to_add) = case count {
        0 -> int.divide(n, 100)
        c -> {
          100 - c + n
          |> int.divide(100)
        }
      }

      #(new_count, to_add)
    }
    "R" <> n -> {
      let assert Ok(n) = int.parse(n)

      let assert Ok(new_count) =
        count + n
        |> int.modulo(100)

      let assert Ok(to_add) =
        count + n
        |> int.divide(100)

      #(new_count, to_add)
    }
    _ -> panic
  }
}
