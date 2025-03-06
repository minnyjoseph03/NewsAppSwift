# iOS News API App

## Overview
This iOS application fetches and displays news articles from an external API. Users can browse through news articles, search for specific topics, and view detailed information about each article, including the author, likes, and comments.

## Features
- Fetches news articles from an API
- Displays article images, titles, and descriptions in a list
- Allows users to search for articles
- Opens a detailed screen when selecting an article
- Displays likes and comments fetched from an external API
- Supports both dark and light mode
- Unit tests for core functionalities

## Installation
1. Clone the repository:
   ```sh
   git clone https://github.com/your-repo.git
   ```
2. Open the project in Xcode:
   ```sh
   cd iOS-News-API
   open NewsAPI.xcodeproj
   ```
3. Install dependencies (if any) using CocoaPods or Swift Package Manager.
4. Replace `YOUR_API_KEY` in the code with your actual API key.
5. Build and run the project on a simulator or device.

## API Endpoints
- **News Articles:** `https://newsapi.org/v2/top-headlines?country=us&apiKey=YOUR_API_KEY`
- **Article Likes:** `https://cn-news-info-api.herokuapp.com/likes/{article_id}`
- **Article Comments:** `https://cn-news-info-api.herokuapp.com/comments/{article_id}`

## Technologies Used
- Swift
- UIKit
- Combine for reactive programming
- URLSession for network requests
- Auto Layout for UI design
- XCTest for unit testing

## Unit Testing
The project includes unit tests for:
- Fetching news articles
- Searching for articles

Run tests using:
```sh
Cmd + U (Run Tests in Xcode)
```

## Future Enhancements
- Implement offline caching for articles
- Add bookmarking functionality
- Enhance accessibility features


