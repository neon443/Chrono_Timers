//
//  ContentView.swift
//  Chrono
//
//  Created by Nihaal Sharma on 01/12/2024.
//

import SwiftUI

struct ContentView: View {
	var body: some View {
		NavigationSplitView {
			List {
				NavigationLink(destination: StopwatchesView()) {
					Label("Stopwatch", systemImage: "stopwatch")
				}
				NavigationLink(destination: TimerView()) {
					Label("Timers", systemImage: "timer")
				}
			}
		} detail: {
			Text("Select an option")
				.font(.headline)
				.foregroundStyle(.secondary)
		}
	}
}

#Preview {
	ContentView()
}
