@testable import SimpleAlbumsList
import Combine
import XCTest

final class AlbumsListViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws {}
    
    override func tearDownWithError() throws {
        cancellables.removeAll()
    }
    
    func testInitializer() {
        // given
        let repository = MockAlbumsListRepository()
        
        // when
        let albumsListViewModel = AlbumsListViewModel(repository: repository)
        
        // then
        XCTAssertTrue(albumsListViewModel.albums.isEmpty)
        XCTAssertNil(albumsListViewModel.error)
    }
    
    func testLoadAlbums_whenLoadingAlbumsSuccessfully_shouldSetAlbumsWithCorrectData() throws {
        // given
        let exp = expectation(description: "load albums")
        let fakeAlbums: [Album] = [
            Album(id: 0, userId: 1, title: "awesome album"),
            Album(id: 1, userId: 2, title: "cool album")
        ]
        let repository = MockAlbumsListRepository(albums: fakeAlbums)
        let albumsListViewModel = AlbumsListViewModel(repository: repository)
        albumsListViewModel.$albums
            .sink { albums in
                guard albums.isEmpty == false else { return }
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        // when
        albumsListViewModel.loadAlbums()
        
        // then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertEqual(albumsListViewModel.albums, fakeAlbums)
            XCTAssertNil(albumsListViewModel.error)
        }
    }
    
    func testLoadAlbums_whenLoadingAlbumsUnsuccessfully_shouldSetError() throws {
        // given
        let exp = expectation(description: "load albums")
        let fakeError = GetAlbumsError.noInternetConnection
        let repository = MockAlbumsListRepository(error: fakeError)
        let albumsListViewModel = AlbumsListViewModel(repository: repository)

        albumsListViewModel.$error
            .compactMap { $0 }
            .sink { _ in
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        // when
        albumsListViewModel.loadAlbums()
        
        // then
        waitForExpectations(timeout: 1) { _ in
            XCTAssertTrue(albumsListViewModel.albums.isEmpty)
            XCTAssertEqual(albumsListViewModel.error, fakeError)
        }
    }
}
