//
//  RatingCell.swift
//  VRefSolution ios app
//
//  Created by Yassine on 15/12/2022.
//

import SwiftUI

struct RatingCell: View {
    @Binding var rating: Int
    
    var label = ""
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.white
    var onColor = Color.yellow
    

    var body: some View {
        HStack{
            if label.isEmpty == false{
                Text(label)
            }
            
            ForEach(1..<maximumRating + 1, id: \.self){ number in
                image(for: number)
                    .foregroundColor(number > rating ? offColor : onColor)
                    .onTapGesture {
                        rating = number
                    }
                
            }
        }
    }
    
    func image(for number: Int) -> Image{
        if number > rating{
            return offImage ?? onImage
        }
        else{
            return onImage
        }
    }
}

struct RatingCell_Previews: PreviewProvider {
    static var previews: some View {
        RatingCell(rating: .constant(4))
    }
}
