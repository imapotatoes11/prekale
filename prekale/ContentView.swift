//
//  ContentView.swift
//  prekale
//
//  Created by Kevin Wang on 2024-06-15.
//

import SwiftUI
import Foundation

extension String {
  func truncate(length: Int, trailing: String = "...") -> String {
    if self.count <= length {
      return self
    }

    let truncatedPrefix = prefix(length)
    return truncatedPrefix + trailing
  }
}
extension Int {
    var daySuffix: String {
        switch self {
        case 11, 12, 13: return "th"
        default:
            switch self % 10 {
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
    }
}

extension Date {
    func formattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d"
        let day = Calendar.current.component(.day, from: self)
//        let dayString = "\(day)\(day.daySuffix)"
        let dayString = "\(day.daySuffix)"
        let monthAndDay = dateFormatter.string(from: self)
        dateFormatter.dateFormat = "yyyy"
        let year = dateFormatter.string(from: self)
        
        return "\(monthAndDay)\(dayString), \(year)"
    }
}

struct Schedule: Codable {
    let date: String
    let periods: [Period]
}
struct Period: Codable {
    let course: String
    let name: String
    let period: String
    let room: String
    let teacher: String
    let time1: String
    let time2: String
}

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
                            .fontDesign(.monospaced)
                            .fontWeight(.bold)
                        Text(_b2)
                        Text(_b3)
                    }
                }
            }
        }
    }
}

struct ContextStack: View {
    var fullName: String, courseCode: String;
    init(fullName: String, courseCode: String) {
        self.fullName = fullName;
        self.courseCode = courseCode;
    }
    var body: some View {
        Button(action: {
            UIPasteboard.general.string = self.courseCode
        }, label:
        {
            HStack {
                Image(systemName: "text.document")
                Text("Copy Course Code")
            }
        })
        
        Button(action: {
            UIPasteboard.general.string = self.fullName
        }, label:
        {
            HStack {
                Image(systemName: "document.on.document")
                Text("Copy Course Name")
            }
        })
        Text(self.fullName)
    }
}

struct ContentView: View {
    func getCurrentDateFormatted() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date) % 100
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let formattedMonth = String(format: "%02d", month)
        let formattedDay = String(format: "%02d", day)
        let formattedYear = String(format: "%02d", year)
        
        return "\(formattedMonth)-\(formattedDay)-\(formattedYear)"
    }
    func fetchJsonData(from url: String, completion: @escaping (Schedule?, Error?) -> Void) {
        guard let url = URL(string: url) else {
            completion(nil, NSError(domain: "Invalid URL", code: 400, userInfo: nil))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            do {
                let schedule = try JSONDecoder().decode(Schedule.self, from: data)
                DispatchQueue.main.async {
                    completion(schedule, nil)
                }
            } catch let parseError {
                DispatchQueue.main.async {
                    completion(nil, parseError)
                }
            }
        }
        task.resume()
    }
    
    @State private var data: Schedule?
    @State private var fetchError: Error?
    init() {
        print("ContentView initialized")
    }
    var body: some View {
        // TODO: https://chatgpt.com/share/021afbc9-86c3-4306-89b0-2c5f754af43e
        VStack {
            GroupBox {
                Text(Date().formattedString())
                    .font(.system(size: 24).bold())
                if let schedule = self.data {
                    ForEach(schedule.periods, id: \.period) { period in
                        ScheduleCard(
                            a1: "\(period.time1) - \(period.time2)",
                            a2: "P\(period.period) RM \(period.room)",
                            b1: period.course,
                            b2: period.name.truncate(length: 9),
                            b3: period.teacher
                        ).contextMenu {
                            ContextStack(fullName: period.name, courseCode: period.course).body
                        }
                    }
                } else if let fetchError = fetchError {
                    Text("Error: \(fetchError.localizedDescription)")
                } else {
                    Text("Loading data...")
                }
                
            }
        }
        .padding()
        .onAppear {
            let url = "https://kaleflake.vercel.app/schedule/get/\(getCurrentDateFormatted())"
            fetchJsonData(from: url) { json, error in
                if let error = error {
                    self.fetchError = error
                    print("Error fetching JSON data: \(error)")
                } else if let json = json {
                    self.data = json
                    print("JSON data: \(json)")
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
