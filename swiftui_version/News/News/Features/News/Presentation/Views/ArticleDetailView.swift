import SwiftUI

/// Detail view for a single article
struct ArticleDetailView: View {
    let article: Article
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Back button
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding()
                
                // Article image
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 250)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 250)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .frame(height: 250)
                                .background(Color.gray.opacity(0.3))
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    // Title
                    Text(article.title ?? "No title")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // Source and author
                    HStack(spacing: 12) {
                        if let source = article.sourceName {
                            Label(source, systemImage: "newspaper.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        Spacer()
                        
                        if let date = article.publishedAt {
                            Label(formatDate(date), systemImage: "calendar")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    
                    // Author
                    if let author = article.author {
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                            Text(author)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    // Description
                    if let description = article.description {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            Text(description)
                                .font(.body)
                                .lineSpacing(1.2)
                        }
                    }
                    
                    // URL
                    if let url = article.url {
                        Divider()
                        Link(destination: URL(string: url)!) {
                            HStack {
                                Image(systemName: "link")
                                Text("Read Full Article")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    ArticleDetailView(
        article: Article(
            sourceName: "TechCrunch",
            author: "Jane Doe",
            title: "Breaking News: Revolutionary Technology Unveiled",
            description: "Researchers have announced a groundbreaking new technology that could revolutionize the industry. This discovery comes after years of research and development.",
            url: "https://example.com/article",
            urlToImage: "https://via.placeholder.com/400x250",
            publishedAt: Date()
        )
    )
}
