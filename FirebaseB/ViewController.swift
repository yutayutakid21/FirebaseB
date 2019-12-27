//
//  ViewController.swift
//  FirebaseB
//
//  Created by Fujii Yuta on 2019/12/27.
//  Copyright © 2019 Fujii Yuta. All rights reserved.
//

import UIKit
import Firebase


/*
 
 課題
 
 画面を3つ準備し、(ABC)
 
 A.匿名ログイン後、Bへ画面遷移、DBへユーザー名とuserIDを入れ準備をする
 B.画像をアルバムからとって来れるようにし、自分のアイコンとして画像として設定。
 自分のDBへユーザー名、userID、画像URLを送信
 C.プロフィールページとして、DBから自分のユーザー名、userID、画像を取得し、表示
 
 */

class ViewController: UIViewController {

    
    @IBOutlet weak var disPlayLoginID: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func loginButton(_ sender: Any) {
        
        Auth.auth().signInAnonymously { (authResult, error) in
                
                if error != nil {
                    print("ログイン失敗やで")
                    return

                } else {
                    print("ログイン成功しました")
                }
           
                guard let user = authResult?.user else {
                    return
                }
                
                //ログインしたユーザーが匿名であるかをbool
                //ログイン成功で匿名が保証されているので必要なし
                //let isAnonymous = user.isAnonymous
                self.displayLoginID.text = "   ID:\(user.uid)"
                
            }
            performSegue(withIdentifier: "next1", sender: nil)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "next1"{
            let nextVC:NextViewController = segue.destination as! NextViewController
            nextVC.passedUserID = user.uid
        }
    }
    
    
}

