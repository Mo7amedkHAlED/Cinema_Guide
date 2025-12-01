//
//  FavouritesManager.swift
//  CinemaGuide
//
//  Created by Mohamed Khaled Gomaa on 30/11/2025.
//


import Foundation
import RxSwift

class FavoritesRepoImple: FavoritesRepoProtocol {
    
    private let fileName = "favourites.json"
    
    private var fileURL: URL? {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?
            .appendingPathComponent(fileName)
    }
    
    // Get all favourite IDs
    func getFavourites() -> Observable<Set<Int>> {
        return Observable.create { [weak self] observer in
            guard let self = self,
                  let fileURL = self.fileURL else {
                observer.onNext([])
                observer.onCompleted()
                return Disposables.create()
            }
            
            do {
                let fileData = try Data(contentsOf: fileURL)
                let favourites = try JSONDecoder().decode(Set<Int>.self, from: fileData)
                observer.onNext(favourites)
                observer.onCompleted()
            } catch {
                // If file doesn't exist or can't be read, return empty set
                observer.onNext([])
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    // Toggle favourite status
    func toggleFavourite(id: Int) -> Observable<Bool> {
        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onError(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Self is nil"]))
                return Disposables.create()
            }
            
            // Get current favourites
            let disposable = self.getFavourites()
                .subscribe(onNext: { favourites in
                    var updatedFavourites = favourites
                    
                    // Toggle the favourite
                    if updatedFavourites.contains(id) {
                        updatedFavourites.remove(id)
                    } else {
                        updatedFavourites.insert(id)
                    }
                    
                    // Save updated favourites
                    self.saveFavourites(updatedFavourites)
                    
                    // Return the new state
                    let isFavourite = updatedFavourites.contains(id)
                    observer.onNext(isFavourite)
                    observer.onCompleted()
                }, onError: { error in
                    observer.onError(error)
                })
            
            return Disposables.create {
                disposable.dispose()
            }
        }
    }
    
    // Check if movie is favourite
    func isFavourite(id: Int) -> Observable<Bool> {
        return getFavourites()
            .map { favourites in
                favourites.contains(id)
            }
    }
    
    // Private save method
    private func saveFavourites(_ favourites: Set<Int>) {
        guard let fileURL = fileURL else { return }
        
        do {
            let jsonData = try JSONEncoder().encode(favourites)
            try jsonData.write(to: fileURL)
        } catch {
            print("Error writing favourites to file: \(error)")
        }
    }
}
