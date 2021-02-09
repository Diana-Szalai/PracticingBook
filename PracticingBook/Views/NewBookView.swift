//
//  NewBookView.swift
//  PracticingBook
//
//  Created by Diana  on 1/17/21.
//

import SwiftUI

struct NewBookView: View {
    @ObservedObject var book = Book(title: "Title", author: "Author")
    @State var image: UIImage? = nil
    @EnvironmentObject var Library: Library
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack(spacing: 24) {
                TextField( "Title", text: $book.title )
                    .foregroundColor(.secondary)
                    .padding(.leading)
                TextField( "Author", text: $book.author )
                    .foregroundColor(.secondary)
                    .padding(.leading)
                ReviewAndImageStack(book: book, image: $image)
            }
            .padding()
            .navigationTitle("Got a new book ?")
            .toolbar{
                ToolbarItem(placement: .status) {
                    Button("Add to library"){
                        Library.addNewBook(book, image: image)
                        presentationMode.wrappedValue.dismiss()
                        
                    }
                    .disabled([book.title, book.author].contains(where: \.isEmpty))
                }
            }
        }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView().environmentObject(Library())
    }
}
