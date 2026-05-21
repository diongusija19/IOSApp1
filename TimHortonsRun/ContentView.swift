import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = OrderListViewModel()
    @State private var showingNewOrderSheet = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TimerCardView(viewModel: viewModel)
                        .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                        .listRowBackground(Color.clear)
                }

                if !viewModel.favorites.isEmpty {
                    Section("Saved Favorites") {
                        ForEach(viewModel.favorites) { favorite in
                            OrderRowView(teamOrder: favorite) {
                                viewModel.toggleFavorite(favorite)
                            }
                        }
                    }
                }

                Section("Today’s Team Orders") {
                    ForEach(viewModel.teamOrders) { teamOrder in
                        OrderRowView(teamOrder: teamOrder) {
                            viewModel.toggleFavorite(teamOrder)
                        }
                    }
                    .onDelete(perform: viewModel.deleteOrders)
                }
            }
            .navigationTitle("Tim Hortons Run")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewOrderSheet = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewOrderSheet) {
                OrderFormView { name, order in
                    viewModel.addOrder(personName: name, order: order)
                }
            }
        }
    }
}
