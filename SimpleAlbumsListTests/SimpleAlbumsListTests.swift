@testable import SimpleAlbumsList
import XCTest

final class SimpleAlbumsListTests: XCTestCase {
    var albumsListViewModel: AlbumsListViewModel!
    
    override func setUpWithError() throws {
        let repository = MockAlbumsListRepository()
        albumsListViewModel = AlbumsListViewModel(repository: repository)
    }
    
    override func tearDownWithError() throws {
        albumsListViewModel = nil
    }
    
    func testInitializingViewModel() {
        XCTAssertTrue(albumsListViewModel.albums.isEmpty)
        XCTAssertNil(albumsListViewModel.error)
    }
    
    func testGettingAlbums() async throws {
        // given
        // when
        await albumsListViewModel.loadAlbums()
        
        // then
        XCTAssertEqual(albumsListViewModel.albums, MockAlbumsListRepository.fakeAlbums)
        XCTAssertNil(albumsListViewModel.error)
    }
}
