import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        setTabBarVCs()
        
        return true
    }
    
    // MARK: - Tab bars
    
    func setTabBarVCs() {
        
        let navigationController = window!.rootViewController as! UINavigationController
        let tabBarController = navigationController.topViewController as! UITabBarController
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let interestingPhotosViewController = storyboard.instantiateViewController(withIdentifier: "photosViewController") as! PhotosViewController
        let recentPhotosViewController = storyboard.instantiateViewController(withIdentifier: "photosViewController") as! PhotosViewController
        
        interestingPhotosViewController.photoType = PhotoType.interesting
        interestingPhotosViewController.store = PhotoStore()
        interestingPhotosViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.featured, tag: PhotoType.interesting.rawValue)
        
        recentPhotosViewController.photoType = PhotoType.recent
        recentPhotosViewController.store = PhotoStore()
        recentPhotosViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.recents, tag: PhotoType.recent.rawValue)
        
        tabBarController.setViewControllers([interestingPhotosViewController, recentPhotosViewController], animated: true)
        tabBarController.selectedIndex = 0
    }
    
    // MARK: - Life cycle

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

