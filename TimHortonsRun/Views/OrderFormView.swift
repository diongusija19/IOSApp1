import SwiftUI

struct OrderFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var personName = ""
    @State private var drinkType = "Coffee"
    @State private var size = "Medium"
    @State private var milk = "Regular"
    @State private var sugarCount = 1
    @State private var extras = ""

    let onSave: (String, Order) -> Void

    private let drinkOptions = ["Coffee", "Iced Capp", "Tea", "French Vanilla", "Hot Chocolate"]
    private let sizeOptions = ["Small", "Medium", "Large", "Extra Large"]
    private let milkOptions = ["Regular", "2%", "Skim", "Oat", "Almond"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Team Member") {
                    TextField("Name", text: $personName)
                }

                Section("Order") {
                    Picker("Drink", selection: $drinkType) {
                        ForEach(drinkOptions, id: \.self) { option in
                            Text(option)
                        }
                    }

                    Picker("Size", selection: $size) {
                        ForEach(sizeOptions, id: \.self) { option in
                            Text(option)
                        }
                    }

                    Picker("Milk", selection: $milk) {
                        ForEach(milkOptions, id: \.self) { option in
                            Text(option)
                        }
                    }

                    Stepper("Sugar: \(sugarCount)", value: $sugarCount, in: 0...6)
                    TextField("Extras", text: $extras)
                }
            }
            .navigationTitle("New Order")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let order = Order(
                            drinkType: drinkType,
                            size: size,
                            milk: milk,
                            sugarCount: sugarCount,
                            extras: extras
                        )
                        onSave(personName, order)
                        dismiss()
                    }
                    .disabled(personName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
