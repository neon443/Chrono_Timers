import SwiftUI

struct TimerView: View {
	@State private var selectedMinutes = 1
	@State private var selectedSeconds = 0
	@State private var timeRemaining = 60
	@State private var isTimerRunning = false
	@State private var timer: Timer?

	var body: some View {
		VStack {
			// Display the remaining time
			Text(formatTime(timeRemaining))
				.font(.system(size: 72, weight: .bold))
				.padding()

			if !isTimerRunning {
				// Time picker for duration setting
				HStack {
					Picker("Minutes", selection: $selectedMinutes) {
						ForEach(0...59, id: \.self) { minute in
							Text("\(minute)").tag(minute)
						}
					}
					.pickerStyle(WheelPickerStyle())
					.frame(width: 100, height: 200)
					.clipped()

					Text(":")
						.font(.largeTitle)

					Picker("Seconds", selection: $selectedSeconds) {
						ForEach(0...59, id: \.self) { second in
							Text("\(second)").tag(second)
						}
					}
					.pickerStyle(WheelPickerStyle())
					.frame(width: 100, height: 200)
					.clipped()
					Button(action: resetTimer) {
						Text("Set")
							.font(.title)
							.padding()
							.background(Color.orange.opacity(0.5))
							.foregroundColor(.white)
							.clipShape(Circle())
					}
				}
				.padding(.bottom, 20)
			}

			HStack {
				// Reset button
				Button(action: resetTimer) {
					Text("Reset")
						.font(.title2)
						.padding()
						.background(Color.gray.opacity(0.5))
						.foregroundColor(Color.white)
						.frame(width: 200)
						.clipShape(Circle())
				}
				// Start/Stop button
				Button(action: {
					if isTimerRunning {
						stopTimer()
					} else {
						setTimeRemaining()
						startTimer()
					}
				}) {
					Text(isTimerRunning ? "Stop" : "Start")
						.font(.title2)
						.padding()
						.background(isTimerRunning ? Color.red.opacity(0.5) : Color.green.opacity(0.5))
						.foregroundColor(.white)
						.frame(width: 200)
						.clipShape(Circle())
				}


			}
			.padding(.top, 20)
		}
		.padding()
	}

	// Format time in minutes:seconds
	private func formatTime(_ seconds: Int) -> String {
		let minutes = seconds / 60
		let seconds = seconds % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}

	// Start the timer
	private func startTimer() {
		isTimerRunning = true
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
			if timeRemaining > 0 {
				timeRemaining -= 1
			} else {
				stopTimer() // Stop the timer when it reaches 0
			}
		}
	}

	// Stop the timer
	private func stopTimer() {
		isTimerRunning = false
		timer?.invalidate()
	}

	// Reset the timer
	private func resetTimer() {
		stopTimer()
		setTimeRemaining()
	}

	// Set time remaining from picker selection
	private func setTimeRemaining() {
		timeRemaining = selectedMinutes * 60 + selectedSeconds
	}
}

struct TimerView_Previews: PreviewProvider {
	static var previews: some View {
		TimerView()
	}
}
