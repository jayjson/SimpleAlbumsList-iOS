import Foundation

enum GetAlbumsError: Error, Equatable {
    case invalidUrl
    case couldNotPerform
    case noInternetConnection
    case timeout
    case badResponse(String)
    case decodeError
    case unknown
    
    var alertDescription: String {
        switch self {
        case .invalidUrl:
            return "An invalid URL was used."
        case .couldNotPerform:
            return "Failed to perform the networking function."
        case .noInternetConnection:
            return "No internet connection."
        case .timeout:
            return "Timeout."
        case .badResponse(let reason):
            return "A bad response was received. Reason: \(reason)"
        case .decodeError:
            return "The return data could not be decoded."
        case .unknown:
            return "An unknown error occured."
        }
    }
}
