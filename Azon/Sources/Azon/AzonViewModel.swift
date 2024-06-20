//
//  AzonViewModel.swift
//  
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Combine
import CoreModel

final class AzonViewModel: ObservableObject {
    
    // MARK: Public Properties
    @Published var state = State()
    let action = PassthroughSubject<Action, Never>()
    
    // MARK: Private properties
    private let worker: AnyAzonWorker
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Init
    init(worker: AnyAzonWorker) {
        self.worker = worker
        loadNotificationState()
        action
            .sink(receiveValue: { [unowned self] in
                self.didChange($0)
            })
            .store(in: &cancellables)
    }
    
    // MARK: Private Methods
    private func didChange(_ action: Action) {
        switch action {
        case .fetchAzon:
            fetchAzon()
        case .requestNotification:
            requestAuth()
        case .checkPendingNotifications:
            checkPendingNotifications()
        }
    }
    
    private func fetchAzon() {
        Task {
            DispatchQueue.main.async {
                self.state.isLoading = true
            }
            do {
                let response = try await worker.fetchAzon(year: state.currentYear, month: state.currentMonth)
                DispatchQueue.main.async {
                    self.state.prayers = response.data
                    self.state.isLoading = false
                    self.scheduleNotifications()
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    self.state.isLoading = false
                }
            }
        }
    }
    
    private func scheduleNotifications() {
        Task {
            if !state.didSetNotification {
                for prayer in state.prayers {
                    if prayer.date.gregorian.day == String(state.currentDay) {
                        NotificationManager.shared.scheduleNotification(at: DateComponents(hour: 16, minute: 52), title: "Test")
                        NotificationManager.shared.scheduleNotification(at: prayer.timings.Fajr.toDateComponents(), title: "Fajr")
                        NotificationManager.shared.scheduleNotification(at: prayer.timings.Dhuhr.toDateComponents(), title: "Dhuhr")
                        NotificationManager.shared.scheduleNotification(at: prayer.timings.Asr.toDateComponents(), title: "Asr")
                        NotificationManager.shared.scheduleNotification(at: prayer.timings.Maghrib.toDateComponents(), title: "Maghrib")
                        NotificationManager.shared.scheduleNotification(at: prayer.timings.Isha.toDateComponents(), title: "Isha")
                    }
                }
                DispatchQueue.main.async {
                    self.state.didSetNotification = true
                    self.saveNotificationState()
                }
            }
        }
    }
    
    private func requestAuth() {
        if !state.didAuthNotification {
            NotificationManager.shared.requestAuthorization()
            state.didAuthNotification = true
            UserDefaults.standard.set(state.didAuthNotification, forKey: state.authKey)
        }
    }
    
    private func saveNotificationState() {
        UserDefaults.standard.set(state.didSetNotification, forKey: state.setKey)
    }
    
///      - To test notification:   uncomment ```state.didSetNotification = false```
///      And add your notification time below inside `State` in `var times: [DateComponents]`
///      Note that when you uncomment this section the notificaions might be duplicated several times
    private func loadNotificationState() {
        state.didAuthNotification = UserDefaults.standard.bool(forKey: state.authKey)
        state.didSetNotification = UserDefaults.standard.bool(forKey: state.setKey)
    }
    
    private func checkPendingNotifications() {
        NotificationManager.shared.getPendingNotifications { requests in
            for request in requests {
                print("Notification ID: \(request.identifier)")
                print("Title: \(request.content.title)")
                print("Body: \(request.content.body)")
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    print("Date: \(trigger.dateComponents)")
                }
            }
        }
    }
}

// MARK: - ViewModel Actions & State

extension AzonViewModel {
    
    enum Action {
        case fetchAzon
        case requestNotification
        case checkPendingNotifications
    }
    
    struct State {
        var isLoading = false
        var didSetNotification = false
        var didAuthNotification = false
        let setKey = "didSetNotif"
        let authKey = "didAuthNotif"
        var prayers: [Prayer] = []
        let currentDay = Calendar.current.component(.day, from: Date())
        let currentMonth: String = String(Calendar.current.component(.month, from: Date()))
        let currentYear: String = String(Calendar.current.component(.year, from: Date()))
    }
}
