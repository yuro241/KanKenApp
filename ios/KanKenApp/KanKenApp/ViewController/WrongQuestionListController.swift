//
//  WrongQuestionListController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/06/06.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit

class WrongQuestionListController: UITableViewController {
    
    @IBOutlet var baseTableView: UITableView!
    
    var cellCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.baseTableView.backgroundColor = #colorLiteral(red: 1, green: 0.8196078431, blue: 0.3176470588, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9058823529, green: 0.4666666667, blue: 0.1568627451, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellCount = UserDefaults.standard.integer(forKey: "numOfWrongAnswer")
        print(cellCount)
        return cellCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
        var wrongQuestionPairArray = deCodeWrongQuestion()
        cell.textLabel?.text = wrongQuestionPairArray[indexPath.row].Kanji
        
        return cell
    }
    
    func deCodeWrongQuestion() -> [Question] {
        var wrongQuestionPair: [Question] = []
        if let fetchedData = UserDefaults.standard.data(forKey: "wrongAnswer") {
            let fetchedWrongAnswers = try! PropertyListDecoder().decode([Question].self, from: fetchedData)
//            cellCount = fetchedWrongAnswers.count
//            print(fetchedWrongAnswers.count)
//            for data in fetchedWrongAnswers {
//                print(data.Kanji)
//                print(data.Kana)
//                //todo: 間違えた数も出力できればおｋ
//            }
            wrongQuestionPair = fetchedWrongAnswers
        }
        return wrongQuestionPair
    }
}
