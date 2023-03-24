import XCTest
@testable import CSVParser

final class CSVParserTests: XCTestCase {
    func testBasicCSV() throws {
        let testableCSV = """
        A;B;C
        1;2;3
        4;5;6
        """
        let testOutput = [["A", "B", "C"], ["1", "2", "3"], ["4", "5", "6"]]
        XCTAssertEqual(CSVParser().parse(testableCSV), testOutput)
    }
    
    func testSimpleCSV() throws {
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
    
    func testBasicQuotedCSV() throws {
        let testableCSV = """
        A;B;C
        "1";2;3
        4;"5";6
        """
        let testOutput = [["A", "B", "C"], ["1", "2", "3"], ["4", "5", "6"]]
        XCTAssertEqual(CSVParser().parse(testableCSV), testOutput)
    }

    func testQuotedCSV() throws {
        let testableCSV = """
        OPERA;AUTORE;CASA EDITRICE
        I Robot e l'Impero;Isaac Asimov;Mondadori
        Il lungo meriggio della Terra;Brian W. Aldiss;Minotauro
        "Absolute OpenBSD - 2d Edition";Michael W. Lucas;No Starch Press
        I mercanti dello spazio;"Frederik Pohl; C. M. Kornbluth";Mondadori
        """
        let testOutput = [["OPERA", "AUTORE", "CASA EDITRICE"],
                          ["I Robot e l\'Impero", "Isaac Asimov", "Mondadori"],
                          ["Il lungo meriggio della Terra", "Brian W. Aldiss", "Minotauro"],
                          ["Absolute OpenBSD - 2d Edition", "Michael W. Lucas", "No Starch Press"],
                          ["I mercanti dello spazio", "Frederik Pohl; C. M. Kornbluth", "Mondadori"]]
        XCTAssertEqual(CSVParser().parse(testableCSV), testOutput)
    }

    func testDoubleQuotedCSV() throws {
        let testableCSV = """
        OPERA;AUTORE;CASA EDITRICE
        I Robot e l'Impero;Isaac Asimov;Mondadori
        Il lungo meriggio della Terra;Brian W. Aldiss;Minotauro
        "Absolute OpenBSD "2d Edition"";Michael W. Lucas;No Starch Press
        I mercanti dello spazio;"Frederik Pohl; C. M. Kornbluth";Mondadori
        """
        let testOutput = [["OPERA", "AUTORE", "CASA EDITRICE"],
                          ["I Robot e l\'Impero", "Isaac Asimov", "Mondadori"],
                          ["Il lungo meriggio della Terra", "Brian W. Aldiss", "Minotauro"],
                          ["Absolute OpenBSD \"2d Edition\"", "Michael W. Lucas", "No Starch Press"],
                          ["I mercanti dello spazio", "Frederik Pohl; C. M. Kornbluth", "Mondadori"]]
        XCTAssertEqual(CSVParser().parse(testableCSV), testOutput)
    }
}
