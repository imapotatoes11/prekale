//
//  ContentView.swift
//  prekale
//
//  Created by Kevin Wang on 2024-06-15.
//

import SwiftUI

struct ScheduleCard: View {
    var _a1: String, _a2: String, _b1: String, _b2: String, _b3: String;
    init(a1: String, a2: String, b1: String, b2: String, b3: String) {
        _a1 = a1; _a2 = a2;
        _b1 = b1; _b2 = b2; _b3 = b3;
    }
    var body: some View {
        GroupBox {
            ZStack {
                HStack() {
                    // TODO: align this stack top
                    VStack(alignment: .leading) {
                        Text(_a1)
                            .fontWeight(.medium)
                        Text(_a2)
                            .fontWeight(.light)
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(_b1)
                            .fontWeight(.bold)
                        Text(_b2)
                        Text(_b3)
                    }
                }
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!!")
            GroupBox {
                Text("June 15th, 2024")
                    .font(.system(size: 24).bold())
                ScheduleCard(
                    a1: "9:00 AM - 10:20 AM",
                    a2: "P1 RM 254",
                    b1: "SPH3U1 - 21",
                    b2: "Physics",
                    b3: "C. Chien"
                )
                ScheduleCard(
                    a1: "10:25 AM - 11:40 AM",
                    a2: "P2 RM 132",
                    b1: "CHC2D6 - 22",
                    b2: "History",
                    b3: "P. Dean"
                )
                ScheduleCard(
                    a1: "12:40 PM - 1:55 PM",
                    a2: "P3 RM 231",
                    b1: "MCR3U6 - 43",
                    b2: "Functions",
                    b3: "D. Chan"
                )
                ScheduleCard(
                    a1: "2:00 PM - 3:15 PM",
                    a2: "P4 RM 123",
                    b1: "ENG2D6 - 64",
                    b2: "Engilsh",
                    b3: "L. Dudgeon"
                )
                
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
