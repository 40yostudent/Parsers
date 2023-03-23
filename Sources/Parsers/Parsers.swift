import CSVParser

public struct Parsers {
    public enum FileType {
        case csv, json, xml, jsonfeed, rss
    }
    
    private let fileType: FileType

    public init(fileType: FileType) {
        self.fileType = fileType
    }
}
