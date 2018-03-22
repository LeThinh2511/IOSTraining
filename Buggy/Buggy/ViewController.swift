//
//  ViewController.swift
//  Buggy
//
//  Created by ThinhLe on 3/3/18.
//  Copyright © 2018 ThinhLe. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func buttonTapped(_ sender: UIButton)
    {
        print("Method: \(#function) in file: \(#file) line: \(#line) called.")
        
        badMethod()
    }
    
    func badMethod()
    {
        let array = NSMutableArray()
        
        for i in 0..<10
        {
            array.insert(i, at: i)
        }
        
        for _ in 0...10
        {
            array.removeObject(at: 0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

