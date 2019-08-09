//
//  StoredImagesManager.swift
//  OCR test
//
//  Created by Maciej Madaj on 09/08/2019.
//

import Foundation
import UIKit

class StoredImagesManager {
    static let shared = StoredImagesManager()

    private init() {}

    /// although possible, images will not be stored in database directly but in file system.
    /// This however requires _dynamic linking_ to file since documents directory changes in time
    func saveImage(image: Data?, name: String) -> String? {
        guard let path = currentPath() else {
            return nil
        }
        let rootFolder = path.appendingPathComponent("images")
        if !directoryExistsAtPath(rootFolder.path) {
            do {
                try FileManager.default.createDirectory(at: rootFolder, withIntermediateDirectories: false, attributes: nil)
            } catch {
                print("Could not create folder at path \(rootFolder.path)")
                return nil
            }
        }

        let url = rootFolder.appendingPathComponent("\(name).jpg")

        do {
            try image?.write(to: url)
            return "images/\(name).jpg"
        } catch {
            return nil
        }
    }

    func getProperImagePath(imageLocation: String) -> URL? {
        guard let path = currentPath() else {
            return nil
        }
        return path.appendingPathComponent(imageLocation)
    }

    @discardableResult
    func deleteImage(imageLocation: String) -> Bool {
        guard let url = getProperImagePath(imageLocation: imageLocation) else {
            return false
        }
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch {
            return false
        }
    }

    private func currentPath() -> URL? {
        guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        return path
    }

    fileprivate func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
