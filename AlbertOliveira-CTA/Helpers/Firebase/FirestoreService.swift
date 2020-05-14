//
//  FirestoreService.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FireStoreCollections: String {
    case users
    case favorite
}

class FirestoreService {
    static let manager = FirestoreService()
    private let db = Firestore.firestore()
    
    //MARK: AppUsers
    func SaveUser(user: AppUser, completion: @escaping (Result<(), Error>) -> ()) {
        var fields = user.fieldsDict
        fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.users.rawValue).document(user.uid).setData(fields) { (error) in
            if let error = error {
                completion(.failure(error))
                print(error)
            }
            completion(.success(()))
        }
    }
    func saveUserPreferences(experience: String, completion: @escaping (Result<(),Error>) ->()){
        guard let userId = FirebaseAuthService.manager.currentUser?.uid else {
            return
        }
        var updateFields = [String:Any]()
        updateFields["experience"] = experience
        db.collection(FireStoreCollections.users.rawValue).document(userId).updateData(updateFields) { (error) in
                   if let error = error {
                       completion(.failure(error))
                   } else {
                       completion(.success(()))
                   }
               }
    }
    func getUserInfo(id: String,  completion: @escaping (Result<AppUser,Error>) -> ()) {
               db.collection(FireStoreCollections.users.rawValue).document(id).getDocument { (snapshot, error)  in
                   if let error = error {
                       completion(.failure(error))
                   } else if let snapshot = snapshot,
                       let data = snapshot.data() {
                       let userID = snapshot.documentID
                       let user = AppUser(from: data, id: userID)
                       if let appUser = user {
                           completion(.success(appUser))
                       }
                   }
               }
           }
    func storeFavorite(thing: FavoriteThings,  completion: @escaping (Result<(),Error>) -> ()) {
        var fields = thing.fieldsDict
             fields["dateCreated"] = Date()
        db.collection(FireStoreCollections.favorite.rawValue).addDocument(data: fields) { (error) in
                 if let error = error {
                     completion(.failure(error))
                 } else {
                     completion(.success(()))
                 }
             }
         }
    func getFavorites(forUserID: String, completion: @escaping (Result<[FavoriteThings], Error>) -> ()) {
        db.collection(FireStoreCollections.favorite.rawValue).whereField("creatorID", isEqualTo: forUserID).getDocuments { (snapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let favorites = snapshot?.documents.compactMap({ (snapshot) -> FavoriteThings? in
                    let favoriteId = snapshot.documentID
                    let fav = FavoriteThings(from: snapshot.data(), id: favoriteId)
                    return fav
                })
                completion(.success(favorites ?? []))
            }
        }
    }
    func getThingID(forUserID: String, forObjectId: String, completion: @escaping (Result<[FavoriteThings], Error>) -> ()) {
        db.collection(FireStoreCollections.favorite.rawValue).whereField("creatorID", isEqualTo: forUserID).whereField("favoriteId", isEqualTo: forObjectId).getDocuments{ (snapshot, error) in
               if let error = error {
                   completion(.failure(error))
               } else {
                   let favorites = snapshot?.documents.compactMap({ (snapshot) -> FavoriteThings? in
                       let favoriteId = snapshot.documentID
                       let fav = FavoriteThings(from: snapshot.data(), id: favoriteId)
                       return fav
                   })
                   completion(.success(favorites ?? []))
               }
           }
       }
    
    func deleteFavorite(id:String,  completion: @escaping (Result<(),Error>) -> ()) {
        print(id)
        db.collection(FireStoreCollections.favorite.rawValue).document(id).delete { (error) in
            if let error = error {
                completion(.failure(error))
 
            } else {
                completion(.success(()))
             
            }
        }
}
    private init () {}
}


//    delete function that takes in id and post id and deletes it in one go
//    func newDeleteFavorite(id:String, postId: String,  completion: @escaping (Result<(),Error>) -> ()) {
//         db.collection(FireStoreCollections.favorite.rawValue).whereField("creatorID", isEqualTo: id).whereField("favoriteId", isEqualTo: postId).getDocuments{ (snapshot, error) in
//                      if let error = error {
//                          completion(.failure(error))
//                      } else {
//                          let favorites = snapshot?.documents.compactMap({ (snapshot) -> String? in
//                              let favoriteId = snapshot.documentID
//                              let fav = FavoriteThings(from: snapshot.data(), id: favoriteId)
//                            return fav?.id
//                          })
//                        guard let favo = favorites else {return}
//                for i in favo{
//    self.db.collection(FireStoreCollections.favorite.rawValue).document(i).delete()
//                            }
//            }
//            completion(.success(()))
//                      }
//                  }



