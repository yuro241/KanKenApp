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
        
        self.baseTableView.backgroundColor = #colorLiteral(red: 1, green: 0.831372549, blue: 0, alpha: 1)
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.9270954605, green: 0.4472710504, blue: 0.05901660795, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return UserDefaults.standard.integer(forKey: "numOfWrongAnswer")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
        
        var wrongQuestionPairArray = deCodeWrongQuestion()
        let wrongTimeCountArray = UserDefaults.standard.array(forKey: "wrongTimeCount")
        
        cell.textLabel?.text = wrongQuestionPairArray[indexPath.section].Kanji
        cell.detailTextLabel?.text = wrongQuestionPairArray[indexPath.section].Kana
        //TODO: wrongTimeCountArrayの数やKanaを正しくCellに表示(カスタムセル作る)
        print(wrongTimeCountArray![indexPath.section])
        cell.detailTextLabel?.textColor = UIColor.black
        
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.9333333333, blue: 0.8352941176, alpha: 1)
        cell.alpha = 0.7
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = true
        
        return cell
    }
    
    func deCodeWrongQuestion() -> [Question] {
        var wrongQuestionPair: [Question] = []
        if let fetchedData = UserDefaults.standard.data(forKey: "wrongAnswer") {
            let fetchedWrongAnswers = try! PropertyListDecoder().decode([Question].self, from: fetchedData)
            wrongQuestionPair = fetchedWrongAnswers
        }
        return wrongQuestionPair
    }
}
