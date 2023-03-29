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

class FileManagerService {
    private let fileManager = FileManager.default
    private var currentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    var updateView: ((_ names: [String]) -> ())?
    var showError: ((_ message: String) -> ())?
    
    func saveImage(image: UIImage, with name: String) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            showError?(FileManagerError.imageFormatError.localizedDescription)
            return
        }
        guard let directory = try? fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            showError?(FileManagerError.directoryDoesntExist.localizedDescription)
            return
        }
        do {
            try data.write(to: directory.appendingPathComponent(name)!)
        } catch {
            showError?(error.localizedDescription)
        }
    }
    
    func contentsOfDirectory() {
        do {
            var names = try fileManager.contentsOfDirectory(atPath: currentPath)
            if UserDefaults.standard.bool(forKey: UserDefaultsKey.sort.rawValue) {
                names = names.sorted()
            }
            updateView?(names)
        } catch {
            showError?(error.localizedDescription)
        }
    }
    
    func removeContent(with name: String) {
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let docsURL = dirPaths[0]
        let content = docsURL.appendingPathComponent(name).path
        do {
            try fileManager.removeItem(atPath: content)
        } catch {
            showError?(error.localizedDescription)
        }
    }
}

extension FileManagerService: FileManagerDelegate {
    func sortFiles(_ needSorting: Bool) {
        UserDefaults.standard.set(needSorting, forKey: UserDefaultsKey.sort.rawValue)
        contentsOfDirectory()
    }
}
