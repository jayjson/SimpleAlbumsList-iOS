import Combine
import SnapKit
import UIKit

class AlbumsListViewController: UIViewController {
    private let viewModel: AlbumsListViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: AlbumsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        setupSubscribers()
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupSubscribers() {
        viewModel.$albums
            .receive(on: DispatchQueue.main)
            .sink { [weak self] products in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let error = error else { return }
                self?.showErrorAlert(error: error)
            }
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadAlbums()
    }
    
    private func showErrorAlert(error: GetAlbumsError) {
        let alert = UIAlertController(title: "Error", message: error.alertDescription, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let cv = UICollectionView(frame: view.frame, collectionViewLayout: flowLayout)
        cv.register(AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.reuseId)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AlbumsListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.reuseId, for: indexPath) as! AlbumCell
        let album = viewModel.albums[indexPath.item]
        cell.configureCell(with: album)
        return cell
    }
}

extension AlbumsListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = view.frame.width
        return CGSize(width: cellWidth, height: 70)
    }
}
