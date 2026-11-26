# Python in 30 Days (iOS)

A small UIKit learning app built in Swift for iPhone. Open `Python30Days.xcodeproj` in Xcode and run the `Python30Days` scheme on an iOS Simulator or device.

## Features

- Dashboard with lesson completion, points, level, and current streak.
- 30 short Python lessons loaded from bundled JSON, so the course works offline.
- `UITableView` lesson list with completed status and navigation into each lesson.
- Multiple-choice activity with required-answer validation, incorrect-answer retry, and correct-answer feedback.
- Progress saved with `UserDefaults`; a lesson awards 25 points only on its first completion.
- Levels based on points, daily streak tracking, and milestone badges at 1, 7, 15, and 30 completed lessons.
- `URLSession` GET request to DummyJSON for a dashboard learning quote. A built-in prompt remains visible if the request fails.
- UIKit layouts use Auto Layout and scroll views to fit different iPhone screen sizes.

## Main files

- `Python30Days/Base.lproj/Main.storyboard` — Storyboard navigation root and dashboard entry screen.
- `Python30Days/Views` — dashboard, lesson list, lesson activity, achievements, and shared styling.
- `Python30Days/Resources/Lessons.json` — 30 lesson records and quiz questions.
- `Python30Days/Services` — quote web service, local course loader, and saved progress.

The lesson catalog is intentionally bundled for reliable offline access; the network integration supplies a fresh quote rather than downloading lesson records.
