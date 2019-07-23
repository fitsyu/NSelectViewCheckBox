//
//  ViewController.swift
//  NSelectViewCheckBox
//
//  Created by fitsyu on 06/20/2019.
//  Copyright (c) 2019 fitsyu. All rights reserved.
//

import UIKit
import NSelect
import NSelectViewCheckBox

class ViewController: UIViewController {
    
    @IBOutlet weak var buttonPrint: UIButton!
    
    var sortQ: NSelect   = NSelect()
    var filterQ: NSelect = NSelect()

    override func viewDidLoad() {
        super.viewDidLoad()
     
        
        // === single ===
        sortQ.title = "Sort by"
        sortQ.mode = .single
        sortQ.options = ["Distance", "Cheapest", "Availability"]
        sortQ.select(option: "Cheapest")
        
        let height = 30+CGFloat(30 * sortQ.options.count)
        let frame = CGRect(x: 8, y: 50, width: view.frame.width-16, height: height)
        let sortQView = NSelectViewCheckBox(frame: frame)
        sortQView.backgroundColor = UIColor.red
        sortQView.backing = sortQ
        
        self.view.addSubview(sortQView)
        sortQView.present()
        
        // === multi ===
        filterQ.title = "Facilites"
        filterQ.mode  = .multiple
        filterQ.options = [ "Living room", "Trees", "Breakfast", "Supermarket", "Carport" ]
        filterQ.select(options: "Trees", "Supermarket")
        
        let height2 = 30+CGFloat(30 * filterQ.options.count)
        let frame2 = CGRect(x: 8, y: 50+120+16, width: view.frame.width-16, height: height2)
        let filterQView = NSelectViewCheckBox(frame: frame2)
        filterQView.backing = filterQ
        
        self.view.addSubview(filterQView)
        filterQView.present()
        
        
        buttonPrint.addTarget(self, action: #selector(printSelection), for: .touchUpInside)
    }
    
    @objc func printSelection() {
        dump(sortQ.selections())
        print("===")
        dump(filterQ.selections())
    }
}

