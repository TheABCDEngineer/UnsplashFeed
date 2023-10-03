import Foundation

final class DateConverter {
    static let shared = DateConverter()
    private let dateFormatter = DateFormatter()
   
    
    func date(from string: String) -> Date? {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return dateFormatter.date(from: string)
    }
    
    func string(from date: Date?) -> String {
        guard let date = date else { return "" }
        dateFormatter.dateFormat = "dd MMMM YYYY"
        return dateFormatter.string(from: date)
    }
}
