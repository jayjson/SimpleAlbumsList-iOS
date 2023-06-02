@testable import SimpleAlbumsList

final class MockAlbumsListRepository: AlbumsListRepository {
  static var fakeAlbums: [Album] = [
    Album(id: 0, userId: 1, title: "awesome album"),
    Album(id: 1, userId: 2, title: "cool album")
  ]
  
  func getAlbums() async throws -> [Album] {
    MockAlbumsListRepository.fakeAlbums
  }
}
