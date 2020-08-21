//
//  FurnitureTableViewCell.swift
//  boost_project
//
//  Created by woong on 2020/08/14.
//  Copyright © 2020 남기범. All rights reserved.
//

import UIKit

class FurnitureTableViewCell: UITableViewCell {
    
    var furniture: Furniture?
    @IBOutlet weak var furnitureButton: UIButton!
    var didSelectFurniture: ((Furniture, Bool) -> Void)?
    var isSelectedFurniture = true {
        didSet {
            isSelectedFurniture ? setSelect() : setDeSelect()
        }
    }
    
    @IBAction func onClickFurnitureButton(_ sender: UIButton) {
        guard let furniture = furniture else { return }
        isSelectedFurniture.toggle()
        didSelectFurniture?(furniture, isSelectedFurniture)
    }
    
    
    func setSelect() {
        furnitureButton.backgroundColor = UIColor(named: "furnitureColor")
        furnitureButton.setTitleColor(.white, for: .normal)
    }
    
    func setDeSelect() {
        furnitureButton.backgroundColor = UIColor(named: "backgroundColor")
        furnitureButton.setTitleColor(.black, for: .normal)
    }
    
    func configure(furniture: Furniture, isSelected: Bool, handler: ((Furniture, Bool) -> Void)?) {
        self.furniture = furniture
        self.isSelectedFurniture = isSelected
        self.didSelectFurniture = handler
        furnitureButton.setTitle(furniture.name, for: .normal)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        furnitureButton.layer.cornerRadius = 10
        furnitureButton.layer.shadowColor = UIColor.black.cgColor
        furnitureButton.layer.shadowOpacity = 0.5
        furnitureButton.layer.shadowOffset = .init(width: 3, height: 3)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
