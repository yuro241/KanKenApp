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
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var toTitleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = String(UserDefaults.standard.integer(forKey: "correctCount")) + "問正解"
        persentageLabel.text = String(UserDefaults.standard.double(forKey: "accuracy")) + "%です"
        
        self.setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "クイズ結果"
        //navigationBarを非表示に
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setLayout() {
        self.restartButton.layer.cornerRadius = 10
        self.toTitleButton.layer.cornerRadius = 10
    }
    
    @IBAction func retry(_ sender: UIButton) {
    }
    @IBAction func titleBack(_ sender: UIButton) {
    }
    
}
