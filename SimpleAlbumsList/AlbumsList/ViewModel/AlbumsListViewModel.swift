import Combine
import Foundation

class AlbumsListViewModel: ObservableObject {
  private let repository: AlbumsListRepository
  
  @Published private(set) var products = [Album]()
  @Published private(set) var error: GetAlbumsError?
  
  init(repository: AlbumsListRepository) {
    self.repository = repository
  }

  func loadProducts() {
    Task {
      do {
        products = try await repository.getAlbums()
      } catch is GetAlbumsError {
        self.error = error
      }
    }
  }
}
