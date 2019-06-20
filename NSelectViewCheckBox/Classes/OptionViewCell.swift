//
//  OptionViewCell.swift
//  NSelectViewCheckBox
//
//  Created by iOSDev on 14/06/19.
//

import UICheckbox_Swift

class OptionViewCell: UICollectionViewCell {
    
    static var ID: String = "OptionViewCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkBox: UICheckbox!
    
    struct Data {
        var title: String
        var selected: Bool = false
    }
    
    var meta: Data! {
        didSet {
            titleLabel.text = meta.title
            checkBox.isSelected = meta.selected
        }
    }
}

