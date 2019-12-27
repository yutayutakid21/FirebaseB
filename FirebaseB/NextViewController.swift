//
//  NextViewController.swift
//  FirebaseB
//
//  Created by 宏輝 on 27/12/2019.
//  Copyright © 2019 Fujii Yuta. All rights reserved.
//

import UIKit
import Photos

class NextViewController: UIViewController,UIImagePickerControllerDelegate {

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
