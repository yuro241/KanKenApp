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
    var arrayWrongAnswer: [Question] = []
    //間違えた数データ
    var arrayWrongTimeCount: [Int] = []
    
    var count: Int = 1
    var questionNum: Int = 0
    var correctAnsCount: Int = 0
    var overcomeCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        correctLabel.isHidden = true
        incorrectLabel.isHidden = true
        ansLabel.isHidden = true
        answerInputField.clearButtonMode = .always
        
        setLayout()
        getWrongAnswers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.hidesBackButton = true
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        arrayWrongTimeCount = UserDefaults.standard.array(forKey: "wrongTimeCount") as! [Int]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func getWrongAnswers() {
        let fetchedData = UserDefaults.standard.data(forKey: "wrongAnswer")
        let fetchedAnswers = try! PropertyListDecoder().decode([Question].self, from: fetchedData!)
        arrayWrongAnswer = fetchedAnswers
        for answers in fetchedAnswers {
            print(answers.Kanji)
            print(answers.Kana)
        }
        changeQuestion()
    }
    
    //問題出題
    func changeQuestion() {
        if arrayWrongAnswer.count == 0 {
            finishQuiz()
        }
        questionNumberLabel.text = String(count) + "問目"
        questionNum = Int(arc4random() % UInt32(arrayWrongAnswer.count))
        questionLabel.text = arrayWrongAnswer[questionNum].Kanji
    }
    
    //答え合わせ処理
    func checkAns() {
        if answerInputField.text! == arrayWrongAnswer[questionNum].Kana {
            correctAnsCount += 1
            changeCorrectLabel()
            //間違えた数を-1し、0なら問題を削除
            arrayWrongTimeCount[questionNum] -= 1
            if arrayWrongTimeCount[questionNum] == 0 {
                overcomeCount += 1
                arrayWrongAnswer.remove(at: questionNum)
                arrayWrongTimeCount.remove(at: questionNum)
            }
        } else {
            changeIncorrectLabel()
            ansLabel.text = "答えは：" + arrayWrongAnswer[questionNum].Kana
            arrayWrongTimeCount[questionNum] += 1
        }
        answerInputField.text! = ""
        count += 1
        setTextFieldAndAnswerButtonDisable()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.changeInvisible(flag: true)
            self.changeQuestion()
        })
    }
    
    func finishQuiz() {
        setWrongAnswersToUserDefaults()
        setWrongTimeCountToUserDefaults()
        let accuracy: Double = (Double(self.correctAnsCount) / Double(count))*100
        UserDefaults.standard.set(accuracy, forKey: "accuracy")
        UserDefaults.standard.set(correctAnsCount, forKey: "correctCount")
        UserDefaults.standard.set(overcomeCount, forKey:"overcomeCount")
        self.performSegue(withIdentifier: "toResult", sender: nil)
    }
    
    //間違えた問題の配列データを,エンコードしてをUserDefaultsへ保存
    func setWrongAnswersToUserDefaults() {
        let wrongAnswersData = try! PropertyListEncoder().encode(arrayWrongAnswer)
        UserDefaults.standard.set(wrongAnswersData, forKey: "wrongAnswer")
        //間違えた問題の数をUserDefaultsに保存
        UserDefaults.standard.set(arrayWrongAnswer.count, forKey: "numOfWrongAnswer")
    }
    
    //間違えた回数データをUserDefaultsへ保存
    func setWrongTimeCountToUserDefaults() {
        UserDefaults.standard.set(arrayWrongTimeCount, forKey: "wrongTimeCount")
    }
    
    //正解した時のラベル表示
    func changeCorrectLabel() {
        self.correctLabel.isHidden = false
        self.ansLabel.isHidden = true
        self.incorrectLabel.isHidden = true
    }
    
    //不正解の時のラベル表示
    func changeIncorrectLabel() {
        self.correctLabel.isHidden = true
        self.ansLabel.isHidden = false
        self.incorrectLabel.isHidden = false
    }
    
    //部品を隠す処理
    func changeInvisible(flag: Bool) {
        self.ansLabel.isHidden = flag
        self.incorrectLabel.isHidden = flag
        self.correctLabel.isHidden = flag
        self.answerInputField.isEnabled = flag
        self.answerButton.isEnabled = flag
    }
    
    //テキスト入力とボタン押下の禁止処理
    func setTextFieldAndAnswerButtonDisable() {
        self.answerInputField.isEnabled = false
        self.answerButton.isEnabled = false
    }
    
    //クイズ終了処理
    @objc func toTitle() {
        finishQuiz()
    }
    
    //画面レイアウトを設定
    func setLayout() {
        self.questionNumberLabel.layer.cornerRadius = 10
        self.questionNumberLabel.clipsToBounds = true
        self.questionLabel.layer.cornerRadius = 20
        self.questionLabel.clipsToBounds = true
        self.answerInputField.layer.cornerRadius = 10
        self.answerButton.layer.cornerRadius = 5
    }
    
    @IBAction func PauseTap(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(hideWhenBackgroundViewIsTapped: true)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("終了", target:self, selector:#selector(MainViewController.toTitle))
        alertView.showWait("一時停止中...", closeButtonTitle: "クイズ再開", colorStyle: 0xFFD151, colorTextButton: 0x1C1C1C)
    }
    
    @IBAction func answerButtonTap(_ sender: UIButton) {
        checkAns()
    }
    
}
