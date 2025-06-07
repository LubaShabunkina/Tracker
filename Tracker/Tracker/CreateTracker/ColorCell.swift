import UIKit

final class ColorCell: UICollectionViewCell {
    private let colorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 26 // половина от 52 (itemSize)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(colorView)

        NSLayoutConstraint.activate([
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            colorView.widthAnchor.constraint(equalToConstant: 52),
            colorView.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setColor(_ color: UIColor, isSelected: Bool) {
        colorView.backgroundColor = color
        colorView.layer.borderWidth = isSelected ? 3 : 0
        colorView.layer.borderColor = isSelected ? UIColor.black.cgColor : nil
    }
}
