//
//  ResultViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/04/10.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var persentageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resultLabel.text = String(UserDefaults.standard.integer(forKey: "correctCount")) + "問正解"
        persentageLabel.text = String(UserDefaults.standard.double(forKey: "accuracy")) + "%です"
    }
    
    @IBAction func retry(_ sender: UIButton) {
    }
    @IBAction func titleBack(_ sender: UIButton) {
    }
    
}
