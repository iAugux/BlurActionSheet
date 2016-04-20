//
//  ViewController.swift
//  BlurActionSheetDemo
//
//  Created by nathan on 15/4/23.
//  Copyright (c) 2015年 nathan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel! {
        didSet {
            label.text = nil
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let titles = ["commit","reload image","save image","copy image","share image","cancel"]
        
        BlurActionSheet.showWithTitles(titles, handler: { (index) -> Void in
            
            self.label.text = "\"" + titles[index] + "\"" + " selected"
            
        })
    }
    
}

