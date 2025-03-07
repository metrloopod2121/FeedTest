//
//  PostCell.swift
//  FeedTest
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 06.03.2025.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20 // закругление аватарки
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 1
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = .black
        return button
    }()

    private let commentButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bubble.right"), for: .normal)
        button.tintColor = .black
        return button
    }()

    private let shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowshape.turn.up.right"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(dateLabel)
        
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        likeButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false

        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Аватарка
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10), // Отступ слева
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // Отступ сверху
            avatarImageView.widthAnchor.constraint(equalToConstant: 40), // Фиксированная ширина
            avatarImageView.heightAnchor.constraint(equalToConstant: 40), // Фиксированная высота
            
            // Заголовок поста
            titleLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10), // Отступ от аватарки
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10), // Отступ сверху
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10), // Отступ справа
            
            // Текст поста
            bodyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor), // Левый край совпадает с заголовком
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5), // Отступ от заголовка
            bodyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor), // Правый край совпадает с заголовком
            
            // Дата
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor), // Левый край совпадает с заголовком
            dateLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 5), // Отступ от текста
            
            // Кнопка лайка
            likeButton.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor), // Левый край совпадает с заголовком
            likeButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10), // Отступ от даты
            likeButton.widthAnchor.constraint(equalToConstant: 30), // Фиксированная ширина
            likeButton.heightAnchor.constraint(equalToConstant: 30), // Фиксированная высота

            // Кнопка комментариев
            commentButton.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 15), // Отступ от кнопки лайка
            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor), // Выравнивание по вертикали с кнопкой лайка
            commentButton.widthAnchor.constraint(equalToConstant: 30), // Фиксированная ширина
            commentButton.heightAnchor.constraint(equalToConstant: 30), // Фиксированная высота

            // Кнопка репоста
            shareButton.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 15), // Отступ от кнопки комментариев
            shareButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor), // Выравнивание по вертикали с кнопкой лайка
            shareButton.widthAnchor.constraint(equalToConstant: 30), // Фиксированная ширина
            shareButton.heightAnchor.constraint(equalToConstant: 30), // Фиксированная высота

            // Позволяет contentView подстроиться под контент
            shareButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10) // Отступ от нижнего края
        ])

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        bodyLabel.text = post.body
        dateLabel.text = formatDate(post.createDate)
        
        likeButton.isSelected = post.liked
        
        if let url = URL(string: post.avatarURL) {
            loadImage(from: url)
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
    
    private func loadImage(from url: URL) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.avatarImageView.image = image
                }
            }
        }
    }
    
    @objc private func likeButtonTapped() {
        likeButton.isSelected.toggle()
        likeButton.tintColor = .red
    }
}
