//
//  MainTabBarController.swift
//  
//
//  Created by Nikola Milenkovic on 6/9/17.
//
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    
    var trenutniIndex = 0
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        guard let index = viewControllers?.index(of: viewController) else { return }
        
        
        if index == trenutniIndex {
            
            guard let dum = dummy else { return }
            
            let offset = CGPoint(x: 0, y: -65)
            print("Returning")
            dum.collectionView?.setContentOffset(offset, animated: true)
            
        }
        
        trenutniIndex = index
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      
        let index = viewControllers?.index(of: viewController)
        
        if index == 2 {
            
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let photoSelNavController = UINavigationController(rootViewController: photoSelectorController)
            
            
            self.present(photoSelNavController, animated: true, completion: nil)
            
            return false
            
        }
        
        return true
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.delegate = self
        if Auth.auth().currentUser == nil {
            
            let loginController = LoginController()
            let navCOntroller = UINavigationController(rootViewController: loginController)
            DispatchQueue.main.async {
                
                
                self.present(navCOntroller, animated: true, completion: nil)
            }
            
            return
        }
        
        setupViewControllers()
        
        
    }
    
    func setupViewControllers() {
        
        // Home
        
        let homeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        /*
        let layoutH = UICollectionViewFlowLayout()
        let homeNavController = HomeController(collectionViewLayout: layoutH)
        homeNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        homeNavController.tabBarItem.selectedImage =  #imageLiteral(resourceName: "profile_selected")
        */
        
        // Search
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"),rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        //Plus
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        
        // Like
        let likeNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), selectedImage: #imageLiteral(resourceName: "like_selected"))
        
        // User Profile
        let layout = UICollectionViewFlowLayout()
        let userViewController = UserProfileController(collectionViewLayout: layout)
        let userProfileNavController = UINavigationController(rootViewController: userViewController)
        userProfileNavController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
        userProfileNavController.tabBarItem.selectedImage =  #imageLiteral(resourceName: "profile_selected")
        
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavController,
                           searchNavController,
                           plusNavController,
                           likeNavController,
                           userProfileNavController]
        
        guard  let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4.5, left: 0, bottom: -4.5, right: 0)
            
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage,selectedImage: UIImage,rootViewController : UIViewController = UIViewController()) -> UINavigationController {
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage
        return navController
        
        
    }
}
