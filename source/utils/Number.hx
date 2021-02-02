package utils;

class Number {
    public static function format(number:Int, numDigits = 2, fillWith = "0"):String {
        var numStr = '${[for (_ in 0...numDigits - 1) fillWith].join("")}$number';
        return numStr.substring(numStr.length - numDigits);
    }
}
