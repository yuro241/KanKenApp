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
//import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var answerInputField: UITextField!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var incorrectLabel: UILabel!
    @IBOutlet weak var ansLabel: UILabel!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    
    let alertView = SCLAlertView()
    
    
    var arrayKanji = [String]()
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
        
        if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
            let targetTextFilePath = documentDirectoryFileURL.appendingPathComponent("test2.txt")
            print("読み込むファイルのパス: \(targetTextFilePath)")
            readTextFile(fileURL: targetTextFilePath)
        }
        self.changeQuestion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //テキストファイル読み込み処理
    func readTextFile(fileURL: URL) {
        do {
            let text = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
            
            // 行番号
            var lineNum = 1
            
            text.enumerateLines(invoking: {
                line, stop in
                print("\(lineNum): \(line)")
                if lineNum % 2 == 1 {
                    self.arrayKanji.append(line)
                } else {
                    self.arrayKana.append(line)
                }
                lineNum += 1
            })
            
        } catch let error as NSError {
            print("failed to read: \(error)")
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
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            self.changeQuestion()
        })
        
    }
    
    func finishQuiz() {
        //TODO: ここの確率計算を正確に(現状全て0%)
        print(self.correctAnswers)
        let accuracy: Double = Double(self.correctAnswers / 10)
        print(accuracy)
        UserDefaults.standard.set(accuracy, forKey: "accuracy")
        UserDefaults.standard.set(correctAnswers, forKey: "correctCount")
        self.performSegue(withIdentifier: "finish", sender: nil)
    }
    @IBAction func tapStop(_ sender: UIBarButtonItem) {
        print("pause")
        
    }
    
    @IBAction func answerTap(_ sender: UIButton) {
        self.checkAns()
    }    
}

