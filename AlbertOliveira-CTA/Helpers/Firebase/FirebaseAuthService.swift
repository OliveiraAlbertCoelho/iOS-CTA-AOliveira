//
//  FirebaseAuthService.swift
//  AlbertOliveira-CTA
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import Foundation
import FirebaseAuth
import Firebase

class FirebaseAuthService {
    static let manager = FirebaseAuthService()
    private let auth = Auth.auth()
    
    var currentUser: User? {
        return auth.currentUser
    }
    
    
    func CreateAuthUser(email: String, password: String, completion:@escaping (Result<User,Error>) -> ()) {
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let createdUser = result?.user{
                completion(.success(createdUser))
            }else if let error = error {
                completion(.failure(error))
            }
        }
    }
    func loginUser(email: String, password: String, completion: @escaping (Result<(), Error>) -> ()) {
           auth.signIn(withEmail: email, password: password) { (result, error) in
               if let user = result?.user {
                   print(user)
                   completion(.success(()))
               } else if let error = error {
                   completion(.failure(error))
               }
           }
       }
    func updateUserFields(experience: String ,  completion: @escaping (Result<(),Error>) -> ()){
           let changeRequest = auth.currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = experience
           changeRequest?.commitChanges(completion: { (error) in
               if let error = error {
                   completion(.failure(error))
               } else {
                   completion(.success(()))
               }
           })
       }
    func logOutUser(completion: @escaping (Result<(), Error>) -> ()){
        do {
            try  auth.signOut()
            completion(.success(()))
        }catch{
            completion(.failure(error))
        }
       
    }
    
}
