import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        
        let m = image.count
        if m == 0 { return [[]] }
        let n = image[0].count

        var tempImage = image
        let oldColor = tempImage[row][column]
        
        var queue = [[row,column]]
        while queue.count > 0 {
            let item = queue.removeFirst()
            let i = item[0]
            let j = item[1]
            tempImage[i][j] = newColor
            
            manageQueue(&queue, tempImage, i, j + 1, m, n, oldColor, newColor)
            manageQueue(&queue, tempImage, i, j - 1, m, n, oldColor, newColor)
            manageQueue(&queue, tempImage, i + 1, j, m, n, oldColor, newColor)
            manageQueue(&queue, tempImage, i - 1, j, m, n, oldColor, newColor)
        }
        return tempImage
    }

    func manageQueue(_ queue:inout[[Int]], _ image: [[Int]],
                     _ i: Int, _ j: Int , _ m: Int, _ n: Int,
                      _ oldColor: Int, _ newColor: Int) {

        if  i < 0 || i >= m || j < 0 || j >= n ||
        image[i][j] != oldColor || image[i][j] == newColor
            {
            return
        }
        queue.append([i,j])
    }
}
