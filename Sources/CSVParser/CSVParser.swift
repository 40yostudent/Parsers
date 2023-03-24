public struct CSVParser {
    
// FSA for CSV parsing
//
//     ┌─sep─┐                        ┌!quo┐
//     │     │                        ▼    │
//     │  ╔════╗                   ┌────┐  │
//     ├─▶║ q1 ║────────quo───────▶│ q2 │──┘        q1: start field
//     │  ╚════╝                   └────┘           q2: scan quoted field
//     │     ▲                        │             q3: end scan quoted field
//   !sep    │         ╔════╗         │             q4: scan field
//   !quo  sep─────────║ q3 ║◀──────quo
//     │     │         ╚════╝
//     │  ╔════╗          │
//     └─▶║ q4 ║◀─┐       │        ┌────┐
//        ╚════╝  │       └!sep───▶│err │
//           │    │                └────┘
//           └!sep┘
//
    
    public func parse(_ input: String, separator: Character = ";") -> [[String]] {
        
        enum State {
            case q1, q2, q3, q4, err
        }
        
        func fsa(_ state: State, _ input: Character) -> State {
            var result = State.err
            
            switch state {
            case .q1:
                if input == separator {
                    result = .q1
                } else if input == "\"" {
                    result = .q2
                } else {
                    result = .q4
                }
            case .q2:
                if input != "\"" {
                    result = .q2
                } else {
                    result = .q3
                }
            case .q3:
                if input == separator {
                    result = .q1
                } else {
                    result = .err
                }
            case .q4:
                if input == separator {
                    result = .q1
                } else {
                    result = .q4
                }
            default:
                return .err
            }
            
            return result
        }
        
        var currentIndex = input.startIndex
        var currentState = State.q1
        var currentWord = ""
        var result: [[String]] = []
        
        // parse csv values
        var linenumber = 0
        while currentIndex < input.endIndex {
            result.append([String]())
            
            var endOfLine = false
            while !endOfLine && currentIndex < input.endIndex {
                let currentChar: Character = input[currentIndex]
                
                if currentChar == "\n" {
                    currentState = .q1
                    endOfLine = true
                } else {
                    currentState = fsa(currentState, currentChar)
                }
                
                switch currentState {
                case .q1:
                    result[linenumber].append(currentWord)
                    currentWord = ""
                case .q2:
                    currentWord.insert(currentChar, at: currentWord.endIndex)
                case .q3:
                    continue
                case .q4:
                    currentWord.insert(currentChar, at: currentWord.endIndex)
                default:
                    print(".err state reached")
                }
                
                currentIndex = input.index(after: currentIndex)
            }
            
            linenumber += 1
        }
        
        if currentState == .q2 {
            fatalError("End of file reached before closing quotes")
        }
        result[linenumber-1].append(currentWord) // QUESTO FA SCHIFO
        return result
    }
}
