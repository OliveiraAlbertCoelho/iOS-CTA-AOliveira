//
//  AlbertOliveira_CTATests.swift
//  AlbertOliveira-CTATests
//
//  Created by albert coelho oliveira on 12/2/19.
//  Copyright © 2019 albert coelho oliveira. All rights reserved.
//

import XCTest
@testable import AlbertOliveira_CTA

class AlbertOliveira_CTATests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testArtDetailModel(){
        guard let jsonPath = Bundle.main.path(forResource: "ArtDetailJsonModel", ofType: "json") else {
                XCTFail("Could not find ArtDetailJsonModel.json file")
                return
            }
            
            let jsonURL = URL(fileURLWithPath: jsonPath)
            var artJSONData = Data()
            
            do {
                artJSONData = try Data(contentsOf: jsonURL)
            } catch {
                XCTFail("\(error)")
            }
            
            // Act
        var artObjects: ArtObject?
            
            do {
                let artInfo = try ArtDetailModel.decodeArtObjects(from: artJSONData)
                artObjects = artInfo
            } catch {
                XCTFail("\(error)")
            }
            
            // Assert
        XCTAssertTrue(artObjects!.title == "The Night Watch" )
        }
 func testArtModel(){
        guard let jsonPath = Bundle.main.path(forResource: "ArtJsonModel", ofType: "json") else {
                XCTFail("Could not find ArtDetailJsonModel.json file")
                return
            }
            
            let jsonURL = URL(fileURLWithPath: jsonPath)
            var artJSONData = Data()
            
            do {
                artJSONData = try Data(contentsOf: jsonURL)
            } catch {
                XCTFail("\(error)")
            }
            
            // Act
        var artObjects = [ArtObjects]()
            
            do {
                let artInfo = try Rijksmuseum.decodeArtObjects(from: artJSONData)
                artObjects = artInfo
            } catch {
                XCTFail("\(error)")
            }
            
            // Assert
    XCTAssertTrue(artObjects.count == 10, "Was expecting 10 venues, but found \(artObjects.count)")
        }
    
    
    
}

