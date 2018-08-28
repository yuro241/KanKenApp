//
//  UserDefaultsManager.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/08/28.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import Foundation

let userDefaults = UserDefaults.standard
class UserDefaultsManager {
    
    func setKana(textArr: [String]) {
        userDefaults.set(textArr, forKey: Keys.kana.rawValue)
    }
    func getKana() ->[String] {
        return userDefaults.array(forKey: Keys.kana.rawValue) as! [String]
    }
    
    func setKanji(textArr: [String]) {
        userDefaults.set(textArr, forKey: Keys.kanji.rawValue)
    }
    func getKanji() ->[String] {
        return userDefaults.array(forKey: Keys.kanji.rawValue) as! [String]
    }
    
    func setWrongAnswer(data: Data?) {
        userDefaults.set(data, forKey: Keys.wrongAnswer.rawValue)
    }
    func getWrongAnswer() ->Data? {
        return userDefaults.data(forKey: Keys.wrongAnswer.rawValue)
    }
    
    func setWrongTimeCount(nums: [[Int]]?) {
        userDefaults.set(nums, forKey: Keys.wrongTimeCount.rawValue)
    }
    func getWrongTimeCount() ->[[Int]]? {
        return userDefaults.array(forKey: Keys.wrongTimeCount.rawValue) as? [[Int]]
    }
    
    //TODO: gameModeはStringであらわしたい
    func setGameMode(num: Int) {
        userDefaults.set(num, forKey: Keys.gameMode.rawValue)
    }
    func getGameMode() ->Int {
        return userDefaults.integer(forKey: Keys.gameMode.rawValue)
    }
    
    func setNumOfWrongAnswer(num: Int) {
        userDefaults.set(num, forKey: Keys.numOfWrongAnswer.rawValue)
    }
    func getNumOfWrongAnswer() ->Int {
        return userDefaults.integer(forKey: Keys.numOfWrongAnswer.rawValue)
    }
    
    func setCorrectCount(num: Int) {
        userDefaults.set(num, forKey: Keys.correctCount.rawValue)
    }
    func getCorrectCount() ->Int {
        return userDefaults.integer(forKey: Keys.correctCount.rawValue)
    }
    
    func setAccuracy(num: Double) {
        userDefaults.set(num, forKey: Keys.accuracy.rawValue)
    }
    func getAccuracy() ->Double {
        return userDefaults.double(forKey: Keys.accuracy.rawValue)
    }
    
    func setOvercomeCount(num: Int) {
        userDefaults.set(num, forKey: Keys.overcomeCount.rawValue)
    }
    func getOvercomeCount() ->Int {
        return userDefaults.integer(forKey: Keys.overcomeCount.rawValue)
    }
}
