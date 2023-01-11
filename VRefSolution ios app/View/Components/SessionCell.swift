//
//  SessionCell.swift
//  VRefSolution ios app
//
//  Created by Yassine on 22/11/2022.
//

import SwiftUI

struct SessionCell: View {
    let session: Session
    let selected: Bool
    
    var body: some View {
        VStack{
            HStack(alignment: .top){
                Text(session.sessionName).font(.callout).fontWeight(.semibold).foregroundColor(.white).frame(width: 215, height: 30, alignment: .leading)
                
                Image("notFinished")
                    .resizable()
                    .frame(width: 35, height: 35, alignment: .leading)
                    .opacity(session.status != .Finished ? 1 : 0)
        
                    .frame(width: 30, height: 30, alignment: .leading)
                
                Spacer()
                Group(){
                    Image(systemName: "chevron.right").font(Font.system(.body).weight(.semibold)).foregroundColor(Color("lightGreyText")).padding(.top,7)
                }.padding(.trailing,11)
                
            }.padding(.leading,10)
                .padding(.top, 8)
            Spacer()
            Divider().frame(height: 2).overlay(Color("lightGreyText")).position(x:150, y:1)
            
        }.frame(width: 300, height: 48)
            .background(selected == true ? Color("buttonColorBlue") : Color("darkmodeColor2"))
        
    }
}


struct SessionCell_Previews: PreviewProvider {
    static var previews: some View {
        SessionCell(session: Session(id: "1", startTime: Date.now, companyId: "1", videos: [], users: [], status: .Started),selected: false)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
