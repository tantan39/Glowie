//
//  FilesPickerRouter.swift
//  Bloomr
//
//  Created by Tan Tan on 8/27/19.
//  Copyright © 2019 phdv. All rights reserved.
//

struct FilesPickerRouter: Router {
    func navigate(from root: AnyScreen?, transitionType: TransitionType, animated: Bool, completion: (() -> Void)? = nil) -> AnyObject? {
        let controller = UIDocumentPickerViewController(
            documentTypes: ["public.mpeg-4-audio", "public.mpeg-4", "public.audio", "public.movie"], // choose your desired documents the user is allowed to select
            in: .import // choose your desired UIDocumentPickerMode
        )
        return controller
        
    }
}
