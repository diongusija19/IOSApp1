import SwiftUI

struct OrderRowView: View {
    let teamOrder: TeamOrder
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(teamOrder.personName)
                    .font(.headline)
                Text(teamOrder.order.summaryText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: onToggleFavorite) {
                Image(systemName: teamOrder.isFavorite ? "star.fill" : "star")
                    .foregroundStyle(teamOrder.isFavorite ? .yellow : .gray)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(teamOrder.isFavorite ? "Remove from favorites" : "Add to favorites")
        }
        .padding(.vertical, 4)
    }
}
