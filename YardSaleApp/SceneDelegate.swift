//
//  SceneDelegate.swift
//  YardSaleApp
//
//  Created by Charlie Brush on 6/6/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let tabBar = UITabBarController()

//            let map = UINavigationController(rootViewController: MapViewController())
//            let list = UINavigationController(rootViewController: ListViewController())
            let map = MapViewController()
            let list = ListViewController()
            let path = PathViewController()
           //let add = UINavigationController(rootViewController: NewSaleViewController())

            let config = UIImage.SymbolConfiguration(scale: .large)
           
            
            let unselectedMapIcon = UIImage(systemName: "map", withConfiguration: config)
            let selectedMapIcon = UIImage(systemName: "map.fill", withConfiguration: config)
            let unselectedListIcon = UIImage(systemName: "tag", withConfiguration: config)
            let selectedListIcon = UIImage(systemName: "tag.fill", withConfiguration: config)
            let unselectedCarIcon = UIImage(systemName: "car", withConfiguration: config)
            let selectedCarIcon = UIImage(systemName: "car.fill", withConfiguration: config)
//            let unselectedAddIcon = UIImage(systemName: "plus.square", withConfiguration: config)
//            let selectedAddIcon = UIImage(systemName: "plus.square.fill", withConfiguration: config)
            
            let carItem = UITabBarItem(title: "Travel", image: unselectedCarIcon, selectedImage: selectedCarIcon)
            let mapItem = UITabBarItem(title: "Map", image: unselectedMapIcon, selectedImage: selectedMapIcon)
            let listItem = UITabBarItem(title: "Sales", image: unselectedListIcon, selectedImage: selectedListIcon)
           // let addItem = UITabBarItem(title: "New Sale", image: unselectedAddIcon, selectedImage: selectedAddIcon)
            path.tabBarItem = carItem
            map.tabBarItem = mapItem
            list.tabBarItem = listItem
           // add.tabBarItem = addItem
        
            tabBar.setViewControllers([map,list,path], animated: false)
            tabBar.selectedIndex = 0
            tabBar.tabBar.barTintColor = .appColor
            tabBar.tabBar.tintColor = .white
            
            
            let navigationController = NavigationController(root: tabBar)
            list.delegate = navigationController
            map.delegate = navigationController
            path.delegate = navigationController
            navigationController.listDelegate = list
            navigationController.mapDelegate = map
            navigationController.pathDelegate = path
          
            window.rootViewController = navigationController
            self.window = window
            window.makeKeyAndVisible()
    }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

