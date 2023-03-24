import XCTest
@testable import CSVParser

final class CSVParserTests: XCTestCase {
    func testExample() throws {
        let testableCSV = """
        OPERA;AUTORE;CASA EDITRICE
        I Robot e l'Impero;Isaac Asimov;Mondadori
        Il lungo meriggio della Terra;Brian W. Aldiss;Minotauro
        Absolute OpenBSD - 2d Edition;Michael W. Lucas;No Starch Press
        I mercanti dello spazio;Frederik Pohl, C. M. Kornbluth;Mondadori
        """
        let testOutput = [["OPERA", "AUTORE", "CASA EDITRICE"],
                          ["I Robot e l\'Impero", "Isaac Asimov", "Mondadori"],
                          ["Il lungo meriggio della Terra", "Brian W. Aldiss", "Minotauro"],
                          ["Absolute OpenBSD - 2d Edition", "Michael W. Lucas", "No Starch Press"],
                          ["I mercanti dello spazio", "Frederik Pohl, C. M. Kornbluth", "Mondadori"]]
        XCTAssertEqual(CSVParser().parse(testableCSV), testOutput)
    }
//
//    func quotesTest() throws {
//        let testableCSV = """
//        OPERA;AUTORE;CASA EDITRICE
//        I Robot e l'Impero;Isaac Asimov;Mondadori
//        Il lungo meriggio della Terra;Brian W. Aldiss;Minotauro
//        "Absolute OpenBSD - 2d Edition";Michael W. Lucas;No Starch Press
//        I mercanti dello spazio;"Frederik Pohl; C. M. Kornbluth";Mondadori
//        """
//        let testOutput = [["OPERA", "AUTORE", "CASA EDITRICE"],
//                          ["I Robot e l'Impero", "Il lungo meriggio della Terra", "Absolute OpenBSD - 2d Edition", "I mercanti dello spazio"],
//                          ["Isaac Asimov", "Brian W. Aldiss", "Michael W. Lucas", "Frederik Pohl; C. M. Kornbluth"],
//                          ["Mondadori", "Minotauro", "No Starch Press", "Mondadori"]]
//        XCTAssertEqual(CSVParser().parse(testableCSV), testOutput)
//    }
//
//    func doubleQuotesTest() throws {
//        let testableCSV = """
//        OPERA;AUTORE;CASA EDITRICE
//        I Robot e l'Impero;Isaac Asimov;Mondadori
//        Il lungo meriggio della Terra;Brian W. Aldiss;Minotauro
//        "Absolute OpenBSD "2d Edition"";Michael W. Lucas;No Starch Press
//        I mercanti dello spazio;"Frederik Pohl; C. M. Kornbluth";Mondadori
//        """
//        let testOutput = [["OPERA", "AUTORE", "CASA EDITRICE"],
//                          ["I Robot e l'Impero", "Il lungo meriggio della Terra", "Absolute OpenBSD \"2d Edition\"", "I mercanti dello spazio"],
//                          ["Isaac Asimov", "Brian W. Aldiss", "Michael W. Lucas", "Frederik Pohl; C. M. Kornbluth"],
//                          ["Mondadori", "Minotauro", "No Starch Press", "Mondadori"]]
//        XCTAssertEqual(CSVParser().parse(testableCSV), testOutput)
//    }
}
