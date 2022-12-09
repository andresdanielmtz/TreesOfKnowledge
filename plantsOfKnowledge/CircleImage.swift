//
//  CircleImage.swift
//  plantsOfKnowledge
//
//  Created by Andres Daniel  on 08/12/22.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("totoro")
            .frame(width: 250, height:250)
            .clipShape(Circle())
            .overlay {
                Circle().stroke(.white, lineWidth: 5)
            }
            .shadow(radius: 4)
            .padding() // small padding
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
