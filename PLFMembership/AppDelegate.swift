//
//  AppDelegate.swift
//  PLFMembership
//
//  Created by Platfarm on 2023/09/21.
//

import UIKit
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.setFCM(application)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    private func setFCM(_ application: UIApplication) {
        // 1. Push Notification 관련 설정
        UNUserNotificationCenter.current().delegate = self
        
            // Notification 허용 설정
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
            // APNs에 device token 요청
        application.registerForRemoteNotifications()
        
        // 2. Messaging delegate 설정
        Messaging.messaging().delegate = self
        
    }
    
    /// 수신한 푸시알림 탭 시
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        PLFLogger.logger.info("\(String(describing: #function)): \(String(describing: response.notification.request.content.userInfo as NSDictionary))")
    }
    
    /// Foreground 시 noti 수신
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {

        PLFLogger.logger.info("\(String(describing: #function)): \(String(describing: notification.request.content.userInfo as NSDictionary))")
   
        return [.sound, .banner, .list]
    }
    
    /// FCMToken 업데이트 시 호출 됨.
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken else { return }
        PLFLogger.logger.info("FCM Token Updated: \(String(describing: token))")
        
        Task {
            await self.setCloudTopicSubscription()
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Method Swizzling 사용을 중지했거나 SwiftUI 앱을 빌드 중인 경우 APN 토큰을 명시적으로 FCM 등록 토큰에 매핑
        Messaging.messaging().apnsToken = deviceToken
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        PLFLogger.logger.error("\(String(describing: #function)): \(String(describing: error))")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        if let messageID = userInfo[gcmMessageIDKey] {
           print("Message ID: \(messageID)")
         }

         // Print full message.
        print("🟢", #function, userInfo)

         return UIBackgroundFetchResult.newData
    }

}

extension AppDelegate {
    private func setCloudTopicSubscription() async {
        let topic: String = "new_user_forums"
        
        do {
            try await Messaging.messaging().subscribe(toTopic: topic)
            PLFLogger.logger.info("Successfully subscribed to FCM topic")
        }
        catch {
            print("Error subscribing to FCM Topic: \(error)")
        }
    }
}
