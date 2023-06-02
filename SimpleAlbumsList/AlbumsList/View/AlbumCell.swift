import SnapKit
import UIKit

class AlbumCell: UICollectionViewCell {
  static let reuseId = "AlbumCell"
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    setupSubivews()
  }

  private func setupSubivews() {
    let stackView = UIStackView(arrangedSubviews: [idAndTitleLabel, adminInfoLabel])
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    contentView.addSubview(stackView)
    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(10)
    }
  }
  
  func configureCell(with album: Album) {
      idAndTitleLabel.text = "Album \(album.id): \(album.title)"
      adminInfoLabel.text = "Admin: User\(album.userId)"
  }
  
  lazy var idAndTitleLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 18)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  lazy var adminInfoLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
