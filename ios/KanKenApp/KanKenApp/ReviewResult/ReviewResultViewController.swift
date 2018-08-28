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
        
        self.navigationItem.title = "復習結果"
        //navigationBarを非表示に
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        resultLabel.text = String(UserDefaults.standard.integer(forKey: Keys.correctCount.rawValue)) + "問正解"
        overcomeCountLabel.text = String(UserDefaults.standard.integer(forKey: Keys.overcomeCount.rawValue)) + "個の問題を克服しました"
        
        //2秒後にタイトルへ自動遷移
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
            self.performSegue(withIdentifier: "totitle", sender: nil)
        })
    }

}
