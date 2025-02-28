//
//  SettingsRowView.swift
//  HauteVision
//
//  Created by romi bonomo on 2025-02-10.
//

import SwiftUI

struct SettingsRowView: View {
    let imageName: String
    let title: String
    let tintColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: imageName)
                .imageScale(.small)
                .font(.title)
                .foregroundColor(tintColor)
            
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

struct SettingRowView_Previews: PreviewProvider {
    static var previews: some View{
        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
    }
}
