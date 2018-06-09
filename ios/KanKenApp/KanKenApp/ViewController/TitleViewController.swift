//
//  TitleViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/06/03.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit
import SCLAlertView

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
            buttons.layer.cornerRadius = 10
            buttons.addTarget(self, action: #selector (self.showPopUp(sender:)), for: .touchUpInside)
        }
        startButton.isEnabled = false
//        //fordebug: 間違えた問題データ削除
//        UserDefaults.standard.removeObject(forKey: "wrongAnswer")
//        UserDefaults.standard.removeObject(forKey: "wrongTimeCount")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        setModeSelectButtonEnable()
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
    
    func setModeSelectButtonEnable() {
        if UserDefaults.standard.data(forKey: "wrongAnswer") == nil {
            modeSelectButtons[0].isEnabled = false
            modeSelectButtons[1].isEnabled = false
        } else {
            modeSelectButtons[0].isEnabled = true
            modeSelectButtons[1].isEnabled = true
        }
    }
    
    @objc internal func showPopUp(sender: UIButton) {
        let appearance = SCLAlertView.SCLAppearance(
            showCircularIcon: false,
            hideWhenBackgroundViewIsTapped: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showSuccess("No icon", subTitle: "This is a clean alert without Icon!", closeButtonTitle: "閉じる")
    }
    
    //開始ボタン押下時実行
    @IBAction func startButtonTapped(_ sender: UIButton) {
        //選ばれたモードによってtagで画面遷移を変更
        if tagForIdentifier == 2 {
            UserDefaults.standard.set(2, forKey: "gameMode")
        }
        if tagForIdentifier == 3 {
            UserDefaults.standard.set(3, forKey: "gameMode")
        }
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
