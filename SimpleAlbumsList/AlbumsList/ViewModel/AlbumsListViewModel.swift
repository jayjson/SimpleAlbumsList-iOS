import Combine
import Foundation

class AlbumsListViewModel: ObservableObject {
  private let repository: AlbumsListRepository
  
    @Published private(set) var albums = [Album]() {
        didSet {
            print("value updated: \(albums)")
        }
    }
  @Published private(set) var error: GetAlbumsError?
  
  init(repository: AlbumsListRepository) {
    self.repository = repository
  }

  func loadAlbums() async {
      do {
        let fetchedAlbums = try await repository.getAlbums()
        albums = fetchedAlbums
      } catch is GetAlbumsError {
        self.error = error
      } catch {
          let errorMessage = "Unexpected error occured: \(error)"
          assertionFailure(errorMessage)
      }
    }
}
