//
//  TabBarController.swift
//  Diary
//
//  Created by tautau on 2019/11/26.
//  Copyright © 2019 tautau. All rights reserved.
//

import Foundation
import UIKit

class TabBarController:UITabBarController{

    init(viewControllers:[UIViewController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = viewControllers.map() {UINavigationController(rootViewController: $0)}
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
