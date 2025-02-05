//
//  UseConditionView.swift
//  IMAD_Project
//
//  Created by 유영웅 on 7/20/24.
//

import SwiftUI
import PDFKit

struct UseConditionView: View {
    @State var all = false
    @State var condition = false
    @State var info = false
    @State var age = false
    
    @State var showCondition = false
    @State var showInfo = false
    
    @State var noAdmit = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment:.leading){
            titleView
            ScrollView{
                VStack(alignment:.leading,spacing: 20){
                    allButton
                    Divider()
                    content(what: $condition, text: "[필수] 이용약관에 동의합니다.",show:"condition")
                    content(what: $info, text: "[필수] 개인정보 수집 및 이용에 동의합니다.",show:"info")
                    content(what: $age, text: "[필수] 본인은 만 14세 이상입니다.",show:"")
                    Spacer().frame(height:30)
                    CustomConfirmButton(text: "완료", color: .customIndigo,textColor:.white){
                        guard condition,info,age else{ return noAdmit = true}
                        noAdmit = false
                        dismiss()
                    }
                    announcementView
                }
                .padding()
                .background(Color.white)
                .padding(.vertical)
            }
            .foregroundColor(.black)
            .background(Color.gray.opacity(0.1))
        }
        .foregroundColor(.black)
        .background(Color.white.ignoresSafeArea())
        .sheet(isPresented: $showCondition){ PDFUIView(pdfName: "이용약관") }
        .sheet(isPresented: $showInfo){ PDFUIView(pdfName: "개인정보처리방침") }
    }
}

#Preview {
    UseConditionView()
}

extension UseConditionView{
    var titleView:some View{
        VStack(alignment:.leading){
            HeaderView(text: "약관 동의")
                .padding(.horizontal)
            Text("가입을 위해서는 다음 정책들의 동의가 필요합니다.")
                .font(.GmarketSansTTFMedium(15))
                .padding(.horizontal)
                .padding(.vertical,5)
        }
    }
    var allButton:some View{
        Button {
            if !all{
                all = true
                condition = true
                info = true
                age = true
            }else{
                all = false
                condition = false
                info = false
                age = false
            }
        } label: {
            HStack{
                Image(systemName: all ? "checkmark.square.fill":"checkmark.square")
                    .font(.title3)
                    .opacity(all ? 1 : 0.5)
                Text("모두 동의합니다.")
                    .font(.subheadline)
            }
        }
    }
    func content(what:Binding<Bool>,text:String,show:String)->some View{
        Button {
            what.wrappedValue.toggle()
            if condition,info,age{
                all = true
            }else{
                all = false
            }
        } label: {
            HStack{
                Image(systemName: what.wrappedValue ? "checkmark.square.fill":"checkmark.square")
                    .opacity(what.wrappedValue ? 1 : 0.5)
                    .font(.title3)
                Text(text)
                    .font(.subheadline)
                Spacer()
                if !show.isEmpty{
                    Button {
                        if show == "condition"{
                            showCondition = true
                        }else{
                            showInfo = true
                        }
                    } label: {
                        Text("보기")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    @ViewBuilder
    var announcementView:some View{
        if noAdmit{
            Text("모두 동의 하지 않으면 가입을 완료할 수 없습니다.")
                .font(.GmarketSansTTFMedium(12))
                .foregroundColor(.red)
        }
    }
}
