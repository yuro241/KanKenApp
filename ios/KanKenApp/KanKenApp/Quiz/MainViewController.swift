//
//  ViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/02/23.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit
import SCLAlertView

private let hiraginoFontString = "ヒラギノ角ゴシック W3"
private let hiraginoBoldFontString = "ヒラギノ角ゴシック W6"

internal class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    //回答入力フィールド
    @IBOutlet weak var answerInputField: UITextField!
    //正解！ラベル
    @IBOutlet weak var correctLabel: UILabel!
    //不正解...ラベル
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var answerButton: UIButton!
    
    //漢字データ
    private var arrayKanji: [String] = []
    //読み仮名データ
    private var arrayKana: [String] = []
    //間違えた問題データ
    private var arrayWrongAnswer: [(Question)] = []
    //間違えた数データ
    private var arrayWrongTimeCount: [[Int]] = [[],[]]
    
    private var count: Int = 1
    private var correctAnswers: Int = 0
    private var wrongAnswers: Int = 0
    private var questionNum: Int = 0
    private var numOfTry: Int = 1
    
    private let userDefaultManager = UserDefaultsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        answerInputField.delegate = self
        answerInputField.clearButtonMode = .always
        
        viewReset()
        setLayout()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9270954605, green: 0.4472710504, blue: 0.05901660795, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        
        arrayKana = userDefaultManager.getKana()
        arrayKanji = userDefaultManager.getKanji()
        
        if let fetchedData = userDefaultManager.getWrongAnswer() {
            let fetchedWrongAnswers = try! PropertyListDecoder().decode([Question].self, from: fetchedData)
            self.arrayWrongAnswer = fetchedWrongAnswers
        }
        
        if let wrongTimeCount = userDefaultManager.getWrongTimeCount() {
            arrayWrongTimeCount = wrongTimeCount
        }
        
        switch userDefaultManager.getGameMode() {
        case 2:
            numOfTry = 10
            self.navigationItem.title = "10問組手モード"
        case 3:
            numOfTry = arrayKanji.count
            self.navigationItem.title = "全問必答モード"
        default:
            print("Error")
        }
        
        changeQuestion()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    //画面レイアウトを設定
    private func setLayout() {
        questionNumberLabel.layer.cornerRadius = 10
        questionNumberLabel.clipsToBounds = true
        questionLabel.layer.cornerRadius = 20
        questionLabel.clipsToBounds = true
        answerInputField.layer.cornerRadius = 10
        answerButton.layer.cornerRadius = 5
    }
    
    //問題出題
    private func changeQuestion() {
        if count > numOfTry {
            finishQuiz()
        } else {
            questionNumberLabel.text = String(count) + "問目"
            questionNum = Int(arc4random() % UInt32(arrayKanji.count))
            questionLabel.text = arrayKanji[questionNum]
        }
    }
    
    //答え合わせ処理
    private func checkAns() {
        if answerInputField.text! == arrayKana[questionNum] {
            correctAnswers += 1
            changeCorrectLabel()
        } else {
            wrongAnswers += 1
            changeIncorrectLabel()
            addWrongAnswer()
            ansLabel.text = "答えは：" + arrayKana[questionNum]
        }
        answerInputField.text! = ""
        arrayKanji.remove(at: questionNum)
        arrayKana.remove(at: questionNum)
        count += 1

        //1秒後に次の問題へ移動
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
            self.viewReset()
            self.changeQuestion()
        })
    }
    
    //間違えた問題を配列へ追加. 重複時は間違えた回数をインクリメント
    private func addWrongAnswer() {
        let currentWrongAnswer = Question(Kanji: arrayKanji[questionNum], Kana: arrayKana[questionNum])
        if arrayWrongAnswer.contains(currentWrongAnswer) {
            arrayWrongTimeCount[0][arrayWrongAnswer.index(of: currentWrongAnswer)!] += 1
        } else {
            arrayWrongAnswer.append(currentWrongAnswer)
            arrayWrongTimeCount[0].append(1)
            arrayWrongTimeCount[1].append(arrayWrongAnswer.count - 1)
        }
    }
    
    //間違えた問題の配列データを,エンコードしてをUserDefaultsへ保存
    private func setWrongAnswersToUserDefaults() {
        let wrongAnswersData = try! PropertyListEncoder().encode(arrayWrongAnswer)
        userDefaultManager.setWrongAnswer(data: wrongAnswersData)

        //間違えた問題の数をUserDefaultsに保存
        userDefaultManager.setNumOfWrongAnswer(num: arrayWrongAnswer.count)
    }
    
    //間違えた回数データをUserDefaultsへ保存
    private func setWrongTimeCountToUserDefaults() {
        userDefaultManager.setWrongTimeCount(nums: arrayWrongTimeCount)
    }
    
    //クイズ終了時の処理
    private func finishQuiz() {
        //Q 全問終えてから間違えた問題を追加？それとも中断しても追加する?
        setWrongAnswersToUserDefaults()
        setWrongTimeCountToUserDefaults()
        let accuracy: Double = (Double(self.correctAnswers)/Double(numOfTry))*100
        userDefaultManager.setAccuracy(num: accuracy)
        userDefaultManager.setCorrectCount(num: correctAnswers)

        self.performSegue(withIdentifier: "finish", sender: nil)
    }
    
    //画面を問題提示の状態に戻す
    private func viewReset() {
        ansLabel.isHidden = true
        incorrectLabel.isHidden = true
        correctLabel.isHidden = true
        answerInputField.isHidden = false
        answerButton.isHidden = false
    }
    
    //正解した時のラベル表示
    private func changeCorrectLabel() {
        correctLabel.isHidden = false
        ansLabel.isHidden = true
        incorrectLabel.isHidden = true
        
        answerInputField.isHidden = true
        answerButton.isHidden = true
    }
    
    //不正解の時のラベル表示
    private func changeIncorrectLabel() {
        correctLabel.isHidden = true
        ansLabel.isHidden = false
        incorrectLabel.isHidden = false
        
        
        answerInputField.isHidden = true
        answerButton.isHidden = true
    }
    //タイトルへ戻る処理
    @objc internal func toTitle() {
        self.performSegue(withIdentifier: "totitle", sender: nil)
    }
    
    //一時停止ボタン押下時実行
    @IBAction func tapStop(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: hiraginoFontString, size: 24)!,
            kTextFont: UIFont(name: hiraginoFontString, size: 16)!,
            kButtonFont: UIFont(name: hiraginoBoldFontString, size: 16)!,
            contentViewCornerRadius: 10, fieldCornerRadius: 10, buttonCornerRadius: 5,
            hideWhenBackgroundViewIsTapped: true)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("中断", target:self, selector:#selector(MainViewController.toTitle))
        alertView.showWait("一時停止中...", subTitle: "", closeButtonTitle: "クイズ再開", colorStyle: 0xFFD151, colorTextButton: 0x1C1C1C)
    }
    
    //答えるボタン押下時実行
    @IBAction func answerTap(_ sender: UIButton) {
        checkAns()
    }
}

