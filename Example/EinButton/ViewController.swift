//
//  ViewController.swift
//  EinButton
//
//  Created by Amorn Apichattanakul on 09/05/2018.
//  Copyright (c) 2018 Amorn Apichattanakul. All rights reserved.
//

import UIKit
import EinButton

class ViewController: UIViewController {
    @IBOutlet weak var addCartButtonByView: EinButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addCartButtonByCode = EinButton(frame: CGRect(x: 100 , y: 100, width: 100, height: 40))
        addCartButtonByCode.backgroundColor = .red
        addCartButtonByCode.buttonLabel = "Add Button"
        addCartButtonByCode.cornerRadius = 10
        addCartButtonByCode.iconImage = UIImage(named: "ic_trash")
        addCartButtonByCode.titleTextColor = .white
        addCartButtonByCode.delegate = self
        view.addSubview(addCartButtonByCode)

        addCartButtonByView.delegate = self
    }

}

extension ViewController: EinButtonDelegate {
    func valueDidChanged(to value: Int) {
        infoLabel.text = "Current value : \(value)"
    }
    
    func didTapMinus() {
        infoLabel.text = "You just tapped Minus button"
    }
    
    func didTapPlus() {
        infoLabel.text = "You just tapped Plus button"
    }
    
    func cannotAddMoreItem() {
        // Use for showing warning to user that you can't add anymore
        infoLabel.text = "Not Allowed to add more item"
    }
}

