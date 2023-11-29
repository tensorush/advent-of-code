#lang racket/base

(require racket/file)

(define nums (map string->number (file->lines "inputs/day_01.txt")))

(display "--- Day 1: Report Repair ---\n")

(display "Part 1: ")

(for*/first ((i nums)
             (j nums)
             #:when (= 2020 (+ i j)))
    (* i j))

(display "Part 2: ")

(for*/first ((i nums)
             (j nums)
             (k nums)
             #:when (= 2020 (+ i j k)))
    (* i j k))
