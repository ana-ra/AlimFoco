//
// AlimFocoWidget.swift
// AlimFocoWidget
//
// Created by Carol Quiterio on 24/11/23.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(
      date: Date(),
      mealTitle: "Almoço",
      mealCalories: "210 CAL",
      mealItems: ["Arroz", "Frango"]
    )
  }
   
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(
      date: Date(),
      mealTitle: "Almoço",
      mealCalories: "210 CAL",
      mealItems: ["Arroz", "Frango"]
    )
    completion(entry)
  }
   
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []
     
    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(
        date: entryDate,
        mealTitle: "Almoço",
        mealCalories: "210 CAL",
        mealItems: ["Arroz", "Frango"]
      )
      entries.append(entry)
    }
     
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  var date: Date
   
  let mealTitle: String
  let mealCalories: String
  let mealItems: [String]
}

struct AlimFocoWidgetEntryView : View {
  var entry: Provider.Entry
   
  @Environment(\.widgetFamily) var family
   
  var body: some View {
    switch(family) {
    default:
      VStack(alignment: .leading) {
        Text("PRÓXIMA REFEIÇÃO")
          .font(.system(size: 10))
          .fontWeight(.semibold)
          .foregroundColor(Color(red: 0.01, green: 0.61, blue: 0.51))
          .padding(.top, 4)
         
        HStack {
          Image(systemName: "fork.knife")
            .font(.system(size: 12))
          Text(entry.mealTitle)
            .font(.system(size: 12))
            .fontWeight(.medium)
        }.padding(.top, 4)
         
        ForEach(entry.mealItems.prefix(3), id: \.self) { item in
          Text(item)
            .font(.system(size: 10))
            .fontWeight(.medium)
        }.padding(.top, 2)
         
        Text(entry.mealCalories)
          .font(.system(size: 10))
          .fontWeight(.medium)
          .foregroundColor(Color(red: 0.56, green: 0.56, blue: 0.58))
          .padding(.top, 4)
         
        Spacer()
      }
    }
  }
   
}

struct AlimFocoWidget: Widget {
  let kind: String = "AlimFocoWidget"
   
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      if #available(iOS 17.0, *) {
        AlimFocoWidgetEntryView(entry: entry)
          .containerBackground(.fill.tertiary, for: .widget)
      } else {
        AlimFocoWidgetEntryView(entry: entry)
          .padding()
          .background()
      }
    }
    .configurationDisplayName("Nutrifi Widget")
    .supportedFamilies([.systemSmall])
  }
}

#Preview(as: .systemSmall) {
  AlimFocoWidget()
} timeline: {
  SimpleEntry(
    date: Date(),
    mealTitle: "Almoço",
    mealCalories: "210 CAL",
    mealItems: ["Arroz", "Frango", "Limão espremido"]
  )
}
