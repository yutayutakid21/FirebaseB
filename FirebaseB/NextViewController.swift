//
//  NextViewController.swift
//  FirebaseB
//
//  Created by 宏輝 on 27/12/2019.
//  Copyright © 2019 Fujii Yuta. All rights reserved.
//

import UIKit
import Photos
import Firebase

/*

課題

画面を3つ準備し、(ABC)

A.匿名ログイン後、Bへ画面遷移、DBへユーザー名とuserIDを入れ準備をする
B.画像をアルバムからとって来れるようにし、自分のアイコンとして画像として設定。
自分のDBへユーザー名、userID、画像URLを送信
C.プロフィールページとして、DBから自分のユーザー名、userID、画像を取得し、表示

*/

class NextViewController: UIViewController,UIImagePickerControllerDelegate {
    
    
    //匿名ログインIDをViewControllerからとってくる
    var passedUserID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //appleは「カメラを使っても良いですか？」とユーザーに問いかけなければならないようにしている。
        //ユーザーに画像ライブラリーの許可を促す。
        PHPhotoLibrary.requestAuthorization { (status) in
            
            switch status{
                
            case .authorized:
                print("許可されています。")
            case .denied:
                print("拒否された")
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
                
            }
        }
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func openAlbum(_ sender: Any) {
        
        let sourceType = UIImagePickerController.SourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let albumPicker = UIImagePickerController()
            albumPicker.sourceType = sourceType
            albumPicker.delegate = self
            albumPicker.allowsEditing = true
            present(albumPicker, animated: true, completion: nil)
            
        } else {
            print("エラー")
        }
    }
    
    
    

    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
