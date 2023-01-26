//
//  EventCell.swift
//  VRefSolution ios app
//
//  Created by Yassine on 01/12/2022.
//

import SwiftUI

struct EventCell: View {
    let event: Event
    let selected: Bool
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(DateParser().getCurrentTimerInFormat(progressTime: event.timestamp)
                         )
                        .background(Color("colorBlue"))
                        .font(.callout).fontWeight(.bold).foregroundColor(.white)
                    
                    Text("\(event.altitude ?? 0) ft").font(.callout).fontWeight(.semibold).foregroundColor(.white)
                }
                
                ZStack(){
                    
                    Rectangle().fill(Color.black).frame(width: 3, height: 48)
                    Circle().strokeBorder(Color(event.eventType.eventTypeColor),lineWidth: 3)
                        .background(Circle().foregroundColor(.white))
                        .frame(width: 25, height: 25, alignment: .center)
                    Image(event.eventType.eventIcon)
                }
                
                Text(event.eventType.eventName).font(.body).fontWeight(.semibold).foregroundColor(.white)
                    .frame(width: 124, alignment: .leading)
                VStack{
                    Image("note").opacity(event.hasNotes ? 0 : 1).frame(width: 31)
                    
                    if event.ratingAll != nil && event.ratingAll != 0
                    {
                        
                        HStack{
                            Text("\(event.ratingAll!)" ).foregroundColor(.white).bold().font(.footnote).frame(width: 9).padding(.trailing, -5)
                            Image(systemName: "star.fill").foregroundColor(.yellow).font(.footnote)
                        }.frame(width: 31, alignment: .center)
                            .background(Color("buttonColorPurple")).padding(.top, -7)
                    }
                }
                
                Image(systemName: "chevron.right")
                    .font(Font.system(.body)
                        .weight(.semibold)).foregroundColor(Color("lightGreyText"))
            }.padding(.top, 12)
            Divider().frame(height: 2).overlay(Color("lightGreyText")).position(x:150, y:-13)
            
        }.frame(width: 300, height: 48)
            .background(selected == true ? Color("buttonColorBlue") : Color("darkmodeColor2"))
    }
}

struct EventCell_Previews: PreviewProvider {
    static var previews: some View {
        EventCell(event: Event(eventId: nil, logbookId: nil, timestamp: 987, eventType: .MASTER_WARNING, captain: nil, firstOfficer: nil, feedbackAll: "e", feedbackCaptain: nil, feedbackFirstOfficer: nil, ratingAll: 2, ratingCaptain: nil, ratingFirstOfficer: nil), selected: false)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
