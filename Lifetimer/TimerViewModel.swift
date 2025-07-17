import Foundation
import Combine

class TimerViewModel: ObservableObject {

    @Published var isTimerRunning: Bool = false
    
    private var timer: Timer?
    private var targetDate: Date?
    private let persistenceService = PersistenceService()

    // Callbacks to update the UI in AppDelegate
    var onTimeUpdate: ((String) -> Void)?
    var onTimerFinished: (() -> Void)?

    init() {
        // Load the target date from persistence and configure the timer.
        loadTargetDate()
    }

    /// Starts the countdown timer based on the number of years provided.
    func startTimer(years: Double) {
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .year, value: Int(years), to: Date()) {
            // Calculate seconds for fractional part of the year
            let remainingSeconds = (years - Double(Int(years))) * 365.25 * 24 * 60 * 60
            targetDate = calendar.date(byAdding: .second, value: Int(remainingSeconds), to: date)
            
            if let targetDate = targetDate {
                persistenceService.save(targetDate: targetDate)
                isTimerRunning = true
                setupTimer()
            }
        }
    }

    /// Resets the timer and clears the persisted target date.
    func resetTimer() {
        timer?.invalidate()
        timer = nil
        targetDate = nil
        persistenceService.clearTargetDate()
        isTimerRunning = false
        // Restore initial icon
        onTimeUpdate?("") // Clear title
        // You might need a more direct way to reset the icon if onTimeUpdate doesn't handle it
    }

    /// Loads the target date from persistence and sets up the timer if a date is found.
    private func loadTargetDate() {
        if let savedDate = persistenceService.loadTargetDate() {
            targetDate = savedDate
            isTimerRunning = true
            setupTimer()
        }
    }

    /// Sets up and starts the `Timer` instance.
    private func setupTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateCountdown()
        }
    }

    /// Called by the timer to update the remaining time.
    private func updateCountdown() {
        guard let targetDate = targetDate else {
            timer?.invalidate()
            return
        }

        let now = Date()
        let remainingSeconds = targetDate.timeIntervalSince(now)

        if remainingSeconds > 0 {
            let formattedString = format(seconds: remainingSeconds)
            onTimeUpdate?(formattedString)
        } else {
            onTimerFinished?()
            timer?.invalidate()
            isTimerRunning = false
        }
    }
    
    /// Formats the remaining seconds into a string.
    private func format(seconds: TimeInterval) -> String {
        return String(format: "%.0f", seconds)
    }
}
