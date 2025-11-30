import SwiftUI

struct NewsDetailView: View {
    let article: Article
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                // Image
                if let urlToImage = article.urlToImage, let imageURL = URL(string: urlToImage) {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 200)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                        case .failure:
                            Image(systemName: "photo")
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.2))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .clipped()
                    .cornerRadius(8)
                } else {
                    Image(systemName: "photo")
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                // Title
                Text(article.title ?? "No title")
                    .font(.headline)
                    .fontWeight(.bold)
                
                // Source, Author, Date
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        if let sourceName = article.sourceName {
                            Text(sourceName)
                                .fontWeight(.semibold)
                            if let sourceId = article.sourceId {
                                Text("(\(sourceId))")
                                    .foregroundColor(.gray)
                                    .font(.caption)
                            }
                        }
                    }
                    
                    if let author = article.author {
                        Text("— \(author)")
                    }
                    
                    if let publishedAt = article.publishedAt {
                        Text(publishedAt.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                
                // Description
                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                // Content
                if let content = article.content, !content.isEmpty {
                    Text(content)
                        .font(.body)
                }
                
                // URL
                if let url = article.url {
                    HStack {
                        Text(url)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        Button(action: {
                            UIPasteboard.general.string = url
                        }) {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.top, 8)
                }
                
                Spacer()
            }
            .padding(16)
        }
        .navigationTitle("Article Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        NewsDetailView(
            article: Article(
                sourceName: "Example",
                author: "John Doe",
                title: "Sample Article Title",
                description: "This is a sample article description",
                url: "https://example.com/article",
                urlToImage: "https://via.placeholder.com/400x200",
                publishedAt: Date(),
                content: "This is the full article content with more details about the topic."
            )
        )
    }
}
