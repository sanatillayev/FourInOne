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
        case .fetchData:
            break
        case .requestNotification:
            requestAuth()
        case .scheduleNotification:
            scheduleNotifications()
        }
    }
    
    private func scheduleNotifications() {
        if !state.didSetNotification {
            for i in state.times.indices {
                NotificationManager.shared.scheduleNotification(at: state.times[i], title: state.names[i], body: "\(state.times[i].toString()) It's time for prayer.")
            }
            state.didSetNotification = true
            saveNotificationState()
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
        UserDefaults.standard.removeObject(forKey: "didSetNotification")
        UserDefaults.standard.removeObject(forKey: "didAuthNotification")
        state.didAuthNotification = UserDefaults.standard.bool(forKey: state.authKey)
        state.didSetNotification = UserDefaults.standard.bool(forKey: state.setKey)
        
        //state.didSetNotification = false
    }
}

// MARK: - ViewModel Actions & State

extension AzonViewModel {
    
    enum Action {
        case fetchData
        case requestNotification
        case scheduleNotification
    }
    
    struct State {
        var isLoading = false
        var didSetNotification = false
        var didAuthNotification = false
        let setKey = "didSetNotificatio"
        let authKey = "didAuthNotificatio"
        var times: [DateComponents] = [
            DateComponents(hour: 5, minute: 0),
            DateComponents(hour: 13, minute: 0),
            DateComponents(hour: 16, minute: 35),
            DateComponents(hour: 16, minute: 40),
            DateComponents(hour: 16, minute: 45)
        ]
        let names: [String] = ["Fajr","Dhuhr","Asr","Maghrib","Isha"]
    }
}

extension DateComponents {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let date = calendar.date(from: self) ?? Date()
        return formatter.string(from: date)
    }
}
