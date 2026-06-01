import SwiftUI

struct OrderFormView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var personName: String
    @State private var drinkType: String
    @State private var size: String
    @State private var milk: String
    @State private var sugarCount: Int
    @State private var extras: String

    private let title: String
    private let saveButtonLabel: String
    private let onSave: (String, Order) -> Void

    private let drinkOptions = ["Coffee", "Iced Capp", "Tea", "French Vanilla", "Hot Chocolate"]
    private let sizeOptions = ["Small", "Medium", "Large", "Extra Large"]
    private let milkOptions = ["Regular", "2%", "Skim", "Oat", "Almond"]

    init(
        title: String = "New Order",
        saveButtonLabel: String = "Save",
        initialName: String = "",
        initialOrder: Order = Order(),
        onSave: @escaping (String, Order) -> Void
    ) {
        self.title = title
        self.saveButtonLabel = saveButtonLabel
        self.onSave = onSave

        _personName = State(initialValue: initialName)
        _drinkType = State(initialValue: initialOrder.drinkType)
        _size = State(initialValue: initialOrder.size)
        _milk = State(initialValue: initialOrder.milk)
        _sugarCount = State(initialValue: initialOrder.sugarCount)
        _extras = State(initialValue: initialOrder.extras)
    }

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
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(saveButtonLabel) {
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
