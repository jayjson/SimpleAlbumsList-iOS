@testable import SimpleAlbumsList

final class MockAlbumsListRepository: AlbumsListRepository {
    private var fakeAlbums: [Album]
    private var error: GetAlbumsError?

    init(albums: [Album] = [], error: GetAlbumsError? = nil) {
        self.fakeAlbums = albums
        self.error = error
    }
    
    func getAlbums() async throws -> [Album] {
        if let error = error {
            throw error
        } else {
            return fakeAlbums
        }
    }
}
