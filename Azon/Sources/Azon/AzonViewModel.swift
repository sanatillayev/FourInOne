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
        case .scheduleNotification:
            scheduleNotifications()
        }
    }
    
    private func fetchAzon() {
        Task.detached(priority: .high) { @MainActor [unowned self] in
            state.isLoading = true
            do {
                let response = try await worker.fetchAzon(year: state.currentYear,
                                                          month: state.currentMonth)
                state.prayers = response.data
                state.isLoading = false
            } catch {
                print(error)
                state.isLoading = false
            }
        }
    }
    
    private func scheduleNotifications() {
        if !state.didSetNotification {
            for prayer in state.prayers {
                NotificationManager.shared.scheduleNotification(at: prayer.timings.Fajr.toDateComponents(date: prayer.date.gregorian),title: "Fajr", body: "Its prayer time")
                NotificationManager.shared.scheduleNotification(at: prayer.timings.Dhuhr.toDateComponents(date: prayer.date.gregorian), title: "Dhuhr", body: "Its prayer time")
                NotificationManager.shared.scheduleNotification(at: prayer.timings.Asr.toDateComponents(date: prayer.date.gregorian), title: "Asr", body: "Its prayer time")
                NotificationManager.shared.scheduleNotification(at: prayer.timings.Maghrib.toDateComponents(date: prayer.date.gregorian), title: "Maghrib", body: "Its prayer time")
                NotificationManager.shared.scheduleNotification(at: prayer.timings.Isha.toDateComponents(date: prayer.date.gregorian), title: "Isha", body: "Its prayer time")
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
        state.didAuthNotification = UserDefaults.standard.bool(forKey: state.authKey)
        state.didSetNotification = UserDefaults.standard.bool(forKey: state.setKey)
    }
}

// MARK: - ViewModel Actions & State

extension AzonViewModel {
    
    enum Action {
        case fetchAzon
        case requestNotification
        case scheduleNotification
    }
    
    struct State {
        var isLoading = false
        var didSetNotification = false
        var didAuthNotification = false
        let setKey = "didSetNotification"
        let authKey = "didAuthNotification"
        var prayers: [Prayer] = []
        let currentDay = Calendar.current.component(.day, from: Date())
        let currentMonth: String = String(Calendar.current.component(.month, from: Date()))
        let currentYear: String = String(Calendar.current.component(.year, from: Date()))
    }
}
