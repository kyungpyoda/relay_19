//
//  AddImageViewController.swift
//  boost_project
//
//  Created by woong on 2020/08/14.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit

class AddImageViewController: UIViewController {

    @IBOutlet weak var tagTableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    var tagList = (1...3).map { Furniture(name: "\($0)") }
    var selectList = [Furniture]()
    let picker = UIImagePickerController()

    @IBAction func onClickSave(_ sender: UIBarButtonItem) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTapGesture() 
        configureTableView()
        configureViews()
        
        picker.delegate = self
        selectList = tagList
    }
    
    func configureViews() {
        imageBackgroundView.layer.shadowColor = UIColor.black.cgColor
        imageBackgroundView.layer.shadowOpacity = 0.5
        imageBackgroundView.layer.shadowOffset = .init(width: 3, height: 3)
        imageBackgroundView.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 15
    }
    
    func configureTableView() {
        tagTableView.separatorStyle = .none
        tagTableView.allowsSelection = false
    }
    
    func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageView))
        imageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapImageView() {
        openLibrary()
    }
    
    func openLibrary(){
      picker.sourceType = .photoLibrary
      present(picker, animated: false, completion: nil)
    }
}

extension AddImageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FurnitureTableViewCell else { return UITableViewCell() }
        
        let furniture = tagList[indexPath.row]
        let selected = selectList.contains(furniture)
        cell.configure(furniture: furniture, isSelected: selected) { [weak self] (furniture, selected) in
            if selected {
                self?.selectList.append(furniture)
            } else {
                self?.selectList.removeAll(where: { $0 == furniture })
            }
            print(self?.selectList.count)
        }
        
        return cell
    }
    
    
    
}

extension AddImageViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(named: "backgroundColor")
        let label = UILabel()
        view.addSubview(label)
        label.text = "인식된 물체"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        label.font = .systemFont(ofSize: 20, weight: .heavy)
        
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "인식된 물체"
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension AddImageViewController: UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

