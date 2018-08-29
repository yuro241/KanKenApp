//
//  TitleViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/06/03.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit
import SCLAlertView

internal let HIRAGINO_FONT_STRING = "ヒラギノ角ゴシック W3"
internal let HIRAGINO_BOLD_FONT_STRING = "ヒラギノ角ゴシック W6"

class TitleViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet var modeSelectButtons: [UIButton]!
    @IBOutlet var backGroundView: UIView!
    
    private var tagForIdentifier: Int = 0
    private var tagNumOfButton: Int = 0
    
    private let userDefaultsManager = UserDefaultsManager()
    private let csvFileManager = CsvFileManager()
    
    //各モード0〜3の説明文を記載
    private var ExplanationArray = ["\n今までのクイズで間違えた問題と答え、間違えた回数が一覧で確認できます\n\nリストを空っぽにしましょう！",
                                    "\n今までのクイズで間違えた問題のみが出題されます\n\n苦手を克服しましょう！",
                                    "\n問題がランダムで10問出題されます\n\n全問正解を目指しましょう！",
                                    "\nすべての問題がランダムな順で出題されます\n\n全問正解したあなたは漢字マスター！？"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        csvFileManager.readCsv()
        //        //fordebug: 間違えた問題データ削除
        //        UserDefaults.standard.removeObject(forKey: "wrongAnswer")
        //        UserDefaults.standard.removeObject(forKey: "wrongTimeCount")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setModeSelectButtonEnable()
        setNavigationBarLayout()
    }
    
    //NavigationBarの見た目設定
    func setNavigationBarLayout() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    //各部品の見た目設定
    func setLayout() {
        mainTitleLabel.layer.cornerRadius = CGFloat(MAINTITLE_LABEL_CORNER_RADIUS)
        mainTitleLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mainTitleLabel.clipsToBounds = true
        subTitleLabel.layer.cornerRadius  = SUBTITLE_LABEL_CORNER_RADIUS
        subTitleLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        subTitleLabel.clipsToBounds = true
        backGroundView.layer.cornerRadius = BACKGROUNDVIEW_CORNER_RADIUS
        
        resetModeSelectButton()
        resetStartButton()
        startButton.layer.cornerRadius = STARTBUTTON_CORNER_RADIUS
    }
    
    //間違えた問題がない場合、復習のモードを選択不可に設定
    func setModeSelectButtonEnable() {
        if userDefaultsManager.getWrongAnswer() == nil {
            modeSelectButtons[0].isEnabled = false
            modeSelectButtons[1].isEnabled = false
        } else {
            modeSelectButtons[0].isEnabled = true
            modeSelectButtons[1].isEnabled = true
        }
    }
    
    //各モード選択ボタンのalphaと角丸設定
    func resetModeSelectButton() {
        for buttons in modeSelectButtons {
            buttons.alpha = alphaValue.light.rawValue
            buttons.layer.cornerRadius = MODESELECTBUTTON_CORNER_RADIUS
        }
    }
    
    //スタートボタンのalphaと押下不可を設定
    func resetStartButton() {
        startButton.alpha = alphaValue.light.rawValue
        startButton.isEnabled = false
    }
    
    //開始ボタン押下時実行
    @IBAction func startButtonTapped(_ sender: UIButton) {
        //選ばれたモードによってtagで画面遷移を変更
        if tagForIdentifier == QuestionNumber.tenQuestionsMode.rawValue {
            userDefaultsManager.setGameMode(num: QuestionNumber.tenQuestionsMode.rawValue)
        }
        if tagForIdentifier == QuestionNumber.allQuestionsMode.rawValue {
            userDefaultsManager.setGameMode(num: QuestionNumber.allQuestionsMode.rawValue)
        }
        resetModeSelectButton()
        resetStartButton()
        self.performSegue(withIdentifier: String(tagForIdentifier), sender: nil)
    }
    
    //ボタンの選択非選択変更
    @IBAction func changeAlpha(_ sender: UIButton) {
        resetModeSelectButton()
        modeSelectButtons[sender.tag].alpha = alphaValue.dark.rawValue
        tagForIdentifier = sender.tag
        startButton.alpha = alphaValue.dark.rawValue
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
            kTitleFont: UIFont(name: HIRAGINO_FONT_STRING, size: POPUP_TITLE_FONT_SIZE)!,
            kTextFont: UIFont(name: HIRAGINO_FONT_STRING, size: POPUP_TEXT_FONT_SIZE)!,
            kButtonFont: UIFont(name: HIRAGINO_BOLD_FONT_STRING, size: POPUP_TEXT_FONT_SIZE)!,
            showCircularIcon: false, contentViewCornerRadius: POPUP_CONTENTS_CORNER_RADIUS, fieldCornerRadius: POPUP_CONTENTS_CORNER_RADIUS, buttonCornerRadius: POPUP_BUTTON_CORNER_RADIUS,
            hideWhenBackgroundViewIsTapped: true
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.showSuccess((sender.titleLabel?.text!)!, subTitle: ExplanationArray[sender.tag], closeButtonTitle: "閉じる", colorStyle: 0xFFD151, colorTextButton: 0x1C1C1C, animationStyle: .noAnimation)
    }
}
