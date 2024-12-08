//
//  DiscogsApp.swift
//  Discogs
//
//  Created by Belen on 03/12/2024.
//

import SwiftUI

@main
struct DiscogsApp: App {
    init() {
        saveAPIKeyIfNeeded()
        saveAPISecretIfNeeded()
    }
    
    var body: some Scene {
        WindowGroup {
            SearchView()
        }
    }
    
    private func saveAPIKeyIfNeeded() {
        let keyExists = SecureStorage.shared.getFromKeychain(key: "APIKey") != nil
        if !keyExists {
            let apiKey = "fFiBcsvCXfTgrctbtrrk"
            let saved = SecureStorage.shared.saveToKeychain(key: "APIKey", value: apiKey)
            
            if saved {
                print("API Key saved to Keychain.")
            } else {
                print("Failed to save API Key to Keychain.")
            }
        } else {
            print("API Key already exists in Keychain.")
        }
    }
    
    private func saveAPISecretIfNeeded() {
        let keyExists = SecureStorage.shared.getFromKeychain(key: "APISecret") != nil
        if !keyExists {
            let apiSecret = "FvdYCTKkhHJTNbxJCJXpZQgofteFQIVH"
            let saved = SecureStorage.shared.saveToKeychain(key: "APISecret", value: apiSecret)
            
            if saved {
                print("API Key saved to Keychain.")
            } else {
                print("Failed to save API Key to Keychain.")
            }
        } else {
            print("API Key already exists in Keychain.")
        }
    }
}
