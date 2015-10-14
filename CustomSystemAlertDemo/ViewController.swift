//
//  ViewController.swift
//  CustomSystemAlertDemo
//
//  Created by WeCarMac02 on 15/10/12.
//  Copyright © 2015年 WeCarMac02. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*提示框直接弹出*/
        /*
        let alert = UIAlertView(title: "hello", message: "world", delegate: nil, cancelButtonTitle: nil, otherButtonTitles:"1","2","3","2","3")
        alert.show()
        */
        
        
        /*以下弹不出提示框*/
        /*
        let alert = UIAlertController(title: "as", message: "assa", preferredStyle: UIAlertControllerStyle.Alert)
        let action = UIAlertAction(title: "what", style: UIAlertActionStyle.Default) { (action) -> Void in
            
        }
        alert.addAction(action)
        //UIApplication.sharedApplication().delegate?.window!!.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        self.presentViewController(alert, animated: true, completion: nil)
        */
        
        
        /*
        2015-10-13 17:44:52.016 CustomSystemAlertDemo[28666:6119832] Warning: Attempt to present <UIAlertController: 0x7f925ad3fa90> on <CustomSystemAlertDemo.ViewController: 0x7f925ad3afd0> whose view is not in the window hierarchy!
        */

        //同上问题
//        let alert = DIYSystemAlertView(title: "as", message: "hello world", buttonTitles: "1","2","3","4") { (index) -> Void in
//            print(index)
//        }
//        alert.show()
//

    }

    @IBAction func btnClick(sender: UIButton) {
         let alert = DIYSystemAlertView(title: "as", message: "hello world", buttonTitles: "0","1","2","3") { (index) -> Void in
            print(index)
        }
//         alert.show()
        
        
        let alert1 = DIYSystemAlertView(title: "xxxx", message: "嘻嘻", buttonTitles: "11","22","33", clickBlock: nil)
//        alert1.show()

        
//        let ctr = ViewController2(nibName:"ViewController2", bundle:nil)
//        self.navigationController!.pushViewController(ctr, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

