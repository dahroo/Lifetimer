import SwiftUI

struct ContentView: View {
    @EnvironmentObject var timerViewModel: TimerViewModel
    @State private var years: String = ""

    var body: some View {
        VStack(spacing: 20) {
            if timerViewModel.isTimerRunning {
                Text("Time Remaining")
                    .font(.headline)
                Button(action: {
                    timerViewModel.resetTimer()
                }) {
                    Text("Reset Timer")
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                Text("How many years do you think you have left?")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                
                TextField("Enter years", text: $years)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .frame(width: 150)

                Button(action: {
                    if let yearsValue = Double(years) {
                        timerViewModel.startTimer(years: yearsValue)
                        // Optionally close the popover after starting
                         NSApp.keyWindow?.close()
                    }
                }) {
                    Text("Start Countdown")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .frame(width: 300, height: 150)
    }
}
