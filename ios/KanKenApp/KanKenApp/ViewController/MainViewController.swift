//
//  ViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/02/23.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit
import SCLAlertView

class MainViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var answerInputField: UITextField!
    //正解！ラベル
    @IBOutlet weak var correctLabel: UILabel!
    //不正解...ラベル
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var answerButton: UIButton!
    
    //データ配列
    var dataList: [String] = []
    //漢字データ
    var arrayKanji: [String] = []
    //読み仮名データ
    var arrayKana: [String] = []
    //間違えた問題データ
    var arrayWrongAnswer: [Question] = []
    //間違えた数データ
    var arrayWrongTimeCount: [Int] = []
    
    var count: Int = 1
    var correctAnswers: Int = 0
    var wrongAnswers: Int = 0
    var questionNum: Int = 0
    var numOfTry: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        correctLabel.isHidden = true
        incorrectLabel.isHidden = true
        ansLabel.isHidden = true
        answerInputField.clearButtonMode = .always
        
        self.setLayout()
        self.readCSV()
        self.changeQuestion()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9270954605, green: 0.4472710504, blue: 0.05901660795, alpha: 1)
//        //fordebug: 間違えた問題データ削除
//        UserDefaults.standard.removeObject(forKey: "wrongAnswer")
//        UserDefaults.standard.removeObject(forKey: "wrongTimeCount")

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       self.navigationItem.hidesBackButton = true
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        arrayKana = UserDefaults.standard.array(forKey: "kana") as! [String]
        arrayKanji = UserDefaults.standard.array(forKey: "kanji") as! [String]
        
        if let fetchedData = UserDefaults.standard.data(forKey: "wrongAnswer") {
            let fetchedWrongAnswers = try! PropertyListDecoder().decode([Question].self, from: fetchedData)
            self.arrayWrongAnswer = fetchedWrongAnswers
        }
        
        if let wrongTimeCount = UserDefaults.standard.array(forKey: "wrongTimeCount") {
            self.arrayWrongTimeCount = wrongTimeCount as! [Int]
        }
        
        if UserDefaults.standard.integer(forKey: "gameMode") == 2 {
            numOfTry = 10
            self.navigationController?.title = "10問組手モード"
            print(numOfTry)
        }
        if UserDefaults.standard.integer(forKey: "gameMode") == 3 {
            numOfTry = arrayKanji.count
            self.navigationController?.title = "全問必答モード"
            print(numOfTry)
        }
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
    
    //CSVファイル読み込み処理
    func readCSV() {
        do {
            //CSVファイルのPath取得
            let csvPath = Bundle.main.path(forResource: "questions", ofType: "csv")
            //CSVファイルのデータを取得
            let csvData = try! String(contentsOfFile:csvPath!, encoding:String.Encoding.utf8)
            //改行ごとにデータ格納
            dataList = csvData.components(separatedBy: "\n")
            //漢字とひらがなに分割
            for i in 0..<dataList.count-1 {
                let array: Array = dataList[i].components(separatedBy: ",")
                arrayKanji.append(array[0])
                arrayKana.append(array[1])
            }
        } catch {
            print("error")
        }
        UserDefaults.standard.set(arrayKanji, forKey: "kanji")
        UserDefaults.standard.set(arrayKana, forKey: "kana")
    }
    
    //問題出題
    func changeQuestion() {
        if count > numOfTry {
            self.finishQuiz()
        } else {
            questionNumberLabel.text = String(count) + "問目"
            questionNum = Int(arc4random() % UInt32(arrayKanji.count))
            questionLabel.text = arrayKanji[questionNum]
        }
    }
    
    //答え合わせ処理
    func checkAns() {
        print(arrayKana[questionNum])
        print(answerInputField.text!)
        if answerInputField.text! == arrayKana[questionNum] {
            self.correctAnswers += 1
            self.changeCorrectLabel()
        } else {
            self.wrongAnswers += 1
            self.changeIncorrectLabel()
            self.addWrongAnswer()
            self.ansLabel.text = "答えは：" + arrayKana[questionNum]
        }
        self.answerInputField.text! = ""
        self.arrayKanji.remove(at: questionNum)
        self.arrayKana.remove(at: questionNum)
        count += 1
        self.setTextFieldAndAnswerButtonDisable()
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.changeInvisible(flag: true)
            self.changeQuestion()
        })
        
    }
    
    //間違えた問題を配列へ追加. 重複時は間違えた回数をインクリメント
    func addWrongAnswer() {
        let currentWrongAnswer = Question(Kanji: arrayKanji[questionNum], Kana: arrayKana[questionNum])
        if arrayWrongAnswer.contains(currentWrongAnswer) {
            arrayWrongTimeCount[arrayWrongAnswer.index(of: currentWrongAnswer)!] += 1
        } else {
            arrayWrongAnswer.append(currentWrongAnswer)
             arrayWrongTimeCount.append(1)
        }
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
    
    //クイズ終了時の処理
    func finishQuiz() {
        setWrongAnswersToUserDefaults()
        setWrongTimeCountToUserDefaults()
        let accuracy: Double = (Double(self.correctAnswers)/10)*100
        UserDefaults.standard.set(accuracy, forKey: "accuracy")
        UserDefaults.standard.set(correctAnswers, forKey: "correctCount")
        self.performSegue(withIdentifier: "finish", sender: nil)
    }
    
    //部品を隠す処理
    func changeInvisible(flag: Bool) {
        self.ansLabel.isHidden = flag
        self.incorrectLabel.isHidden = flag
        self.correctLabel.isHidden = flag
        self.answerInputField.isEnabled = flag
        self.answerButton.isEnabled = flag
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
    
    //テキスト入力とボタン押下の禁止処理
    func setTextFieldAndAnswerButtonDisable() {
        self.answerInputField.isEnabled = false
        self.answerButton.isEnabled = false
    }
    
    //タイトルへ戻る処理
    @objc func toTitle() {
        self.performSegue(withIdentifier: "totitle", sender: nil)
    }
    
    //一時停止ボタン押下時実行
    @IBAction func tapStop(_ sender: UIBarButtonItem) {
        let appearance = SCLAlertView.SCLAppearance(hideWhenBackgroundViewIsTapped: true)
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("終了", target:self, selector:#selector(MainViewController.toTitle))
        alertView.showWait("一時停止中...", closeButtonTitle: "クイズ再開", colorStyle: 0xFFD151, colorTextButton: 0x1C1C1C)
    }
    
    //答えるボタン押下時実行
    @IBAction func answerTap(_ sender: UIButton) {
        self.checkAns()
    }
}

