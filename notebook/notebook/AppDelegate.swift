//
//  AppDelegate.swift
//  notebook
//
//  Created by user on 07.03.18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit
import CocoaLumberjack

private let apiHost = "http://notes.mrdekk.ru"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var navigation: UINavigationController?
    private var coreDataManager: CoreDataManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs
        
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60*60*24)
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
        
        window = UIWindow()
        window?.rootViewController = AuthViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let host = URL(string: apiHost) else {
            return false
        }
        
        let urlString = url.absoluteString.removingPercentEncoding
        guard let hashToQuery = urlString?.replacingOccurrences(of: "#", with: "?", options: .caseInsensitive, range: urlString?.range(of: "#")),
            let components = URLComponents(string: hashToQuery),
            let token = (components.queryItems?.first { $0.name == "access_token" })?.value else {
            return false
        }
        
        DDLogInfo("Successfully authorized with OAuth-token")
        
        let dispatcher = OperationDispatcher()
        
        let api = Api(host: host, authToken: token)
        let serverOperationsFactory = ApiNoteOperationsFactory(api: api)
        
        coreDataManager = CoreDataManager(modelName: "Model")
        let localOperationsFactory = CoreDataOperationsFactory(coreDataManager: coreDataManager)
        
        let noteProvider = NoteProvider(
            serverOperationsFactory: serverOperationsFactory,
            localOperationsFactory: localOperationsFactory,
            operationsDispatcher: dispatcher)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        navigation = storyboard.instantiateInitialViewController() as? UINavigationController
        guard let navigation = navigation,
            let notesList = storyboard.instantiateViewController(
                withIdentifier: "NotesListViewController") as? NotesListViewController else {
                    return false
        }
        
        notesList.notesProvider = noteProvider
        
        navigation.pushViewController(notesList, animated: false)
        
        window?.rootViewController = navigation
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        try? coreDataManager.objectContext.save()
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
        try? coreDataManager.objectContext.save()
    }
}

