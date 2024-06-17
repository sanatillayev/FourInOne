//
//  AzonViewModel.swift
//  
//
//  Created by Bilol Sanatillayev on 09/06/24.
//

import SwiftUI
import Combine
import CoreModel
import SwiftData

final class AzonViewModel: ObservableObject {
    
    // MARK: Public Properties
    @Published var state = State()
    let action = PassthroughSubject<Action, Never>()
    
    // MARK: Private properties
    @Environment(\.modelContext) var modelContext
    @Query var prayers: [Prayer]
    
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
                state.todayPrayer = response.data[state.currentDay - 1]
                state.isLoading = false
            } catch {
                print(error)
                state.isLoading = false
            }
        }
    }
    
    private func scheduleNotifications() {
        if !state.didSetNotification, let timing = state.todayPrayer?.timings {
            NotificationManager.shared.scheduleNotification(at: timing.Fajr.toDateComponents(), title: "Fajr", body: "Its prayer time")
            NotificationManager.shared.scheduleNotification(at: timing.Dhuhr.toDateComponents(), title: "Dhuhr", body: "Its prayer time")
            NotificationManager.shared.scheduleNotification(at: timing.Asr.toDateComponents(), title: "Asr", body: "Its prayer time")
            NotificationManager.shared.scheduleNotification(at: timing.Maghrib.toDateComponents(), title: "Maghrib", body: "Its prayer time")
            NotificationManager.shared.scheduleNotification(at: timing.Isha.toDateComponents(), title: "Isha", body: "Its prayer time")
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
        UserDefaults.standard.removeObject(forKey: "didSetNotificatio")
        UserDefaults.standard.removeObject(forKey: "didAuthNotificatio")
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
        var todayPrayer: Prayer?
        let currentDay = Calendar.current.component(.day, from: Date())
        let currentMonth: String = String(Calendar.current.component(.month, from: Date()))
        let currentYear: String = String(Calendar.current.component(.year, from: Date()))
    }
}

extension String {
    func toDateComponents() -> DateComponents {
        let pattern = #"(\d{2}):(\d{2})\(\+\d{2}\)"#
        let regex = try! NSRegularExpression(pattern: pattern, options: [])

        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        
        guard let match = matches.first else {
            return DateComponents()
        }
        
        let hourRange = Range(match.range(at: 1), in: self)
        let minuteRange = Range(match.range(at: 2), in: self)
        
        guard let hourString = hourRange.flatMap({ String(self[$0]) }),
              let minuteString = minuteRange.flatMap({ String(self[$0]) }),
              let hour = Int(hourString),
              let minute = Int(minuteString) else {
            return DateComponents()
        }

        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        
        return dateComponents
    }
}
