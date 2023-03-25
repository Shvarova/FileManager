//
//  FileManagerService.swift
//  FileManager
//
//  Created by Дина Шварова on 25.03.2023.
//

import UIKit

enum FileManagerError: Error {
    case imageFormatError
    case directoryDoesntExist
}

extension FileManagerError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .imageFormatError:
            return NSLocalizedString("Неверный формат изображения", comment: "FileManagerError")
        case .directoryDoesntExist:
            return NSLocalizedString("Ошибка чтения папки", comment: "FileManagerError")
        }
    }
}

struct FileManagerService {
    private let fileManager = FileManager.default
    private var currentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    func saveImage(image: UIImage, with name: String) throws {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            throw FileManagerError.imageFormatError
        }
        guard let directory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            throw FileManagerError.directoryDoesntExist
        }
        do {
            try data.write(to: directory.appendingPathComponent(name)!)
        } catch {
            throw error
        }
    }
    
    func contentsOfDirectory() -> Result<[String], Error> {
        do {
            let names = try fileManager.contentsOfDirectory(atPath: currentPath)
            return .success(names)
        } catch {
            return .failure(error)
        }
    }
    
    func removeContent(with name: String) throws {
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        let content = docsURL.appendingPathComponent(name).path
        do {
            try fileManager.removeItem(atPath: content)
        } catch {
            throw error
        }
    }
}
