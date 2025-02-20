//
//  CoinTableViewCell.swift
//  Equity-Bank-Assessment
//
//  Created by El-Moatasem on 20/02/2025.
//

import UIKit

class CoinTableViewCell: UITableViewCell {

    static let reuseIdentifier = "CoinTableViewCell"

    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()
    private let changeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(coin: Coin) {
        nameLabel.text = coin.name
        priceLabel.text = String(format: "$%.2f", coin.priceValue)

        let changeValue = coin.changeValue
        changeLabel.text = String(format: "%.2f%%", changeValue)
        changeLabel.textColor = changeValue >= 0 ? .systemGreen : .systemRed

        // Asynchronously load icon
        iconImageView.image = nil
        if let url = URL(string: coin.iconUrl), coin.iconUrl.hasPrefix("http") {
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    self.iconImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }

    private func setupUI() {
        // Configure subviews
        iconImageView.contentMode = .scaleAspectFit
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        priceLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        changeLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        changeLabel.textAlignment = .right

        // If you want single line/truncate:
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        priceLabel.numberOfLines = 1
        priceLabel.lineBreakMode = .byTruncatingTail

        // If you want multiline wrapping:
        // nameLabel.numberOfLines = 0
        // priceLabel.numberOfLines = 0

        // Add subviews
        contentView.addSubview(iconImageView)
        contentView.addSubview(changeLabel)
        
        // Create a vertical stack for name & price
        let textStack = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        textStack.axis = .vertical
        textStack.spacing = 4
        textStack.alignment = .leading
        textStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(textStack)

        // Turn off autoresizing mask
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        changeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            // Icon constraints
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),

            // Change label on the right side
            changeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            changeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            // Give it a bit of a width so it won't get cut off
            changeLabel.widthAnchor.constraint(equalToConstant: 60),

            // Text stack
            textStack.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8),
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            // Force text stack to avoid overlapping the change label
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: changeLabel.leadingAnchor, constant: -8)
        ])
    }
}
