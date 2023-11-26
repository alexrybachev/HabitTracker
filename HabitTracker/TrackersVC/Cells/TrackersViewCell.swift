//
//  TrackersViewCell.swift
//  HabitTracker
//
//  Created by Aleksandr Rybachev on 26.11.2023.
//

import UIKit

final class TrackersViewCell: UICollectionViewCell {
    
    static let cellID = String(describing: TrackersViewCell.self)
    
    // MARK: - UI Elements
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = "😎"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var trackerName: UILabel = {
        let label = UILabel()
        label.text = "trackerName"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "dayLabel"
        label.font = .boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stakcView = UIStackView()
        stakcView.axis = .horizontal
        stakcView.translatesAutoresizingMaskIntoConstraints = false
        return stakcView
    }()
    
    private var isTapped = false
    
    // MARK: - Initial
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setViews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setViews() {
        contentView.addSubview(background)
        contentView.addSubview(stackView)
        
        background.addSubview(emojiLabel)
        background.addSubview(trackerName)
        
        stackView.addArrangedSubview(dayLabel)
        stackView.addArrangedSubview(button)
        
        button.addTarget(self, action: #selector(trackerButtonTapped), for: .touchUpInside)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            background.topAnchor.constraint(equalTo: contentView.topAnchor),
            background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            background.bottomAnchor.constraint(equalTo: stackView.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: background.topAnchor, constant: 10),
            emojiLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            
            trackerName.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 10),
            trackerName.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -10),
            trackerName.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - OBJC Methods

extension TrackersViewCell {
    
    @objc private func trackerButtonTapped() {
        isTapped.toggle()
        let image = UIImage(systemName: isTapped ? "plus.circle.fill" : "checkmark.circle.fill")
        button.setImage(image, for: .normal)
    }
    
}
