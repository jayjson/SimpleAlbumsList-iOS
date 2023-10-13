@testable import SimpleAlbumsList
import XCTest

final class AlbumsListRepositoryImpTests: XCTestCase {
    let albumsUrlString = "https://jsonplaceholder.typicode.com/albums"
    
    var mockSession: MockURLSession!
    
    override func setUpWithError() throws {
        mockSession = MockURLSession()
    }
    
    override func tearDownWithError() throws {
        mockSession = nil
    }
    
    func testGetAlbums_successfulCase() async throws {
        // given
        let mockSession = MockURLSession()
        let jsonString = """
            [
              {
                "userId": 1,
                "id": 1,
                "title": "album1"
              },
              {
                "userId": 1,
                "id": 2,
                "title": "album2"
              }
            ]
            """
        mockSession.data = jsonString.data(using: .utf8)!
        mockSession.response = HTTPURLResponse(url: URL(string: albumsUrlString)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let repository = AlbumsListRepositoryImp(session: mockSession)
        let expectedAlbums = [
            Album(id: 1, userId: 1, title: "album1"),
            Album(id: 2, userId: 1, title: "album2")
        ]
        
        // when
        let albums = try await repository.getAlbums()
        
        // then
        XCTAssertEqual(albums, expectedAlbums)
    }

    func testGetAlbums_invalidURLError() async {
        // given
        let repository = AlbumsListRepositoryImp(session: MockURLSession(), urlString: "_https:/ /jsonplaceholder.typicode.com/albums")

        // when, then
        do {
            _ = try await repository.getAlbums()
            XCTFail("Expected to catch a invalidUrl error but did not")
        } catch GetAlbumsError.invalidUrl {
            // success
        } catch {
            XCTFail("Expected to catch a invalidUrl error but did not")
        }
    }
    
    func testGetAlbums_unknownError() async {
        // given
        let mockSession = MockURLSession()
        mockSession.error = NSError()
        let repository = AlbumsListRepositoryImp(session: mockSession)

        // when, then
        do {
            _ = try await repository.getAlbums()
            XCTFail("Expected to catch an unknown error but did not")
        } catch GetAlbumsError.unknown {
            // success
        } catch {
            XCTFail("Expected to catch an unknown error but did not")
        }
    }
    
    func testGetAlbums_noInternetConnectionError() async {
        // given
        let mockSession = MockURLSession()
        mockSession.error = URLError(.notConnectedToInternet)
        let repository = AlbumsListRepositoryImp(session: mockSession)

        // when, then
        do {
            _ = try await repository.getAlbums()
            XCTFail("Expected to catch a noInternetConnection error but did not")
        } catch GetAlbumsError.noInternetConnection {
            // success
        } catch {
            XCTFail("Expected to catch a noInternetConnection error but did not")
        }
    }
    
    func testGetAlbums_timeoutError() async {
        // given
        let mockSession = MockURLSession()
        mockSession.error = URLError(.timedOut)
        let repository = AlbumsListRepositoryImp(session: mockSession)

        // when, then
        do {
            _ = try await repository.getAlbums()
            XCTFail("Expected to catch a timeout error but did not")
        } catch GetAlbumsError.timeout {
            // success
        } catch {
            XCTFail("Expected to catch a timeout error but did not")
        }
    }
    
    func testGetAlbums_badResponseError() async {
        // given
        let mockSession = MockURLSession()
        let jsonString = "[]"
        mockSession.data = jsonString.data(using: .utf8)!
        mockSession.response = HTTPURLResponse(url: URL(string: albumsUrlString)!, statusCode: 400, httpVersion: nil, headerFields: nil)
        let repository = AlbumsListRepositoryImp(session: mockSession)

        // when, then
        do {
            _ = try await repository.getAlbums()
            XCTFail("Expected to catch a badResponse error but did not")
        } catch GetAlbumsError.badResponse {
            // success
        } catch {
            XCTFail("Expected to catch a badResponse error but did not")
        }
    }
    
    func testGetAlbums_decodeError() async throws {
        // given
        let mockSession = MockURLSession()
        let incorrectIdTypeString = """
            [
              {
                "userId": 1,
                "id": "1",
                "title": "album1"
              },
              {
                "userId": 1,
                "id": "2",
                "title": "album2"
              }
            ]
            """
        mockSession.data = incorrectIdTypeString.data(using: .utf8)!
        mockSession.response = HTTPURLResponse(url: URL(string: albumsUrlString)!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let repository = AlbumsListRepositoryImp(session: mockSession)

        // when, then
        do {
            _ = try await repository.getAlbums()
            XCTFail("Expected to catch a decodeError error but did not")
        } catch GetAlbumsError.decodeError {
            // success
        } catch {
            XCTFail("Expected to catch a decodeError error but did not")
        }
    }
}
