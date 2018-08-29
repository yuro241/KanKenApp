//
//  CommonNumber.swift
//  KanKenApp
//
//  Created by Yuichiro Tsuji on 2018/08/29.
//  Copyright © 2018年 Yuichiro Tsuji. All rights reserved.
//

import Foundation
import CoreGraphics

//ポップアップのViewでつかう値
internal let POPUP_TITLE_FONT_SIZE: CGFloat = 24
internal let POPUP_TEXT_FONT_SIZE: CGFloat = 16
internal let POPUP_CONTENTS_CORNER_RADIUS: CGFloat = 10
internal let POPUP_BUTTON_CORNER_RADIUS: CGFloat = 5
internal let POPUP_COLOR_STYLE: UInt = 0xFFD151
internal let POPUP_TEXTBUTTON_COLOR_STYLE: UInt = 0x1C1C1C

//タイトルViewでつかう値
internal let MAINTITLE_LABEL_CORNER_RADIUS: CGFloat = 30
internal let SUBTITLE_LABEL_CORNER_RADIUS: CGFloat = 20
internal let BACKGROUNDVIEW_CORNER_RADIUS: CGFloat = 20
internal let STARTBUTTON_CORNER_RADIUS: CGFloat = 10
internal let MODESELECTBUTTON_CORNER_RADIUS: CGFloat = 10
internal let DEFAULT_NUMBER_OF_QUESTIONS: Int = 10

//クイズ画面でつかう値
internal let QUESTIONCOUNT_LABEL_CORNER_RADIUS: CGFloat = 10
internal let QUESTION_LABEL_CORNER_RADIUS: CGFloat = 20
internal let ANSWER_INPUTFIELD_CORNER_RADIUS:CGFloat = 10
internal let ANSWER_BUTTON_CORNER_RADIUS:CGFloat = 5

//復習問題リスト画面でつかう値
internal let CELL_CORNER_RADIUS: CGFloat = 10
internal let SHADOW_OPACITY: Float = 0.4

//結果画面で使う値
internal let RESTARTBUTTON_CORNER_RADIUS: CGFloat = 10
internal let TOTITLEBUTTON_CORNER_RADIUS: CGFloat = 10

enum QuestionNumber: Int {
    case tenQuestionsMode = 2
    case allQuestionsMode = 3
}

enum alphaValue: CGFloat {
    case light = 0.3
    case dark = 1.0
    case cell = 0.7
}
