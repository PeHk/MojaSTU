//
//  EmailDetailViewController+Attachment.swift
//  InformationSystem
//
//  Created by Peter Hlavatík on 31/03/2020.
//  Copyright © 2020 Peter Hlavatík. All rights reserved.
//

import Foundation
import UIKit

extension EmailDetailViewController {
    @objc func attachmentTapped() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier:"attachmentViewController") as? AttachmentViewController {
            vc.attachmentArray = attachmentsArray!
            self.present(vc, animated: true, completion: nil)
        }
    }
    func showAttachmentView() {
        self.showAttachment.alpha = 0
        self.showAttachment.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.showAttachment.alpha = 1
        }
    }
}
