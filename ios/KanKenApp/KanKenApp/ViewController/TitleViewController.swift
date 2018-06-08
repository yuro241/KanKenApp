//
//  TitleViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/06/03.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet var modeSelectButtons: [UIButton]!
    
    var tagForIdentifier: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
        
        for buttons in modeSelectButtons {
            buttons.alpha = 0.3
        }
        startButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    func setLayout() {
        self.startButton.layer.cornerRadius = 10
        self.mainTitleLabel.layer.cornerRadius = 20
        self.mainTitleLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.mainTitleLabel.clipsToBounds = true
        self.subTitleLabel.layer.cornerRadius  = 20
        self.subTitleLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.subTitleLabel.clipsToBounds = true
    }
    
    //開始ボタン押下時実行
    @IBAction func startButtonTapped(_ sender: UIButton) {
        //選ばれたモードによってtagで画面遷移を変更
        self.performSegue(withIdentifier: String(tagForIdentifier), sender: nil)
    }
    
    //ボタンの選択非選択変更
    @IBAction func changeAlpha(_ sender: UIButton) {
        for buttons in modeSelectButtons {
            buttons.alpha = 0.3
        }
        modeSelectButtons[sender.tag].alpha = 1.0
        tagForIdentifier = sender.tag
        startButton.isEnabled = true
    }
}
