import SwiftUI

struct TimerCardView: View {
    @ObservedObject var viewModel: OrderListViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text("Coffee Run Timer")
                .font(.headline)

            Text(viewModel.formattedRemainingTime())
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .monospacedDigit()

            HStack {
                Button(viewModel.timerRunning ? "Running..." : "Start") {
                    viewModel.startCoffeeRunTimer()
                }
                .disabled(viewModel.timerRunning)
                .buttonStyle(.borderedProminent)

                Button("Reset") {
                    viewModel.stopCoffeeRunTimer(reset: true)
                }
                .buttonStyle(.bordered)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
