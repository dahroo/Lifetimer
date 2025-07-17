import Foundation

class PersistenceService {

    private let targetDateKey = "CountdownTargetDate"

    /// Saves the target date for the countdown to UserDefaults.
    func save(targetDate: Date) {
        UserDefaults.standard.set(targetDate, forKey: targetDateKey)
    }

    /// Loads the target date from UserDefaults.
    func loadTargetDate() -> Date? {
        return UserDefaults.standard.object(forKey: targetDateKey) as? Date
    }

    /// Clears the saved target date from UserDefaults.
    func clearTargetDate() {
        UserDefaults.standard.removeObject(forKey: targetDateKey)
    }
}
