//
//  FavoriteVC.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import UIKit

class FavoriteVC: UIViewController {
    
    //MARK: - ViewLifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
          self.getFavorites()
    }
    //MARK: - Controller Variables
    var userInfo: AppUser?{
        didSet{
            navigationItem.title = "Favorites"
        }
    }
    var thingsData = [FavoriteThings](){
         didSet{
             thingsTable.reloadData()
         }
     }
    
    //MARK: - Regular Functions
    private func setUpView(){
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = logOutButton
    }
    private func setUpConstraints(){
        constrainCollectionView()
    }
    private func getFavorites(){
        FirestoreService.manager.getFavorites(forUserID: userInfo!.uid) { (result) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(let things):
                self.thingsData = things
            }
        }
    }
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
    
    
//    MARK: - Objc Functions
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
    private func constrainCollectionView(){
        view.addSubview(thingsTable)
        thingsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thingsTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            thingsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            thingsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            thingsTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            
        ])
    }
}
//MARK: - TableViewDelegate
extension FavoriteVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thingsData.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard  let cell = thingsTable.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as? ThingsCell else  {return UITableViewCell()}
        let data = thingsData[indexPath.row]
        cell.delegate = self
        cell.isFavorited = true
        cell.favoriteButton.tag = indexPath.row
        cell.mainInfoLabel.text = data.mainInfo
        cell.additionalInfoLabel.text = data.addInfo
        guard let stringImage = data.imageUrl else {return  cell}
        if let image = ImageHelper.shared.image(forKey: stringImage as NSString) {
                cell.thingsImage.image = image
                cell.flicker.stopAnimating()
                cell.flicker.isHidden = true
            } else {
                ImageHelper.shared.fetchImage(urlString: stringImage) { (result) in
                        DispatchQueue.main.async {
                    switch result{
                    case .failure(_):
                        cell.thingsImage.image = UIImage(named: "notFound")
                    case .success(let newImage):
                        cell.thingsImage.image = newImage
                        cell.flicker.stopAnimating()
                        cell.flicker.isHidden = true
                    }
                }
                    }}
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }
}
//MARK: - Button Delegate
extension FavoriteVC: ButtonFunction{
    func FavAction(sender: UIButton) {
        print("work")
        sender.isEnabled = false
        DispatchQueue.main.async {
            FirestoreService.manager.deleteFavorite(id: self.thingsData[sender.tag].id) { (result) in
            switch result{
            case .failure(let error):
                print(error)
            case .success(()):
            self.getFavorites()
            sender.isEnabled = true
            }
        }
        }
    }
}
