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
            switch (state, input) {
            case (.q1, separator):
                return .q1
            case (.q1, "\n"):
                return .q1
            case (.q1, "\""):
                return .q2
            case (.q1, _):
                return .q4
            case (.q2, "\""):
                return .q3
            case (.q2, _):
                return .q2
            case (.q3, separator):
                return .q1
            case (.q3, "\n"):
                return .q1
            case (.q3, _):
                return .err
            case (.q4, separator):
                return .q1
            case (.q4, "\n"):
                return .q1
            case (.q4, _):
                return .q4
            case (.err, _):
                return .err
            }
        }
        
        var currentIndex = input.startIndex
        var currentState = State.q1
        var currentWord = ""
        
        var result: [[String]] = []
        result.append([String]())
        
        var linenumber = 0
        
        while currentIndex != input.endIndex {
            
            let currentChar: Character = input[currentIndex]
            currentState = fsa(currentState, currentChar)
            
            switch currentState {
            case .q1:
                result[linenumber].append(currentWord)
                currentWord = ""
            case .q2:
                if currentChar != "\"" {
                    currentWord.insert(currentChar, at: currentWord.endIndex)
                }
            case .q3:
                break
            case .q4:
                currentWord.insert(currentChar, at: currentWord.endIndex)
            default:
                print(".err state reached")
            }
            
            if currentChar == "\n" {
                result.append([String]())
                linenumber += 1
            }
            
            currentIndex = input.index(after: currentIndex)
        }
        
        if currentWord.count > 0 {
            result[linenumber].append(currentWord)
        } // save the last word before the end of file, if the file ends with no "\n"
        
        if currentState == .q2 {
            fatalError("End of file reached before closing quotes")
        }
        
        return result
        
    }
}
