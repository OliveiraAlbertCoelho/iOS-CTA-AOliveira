//
//  Search.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation
import UIKit
class SearchVC: UIViewController {
    
    var thingsData = [ThingsProtocol](){
        didSet{
            thingsTable.reloadData()
        }
    }
    var favoriteThingsId = [String]()
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getFavorites(handleComplete: self.thingsTable.reloadData)
    }
    //MARK: - Controller Variables
    var userInfo: AppUser?{
        didSet{
            navigationItem.title = self.userInfo?.experience
        }
    }
    
    //MARK: - UI Objects
    lazy var eventSearchBar: UISearchBar = {
        let search = UISearchBar()
        search.delegate = self
      search.isHidden = false
        return search
    }()
    //MARK: - Regular Functions
    private func setUpView(){
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = logOutButton
    }
    private func setUpConstraints(){
        constrainSearchBar()
        constrainCollectionView()
    }
    
    private func getFavorites(handleComplete: (()->())?){
        FirestoreService.manager.getFavorites(forUserID: userInfo!.uid) { (result) in
            DispatchQueue.main.async {
                switch result{
                case .failure(let error):
                    print(error)
                case .success(let things):
                    self.favoriteThingsId = things.map{
                        return $0.favoriteId
                    }
                    if let handle = handleComplete?(){
                        handle
                    }
                }
            }
        }
    }
    
    private func loadData(userInput: String){
        if userInfo?.experience == "Rijksmuseum"{
            FetchRijksmuseum.manager.getArtData(author: userInput) { (result) in
                DispatchQueue.main.async {
                    switch result{
                    case .failure(let error):
                        print(error)
                    case .success(let art):
                        self.thingsData = art
                    }
                }}
        }else {
      
    FetchTicketMaster.manager.getTicketsData(city: userInput) { (result) in
                  DispatchQueue.main.async {
                      switch result{
                      case .failure(let error):
                          print(error)
                      case .success(let event):
                          self.thingsData = event
                      }
                  }
            }}}
    //MARK: - UI Objects
    lazy var logOutButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOut))
        return button
    }()
    lazy var thingsTable: UITableView = {
        let layout = UITableView()
        layout.register(ThingsCell.self, forCellReuseIdentifier: "searchCell")
        layout.backgroundColor = .white
        layout.delegate = self
        layout.dataSource = self
        return layout
    }()
    
    
    //MARK: - Objc Functions
    @objc func logOut(){
        FirebaseAuthService.manager.logOutUser { (result) in
            switch result{
            case .success(()):
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                    else {
                        return
                }
                UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                    window.rootViewController = LoginVC()
                }, completion: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //MARK: - Constraints
    private func constrainSearchBar(){
        view.addSubview(eventSearchBar)
        eventSearchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventSearchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            eventSearchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            eventSearchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            eventSearchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func constrainCollectionView(){
        view.addSubview(thingsTable)
        thingsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thingsTable.topAnchor.constraint(equalTo: eventSearchBar.bottomAnchor, constant: 0),
            thingsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            thingsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            thingsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
            
        ])
    }
}
//MARK: - UITableView Delegates

extension SearchVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
     print("ah")
        return thingsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = thingsTable.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? ThingsCell else {return UITableViewCell()}
        let data = self.thingsData[indexPath.row]
        cell.delegate = self
        cell.favoriteButton.tag = indexPath.row//set button tag
        cell.mainInfoLabel.text = data.mainInfo
        cell.additionalInfoLabel.text = data.addInfo
        if cell.thingsImage.image == nil{//only display flicker if no image is loaded
            cell.flicker.startAnimating()
        }
        if self.favoriteThingsId.contains(data.ThingsId){// set the the like button on and off
            cell.isFavorited = true}
        else{
            cell.isFavorited = false}
        if let image = ImageHelper.shared.image(forKey: data.imageUrl as NSString) {
            cell.thingsImage.image = image
            cell.flicker.stopAnimating()
            cell.flicker.isHidden = true
        } else {
            ImageHelper.shared.fetchImage(urlString: data.imageUrl) { (result) in
                DispatchQueue.main.async {
                    switch result{
                    case .failure(_):
                        cell.thingsImage.image = UIImage(named: "notFound")
                    case .success(let newImage):
                        cell.thingsImage.image = newImage
                        
                    }
                    cell.flicker.stopAnimating()
                    cell.flicker.isHidden = true
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let selected = thingsTable.cellForRow(at: indexPath) as? ThingsCell else {return}
        let data = thingsData[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? DetailVC else {return}
        vc.things = data
        vc.userInfo = userInfo
        vc.isFavorited = selected.isFavorited
        self.navigationController!.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(150)
    }
}

//MARK: - SearchBar Delegate
extension SearchVC: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text{
            loadData(userInput: search)
        }
    }
}
extension SearchVC: ButtonFunction {
    func FavAction(sender: UIButton) {
        getFavorites(handleComplete: nil )
        sender.isEnabled = false
        guard let user = userInfo else {return}
        let selectedIndex = IndexPath(row: sender.tag, section: 0)
        let selected = thingsTable.cellForRow(at: selectedIndex ) as! ThingsCell
        let data = thingsData[sender.tag]
        if favoriteThingsId.contains(data.ThingsId){
            DispatchQueue.main.async {
                FirestoreService.manager.getThingID(forUserID: user.uid, forObjectId: data.ThingsId) {
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
                                selected.isFavorited = false
                                self.favoriteThingsId.removeAll {$0 == data.ThingsId}
                            }
                        }
                    }}}}else {
            DispatchQueue.main.async {
                let data = self.thingsData[sender.tag]
                let favoriteThing = FavoriteThings(creatorID: user.uid, dateCreated: Date(), imageUrl: data.imageUrl, mainInfo: data.mainInfo, addInfo: data.addInfo, experience: user.experience, favoriteId: data.ThingsId)
                FirestoreService.manager.storeFavorite(thing: favoriteThing) { (result) in
                    switch result{
                    case .failure(let error):
                        print(error)
                    case .success(()):
                        sender.isEnabled = true
                        selected.isFavorited = true
                    }
                }
            }
        }
    }
}
