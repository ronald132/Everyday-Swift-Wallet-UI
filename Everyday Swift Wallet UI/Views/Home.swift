//
//  Home.swift
//  Everyday Swift Wallet UI
//
//  Created by Ronald on 3/8/21.
//

import SwiftUI

struct Home: View {
    
    @State private var currentTab = "Incomings"
    
    // For Segment Tab Slide...
    @Namespace var animation
    
    @State var weeks : [Week] = []
    
    @State var currentDay: Week = Week(day: "", date: "", amountSpent: 0)
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "text.justifyright")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                })
                Spacer(minLength: 0)
                Button(action: {}, label: {
                    Image(systemName: "rectangle.grid.2x2")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 28, height: 28)
                        .foregroundColor(.white)
                })
            }
            .padding()
            
            Text("Statistics")
                .font(.title)
                .fontWeight(.heavy)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
            
            //Custom segment picker
            HStack {
                Text("Incomings")
                    .fontWeight(.bold)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 25)
                    .background(
                        ZStack {
                            if currentTab == "Incomings" {
                                Color.white.cornerRadius(10)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                    .foregroundColor(currentTab == "Incomings" ? .black : .white)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)){
                            currentTab = "Incomings"
                        }
                    }
                
                Text("Outgoings")
                    .fontWeight(.bold)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 25)
                    .background(
                        ZStack {
                            if currentTab == "Outgoings" {
                                Color.white
                                    .cornerRadius(10)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            }
                        }
                    )
                    .foregroundColor(currentTab == "Outgoings" ? .black : .white)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.6, blendDuration: 0.6)){
                            currentTab = "Outgoings"
                        }
                    }
            }
            .padding(.vertical, 7)
            .padding(.horizontal, 10)
            .background(Color.black.opacity(0.35))
            .cornerRadius(10)
            .padding(.top, 20)
            
            //Money View
            
            HStack (spacing: 37) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 22)
                    
                    // Some max Amount for week
                    let progress = currentDay.amountSpent / 500
                    
                    Circle()
                        .trim(from: 0, to: progress)
                        .stroke(Color.yellow, style: StrokeStyle(lineWidth: 22, lineCap: .round, lineJoin: .round))
                        .rotationEffect(.init(degrees: -90))
                    
                    Image(systemName: "dollarsign.square.fill")
                        .font(.system(size: 55, weight: .bold))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: 180)
                
                VStack (alignment: .leading, spacing: 10, content: {
                    
                    Text("Spent")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white.opacity(0.6))
                    
                    let amount = String(format: "%.2f", currentDay.amountSpent)
                    
                    Text("\(amount)")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Maximum")
                        .fontWeight(.bold)
                        .foregroundColor(Color.white.opacity(0.6))
                        .padding(.top, 10)
                    
                    Text("$500")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                })
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.leading, 30)
            
            ZStack {
                if UIScreen.main.bounds.height < 750 {
                    ScrollView(.vertical, showsIndicators: false, content: {
                        BottomSheet(weeks: $weeks, currentDay: $currentDay)
                            .padding([.horizontal, .top])
                            .padding(.bottom)

                    })
                }else {
                    BottomSheet(weeks: $weeks, currentDay: $currentDay)
                        .padding([.horizontal, .top])

                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white
                            .clipShape(CustomShape(corners: [.topLeft, .topRight], radius: 35))
                            .ignoresSafeArea(.all, edges: .bottom))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.ignoresSafeArea(.all, edges: .top))
        .onAppear(perform: {
            getWeekDays()
        })
    }
    
    
    // getting current week 7 days..
    func getWeekDays(){
        let calendar = Calendar.current
        
        let week = calendar.dateInterval(of: .weekOfMonth, for: Date())
        
        guard let startDate = week?.start else {
            return
        }
        
        // whole week days
        
        for index in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: index, to: startDate) else {
                return
            }
            
            let formatter = DateFormatter()
            // EEE will be used to get day like Mon, Tue..
            formatter.dateFormat = "EEE"
            
            var day = formatter.string(from: date)
            // since we need like Mo Tu
            day.removeLast()
            
            formatter.dateFormat = "dd"
            let dateString = formatter.string(from: date)
            
            weeks.append(Week(day: day, date: dateString, amountSpent: index == 0 ? 60 : CGFloat(index * 70)))
        }
        
        self.currentDay = weeks.first!
    }
    
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct BottomSheet : View {
    @Binding var weeks: [Week]
    @Binding var currentDay: Week
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color.gray)
                .frame(width: 100, height: 2)
            
            HStack(spacing: 15){
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Your Balance")
                        .font(.title)
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                    Text("Aug 3 20201")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                })
                Spacer(minLength: 0)
                
                Button(action: {}, label: {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.title2)
                        .foregroundColor(.black)
                })
                .offset(x: -10)
            }
        
            HStack {
                Text("$22,306.07")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                Image(systemName: "arrow.up")
                    .foregroundColor(.gray)
                Text("14%")
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
            .padding(.top, 8)
            
            HStack(spacing: 0) {
                ForEach(weeks) { week in
                    VStack(spacing: 12) {
                        Text(week.day)
                            .fontWeight(.bold)
                            .foregroundColor(currentDay.id == week.id ? Color.black.opacity(0.8) : .black)
                        
                        Text(week.date)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(currentDay.id == week.id ? .white : .black)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(Color.yellow.opacity(currentDay.id == week.id ? 1 : 0))
                    .clipShape(Capsule())
                    .onTapGesture {
                        withAnimation {
                            currentDay = week
                        }
                    }
                }
            }
            .padding(.top, 8)
            
            Button(action: {}, label: {
                Image(systemName: "arrow.forward")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 40)
                    .background(Color.blue)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
            })
            .padding(.top)
            
        }
    }
}
