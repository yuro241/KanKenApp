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
    
    private var cellCount: Int = 0
    private var wrongTimeCountArray: [[Int]] = [[],[]]
    
    private let userDefaultsManager = UserDefaultsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "復習単語リスト"
        wrongTimeCountArray = userDefaultsManager.getWrongTimeCount() ?? [[]]
        
        //wrongTimeCountArrayを降順ソート
        wrongTimeCountArray[0].sort(by: {$0 > $1})
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return userDefaultsManager.getNumOfWrongAnswer()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! CustomTableViewCell
        
        var wrongQuestionPairArray = deCodeWrongQuestion()

        cell.wrongTimeCountLabel.text = String(describing: wrongTimeCountArray[0][indexPath.section])
        cell.KanjiLabel.text = wrongQuestionPairArray[wrongTimeCountArray[1][indexPath.section]].Kanji
        cell.KanaLabel.text = wrongQuestionPairArray[wrongTimeCountArray[1][indexPath.section]].Kana
        
        cell.backgroundColor = #colorLiteral(red: 1, green: 0.9333333333, blue: 0.8352941176, alpha: 1)
        cell.alpha = alphaValue.cell.rawValue
        cell.layer.shadowOpacity = SHADOW_OPACITY
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.cornerRadius = CELL_CORNER_RADIUS
        cell.clipsToBounds = true
        
        return cell
    }
    
    private func deCodeWrongQuestion() -> [Question] {
        let fetchedData = userDefaultsManager.getWrongAnswer()
        let fetchedWrongAnswers = try! PropertyListDecoder().decode([Question].self, from: fetchedData!)
        
        return fetchedWrongAnswers
    }
}
