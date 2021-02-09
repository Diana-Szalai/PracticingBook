//
//  ContentView.swift
//  PracticingBook
//
//  Created by Diana  on 12/30/20.
//

import SwiftUI


struct ContentView: View {
    @EnvironmentObject var library: Library
    @State var addingNewBook = false
    
    var body: some View {
        NavigationView{
            List {
                Button {
                    addingNewBook = true
                } label: {
                        Spacer()
                        VStack(spacing: 6) {
                            Image(systemName: "book.circle")
                                .font(.system(size: 60))
                            Text("Add new book")
                                .font(.title2)
                        }
                        Spacer()
                    }
                .buttonStyle(BorderlessButtonStyle())
                .padding(.vertical, 8)
                .sheet(
                    isPresented: $addingNewBook,
                    content: NewBookView.init
                )
                switch library.sortStyle {
                case .title, .author :
                    BookRows(books: library.sortedBooks, section: nil)
                case .manual:
                    ForEach(Section.allCases, id: \.self){
                        sectionView(section: $0)
                            }
                }
                    }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Menu("Sort") {
                        Picker ("Sort Style", selection: $library.sortStyle) {
                            ForEach(SortStyle.allCases, id: \.self ) {
                                sortStyle in Text("\(sortStyle)".capitalized )
                            }
                        }
                    }
                }
                ToolbarItem(content: EditButton.init)
            }
            .navigationBarTitle("My list")
            }
        }
    }
    
struct TitleAndAuthorStack: View {
    let book: Book
    let titleFont: Font
    let authorFont: Font
    
    var body: some View {
        VStack(alignment: .leading){
            Text(book.title)
                .font(titleFont)
            Text(book.author)
                .font(authorFont)
                .foregroundColor(.secondary)
        }
    }
}

private struct BookRows: View {
    let books: [Book]
    let section: Section?
    @EnvironmentObject var library: Library
    
    var body: some View {
                ForEach(books) {
                    BookRow(book: $0)
                }
                .onDelete{ indexSet in
                    library.deleteBooks(atOffsets: indexSet, section: section)
                }
                .onMove{ indices, newOffset in library.moveBooks(oldOffsets: indices, newOffset: newOffset, section: section!)
                    
                }
                .moveDisabled(section == .none)
            }
        }


private struct BookRow: View {
    @ObservedObject var book: Book
    @EnvironmentObject var library: Library
    @State var addingNewBook = false
    
    var body: some View {
        NavigationLink(
            destination: DetailView(book: book)) {
            HStack {
                Book.Image(
                    title: book.title,
                    size: 80,
                    UIimage: library.uiImages[book],
                    cornerRadius: 12 )
                VStack(alignment: .leading ){
                    TitleAndAuthorStack(
                        book: book,
                        titleFont: .title2,
                        authorFont: .title3)
                    if !book.microReview.isEmpty {
                    Spacer()
                    Text(book.microReview)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                .lineLimit(1)
                
                Spacer()
                BookmarkButton(book: book)
                    .buttonStyle(BorderlessButtonStyle())
                }
            .padding(.vertical, 8)
            .sheet(
                isPresented: $addingNewBook,
                content: NewBookView.init
                )
            }
        }
    }

private struct sectionView: View {
    let section: Section
    @EnvironmentObject var library: Library
    
    var title: String {
        switch section {
        case .readMe:
            return "Read me!"
        case .finished:
            return "Finished!"
        }
    }
    var body: some View {
        if let books = library.manuallySortedBooks[section] {
            SwiftUI.Section(
                header:
                    ZStack {
                        Image("BookTexture")
                        .resizable()
                        .scaledToFit()
                        Text(title)
                            .font(.custom("American Typewriter", size: 24))
                    }
                    .listRowInsets(.init())
            ) {
                BookRows(books: books, section: section)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    //@State var image: UIImage?
    
    static var previews: some View {
        ContentView()
            .environmentObject(Library())
            .previewedInAllColorSchemes
    }
}






