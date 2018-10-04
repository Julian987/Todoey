//
//  SettingsViewController.swift
//  Todoey
//
//  Created by Julian Gurdan on 02.10.18.
//  Copyright © 2018 Julian Gurdan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let defaults = UserDefaults.standard

    @IBOutlet weak var spackoSwitch: UISwitch!
    @IBOutlet weak var fertigButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spackoSwitch.setOn(defaults.bool(forKey: "SpackoModus"), animated: false)
        print(defaults.bool(forKey: "SpackoModus"))
        
        fertigButton.setTitle("fertig", for: .normal)
        
        
        
    }
    

    @IBAction func spackoSwitchOn(_ sender: Any) {
        
        defaults.set(spackoSwitch.isOn, forKey: "SpackoModus")
        
    }
    
    @IBAction func fertigButtonPressed(_ sender: Any) {
        self.dismiss(animated: true , completion: nil)
    }
}
