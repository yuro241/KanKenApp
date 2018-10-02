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
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "クイズ結果"
        //navigationBarを非表示に
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // navigationBarを表示する
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setLayout() {
        restartButton.layer.cornerRadius = RESTARTBUTTON_CORNER_RADIUS
        toTitleButton.layer.cornerRadius = TOTITLEBUTTON_CORNER_RADIUS
    }
}
