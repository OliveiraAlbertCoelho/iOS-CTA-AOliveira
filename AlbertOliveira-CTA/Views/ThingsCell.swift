//
//  ThingsCollectionViewCell.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class ThingsCell: UITableViewCell {
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpContentView()
     }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
override func prepareForReuse() {
    super.prepareForReuse()
    thingsImage.image = nil
}

    var isFavorited = false{
        didSet{
            if self.isFavorited{
            favoriteButton.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
                 }else {
            favoriteButton.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)}
        }
    }
    weak var delegate: ButtonFunction?
 //MARK: - UI Objects
    lazy var thingsImage: UIImageView = {
       let image = UIImageView()
        return image
    }()
    lazy var mainInfoLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    lazy var additionalInfoLabel: UILabel = {
      let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    lazy var favoriteButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.addTarget(self, action: #selector(FavAction), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    lazy var stackView: UIStackView = {
       let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 5
        stackview.distribution = .fillEqually
        return stackview
    }()
    lazy var flicker: UIActivityIndicatorView = {
        let flicker = UIActivityIndicatorView()
        flicker.tintColor = .white
        flicker.color = .black
        return flicker
    }()
    
  //MARK: - Regular Functions
    private func setUpContentView(){
        constrainImage()
        constrainFavButton()
        constraintStackView()
       
    }
     //MARK: - objc Functions
    @objc func FavAction (){
        delegate?.FavAction(sender: favoriteButton)
    }
    
    
 //MARK: - Constraints
    private func constrainImage(){
         contentView.addSubview(thingsImage)
        thingsImage.addSubview(flicker)
         thingsImage.translatesAutoresizingMaskIntoConstraints = false
         NSLayoutConstraint.activate([
             thingsImage.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
             thingsImage.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 0),
             thingsImage.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
             thingsImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.30)
         ])
        flicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flicker.centerXAnchor.constraint(equalTo: thingsImage.centerXAnchor, constant: 0),
            flicker.centerYAnchor.constraint(equalTo: thingsImage.centerYAnchor, constant: 0)
        
        
        ])
     }
    private func constraintStackView(){
           stackView.addArrangedSubview(mainInfoLabel)
           stackView.addArrangedSubview(additionalInfoLabel)
           contentView.addSubview(stackView)
           stackView.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               stackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
               stackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
               stackView.leadingAnchor.constraint(equalTo: thingsImage.trailingAnchor, constant: 0),
               stackView.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: 0)
           ])}
        private func constrainFavButton(){
            contentView.addSubview(favoriteButton)
            favoriteButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                favoriteButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
                favoriteButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 0),
                favoriteButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                favoriteButton.widthAnchor.constraint(equalToConstant: 50)
            ])
        }
    }

