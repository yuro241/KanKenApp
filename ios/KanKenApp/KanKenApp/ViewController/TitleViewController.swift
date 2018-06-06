//
//  TitleViewController.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/06/03.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var mainTitleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    func setLayout() {
        self.startButton.layer.cornerRadius = 10
        self.mainTitleLabel.layer.cornerRadius = 20
        self.mainTitleLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.mainTitleLabel.clipsToBounds = true
        self.subTitleLabel.layer.cornerRadius  = 20
        self.subTitleLabel.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.subTitleLabel.clipsToBounds = true
    }
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "start", sender: nil)
    }
    
    //fordebug
    @IBAction func toWQList(_ sender: Any) {
        self.performSegue(withIdentifier: "toWrongQuestionList", sender: nil)
    }
}
