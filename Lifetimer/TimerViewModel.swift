import Foundation
import Combine

class TimerViewModel: ObservableObject {

    @Published var isTimerRunning: Bool = false
    
    private var timer: Timer?
    private var targetDate: Date?
    private let persistenceService = PersistenceService()

    // Callbacks to update the UI in the App struct
    var onTimeUpdate: ((String) -> Void)?
    var onTimerFinished: (() -> Void)?

    // We no longer need the init() to load the date,
    // as the .task modifier will call a dedicated function.

    /// This is called from the .task modifier to set the initial state.
    func initializeTimerState() {
        if let savedDate = persistenceService.loadTargetDate() {
            targetDate = savedDate
            isTimerRunning = true
            setupTimer()
            updateCountdown() // Call once immediately to set the initial text
        } else {
            isTimerRunning = false
            onTimeUpdate?("") // Ensure the hourglass is shown initially
        }
    }

    /// Starts the countdown timer based on the number of years provided.
    func startTimer(years: Double) {
        let calendar = Calendar.current
        if let date = calendar.date(byAdding: .year, value: Int(years), to: Date()) {
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
        onTimeUpdate?("") // Use the callback to reset the UI to the icon
    }

    /// Sets up and starts the `Timer` instance.
    private func setupTimer() {
        timer?.invalidate() // Ensure no duplicate timers are running
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
