// Q7. Gas Station (EV Delivery Loop Start)
// Source: book/part-viii/35-heaps-tries-greedy.md
package ch35.q07_gas_station

fun canCompleteCircuit(gas: IntArray, cost: IntArray): Int {
    var total = 0
    var tank = 0
    var start = 0
    for (i in gas.indices) {
        val diff = gas[i] - cost[i]
        total += diff
        tank += diff
        if (tank < 0) { // nothing in start..i can be the answer
            start = i + 1
            tank = 0
        }
    }
    return if (total >= 0) start else -1
}
