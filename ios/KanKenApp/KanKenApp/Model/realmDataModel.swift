//
//  realmDataModel.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/04/19.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmModel {
    
    struct realm{
        static var realmTry  = try!Realm()
        static var realmsset = realmDataSet()
        static var usersSet = RealmModel.realm.realmTry.objects(realmDataSet.self)
    }
}
