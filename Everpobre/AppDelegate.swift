//
//  AppDelegate.swift
//  Everpobre
//
//  Created by Cristian Blazquez Bustos on 8/3/18.
//  Copyright © 2018 Cbb. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        
        // Creo unas imageCoreData
        let img1 = imageCoreData(objectid: "1", image: #imageLiteral(resourceName: "noThumbnail.png"))
        let img2 = imageCoreData(objectid: "2", image: #imageLiteral(resourceName: "noThumbnail.png"))
        let img3 = imageCoreData(objectid: "3", image: #imageLiteral(resourceName: "noThumbnail.png"))
        let img4 = imageCoreData(objectid: "4", image: #imageLiteral(resourceName: "noThumbnail.png"))
        
        // Creo unas Notas
        var note1 = Note(title: "Nota 1", creationDate: Date(), endDate:  Date(), tags: ["nota", "nueva"], images: [img1, img2], text: "TEXTOOOOOOOOO11111", notebook: nil)
        var note2 = Note(title: "Nota 2", creationDate: Date(), endDate: Date(), tags: ["otra", "mas"], images: [img3], text: "TEXTOOOOOOOOO22222", notebook: nil)
        var note3 = Note(title: "Nota 3", creationDate: Date(), endDate: Date(), tags: ["ultima", "nota"], images: [img4], text: "TEXTOOOOOOOOO33333", notebook: nil)
        
        // Creo unos Notebooks
        let notebook1 = Notebook(name: "Notebook 1", notes: [note1, note2])
        let notebook2 = Notebook(name: "Notebook 2", notes: [note3])
        
        note1.notebook = notebook1
        note2.notebook = notebook1
        note3.notebook = notebook2
        
        /**
        let notebooksVC =  NotebooksViewController(model: [notebook1, notebook2])
        let navVC = UINavigationController(rootViewController: notebooksVC)
        */
        let noteVC = NoteViewController(model: note1)
        
        window?.rootViewController = noteVC
        
        window?.makeKeyAndVisible()
        
        return true
    }
    
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
