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
    
    private let userDefaultsManager = UserDefaultsManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.title = "復習結果"
        //navigationBarを非表示に
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        resultLabel.text = String(userDefaultsManager.getCorrectCount()) + "問正解"
        overcomeCountLabel.text = String(userDefaultsManager.getOvercomeCount()) + "個の問題を克服しました"
        
        //2秒後にタイトルへ自動遷移
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2), execute: {
            self.performSegue(withIdentifier: "totitle", sender: nil)
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // navigationBarを表示する
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

}
