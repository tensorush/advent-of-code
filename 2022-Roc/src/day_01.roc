app "day_01"
    packages { pf: "https://github.com/roc-lang/basic-cli/releases/download/0.1.1/zAoiC9xtQPHywYk350_b7ust04BmWLW00sjb9ZPtSQk.tar.br" }
    imports [pf.Stdout, pf.Stderr, pf.Arg, pf.Path, pf.Task.{Task}, pf.File, pf.Program.{ Program }]
    provides [main] to pf

main : Program
main = Program.withArgs \args ->
    Stdout.line "--- Day 1: Calorie Counting ---"
    parser = Arg.str { long: "file", short: "f" } |> Arg.program { name: "inputs/day_01" }
    when Arg.parseFormatted parser args is
        Ok file ->
            solve file
        Err helpMenu ->
            Stderr.line helpMenu
            |> Program.exit 1

solve = \file ->
    task =
        input <- Path.fromStr file |> File.readUtf8 |> Task.await
        when parse input is
            Ok nums -> Task.succeed nums
            Err e -> Task.fail e

    Task.attempt task \res ->
        res
        |> Result.map (\data ->
            part1 data
            |> Task.await (\_ -> part2 data)
            |> Program.exit 0
        )
        |> Result.withDefault (Stderr.line "error!" |> Program.exit 1)

parse = \input ->
    Str.trim input |> Str.split "\n" |> List.mapTry Str.toU64

part1 = \nums ->
    walker = \{prev, sum}, next ->
        when P prev next is
            P (Some p) n ->
                sum1 = if n > p then sum + 1 else sum
                {prev: Some n, sum: sum1}
            P None n -> {prev: Some n, sum}

    totalSums =
        List.walk nums { prev: None, sum: 0 } walker
        |> .sum
        |> Num.toStr

    Stdout.line "Part 1: \(totalSums)"

part2 = \nums ->
    walker = \{last2, sum, prev}, last0 ->
        when Triple last0 last2 prev is
            Triple l0 (Both l1 l2) (Some prevSum) ->
                curSum = l0 + l1 + l2
                sum1 = if curSum > prevSum then sum + 1 else sum
                { last2: Both l0 l1, sum: sum1, prev: Some curSum }
            Triple l0 (Both l1 l2) _ ->
                {last2: Both l0 l1, sum, prev: Some (l0 + l1 + l2)}
            Triple l0 (One l1) _ ->
                {last2: Both l0 l1, sum, prev}
            Triple l0 None _ ->
                {last2: One l0, sum, prev}

    totalSums =
        List.walk nums { last2: None, sum: 0, prev: None } walker
        |> .sum
        |> Num.toStr

    Stdout.line "Part 2: \(totalSums)"
