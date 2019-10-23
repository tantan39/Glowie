//
//  FilesManager.swift
//  Bloomr
//
//  Created by Tan Tan on 8/27/19.
//  Copyright © 2019 phdv. All rights reserved.
//

protocol DocumentManagerDelegate: class {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController)
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL])
}

class DocumentManager: NSObject {
    
    private let documentPicker = UIDocumentPickerViewController(
        documentTypes: ["public.mpeg-4-audio", "public.mpeg-4", "public.audio", "public.movie", "public.mp3"], // choose your desired documents the user is allowed to select
        in: .import // choose your desired UIDocumentPickerMode
    )
    
    weak var delegate: DocumentManagerDelegate?
    
    func openDocumentPickerViewController(from viewController: BaseViewController?) {
        guard let viewController = viewController else { return }
        documentPicker.delegate = self
        if #available(iOS 11.0, *) {
            documentPicker.allowsMultipleSelection = false
        }
        viewController.present(
            documentPicker,
            animated: true,
            completion: nil
        )
    }
}

extension DocumentManager: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.delegate?.documentPickerWasCancelled(controller)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        if let delegate = self.delegate {
            delegate.documentPicker(controller, didPickDocumentsAt: urls)
        } else {
            guard let contestRanking = UIViewController.topMostViewController() as? ContestRankingViewController else { return }
            self.delegate = contestRanking
            self.delegate?.documentPicker(controller, didPickDocumentsAt: urls)
        }
    }
}
