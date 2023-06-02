import Foundation

class AlbumsListRepositoryImp: AlbumsListRepository {
    private static let urlString = "https://jsonplaceholder.typicode.com/albums"
    
    func getAlbums() async throws -> [Album] {
        guard let url = URL(string: AlbumsListRepositoryImp.urlString) else {
            throw GetAlbumsError.invalidUrl
        }
        let data: Data
        let urlResponse: URLResponse
        do {
            let result = try await URLSession.shared.data(from: url)
            data = result.0
            urlResponse = result.1
        } catch {
            guard let error = error as? URLError else { throw GetAlbumsError.unknown }
            if error.code == .timedOut {
                throw GetAlbumsError.timeout
            } else if error.code == .notConnectedToInternet {
                throw GetAlbumsError.noInternetConnection
            } else {
                throw GetAlbumsError.badResponse(error.localizedDescription)
            }
        }
        guard let response = urlResponse as? HTTPURLResponse else { throw GetAlbumsError.unknown }
        guard response.statusCode == 200 else {
            throw GetAlbumsError.badResponse("Received a \(response.statusCode) response.")
        }
        let decoder = JSONDecoder()
        guard let fetchedProducts = try? decoder.decode([Album].self, from: data) else {
            throw GetAlbumsError.decodeError
        }
        return fetchedProducts
    }
}
