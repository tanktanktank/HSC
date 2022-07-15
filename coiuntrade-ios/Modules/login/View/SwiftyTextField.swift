//
//  SwiftyTextField.swift
//  coiuntrade-ios
//
//  Created by tfr on 2022/4/24.
//

import UIKit

protocol SwiftyTextFieldDeleteDelegate {
    func didClickBackWard()
}

class SwiftyTextField: UITextField {
    
    var deleteDelegate:SwiftyTextFieldDeleteDelegate?
    
    override func deleteBackward() {
        super.deleteBackward()
        deleteDelegate?.didClickBackWard()

    }

}
