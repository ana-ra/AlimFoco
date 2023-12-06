import SwiftUI

struct CardScrollView: View {
    @State private var isExpanded: Bool = false
    var meals: [Meal]
    @EnvironmentObject private var model: ModelMeal
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(meals, id: \.self) { meal in
                    VStack(alignment: .leading) {
                        Text("\(meal.name)")
                            .foregroundColor(Color.informationGreen)
                            .bold()
                            .padding(.top, 8)
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading) // Alinha o nome da refeição à esquerda
                        
                        // Display the first two items and weights
                        ForEach(meal.itens.indices.prefix(2), id: \.self) { itemIndex in
                            VStack(alignment: .leading, spacing: 2) {
                                Text("\(meal.itens[itemIndex])")
                                Text("\(meal.weights[itemIndex]) g")
                                    .foregroundColor(.gray) // Cor cinza padrão para os pesos
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 4)
                        }
                        
                        // Use DisclosureGroup for additional items and weights
                        if meal.itens.count > 2 {
                            DisclosureGroup(isExpanded: $isExpanded) {
                                VStack(alignment: .leading, spacing: 2) {
                                    ForEach(2..<meal.itens.count, id: \.self) { itemIndex in
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("\(meal.itens[itemIndex])")
                                            Text("\(meal.weights[itemIndex]) g")
                                                .foregroundColor(.gray) // Cor cinza padrão para os pesos
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.bottom, 4)
                                    }
                                }
                            } label: {
                                Text("Ver refeição completa")
                                    .bold()
                                    .foregroundColor(Color(red: 0.05, green: 0.51, blue: 0.44))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.bottom, 4)

                            }
                            .padding(.horizontal, 8)
                        }
                    }
                    .frame(width: 267, alignment: .leading)
                    .background(.white)
                    .cornerRadius(14)
                    .padding(.bottom, 8)
                }
            }
            .padding(.horizontal, 10)
        }
    }
}



// Exemplo de uso com Preview
struct CardScrollView_Previews: PreviewProvider {
    static var previews: some View {
        CardScrollView(meals: [Meal(id: ObjectIdentifier(Meal.self), name: "Opção A", date: Date(), satisfaction: "", itens: ["Arroz", "Feijão"], weights: ["20","30"], mealType: "Almoço", registered: 0), Meal(id: ObjectIdentifier(Meal.self), name: "Opção B", date: Date(), satisfaction: "", itens: ["Macarrao", "Ervilha"], weights: ["20","30"], mealType: "Almoço", registered: 0)])
    }
}
