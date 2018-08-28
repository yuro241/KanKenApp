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
    
    private let userDefaultsManager = UserDefaultsManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = String(userDefaultsManager.getCorrectCount()) + "問正解"
        persentageLabel.text = String(userDefaultsManager.getAccuracy()) + "%です"
//        persentageLabel.text = "\(UserDefaults.standard.double(forKey: "accuracy"))%です"
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "クイズ結果"
        //navigationBarを非表示に
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setLayout() {
        restartButton.layer.cornerRadius = 10
        toTitleButton.layer.cornerRadius = 10
    }
}
