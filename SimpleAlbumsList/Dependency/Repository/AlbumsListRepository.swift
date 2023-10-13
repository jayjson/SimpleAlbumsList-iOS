protocol AlbumsListRepository {
    func getAlbums() async throws -> [Album]
}
