//
//  QuestionPair.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/06/05.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import Foundation

struct Question: Codable, Equatable {
    var Kanji: String
    var Kana: String
    
    static func == (l: Question, r: Question) -> Bool {
        return l.Kanji == r.Kanji && l.Kana == r.Kana
    }
}


