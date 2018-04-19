//
//  ViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/02/23.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//
//  iPhone7で実行しないと、ファイルのpath変わります

import UIKit
import RealmSwift

class MainViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var answerInputField: UITextField!
    
    let realmData = realmDataSet()
    
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
            
            // 行番号
            var lineNum = 1
            
            text.enumerateLines(invoking: {
                line, stop in
                print("\(lineNum): \(line)")
                //realmへのデータ追加
                //TODO: idをprimaryKeyとし、idごとにデータ(漢字と読み)を追加していく必要
                self.realmData.id = lineNum
                self.realmData.kanji = line
                self.save()
                lineNum += 1
            })
            
        } catch let error as NSError {
            print("failed to read: \(error)")
        }
        
    }
    
    func save() {
        do {
            let realm = try Realm()  // Realmのインスタンスを作成します。
            try realm.write {
                realm.add(self.realmData)  // 作成した「realm」というインスタンスにrealmDataを書き込みます。
            }
        } catch {
            
        }
    }
    
    func out() {
        let realm = try! Realm()
        //TODO: primaryKeyを指定して、表示したい問題を取得する
        let data = realm.objects(realmDataSet.self)
    }
    
    @IBAction func answerTap(_ sender: UIButton) {
        self.out()
    }    
}

