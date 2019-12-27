//
//  ThirdViewController.swift
//  FirebaseB
//
//  Created by 宏輝 on 27/12/2019.
//  Copyright © 2019 Fujii Yuta. All rights reserved.
//

import UIKit


/*

課題

画面を3つ準備し、(ABC)

A.匿名ログイン後、Bへ画面遷移、DBへユーザー名とuserIDを入れ準備をする
B.画像をアルバムからとって来れるようにし、自分のアイコンとして画像として設定。
自分のDBへユーザー名、userID、画像URLを送信
C.プロフィールページとして、DBから自分のユーザー名、userID、画像を取得し、表示

*/

class ThirdViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //FirebaseDBに画像URLなどの情報を送信して、その情報を受け取っている段階
     func fetchContentsData(){
         
         //queryLimited toLast に100を入れることで、最新100件とsなる
         //queryOrdered byChild にpostDateを入れることで、postDateの順番に値を取ってくる
         //observe .value で取得していく
         //snapShotに結果が入ってくる
         //つまり、"timeLine"の下にある、最新の100件のデータを"postDate"の順番に取得していったら、snapShotの中にデータが入ってくる
         let ref = Database.database().reference().child("timeLine").queryLimited(toLast: 100).queryOrdered(byChild: "postDate").observe(.value) { (snapShot) in
             
             //配列の中身を空にする
             self.contentsArray.removeAll()
             
             if let snapShot = snapShot.children.allObjects as? [DataSnapshot]{
                 
                 for snap in snapShot{
                     
                     if let postData = snap.value as? [String:Any]{
                         
                         let userName = postData["userName"] as? String
                         let userProfileImage = postData["userProfileImge"] as? String
                         let contents = postData["contens"] as? String
                         let comment = postData["comment"] as? String
                         
                         var postDate:CLong?
                         
                         if let postedDate = postData["postDate"] as? CLong{
                             postDate = postedDate
                         }
                         
                         //postDateを時間に変換していく。
                         let timeString = self.convertTimeStamp(serverTimeStamp: postDate!)
                         
                         
                         self.contentsArray.append(Contents(userNameString: userName!, profileImageString: userProfileImage!, contentImageString: contents!, commentString: comment!, postDateString: timeString))
                     }
                 }
                 self.timeLineTableView.reloadData()
                 
                 
                 //このままだと、一番最新のものが一番下のセルに入ってしまう状態になる。
                 //そのため、タイムラインを一番下まで自動スクロールする設定をする。
                 //-1 をしている理由。　contentArrayの最小値は1、indexPathの最小値は0 そのため-1をする。
                 let indexPath = IndexPath(row: self.contentsArray.count - 1, section: 0)
                 
                 
                 
                 if self.contentsArray.count >= 5 {
                 
                     //ここでタイムラインを一番下まで自動的にスクロースさせるコードを記載
                     self.timeLineTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                 }
             }
         }
     }
     
     
     
     func convertTimeStamp(serverTimeStamp: CLong) -> String{
         
         let x = serverTimeStamp / 1000
         let date = Date(timeIntervalSince1970: TimeInterval(x))
         let formatter = DateFormatter()
         formatter.dateStyle = .long
         formatter.timeStyle = .medium
         
         return formatter.string(from: date)
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
