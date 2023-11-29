import math, os, strutils

when isMainModule:
  var fuelTotal = 0
  var fuelAllTotal = 0
  for line in lines(getCurrentDir() / "inputs" / "day_01.txt"):
    var mass = line.parseInt()
    fuelTotal.inc calculateFuel(mass)
    fuelAllTotal.inc calculateAllFuel(mass)

  echo("--- Day 1: The Tyranny of the Rocket Equation ---")
  echo("Part 1: ", fuelTotal)
  echo("Part 2: ", fuelAllTotal)

proc calculateFuel(mass: int): int =
  floor(mass / 3).int - 2

proc calculateAllFuel(mass: int): int =
  var lastFuel = mass
  while true:
    lastFuel = calculateFuel(lastFuel)
    if lastFuel <= 0:
      break
    result.inc(lastFuel)

when defined(test):
  doAssert calculateFuel(12) == 2
  doAssert calculateFuel(14) == 2
  doAssert calculateFuel(1969) == 654
  doAssert calculateFuel(100756) == 33583
  doAssert calculateAllFuel(12) == 2
  doAssert calculateAllFuel(1969) == 966
  doAssert calculateAllFuel(100756) == 50346
