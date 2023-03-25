//
//  DocumentsViewController.swift
//  FileManager
//
//  Created by Дина Шварова on 25.03.2023.
//

import UIKit

class DocumentsViewController: UIViewController {

    private lazy var mainView = DocumentsView()
    
    private let fileManager = FileManagerService()
    
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Documents"
        setupNavigationBar()
        getContent()
        mainView.removeAction = removeDocument
    }
    
    private func removeDocument(with name: String) {
        do {
            try fileManager.removeContent(with: name)
            getContent()
        } catch {
            showErrorAlert(message: error.localizedDescription)
        }
    }
    
    private func setupNavigationBar() {
        let addImageItem = UIBarButtonItem(image: UIImage(systemName: "photo.stack"), style: .done, target: self, action: #selector(addImage))
        addImageItem.tintColor = .gray
        navigationItem.rightBarButtonItem = addImageItem
    }
    
    private func getContent() {
        let result = fileManager.contentsOfDirectory()
        switch result {
        case .success(let items):
            mainView.setDocuments(documents: items)
        case .failure(let error): showErrorAlert(message: error.localizedDescription)
        }
    }
   
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func showAlertToAddImage (actionHandler:  @escaping  ((String) -> ())) {
        let alert = UIAlertController(title: "Enter name for new image", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "New image"
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [unowned alert] (_) in
            let name = alert.textFields?[0].text ?? "New image"
            actionHandler(name)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        present(alert, animated: true)
    }
    
    @objc private func addImage() {
        present(imagePicker, animated: true)
    }
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        
        showAlertToAddImage() { name in
            do {
                try self.fileManager.saveImage(image: image, with: name)
                self.getContent()
            } catch {
                self.showErrorAlert(message: error.localizedDescription)
            }
        }
    }
}
