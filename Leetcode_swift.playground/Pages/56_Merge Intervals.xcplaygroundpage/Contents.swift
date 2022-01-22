// Given an array of intervals where intervals[i] = [starti, endi], merge all overlapping intervals, and return an array of the non-overlapping intervals that cover all the intervals in the input.
//
// Example 1:
//
// Input: intervals = [[1,3],[2,6],[8,10],[15,18]]
// Output: [[1,6],[8,10],[15,18]]
// Explanation: Since intervals [1,3] and [2,6] overlaps, merge them into [1,6].
// Example 2:
//
// Input: intervals = [[1,4],[4,5]]
// Output: [[1,5]]
// Explanation: Intervals [1,4] and [4,5] are considered overlapping.
//
//
// Constraints:
//
// 1 <= intervals.length <= 104
// intervals[i].length == 2
// 0 <= starti <= endi <= 104


// First direct solution
//
// Time: O(n*log(n))
// Space: O(n)

class Solution1 {
    
    func merge(_ intervals: [[Int]]) -> [[Int]] {
        
        guard intervals.count > 1 else {
            return intervals
        }
        
        let sortedIntervals = intervals.sorted { // O(n*log(n))
            
            guard
                let firstItemOfFirst = $0.first,
                let firstItemOfLast = $1.first else { return true }
            
            return firstItemOfFirst < firstItemOfLast
            
        }
        
        var counter = 0
        var previousInterval = sortedIntervals[0]
        var finalIntervals = [[Int]]()
        finalIntervals.reserveCapacity(sortedIntervals.count)
        
        while counter != sortedIntervals.count { // O(n)
            
            if counter <= sortedIntervals.count - 2 {
                
                let secondInterval = sortedIntervals[counter + 1]
                
                if
                    let firstPreviousItem = previousInterval.first,
                    let firstSecondItem = secondInterval.first,
                    let endPreviousItem = previousInterval.last,
                    let endSecondItem = secondInterval.last,
                    endPreviousItem >= firstSecondItem || firstSecondItem <= firstPreviousItem
                {
                    
                    previousInterval = [
                        min(firstPreviousItem, firstSecondItem),
                        max(endPreviousItem, endSecondItem)
                    ]
                    
                } else {
                    
                    finalIntervals.append(previousInterval)
                    previousInterval = secondInterval
                    
                }
                
            } else {
                
                finalIntervals.append(previousInterval)
                
            }
            
            counter += 1
            
        }
        
        return finalIntervals
        
    }
    
}

// Second short solution
//
// Time: O(n*log(n))
// Space: O(n)

class Solution2 {
    
    func merge(_ intervals: [[Int]]) -> [[Int]] {
        guard intervals.count > 1 else { return intervals }
        
        let sorted = intervals.sorted {$0[0] < $1[0]}
        
        var results = [[Int]]()
        results.reserveCapacity(sorted.count)
        results.append(sorted[0])
        
        for i in 1..<sorted.count {
            let prevStart = results.last![0]
            let prevEnd = results.last![1]
            
            let currentStart = sorted[i][0]
            let currentEnd = sorted[i][1]
            
            if prevEnd >= currentStart {
                if prevEnd > currentEnd {
                    results.removeLast()
                    results.append([prevStart, prevEnd])
                } else {
                    results.removeLast()
                    results.append([prevStart, currentEnd])
                }
            } else {
                results.append([currentStart, currentEnd])
            }
        }
        
        return results
    }
    
}

let array1 = [[1,3],[2,6],[8,10],[15,18]]                                               // result [[1,6],[8,10],[15,18]]
let array2 = [[1,4],[4,5]]                                                              // result [[1,5]]
let array3 = [[2,3],[2,2],[3,3],[1,3],[5,7],[2,2],[4,6]]                                // result [[1,3],[4,7]]
let array4 = [[2,3],[4,5],[6,7],[8,9],[1,10]]                                           // result [[1,10]]
let array5 = [[0,0],[1,2],[5,5],[2,4],[3,3],[5,6],[5,6],[4,6],[0,0],[1,2],[0,2],[4,5]]  // result [[0,6]]

print(Solution1().merge(array1))
print(Solution2().merge(array5))
