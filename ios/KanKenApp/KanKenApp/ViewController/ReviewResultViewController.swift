//
//  ReviewResultViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/06/08.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit

class ReviewResultViewController: UIViewController {
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var overcomeCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resultLabel.text = String(UserDefaults.standard.integer(forKey: "correctCount")) + "問正解"
        
        overcomeCountLabel.text = String(UserDefaults.standard.integer(forKey: "overcomeCount")) + "個の問題を克服しました"
        
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {_ in
            self.performSegue(withIdentifier: "totitle", sender: nil)
        })
    }

}
