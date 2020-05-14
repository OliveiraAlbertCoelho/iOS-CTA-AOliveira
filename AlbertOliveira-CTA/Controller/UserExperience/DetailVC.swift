//
//  DetailVC.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation
import UIKit
class DetailVC: UIViewController {
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingFlicker.startAnimating()
        setUpLikeButton()
        SetUpView()
    }
    //MARK: - Controller variables
    var things: ThingsProtocol!
    var artInfo: ArtObject?{
        didSet{
            setUpArtDetail()
        }
    }
    var userInfo: AppUser?
    var isFavorited = false
    //MARK: - IBOutlet Variables
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var loadingFlicker: UIActivityIndicatorView!
    @IBOutlet weak var likeButtonOut: UIButton!
    
    
    //MARK: - IBAction Function
    @IBAction func likeButton(_ sender: UIButton) {
        getUserInfo()
        guard let user = userInfo else {return}
        sender.isEnabled = false
        if isFavorited{
            DispatchQueue.main.async {
                FirestoreService.manager.getThingID(forUserID: user.uid, forObjectId: self.things.ThingsId) {
                    (result) in
                    switch result{
                    case .failure(let error):
                        print(error)
                    case .success(let thing):
                        guard let thingID = thing.first?.id else {return }
                        FirestoreService.manager.deleteFavorite(id: thingID) { (result) in
                            switch result{
                            case .failure(let error):
                                print(error)
                            case .success(()):
                                sender.isEnabled = true
                                self.isFavorited = false
                                self.setUpLikeButton()
                            }
                        }
                    }}}}else {
            DispatchQueue.main.async {
                let favoriteThing = FavoriteThings(creatorID: user.uid, dateCreated: Date(), imageUrl: self.things.imageUrl, mainInfo: self.things.mainInfo, addInfo: self.things.addInfo, experience: user.experience, favoriteId: self.things.ThingsId)
                FirestoreService.manager.storeFavorite(thing: favoriteThing) { (result) in
                    switch result{
                    case .failure(let error):
                        print(error)
                    case .success(()):
                        self.isFavorited = true
                        sender.isEnabled = true
                         self.setUpLikeButton()
                    }
                }
            }
        }
    }
    
    //MARK: - Regular Functions
    
    private func SetUpView(){
        getImage()
        switch userInfo?.experience{
        case "Rijksmuseum":
            loadArtDetail()
          setUpViewForArt()
        default:
            setUpTicketdetail()
        }
    }
    private func setUpViewForArt(){
        guard let artInfo = things as? ArtObjects else {return}
        nameLabel.text = artInfo.longTitle
        loadArtDetail()
    }
    private func setUpArtDetail(){
        guard let artDetail = artInfo else{return
            descriptionTextField.text = "Description not found"
        }
        descriptionTextField.text = "Maker:\(artDetail.plaqueDescriptionEnglish ?? " ")\n\n\(artDetail.datingFormat)\n\n\(artDetail.placeFormat)\n\n\(artDetail.plaqueFormatDescript)"
    }
    private func setUpLikeButton(){
        if isFavorited {
            likeButtonOut.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        }else {
         
            likeButtonOut.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        }
    }
    private func setUpTicketdetail(){
         nameLabel.text = things.mainInfo
         guard let ticketInfo = things as? EventInfo else {return}
         descriptionTextField.text = "Date:\(ticketInfo.dateFormat)\n\n\(ticketInfo.priceFormat)\n\nPurchase: \(ticketInfo.url)"
     }

    private func loadArtDetail(){
        FetchRijksmuseum.manager.getArtDetailData(objectNum: things.ThingsId) { (result) in
            DispatchQueue.main.async {
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let object):
                    self.artInfo = object
                }
              
            }
        }
    }
    private func getImage(){
        if let image = ImageHelper.shared.image(forKey: (things.imageUrl as NSString)) {
            eventImage.image = image
            self.loadingFlicker.stopAnimating()
            self.loadingFlicker.isHidden = true
        }else {
        ImageHelper.shared.fetchImage(urlString: things.imageUrl) { (result) in
            DispatchQueue.main.async {
                switch result{
                case .failure(let error):
                    print(error)
                     self.loadingFlicker.stopAnimating()
                    self.loadingFlicker.isHidden = true
                    self.eventImage.image = UIImage(named: "notFound")
                case .success(let image):
                    self.eventImage.image = image
                    self.loadingFlicker.stopAnimating()
                    self.loadingFlicker.isHidden = true
                }
            }
            }}}
    private func getUserInfo(){
        guard let user = userInfo else {return}
        FirestoreService.manager.getUserInfo(id: user.uid) { (result) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let user):
                self.userInfo = user
            }
        }
    }
    
}
