//
//  ReviewAndImageStack.swift
//  PracticingBook
//
//  Created by Diana  on 1/18/21.
//

import SwiftUI
import class PhotosUI.PHPickerViewController

struct ReviewAndImageStack: View {
    @ObservedObject var book : Book
    @State var showingImagePicker = false
    @State private var showingAlert = false
    @Binding var image: UIImage?
    
    var body: some View {
        VStack{
            Divider()
                .padding(.vertical)
            TextField("Review", text: $book.microReview)
            Divider()
                .padding(.vertical)
            Book.Image(
                title: book.title,
                size: nil,
                UIimage: image,
                cornerRadius: 16
            )
            .scaledToFit()
            let updateButton = Button("Update Image...") {
                showingImagePicker = true
            }
            .padding(.horizontal)
            if image != nil {
                HStack{
                    Spacer()
                    Button("Delete imeage..") {
                        showingAlert = true
                    }
                    Spacer()
                    updateButton
                    Spacer()
                }
            } else {
                updateButton
            }
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showingImagePicker) {
            PHPickerViewController.View(image: $image)
            }
        .alert(isPresented: $showingAlert, content: {
            .init(title: Text("Delete image for \(book.title)?"),
                  primaryButton: Alert.Button.destructive(Text("Delete"), action: {
                    image = nil
                  }),
                  secondaryButton: Alert.Button.cancel())
        })
    }
}

struct ReviewAndImageStack_Previews: PreviewProvider {
    
    static var previews: some View {
        ReviewAndImageStack(book: .init(), image: .constant(nil))
            .previewedInAllColorSchemes
    }
}
