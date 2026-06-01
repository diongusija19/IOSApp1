import SwiftUI

struct OrderRowView: View {
    let teamOrder: TeamOrder
    let onToggleFavorite: () -> Void
    let onRepeat: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 6) {
                Text(teamOrder.personName)
                    .font(.headline)
                Text(teamOrder.order.summaryText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(String(format: "Est. $%.2f", teamOrder.order.estimatedPrice))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 8) {
                Button(action: onToggleFavorite) {
                    Image(systemName: teamOrder.isFavorite ? "star.fill" : "star")
                        .foregroundStyle(teamOrder.isFavorite ? .yellow : .gray)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(teamOrder.isFavorite ? "Remove from favorites" : "Add to favorites")

                Button(action: onRepeat) {
                    Image(systemName: "arrow.clockwise.circle")
                        .foregroundStyle(.blue)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Repeat this order")
            }
        }
        .padding(.vertical, 4)
    }
}
