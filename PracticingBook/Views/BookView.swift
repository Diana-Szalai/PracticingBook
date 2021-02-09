//
//  BookView.swift
//  PracticingBook
//
//  Created by Diana  on 12/30/20.
//
import class PhotosUI.PHPickerViewController
import SwiftUI

struct addNewBookButton: View {
    @ObservedObject var book : Book
    @Binding var image: UIImage?
    @State var showingImagePicker = false
    @State private var showingAlert = false
    
    var body: some View {
        VStack{
                TitleAndAuthorStack(
                 book: book,
                 titleFont:.title,
                 authorFont:.title2)
            
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
           let updatePhoto = Button("Update Image...") {
                showingImagePicker = true
        }
        .padding()
            if image != nil {
                HStack{
                    Spacer()
                    Button("Delete imeage..") {
                            showingAlert = true
                            }
                    Spacer()
                    updatePhoto
                    Spacer()
                    }
                } else {
                    updatePhoto
                }
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


struct BookmarkButton: View {
    @ObservedObject var book : Book
    let bookmark = "bookmark"
    
    var body: some View {
        Button {
            book.readMe.toggle()
        } label: {
            Image(systemName: book.readMe ? "\(bookmark).fill" : bookmark )
                .font(.system(size: 48, weight: .light))
        }
    }
}

extension Book {
    
struct Image: View {
    let title: String
    let size: CGFloat?
    let UIimage: UIImage?
    let cornerRadius: CGFloat
    
    var body: some View {
        if let image = UIimage.map(SwiftUI.Image.init) {
            image
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .cornerRadius(cornerRadius)
        }else{
        let symbolName = SwiftUI.Image(titleBook: title) ?? SwiftUI.Image(systemName: "book")
            
        symbolName
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .foregroundColor(.secondary)
            }
        }
    }
}


extension Image {

    init?(titleBook: String) {
        guard let character = titleBook.first else {
            return nil
        }
        let symbolName = "\(character.lowercased()).square"
        
        guard UIImage(systemName: symbolName) != nil else {
            return nil
        }
        self.init(systemName: symbolName)
        }
    }

extension Book.Image {
    ///a preview image
    init(title: String) {
        self.init(
            title: title,
            size: nil,
            UIimage: nil,
            cornerRadius: .init()
        )
    }
}
    
extension View {
    var previewedInAllColorSchemes: some View {
        
        ForEach(
            ColorScheme.allCases, id: \.self, content: preferredColorScheme
        )
    }
}

struct BookView_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            HStack{
                BookmarkButton(book: .init())
                BookmarkButton(book: .init(readMe: false))
                TitleAndAuthorStack(
                    book: .init(),
                    titleFont: .title,
                    authorFont: .title2)
                }
                
                Book.Image(title: Book().title, size: nil, UIimage: nil, cornerRadius: 16 )
                Book.Image(title: "", size: nil, UIimage: nil, cornerRadius: 16 )
                Book.Image(title: "3!*", size: nil, UIimage: nil, cornerRadius: 16)
            
            }
        .previewedInAllColorSchemes
    }
}
