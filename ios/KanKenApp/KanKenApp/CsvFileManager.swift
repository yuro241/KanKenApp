//
//  ReadCSVFile.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/08/28.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import Foundation

class CsvFileManager {
    //データ配列
    private var dataList: [String] = []
    private var kanjiArray: [String] = []
    private var kanaArray: [String] = []
    
    func readCsv() {
        //CSVファイルのPath取得
        let csvPath = Bundle.main.path(forResource: "questions", ofType: "csv")
        //CSVファイルのデータを取得
        let csvData = try! String(contentsOfFile:csvPath!, encoding:String.Encoding.utf8)
        //改行ごとにデータ格納
        dataList = csvData.components(separatedBy: "\n")
        //漢字とひらがなに分割
        for i in 0..<dataList.count-1 {
            let array: Array = dataList[i].components(separatedBy: ",")
            kanjiArray.append(array[0])
            kanaArray.append(array[1])
        }
        UserDefaults.standard.set(kanjiArray, forKey: Keys.kanji.rawValue)
        UserDefaults.standard.set(kanaArray, forKey: Keys.kana.rawValue)
    }
}
