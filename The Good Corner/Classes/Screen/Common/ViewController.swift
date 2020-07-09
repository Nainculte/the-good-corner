//
//  ViewController.swift
//  The Good Corner
//
//  Created by Olivier Duménil on 09/07/2020.
//  Copyright © 2020 Olivier Duménil. All rights reserved.
//

import UIKit

class ViewController<VM, C>: UIViewController {

    let viewModel: VM
    let coordinator: C

    init(viewModel: VM,
         coordinator: C,
         nibName: String? = nil,
         bundle: Bundle? = nil) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("title", comment: "")
    }
    
}
