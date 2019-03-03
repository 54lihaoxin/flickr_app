//
//  KeyboardToolbar.swift
//  FlickrApp
//
//  Created by Haoxin Li on 3/2/19.
//  Copyright © 2019 Haoxin Li. All rights reserved.
//

import UIKit

protocol KeyboardToolbarDelegate: class {
    func keyboardToolbarDidHitCancelButton(_ keyboardToolbar: KeyboardToolbar)
}

final class KeyboardToolbar: UIToolbar {
    private unowned let keyboardToolbarDelegate: KeyboardToolbarDelegate

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    init(unownedDelegate: KeyboardToolbarDelegate) {
        keyboardToolbarDelegate = unownedDelegate
        super.init(frame: .zero)

        let leadingSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "BUTTON.CANCEL".localized(),
                                           style: .plain,
                                           target: self,
                                           action: #selector(handleCancel))
        items = [leadingSpace, cancelButton]
    }
}

private extension KeyboardToolbar {
    @objc func handleCancel() {
        keyboardToolbarDelegate.keyboardToolbarDidHitCancelButton(self)
    }
}
