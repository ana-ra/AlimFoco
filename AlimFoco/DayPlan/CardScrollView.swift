import SwiftUI

struct CardScrollView: View {
    var meals: [Meal]
    @State var isMealSheetViewPresented = false
    @EnvironmentObject private var model: ModelMeal
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(meals, id: \.self) { meal in
                        Button {
                            isMealSheetViewPresented.toggle()
                        } label: {
                            VStack(alignment: .leading) {
                                Text(meal.name == "" ? "Sem Título" : "\(meal.name)")
                                    .bold()
                                    .padding(.top, 8)
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity, alignment: .leading) // Alinha o nome da refeição à esquerda
                                    .foregroundStyle(Color(.teal))
                                if (showKcal){
                                    Text("\(calory(meal:meal)) CAL")
                                        .font(.system(size: 12))
                                        .bold()
                                        .padding(.horizontal, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading) // Alinha o nome da refeição à esquerda
                                        .foregroundStyle(Color(.secondary3))
                                }
                                // Display the first two items and weights
                            ForEach(meal.itens.indices.prefix(1), id: \.self) { itemIndex in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(meal.itens[itemIndex])")
                                    Text("\(meal.weights[itemIndex]) g")
                                }.padding(.horizontal, 16)
                            }
                            }.foregroundColor(.black)
                            .padding(.bottom, 8)
                        
                        // Use DisclosureGroup for additional items and weights
                        
                    }
                        .background(Color.white)
                        .sheet(isPresented: $isMealSheetViewPresented, content: {
                        NavigationStack {
                            MealSheetView(meal: meal)
                        }
                    })
                }
                .frame(width: 267, alignment: .leading)
                .cornerRadius(14)
                .padding(.bottom, 8)
            }
        }
    }
}

func calory(meal: Meal) -> String{
    @StateObject var viewModel = foodListViewModel()
    var total : Float = 0
    for index in meal.itens.indices{
        let alimentoSel = viewModel.filteredAlimentos.filter({ (alimento) -> Bool in
            alimento.nome == meal.itens[index]
        })
        let cal = NumberFormatter().number(from: alimentoSel.first!.kcal)
        let weight = NumberFormatter().number(from: meal.weights[index])
        total += cal!.floatValue * (weight!.floatValue/100)

    }
    let totalStr =  String(format: "%.1f", total)
    return totalStr
}

//struct CardScrollView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardScrollView(meals: [Meal(id: ObjectIdentifier(Meal.self), name: "Opção A", date: Date(), satisfaction: "", itens: ["Arroz", "Feijão"], weights: ["20","30"], mealType: "Almoço", registered: 0), Meal(id: ObjectIdentifier(Meal.self), name: "Opção B", date: Date(), satisfaction: "", itens: ["Macarrao", "Ervilha"], weights: ["20","30"], mealType: "Almoço", registered: 0)])
//    }
//}
