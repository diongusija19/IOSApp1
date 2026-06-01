import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = OrderListViewModel()
    @State private var showingNewOrderSheet = false
    @State private var editingOrder: TeamOrder?
    @State private var showingCompleteRunAlert = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TimerCardView(viewModel: viewModel)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(Color.clear)

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Run Summary")
                            .font(.headline)
                        Text("Total Orders: \(viewModel.teamOrders.count)")
                        Text(String(format: "Estimated Total: $%.2f", viewModel.totalEstimatedCost))
                    }
                    .padding(.vertical, 4)
                }

                if !viewModel.favorites.isEmpty {
                    Section("Saved Favorites") {
                        ForEach(viewModel.favorites) { favorite in
                            OrderRowView(
                                teamOrder: favorite,
                                onToggleFavorite: { viewModel.toggleFavorite(favorite) },
                                onRepeat: { viewModel.addOrderFromFavorite(favorite) }
                            )
                        }
                    }
                }

                Section("Today’s Team Orders") {
                    if viewModel.teamOrders.isEmpty {
                        Text("No orders yet. Tap + to add one.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(viewModel.teamOrders) { teamOrder in
                            OrderRowView(
                                teamOrder: teamOrder,
                                onToggleFavorite: { viewModel.toggleFavorite(teamOrder) },
                                onRepeat: { viewModel.addOrderFromFavorite(teamOrder) }
                            )
                            .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                Button("Edit") {
                                    editingOrder = teamOrder
                                }
                                .tint(.blue)
                            }
                        }
                        .onDelete(perform: viewModel.deleteOrders)
                    }
                }

                if !viewModel.runHistory.isEmpty {
                    Section("Completed Runs") {
                        ForEach(viewModel.runHistory.prefix(5)) { run in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(run.completedAt, style: .date)
                                    .font(.headline)
                                Text("Orders: \(run.orders.count)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(String(format: "Total: $%.2f", run.totalEstimatedCost))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 2)
                        }

                        Button("Clear Run History", role: .destructive) {
                            viewModel.clearHistory()
                        }
                    }
                }
            }
            .navigationTitle("Tim Hortons Run")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Complete Run") {
                        showingCompleteRunAlert = true
                    }
                    .disabled(viewModel.teamOrders.isEmpty)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewOrderSheet = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .alert("Complete this coffee run?", isPresented: $showingCompleteRunAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Complete", role: .destructive) {
                    viewModel.completeRun()
                }
            } message: {
                Text("The run will be saved to history, and non-favorite orders will be cleared for the next run.")
            }
            .sheet(isPresented: $showingNewOrderSheet) {
                OrderFormView { name, order in
                    viewModel.addOrder(personName: name, order: order)
                }
            }
            .sheet(item: $editingOrder) { teamOrder in
                OrderFormView(
                    title: "Edit Order",
                    saveButtonLabel: "Update",
                    initialName: teamOrder.personName,
                    initialOrder: teamOrder.order
                ) { name, order in
                    let updated = TeamOrder(
                        id: teamOrder.id,
                        personName: name,
                        order: order,
                        isFavorite: teamOrder.isFavorite
                    )
                    viewModel.updateOrder(updated)
                }
            }
        }
    }
}
