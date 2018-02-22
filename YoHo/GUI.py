#-------------------------------------------------------------------------------
# Name:        module1
# Purpose:
#
# Author:      Yoshiki Honda
#
# Created:     07/07/2017
# Copyright:   (c) Yoshiki Honda 2017
# Licence:     <your licence>
#-------------------------------------------------------------------------------

# -*- coding: utf8 -*-
import sys
import tkinter      #GUIのモジュール
import re           #正規表現のモジュール
import random

args = sys.argv     #ファイル名読み込む
global practice     #ファイルから読み込んだデータを格納する　globalはどのメソッドでも使える
practice=[]
j=0
escape = re.sub('[A-z]',"",args[1])         #ver04.txt →04.だけを抜き取る
COUNT = str(int(escape[0])*10 + int(escape[1]) )        #何回目かを表す

f1= open(args[1],'r',encoding='shift_jis')       #ファイルを開く(読み取り専用)
for line in f1:
    escape = line.split("\t")   #タブで文字列を分けて配列へ
    print(escape)
    practice.append([escape[0]])
    practice[j].append([escape[1]])
    practice[j][1].append(int(re.sub("\n","",escape[2])))   #例[ [茅蜩[ひぐらし,0]] [踏鞴[たたら,1]] ...]
    j+=1

random.shuffle(practice)    #ここで配列をシャッフルする(ランダム要素)


root = tkinter.Tk() #GUIを開く
root.title(u"漢字練習プログラム")    #タイトル
root.option_add('*font', 'FixedSys 40')

Static1 = tkinter.Label(text=u'第　1　問')  #ラベル
Static1.pack()
Static2 = tkinter.Label(text=u'ミス'+str(practice[0][1][1])+u'/'+COUNT)   #上のラベルの下に何回ミスってるか表示
Static2.pack()

#エントリー
Box = tkinter.Entry()   #問題表示させるところ
Box.pack(side="top") #fill = 'both'
EditBox = tkinter.Entry()   #答え入力するところ
EditBox.pack(side="top")

Box.insert(tkinter.END,practice[0][0])  #1問目表示
global count
global i
count=0
i=0

def Check(event):   #正否をチェック
    global i
    global count
    j=i
    if(practice[j][1][0]==EditBox.get()):   #入力した答えと配列の文字列が一致
        Static2.configure(text=u'正解！',foreground='#ff0000')
        count += 1
    else:   #違うとき
        Static2.configure(text=u'不正解！  :'+practice[j][1][0],foreground='#0000ff')
        practice[j][1][1]=int(practice[j][1][1])+1  #間違い数を増やす
    i += 1

def Next(event):    #次の問題へいく～
    Box.delete(0, tkinter.END)
    EditBox.delete(0, tkinter.END)  #ボックスから文字を消す

    if(i==len(practice)):   #最終問題を終えた場合
        Static2.configure(text=str(len(practice))+u"問中"+str(count)+u"問正解!("+str(('%03.2f' % (count/len(practice)*100) ))+u"%)")
        f4 = open("Percentage of correct answers.txt",'a')
        f4.write(str(('%03.2f' % (count/len(practice)*100) ))+"%\n")
        f4.close()  #パーセント表示してファイルに記録
        double=0
    else:
        Box.insert(tkinter.END,practice[i][0])
        Static1.configure(text=u'第　'+str(i+1)+'　問')
        Static2.configure(text=u'ミス'+str(practice[i][1][1])+u'/'+COUNT,foreground='#000000')    #次の問題を表示させる

def Quit(event):    #終了ボタン押した場合
    f3 = open(args[2],'w')
    for M in range(len(practice)):
        f3.write(str(practice[M][0])+"\t"+str(practice[M][1][0])+"\t"+str(practice[M][1][1])+"\n")
    f3.close()
    root.destroy()  #ファイルにデータを書き込み


root.bind("<Return>",Check)
root.bind("<Shift_R>",Next)

Button3 = tkinter.Button(text=u'終　了')
Button3.bind("<Button-1>",Quit)
Button3.pack( side = 'right',fill = 'both')

root.mainloop()
