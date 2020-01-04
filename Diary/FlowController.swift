//
//  FlowController.swift
//  Diary
//
//  Created by tautau on 2019/7/19.
//  Copyright © 2019年 tautau. All rights reserved.
//

import UIKit

protocol LoginVCDelegate:AnyObject {
    func login(withVc vc:LoginViewController)
    func goToSignUp(withVc vc:LoginViewController)
}

protocol SignUpVCDelegate:AnyObject {
    func signUp(withVc vc:SignUpViewController)
}

protocol DiaryListVCDelegate:AnyObject {
    func goToAddDiary(withVc vc:DiaryListViewController)
}

protocol UserDataVCDelegate:AnyObject {
    func goToDetailedDiary(withIndex index:Int, vc:UserDataViewController)
}

class FlowController: UIViewController {
    
    lazy var diaryListVC:DiaryListViewController = {
        let vc = DiaryListViewController()
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon-home"), tag: 0)
        vc.delegate = self
        return vc
    }()
    
    lazy var diaryWallVC:DiaryWallViewController = {
        let vc = DiaryWallViewController()
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon-search"), tag: 1)
        return vc
    }()
    
    lazy var userDataVC:UserDataViewController = {
        let vc = UserDataViewController()
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icon-person"), tag: 2)
        vc.delegate = self
        return vc
    }()
    
    lazy var loginVC:LoginViewController = {
        let vc = LoginViewController()
        vc.delegate = self
        return vc
    }()
    
    lazy var signUpVC:SignUpViewController = {
        let vc = SignUpViewController()
        vc.delegate = self
        return vc
    }()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(loginVC, animated: false)
    }
    
}

extension FlowController:LoginVCDelegate{
    func goToSignUp(withVc vc: LoginViewController) {vc.present(signUpVC, animated: false)}
    
    func login(withVc vc:LoginViewController) {
        guard let email = vc.email.text, email.count>0 else {
            let alert = UIAlertController(title: "Warning", message: "Email Can't not be empty!")
            alert.activatedBy(vc:vc)
            return
        }
        
        guard let password = vc.password.text, password.count>0 else {
            let alert = UIAlertController(title: "Warning", message: "Password Can't not be empty!")
            alert.activatedBy(vc:vc)
            return
        }
        
        UserSocialService.share.login(withEmail: email, password: password) { (result) in
            guard let id = result.value else{
                let alert = UIAlertController(title: "Sign In Failed",message: result.errorMessage!)
                alert.activatedBy(vc: vc)
                return
            }
            self.ConfigViewControllers(withLoginID: id)
            let tabVc = TabBarController(viewControllers: [self.diaryListVC,self.diaryWallVC,self.userDataVC])
            vc.present(tabVc, animated: false)
        }
    }
    
    private func ConfigViewControllers(withLoginID id:String) {
        let followList = Observable<[Member]>(value: [])
        let currentUser = Observable<Member?>(value: nil)
        diaryListVC.controller.followList = followList
        diaryWallVC.controller.followList = followList
        userDataVC.controller.userInfo = currentUser
        diaryListVC.controller.loginID = id
        diaryWallVC.controller.loginID = id
        UserSocialService.share.getUserInfo(withID: id) {currentUser.value = $0.value}
        UserSocialService.share.getFollowList(withID: id) {followList.value = $0.value!}
        UserSocialService.share.getAllUserInfo(){ if let allUser = $0.value {self.diaryWallVC.controller.allUser = allUser}}
    }
}

extension FlowController:SignUpVCDelegate{
    func signUp(withVc vc: SignUpViewController) {
        guard let email = vc.email.text, email.count>0 else {
            let alert = UIAlertController(title: "Warning", message: "Email Can't not be empty!")
            alert.activatedBy(vc:vc)
            return
        }
        
        guard let password = vc.password.text, password.count>0 else {
            let alert = UIAlertController(title: "Warning", message: "Password Can't not be empty!")
            alert.activatedBy(vc:vc)
            return
        }
        
        guard let name = vc.userName.text, name.count>0 else {
            let alert = UIAlertController(title: "Warning", message: "Password Can't not be empty!")
            alert.activatedBy(vc:vc)
            return
        }
        
        let user = Member(name: name, email: email)
        UserSocialService.share.signUp(withUserInfo: user, password: password, image: vc.avatar.image!) { (result) in
            if let e = result.errorMessage {print(e); return}
            DispatchQueue.main.async {vc.dismiss(animated: false)}
        }
    }
}

extension FlowController:DiaryListVCDelegate {
    func goToAddDiary(withVc vc: DiaryListViewController) {
        let addDiaryVc = AddDiaryViewController()
        addDiaryVc.userId = vc.controller.loginID
        vc.navigationController?.pushViewController(addDiaryVc, animated: false)
    }
}

extension FlowController: UserDataVCDelegate{
    func goToDetailedDiary(withIndex index:Int, vc: UserDataViewController) {
        let detailedVC = DiaryDetailedViewController()
        let diaryCellVM = vc.viewModel.diaryCellViewModels.value[index]
        detailedVC.viewModel.diaryCellVM.value = diaryCellVM
        detailedVC.completeEditAction = { (diaryCellVM) in
            vc.viewModel.diaryCellViewModels.value[index] = diaryCellVM!
        }
        vc.navigationController?.pushViewController(detailedVC, animated: true)
    }
}
