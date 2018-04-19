//
//  realmDataSet.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/04/19.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import Foundation
import RealmSwift

class realmDataSet: Object {
    @objc dynamic var id = Int()
    @objc dynamic var kanji = String()
//    @objc dynamic var kana = String()
}
