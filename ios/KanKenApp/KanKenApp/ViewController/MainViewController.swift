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
    
    var count: Int = 1
    var correctAnswers: Int = 0
    var wrongAnswers: Int = 0
    var questionNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        correctLabel.isHidden = true
        incorrectLabel.isHidden = true
        ansLabel.isHidden = true
        self.setLayout()
        self.readCSV()
        self.changeQuestion()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        arrayKana = UserDefaults.standard.array(forKey: "kana") as! [String]
        arrayKanji = UserDefaults.standard.array(forKey: "kanji") as! [String]
        
        if let fetchedData = UserDefaults.standard.data(forKey: "wrongAnswer") {
            let fetchedWrongAnswers = try! PropertyListDecoder().decode([Question].self, from: fetchedData)
            self.arrayWrongAnswer = fetchedWrongAnswers
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
        if count > 10 {
            self.finishQuiz()
        }
        questionNumberLabel.text = String(count) + "問目"
        questionNum = Int(arc4random() % UInt32(arrayKanji.count))
        questionLabel.text = arrayKanji[questionNum]
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
    
    //間違えた問題を配列へ追加
    func addWrongAnswer() {
        //todo: Question構造体に,一文毎の間違えた数を要素として追加. もしarrayWrongAnswerに追加する問題と同じものがあれば,間違えた数をインクリメント
        arrayWrongAnswer.append(Question(Kanji: arrayKanji[questionNum], Kana: arrayKana[questionNum]))
    }
    
    //間違えた問題の配列データを,エンコードしてをUserDefaultsへ保存
    func setWrongAnswersToUserDefaults() {
        let wrongAnswersData = try! PropertyListEncoder().encode(arrayWrongAnswer)
        UserDefaults.standard.set(wrongAnswersData, forKey: "wrongAnswer")
    }
    
    //クイズ終了時の処理
    func finishQuiz() {
        setWrongAnswersToUserDefaults()
        let accuracy: Double = (Double(self.correctAnswers)/10)*100
        
        //fordebug UserDefaultsから間違えた問題を取得してデコード
        if let fetchedData = UserDefaults.standard.data(forKey: "wrongAnswer") {
            let fetchedWrongAnswers = try! PropertyListDecoder().decode([Question].self, from: fetchedData)
            print(fetchedWrongAnswers.count)
            for data in fetchedWrongAnswers {
                print(data.Kanji)
                print(data.Kana)
                //todo: 間違えた数も出力できればおｋ
            }
        }
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
        print("pause")
        let alertView = SCLAlertView()
        alertView.addButton("タイトルへ", target:self, selector:#selector(MainViewController.toTitle))
        alertView.showInfo("Pause", subTitle: "一時停止中...", closeButtonTitle: "クイズ再開", colorStyle: 0x000088,colorTextButton: 0xFFFF00)
    }
    
    //答えるボタン押下時実行
    @IBAction func answerTap(_ sender: UIButton) {
        self.checkAns()
    }
}

