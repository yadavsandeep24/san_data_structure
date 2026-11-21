// Q7. Gas Station (EV Delivery Loop Start)
// Source: book/part-viii/35-heaps-tries-greedy.md

func canCompleteCircuit(_ gas: [Int], _ cost: [Int]) -> Int {
    var total = 0, tank = 0, start = 0
    for i in gas.indices {
        let diff = gas[i] - cost[i]
        total += diff
        tank += diff
        if tank < 0 { // nothing in start...i can be the answer
            start = i + 1
            tank = 0
        }
    }
    return total >= 0 ? start : -1
}
