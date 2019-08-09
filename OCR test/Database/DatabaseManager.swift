//
//  DatabaseManager.swift
//  OCR test
//
//  Created by Maciej Madaj on 09/08/2019.
//

import Foundation
import CoreData

/// Object designed to access database with necessary calls to insert, delete object, as well as fetching results with NSFetchedResultsController
class DatabaseManager {
    static let shared = DatabaseManager()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "OCRResults")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in

            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    lazy var fetchedResultsController: NSFetchedResultsController<HistoryEntry> = {
        let managedContext = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<HistoryEntry>(entityName: "HistoryEntry")

        // Add Sort Descriptors
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]

        return NSFetchedResultsController<HistoryEntry>(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: "createdAt", cacheName: nil)
    }()

    @discardableResult
    func insertHistoryEntry(name: String, text: String, imageData: Data?) -> Bool {
        let managedContext = persistentContainer.viewContext
        let historyEntry = HistoryEntry(context: managedContext)
        historyEntry.createdAt = Date()
        historyEntry.imagePath = StoredImagesManager.shared.saveImage(image: imageData, name: name)
        historyEntry.text = text

        do {
            try managedContext.save()
        } catch {
            let nsError = error as NSError
            print("Unresolved error at saving after inserting \(nsError), \(nsError.userInfo)")
        }
        return true
    }

    @discardableResult
    func removeHistoryEntry(_ entry: HistoryEntry) -> Bool {
        let managedContext = persistentContainer.viewContext

        managedContext.delete(entry)

        do {
            if let path = entry.imagePath {
                StoredImagesManager.shared.deleteImage(imageLocation: path)
            }
            try managedContext.save()
            return true
        } catch {
            let nsError = error as NSError
            print("Unresolved error at saving after removing \(nsError), \(nsError.userInfo)")
            return false
        }
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error at saving context \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
