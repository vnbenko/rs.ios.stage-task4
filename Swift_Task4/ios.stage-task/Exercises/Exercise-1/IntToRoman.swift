import Foundation

public extension Int {
    
    var roman: String? {
        if self <= 0 || self > 3999 {
            return nil
        }
        
        let dictionaryInt = [
            100: "C", 400: "CD", 500: "D", 900: "CM", 1000: "M",
            10: "X", 40: "XL", 50: "L", 90: "XC",
            1: "I", 4: "IV", 5: "V", 9: "IX"].sorted(by: >)
        
        var int = self
        var roman = ""
        
        for dict in dictionaryInt {
            while int >= dict.key {
                roman += dict.value
                int -= dict.key
            }
        }
        return roman
    }
}



