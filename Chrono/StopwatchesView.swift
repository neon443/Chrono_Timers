import SwiftUI

struct StopwatchesView: View {
	@State private var isRunning = false
	@State private var elapsedTime: TimeInterval = 0
	@State private var timer: Timer?

	private let totalTime: TimeInterval = 60 // 60 seconds for full rotation

	var body: some View {
		VStack {
			StopwatchDial(elapsedTime: elapsedTime, totalTime: totalTime)

			HStack(spacing: 40) {
				LapButton(action: resetTimer)
				StartStopButton(isRunning: isRunning, action: toggleTimer)
			}
			.padding(.top, 30)
		}
		.background(Color.black.edgesIgnoringSafeArea(.all))
		.onAppear(perform: resetTimer)
	}

	private func toggleTimer() {
		isRunning.toggle()
		if isRunning {
			startTimer()
		} else {
			stopTimer()
		}
	}

	private func startTimer() {
		let startDate = Date().addingTimeInterval(-elapsedTime)
		timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
			elapsedTime = Date().timeIntervalSince(startDate)
		}
	}

	private func stopTimer() {
		timer?.invalidate()
		timer = nil
	}

	private func resetTimer() {
		stopTimer()
		elapsedTime = 0
	}
}

struct StopwatchDial: View {
	let elapsedTime: TimeInterval
	let totalTime: TimeInterval

	var body: some View {
		ZStack {
			Circle()
				.stroke(lineWidth: 3)
				.foregroundColor(.gray.opacity(0.3))

			ForEach(0..<60) { tick in
				Rectangle()
					.fill(tick % 5 == 0 ? Color.white : Color.gray.opacity(0.5))
					.frame(width: tick % 5 == 0 ? 2 : 1, height: tick % 5 == 0 ? 15 : 10)
					.offset(y: -110)
					.rotationEffect(.degrees(Double(tick) * 6))
			}

			Rectangle()
				.fill(Color.orange)
				.frame(width: 2, height: 100)
				.offset(y: -50)
				.rotationEffect(.degrees(elapsedTime / totalTime * 360))
				.animation(.linear(duration: 0.1), value: elapsedTime)

			Text(formatTime(elapsedTime))
				.font(.system(size: 30, weight: .medium, design: .monospaced))
				.foregroundColor(.white)
				.offset(y: 40)
		}
		.frame(width: 220, height: 220)
	}

	private func formatTime(_ time: TimeInterval) -> String {
		let minutes = Int(time) / 60
		let seconds = Int(time) % 60
		let milliseconds = Int((time.truncatingRemainder(dividingBy: 1)) * 100)
		return String(format: "%02d:%02d.%02d", minutes, seconds, milliseconds)
	}
}

struct LapButton: View {
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			Text("Reset")
				.font(.title2)
				.frame(width: 80, height: 80)
				.background(Color.gray.opacity(0.5))
				.foregroundColor(.white)
				.clipShape(Circle())
		}
	}
}

struct StartStopButton: View {
	var isRunning: Bool
	let action: () -> Void

	var body: some View {
		Button(action: action) {
			Text(isRunning ? "Stop" : "Start")
				.font(.title2)
				.frame(width: 80, height: 80)
				.background(isRunning ? Color.red : Color.green)
				.foregroundColor(.white)
				.clipShape(Circle())
		}
	}
}

#Preview {
	StopwatchesView()
}
