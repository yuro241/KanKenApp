//
//  ViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/02/23.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//
//  iPhone7で実行しないと、ファイルのpath変わります

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
    var arrayKanji = [String]()
    //読み仮名データ
    var arrayKana = [String]()
    
    var count: Int = 1
    var correctAnswers: Int = 0
    var wrongAnswers: Int = 0
    var questionNum: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        correctLabel.isHidden = true
        incorrectLabel.isHidden = true
        ansLabel.isHidden = true
        
        self.readCSV()
        self.changeQuestion()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
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
        var arrayQuestion:[String] = UserDefaults.standard.array(forKey: "kanji")! as! [String]
        questionNum = Int(arc4random() % UInt32(arrayQuestion.count))
        questionLabel.text = arrayQuestion[questionNum]
        
        arrayQuestion.remove(at: questionNum)
    }
    
    //答え合わせ処理
    func checkAns() {
        print(arrayKana[questionNum])
        print(answerInputField.text!)
        if answerInputField.text! == arrayKana[questionNum] {
            self.correctAnswers += 1
            self.correctLabel.isHidden = false
            self.incorrectLabel.isHidden = true
            self.ansLabel.isHidden = true
        } else {
            self.wrongAnswers += 1
            self.correctLabel.isHidden = true
            self.incorrectLabel.isHidden = false
            self.ansLabel.text = "答えは：" + arrayKana[questionNum]
            self.ansLabel.isHidden = false
            
        }
        self.answerInputField.text! = ""
        count += 1
        self.answerInputField.isEnabled = false
        self.answerButton.isEnabled = false
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.ansLabel.isHidden = true
            self.incorrectLabel.isHidden = true
            self.correctLabel.isHidden = true
            self.answerInputField.isEnabled = true
            self.answerButton.isEnabled = true
            self.changeQuestion()
        })
        
    }
    
    //クイズ終了時の処理
    func finishQuiz() {
        print(Double(self.correctAnswers))
        let accuracy: Double = (Double(self.correctAnswers)/10)*100
        print(accuracy)
        UserDefaults.standard.set(accuracy, forKey: "accuracy")
        UserDefaults.standard.set(correctAnswers, forKey: "correctCount")
        self.performSegue(withIdentifier: "finish", sender: nil)
    }
    
    //一時停止ボタン押下時実行
    @IBAction func tapStop(_ sender: UIBarButtonItem) {
        print("pause")
        let alertView = SCLAlertView()
        alertView.addButton("タイトルへ", target:self, selector:#selector(MainViewController.toTitle))
        alertView.showInfo("Pause", subTitle: "一時停止中...", closeButtonTitle: "クイズ再開", colorStyle: 0x000088,colorTextButton: 0xFFFF00)
    }
    
    //タイトルへ戻る処理
    @objc func toTitle() {
        self.performSegue(withIdentifier: "totitle", sender: nil)
    }
    
    //答えるボタン押下時実行
    @IBAction func answerTap(_ sender: UIButton) {
        self.checkAns()
    }    
}

