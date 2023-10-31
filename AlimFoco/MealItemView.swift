import SwiftUI

struct MealItemView: View {
    
    let MealItem: MealItem
    let onUpdate: (MealItem) -> Void
    
    var body: some View {
        HStack {
            Text(MealItem.title)
            Spacer()
            Image(systemName: MealItem.isCompleted ? "checkmark.square": "square")
                .onTapGesture {
                    var MealItemToUpdate = MealItem
                    MealItemToUpdate.isCompleted = !MealItem.isCompleted
                    onUpdate(MealItemToUpdate)
                }
        }
    }
}

struct MealItemView_Previews: PreviewProvider {
    static var previews: some View {
        MealItemView(MealItem: MealItem(title: "Mow the lawn", dateAssigned: Date()), onUpdate: { _ in })
    }
}

