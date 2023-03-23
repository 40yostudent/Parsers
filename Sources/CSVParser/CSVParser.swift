public struct CSVParser {
    
// FSA for CSV parsing
// states:
// q1: start field
// q2: scan quoted field
// q3: end scan quoted field
// q4: scan field
//
//     ┌─sep─┐                        ┌!quo┐
//     │     │                        ▼    │
//     │  ╔════╗                   ┌────┐  │
//     ├─▶║ q1 ║────────quo───────▶│ q2 │──┘
//     │  ╚════╝                   └────┘
//     │     ▲                        │
//   !sep    │         ╔════╗         │
//   !quo  sep─────────║ q3 ║◀──────quo
//     │     │         ╚════╝
//     │  ╔════╗          │
//     └─▶║ q4 ║◀─┐       │        ┌────┐
//        ╚════╝  │       └!sep───▶│err │
//           │    │                └────┘
//           └!sep┘
//
    
    public func parse(_ input: String, separator: Character = ";", headings: Bool = false) -> [String : [String]] {
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
        var result: [String : [String]] = [:]
        
        // parse headings
        // TODO: check id headings == true
        var endOfLine = false
        while !endOfLine {
            let currentChar: Character = input[currentIndex]
            currentState = fsa(currentState, currentChar)
            
            switch currentState {
            case .q1:
                result[currentWord] = []
                currentWord = ""
            case .q2:
                currentWord.insert(currentChar, at: currentWord.endIndex)
            case .q3:
                continue
            case .q4:
                currentWord.insert(currentChar, at: currentWord.endIndex)
            default:
                fatalError(".err state reached")
            }
            
            currentIndex = input.index(after: currentIndex)
            if input[currentIndex] == "\n" {
                endOfLine = true
            }
        }
        
        // parse csv values
        // while not endoffile...
        // while not endofline...
        // add values to the corresponding arrays
        
        return result
    }

//    public func parse(_ input: String) -> [String : [String]] {
//        // prendi la prima riga e fai le intestazioni
//        let separator: Character = ";" // TODO: this should be set as a CSV property while initializing the parser
//        var currentIndex = input.startIndex
//        var currentWord = ""
//        var headings = [String]()
//    firstLine: while currentIndex != input.endIndex {
//        let currentChar: Character = input[currentIndex]
//
//        switch currentChar {
//        case separator:
//            headings.append(currentWord)
//            currentWord = ""
//            continue firstLine
//        case "\n":
//            break firstLine
//        case "\"":
//            // wait for another one
//        default:
//            currentWord.insert(currentChar, at: currentWord.endIndex)
//        }
//
//            currentIndex = input.index(after: currentIndex)
//        }
//
//        // components è in foundation, si prova a fare characters uno alla volta. Usare FSA.
//
//        // vai ciclicamente sulle altre righe e riempi gli arrays
//    }
}
