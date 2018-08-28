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
    @IBOutlet var backGroundView: UIView!
    
    var tagForIdentifier: Int = 0
    var tagNumOfButton: Int = 0
    
    //各モード0〜3の説明文を記載
    var ExplanationArray: [String] = ["\n今までのクイズで間違えた問題と答え、間違えた回数が一覧で確認できます\n\nリストを空っぽにしましょう！","\n今までのクイズで間違えた問題のみが出題されます\n\n苦手を克服しましょう！","\n問題がランダムで10問出題されます\n\n全問正解を目指しましょう！","\nすべての問題がランダムな順で出題されます\n\n全問正解したあなたは漢字マスター！？"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
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
        //        self.startButton.layer.cornerRadius = 10
        self.mainTitleLabel.layer.cornerRadius = 20
        self.mainTitleLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.mainTitleLabel.clipsToBounds = true
        self.subTitleLabel.layer.cornerRadius  = 20
        self.subTitleLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.subTitleLabel.clipsToBounds = true
        backGroundView.layer.cornerRadius = 20
        
        //各ボタンのalphaと角丸設定
        for buttons in modeSelectButtons {
            buttons.alpha = 0.3
            buttons.layer.cornerRadius = 10
        }
        startButton.alpha = 0.3
        startButton.isEnabled = false
        startButton.layer.cornerRadius = 10
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
    
    //開始ボタン押下時実行
    @IBAction func startButtonTapped(_ sender: UIButton) {
        //選ばれたモードによってtagで画面遷移を変更
        if tagForIdentifier == 2 {
            UserDefaults.standard.set(2, forKey: "gameMode")
        }
        if tagForIdentifier == 3 {
            UserDefaults.standard.set(3, forKey: "gameMode")
        }
        startButton.alpha = 0.3
        startButton.isEnabled = false
        self.performSegue(withIdentifier: String(tagForIdentifier), sender: nil)
    }
    
    //ボタンの選択非選択変更
    @IBAction func changeAlpha(_ sender: UIButton) {
        for buttons in modeSelectButtons {
            buttons.alpha = 0.3
        }
        modeSelectButtons[sender.tag].alpha = 1.0
        tagForIdentifier = sender.tag
        startButton.alpha = 1.0
        startButton.isEnabled = true
    }
    
    //モード選択ボタン長押し時にPopUp表示
    //復習単語リスト
    @IBAction func pressButtonToList(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            showPopUp(sender: modeSelectButtons[0])
        }
    }
    //10問組手
    @IBAction func pressButtonToMain(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            showPopUp(sender: modeSelectButtons[1])
        }
    }
    //誤答復習
    @IBAction func pressButtonToReview(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            showPopUp(sender: modeSelectButtons[2])
        }
    }
    //全問必答
    @IBAction func pressButtonToAll(_ sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            showPopUp(sender: modeSelectButtons[3])
        }
    }
    
    @objc internal func showPopUp(sender: UIButton) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "ヒラギノ角ゴシック W3", size: 24)!,
            kTextFont: UIFont(name: "ヒラギノ角ゴシック W3", size: 16)!,
            kButtonFont: UIFont(name: "ヒラギノ角ゴシック W6", size: 16)!,
            showCircularIcon: false, contentViewCornerRadius: 10, fieldCornerRadius: 10, buttonCornerRadius: 5,
            hideWhenBackgroundViewIsTapped: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showSuccess((sender.titleLabel?.text!)!, subTitle: ExplanationArray[sender.tag], closeButtonTitle: "閉じる", colorStyle: 0xFFD151, colorTextButton: 0x1C1C1C, animationStyle: .noAnimation)
    }
}
