//
//  ViewController.swift
//  FileManager
//
//  Created by Pavel Yurkov on 05.04.2021.
//

import UIKit

class FileManagerViewController: UIViewController {
    
    private let defaults = UserDefaults.standard
    
    private var areFilesSorted = true
    private var isFileSizeShown = true
    
    private lazy var paths: [URL] = []
    private lazy var fileManager = FileManager.default
    private var currentDir: URL?
    
    private lazy var createFolderButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(createFolderButtonItemTapped))
        return button
    }()
    
    private lazy var addPhotoButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoButtonItemTapped))
        return button
    }()
    
    private lazy var goUpButtonItem: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "arrow.turn.left.up"), style: .plain, target: self, action: #selector(goUpButtonItemTapped))
        return button
    }()
    
    private lazy var filesTableView: UITableView = {
        let ftv = UITableView()
        ftv.dataSource = self
        ftv.delegate = self
        ftv.showsVerticalScrollIndicator = false
        ftv.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        return ftv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Файлы"
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItems = [createFolderButtonItem, addPhotoButtonItem]
        navigationItem.leftBarButtonItem = goUpButtonItem
        
        setupLayout()
        
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        currentDir = dirPaths
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadSettings()
        
        if let dir = currentDir {
            showFilesFor(dir: dir, using: fileManager)
        }
        
    }
    
    private func loadSettings() {
        areFilesSorted = defaults.object(forKey: Options.sort.rawValue) as? Bool ?? true
        isFileSizeShown = defaults.object(forKey: Options.showFileSize.rawValue) as? Bool ?? true
    }

    func showFilesFor(dir: URL, using fileManager: FileManager) {
        do {
            try paths = fileManager.contentsOfDirectory(at: dir, includingPropertiesForKeys: [], options: .includesDirectoriesPostOrder)
            
            if areFilesSorted {
                paths = paths.sorted { (el1, el2) -> Bool in
                    el1.lastPathComponent < el2.lastPathComponent
                }
            } else {
                paths = paths.sorted { (el1, el2) -> Bool in
                    el1.lastPathComponent > el2.lastPathComponent
                }
            }
            
            goUpButtonItem.isEnabled = true
            filesTableView.reloadData()
        } catch {
            print(error.localizedDescription)
            handleApiError(error: .other, vc: self)
        }
    }
    
    @objc private func createFolderButtonItemTapped() {
        
        if let dir = currentDir {
            createDirUsingAlert(in: dir, usingFileManage: fileManager)
        }
        
    }
    
    @objc private func addPhotoButtonItemTapped() {
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func goUpButtonItemTapped() {
        if let dir = currentDir {
            
            let upDir = dir.deletingLastPathComponent()
            showFilesFor(dir: upDir, using: fileManager)
            currentDir = upDir
            
            if currentDir?.lastPathComponent == "/" {
                goUpButtonItem.isEnabled = false
            }
        }
    }

}

extension FileManagerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paths.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = filesTableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
        
        if isFileSizeShown {
            if let fileSize = paths[indexPath.row].fileSize() {
                cell.textLabel?.text = String(describing: paths[indexPath.row].lastPathComponent) + " (\(fileSize))"
            }
        } else {
            cell.textLabel?.text = String(describing: paths[indexPath.row].lastPathComponent)
        }
        
        cell.accessoryType = paths[indexPath.row].isDirectory() ? .checkmark : .none
        
        return cell
    }
    
}

extension FileManagerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        currentDir = paths[indexPath.row]
        showFilesFor(dir: paths[indexPath.row], using: fileManager)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FileManagerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let imageURL = info[.imageURL] as? URL {
            
            let photoName = imageURL.lastPathComponent
            let photoDestinationURL = currentDir?.appendingPathComponent(photoName)
            
            if let url = photoDestinationURL {
                do {
                    try fileManager.copyItem(at: imageURL, to: url)
                } catch {
                    print("\(error.localizedDescription)")
                }
            }
        }
        
        picker.dismiss(animated: true) { [weak self] in
            if let vc = self {
                if let dir = vc.currentDir {
                    vc.showFilesFor(dir: dir, using: vc.fileManager)
                }
            }
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

private extension FileManagerViewController {
    
    func setupLayout() {
        
        view.addSubviewWithAutolayout(filesTableView)
        
        let constraints = [
            
            filesTableView.topAnchor.constraint(equalTo: view.topAnchor),
            filesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
}



