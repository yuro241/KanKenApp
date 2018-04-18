//
//  ViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/02/23.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//
//  iPhone7で実行しないと、ファイルのpath変わります

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var answerInputField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last {
            // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
            let targetTextFilePath = documentDirectoryFileURL.appendingPathComponent("test2.txt")
            print("読み込むファイルのパス: \(targetTextFilePath)")
            readTextFile(fileURL: targetTextFilePath)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //テキストファイル読み込み処理
    func readTextFile(fileURL: URL) {
        do {
            let text = try String(contentsOf: fileURL, encoding: String.Encoding.utf8)
            print(text)
        } catch let error as NSError {
            print("failed to read: \(error)")
        }
    }
    
    @IBAction func answerTap(_ sender: UIButton) {
        
    }
    
    
}

