//
//  ReViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/06/08.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit
import SCLAlertView

class ReViewController: UIViewController {
    @IBOutlet var questionNumberLabel: UILabel!
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var incorrectLabel: UILabel!
    @IBOutlet var ansLabel: UILabel!
    @IBOutlet var correctLabel: UILabel!
    @IBOutlet var answerInputField: UITextField!
    @IBOutlet var answerButton: UIButton!
    
    //間違えた問題データ
    private var arrayWrongAnswer: [Question] = []
    //間違えた数データ
    private var arrayWrongTimeCount: [[Int]] = [[],[]]
    
    private var count: Int = 1
    private var questionNum: Int = 0
    private var correctAnsCount: Int = 0
    private var overcomeCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        answerInputField.clearButtonMode = .always
        
        setLayout()
        getWrongAnswers()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9270954605, green: 0.4472710504, blue: 0.05901660795, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "誤答復習モード"
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        arrayWrongTimeCount = UserDefaults.standard.array(forKey: "wrongTimeCount") as! [[Int]]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func getWrongAnswers() {
        let fetchedData = UserDefaults.standard.data(forKey: "wrongAnswer")
        let fetchedAnswers = try! PropertyListDecoder().decode([Question].self, from: fetchedData!)
        arrayWrongAnswer = fetchedAnswers
        
        changeQuestion()
    }
    
    //問題出題
    private func changeQuestion() {
        if arrayWrongAnswer.count == 0 {
            finishQuiz()
        } else {
            questionNumberLabel.text = String(count) + "問目"
            questionNum = Int(arc4random() % UInt32(arrayWrongAnswer.count))
            questionLabel.text = arrayWrongAnswer[questionNum].Kanji
        }
        
    }
    
    //答え合わせ処理
    private func checkAns() {
        if answerInputField.text! == arrayWrongAnswer[questionNum].Kana {
            correctAnsCount += 1
            changeCorrectLabel()
            //間違えた数を-1し、0なら問題を削除
            for i in 0..<arrayWrongTimeCount[0].count {
                if arrayWrongTimeCount[1][i] == questionNum {
                    arrayWrongTimeCount[0][i] -= 1
                    if arrayWrongTimeCount[0][i] == 0 {
                        overcomeCount += 1
                        arrayWrongAnswer.remove(at: arrayWrongTimeCount[1][i])
                        arrayWrongTimeCount[0].remove(at: i)
                        arrayWrongTimeCount[1].removeLast()
                        break
                    }
                }
            }
        } else {
            changeIncorrectLabel()
            ansLabel.text = "答えは：" + arrayWrongAnswer[questionNum].Kana
            for i in 0..<arrayWrongTimeCount[0].count {
                if arrayWrongTimeCount[1][i] == questionNum {
                    arrayWrongTimeCount[0][i] += 1
                    break
                }
            }
        }
        answerInputField.text! = ""
        count += 1
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.viewReset()
            self.changeQuestion()
        })
    }
    
    private func finishQuiz() {
        setWrongAnswersToUserDefaults()
        setWrongTimeCountToUserDefaults()
        let accuracy: Double = (Double(self.correctAnsCount) / Double(count))*100
        UserDefaults.standard.set(accuracy, forKey: "accuracy")
        UserDefaults.standard.set(correctAnsCount, forKey: "correctCount")
        UserDefaults.standard.set(overcomeCount, forKey:"overcomeCount")
        self.performSegue(withIdentifier: "toResult", sender: nil)
    }
    
    //間違えた問題の配列データを,エンコードしてをUserDefaultsへ保存
    private func setWrongAnswersToUserDefaults() {
        if !arrayWrongAnswer.isEmpty {
            let wrongAnswersData = try! PropertyListEncoder().encode(arrayWrongAnswer)
            UserDefaults.standard.set(wrongAnswersData, forKey: "wrongAnswer")
            //間違えた問題の数をUserDefaultsに保存
            UserDefaults.standard.set(arrayWrongAnswer.count, forKey: "numOfWrongAnswer")
        } else {
            UserDefaults.standard.set(nil, forKey: "wrongAnswer")
            UserDefaults.standard.set(0, forKey: "numOfWrongAnswer")
        }
        
    }
    
    //間違えた回数データをUserDefaultsへ保存
    private func setWrongTimeCountToUserDefaults() {
        if !arrayWrongTimeCount.isEmpty {
            UserDefaults.standard.set(arrayWrongTimeCount, forKey: "wrongTimeCount")
        } else {
            UserDefaults.standard.set(nil, forKey: "wrongTimeCount")
        }
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
    
    //画面を問題提示の状態に戻す
    func viewReset() {
        ansLabel.isHidden = true
        incorrectLabel.isHidden = true
        correctLabel.isHidden = true
        answerInputField.isHidden = false
        answerButton.isHidden = false
    }
    
    //クイズ終了処理
    @objc func toTitle() {
        finishQuiz()
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
    
    @IBAction func PauseTap(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(kTitleFont: UIFont(name: "ヒラギノ角ゴシック W3", size: 24)!,
                                                    kTextFont: UIFont(name: "ヒラギノ角ゴシック W3", size: 16)!,
                                                    kButtonFont: UIFont(name: "ヒラギノ角ゴシック W6", size: 16)!,
                                                    contentViewCornerRadius: 10, fieldCornerRadius: 10, buttonCornerRadius: 5,
                                                    hideWhenBackgroundViewIsTapped: true)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("終了", target:self, selector:#selector(MainViewController.toTitle))
        alertView.showWait("一時停止中...", subTitle: "", closeButtonTitle: "クイズ再開", colorStyle: 0xFFD151, colorTextButton: 0x1C1C1C)
    }
    
    @IBAction func answerButtonTap(_ sender: UIButton) {
        checkAns()
    }
    
}
