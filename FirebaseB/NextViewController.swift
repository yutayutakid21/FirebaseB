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
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
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
    
    
    @IBAction func postAction(_ sender: Any) {
        
        //DBのchildを決めていく。つまり、DatabaseのURLを取得していく
        let timeLineDB = Database.database().reference().child("timeLine").childByAutoId()
        
        //ストレージサーバーのURLを取得していく
        //URLの場所はFirebaseのStorageに記載
        //(DatabaseとStorageではURLが違う)
        
        let storage = Storage.storage().reference(forURL: /*"gs://swift5firebaseanonymousl-f7c71.appspot.com/"*/)
        
        
        //データを更新、削除するためのパスを作成する。
        //フォルダを作成していく。ここに画像が入っていく。
        //フォルダの名前はそれぞれ、Users Contentsとしておく
        let key = timeLineDB.child("Users").childByAutoId().key
        let key2 = timeLineDB.child("Contens").childByAutoId().key
        
        /*
         参照を作成する
         ファイルをアップロードするには、まず Cloud Storage 内のファイルをアップロードする場所への Cloud Storage 参照を作成します。
         ストレージ ルートに子パスを付加することで、参照を作成できます。
         */
        let imageRef = storage.child("Users").child("\(String(describing: key!)).jpg")
        let imageRef2 = storage.child("Contents").child("\(String(describing: key2!)).jpg")
        var userProfileImageData:Data = Data()
        var contentImageData:Data = Data()
        
        
        //ここは画像を圧縮している箇所
        //何か、userProfileImageView.imageに何かデータが入っていれば
        if userProfileImageView.image != nil {
            
            //そのままの画像データでStorageサーバーに送ると、かなり大きいので100分の1に圧縮している
            userProfileImageData = (userProfileImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        
        if contentImageView.image != nil {
            
            //そのままの画像データでStorageサーバーに送ると、かなり大きいので100分の1に圧縮している
            contentImageData = (contentImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        
        /*
         メモリ内のデータからアップロードする
         */
        //アップロードタスク。デバイスからStorageサーバーに画像を送信
        //クロージャーはuserProfileImageDataは手動で作成、ccontentImageDataは自動で設定(２パターン用意。基本的に同じコード)
        let uploadTask = imageRef.putData(userProfileImageData, metadata: nil){
            (metaData,error) in
            
            if error != nil {
                print(error)
                return
            }
            
            let uploadTask2 = imageRef2.putData(contentImageData, metadata: nil, completion: {
                (metaData, error) in
                
                if error != nil {
                    print(error)
                    return
                }
            })
        
        //サーバーに画像に保存をした後に、画像が保存されているURLをFireBase Storageが返信してくる
        imageRef.downloadURL(completion: { (url, error) in
            
            //urlに何かが入っていたら
            if url != nil {
                imageRef2.downloadURL(completion: { (url2, error) in
                    
                    //さらにurl2に何かが入っていたら
                    if url2 != nil {
                        
                        //この段階でデバイス上で、userName,comment,userProfileImage:画像が保存されているURL,contents:画像が保存されているURL2,postDateの情報が揃って、これからFirebaseDBへ送信できる準備が出来ている状態。
                        //キーバーリュー型で送信するものを準備する。
                        //Dictionary型で作成したキー値(左側の""で囲っているもの)をもとに受信していく
                        //abosoluteStringはURLを文字列型に変換しているもの
                        //ServerValue.timestanp()で現在時刻を取得
                        let timeLineInfo = ["userName":self.userName as Any, "userProfileImage":url?.absoluteString as Any, "contents":url2?.absoluteString as Any, "comment":self.commentTextField.text as Any, "postDate":ServerValue.timestamp()] as [String:Any]
                        
                        //                            let timeLineInfo:[String:Any] = ["userName":self.userName as Any, "userProfileImage":url?.absoluteString as Any, "contents":url2?.absoluteString as Any, "comment":self.commentTextField.text as Any, "postDate":ServerValue.timestamp()]
                        //このコードでtimeLineInfoの情報をFirebaseDBへ送信したことを記載
                        timeLineDB.updateChildValues(timeLineInfo)
                        
                        //ナビゲーションコントローラーでの”戻る"の意味になる。modal遷移でのdismissと同じ
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }
        })
        
        
    }
    
    //ここで「アップロードを続けてください」と書いてある
    uploadTask.resume()
    self.dismiss(animated: true, completion: nil)
    
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
