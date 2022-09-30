function solve()
    grid_serial_number = 5468
    println("--- Day 11: Chronal Charge ---")
    println("Part 1: $(findLargestFuelCellTopLeft(grid_serial_number, true))")
    println("Part 2: $(findLargestFuelCellTopLeft(grid_serial_number, false))")
end

function findLargestFuelCellTopLeft(grid_serial_number, is_part1)
    power_level = computePowerLevel.(1:300, (1:300)', grid_serial_number)
    fuel_cells = cumsum(power_level, dims=1)
    function findLargestFuelCell(side_len)
        y_fuel_cells = fuel_cells[side_len:end, :]
        y_fuel_cells[2:end, :] .-= fuel_cells[1:end-side_len, :]
        y_fuel_cells = cumsum(y_fuel_cells, dims=2)
        x_fuel_cells = y_fuel_cells[:, side_len:end]
        x_fuel_cells[:, 2:end] .-= y_fuel_cells[:, 1:end-side_len]
        findmax(x_fuel_cells)
    end
    if is_part1
        largest_fuel_cell = findLargestFuelCell(3)
        string(largest_fuel_cell[2][1], ",", largest_fuel_cell[2][2])
    else
        largest_fuel_cell = findLargestFuelCell.(1:300)
        largest_size = argmax(first.(largest_fuel_cell))
        string(largest_fuel_cell[largest_size][2][1], ",", largest_fuel_cell[largest_size][2][2], ",", largest_size)
    end
end

function computePowerLevel(x, y, grid_serial_number)
    rack_id = x + 10
    power_level = (rack_id * y + grid_serial_number) * rack_id
    mod(power_level ÷ 100, 10) - 5
end

solve()
