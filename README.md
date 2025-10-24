## Project Overview

Create a Flutter app that calculates the final course grade from component scores. The app should be user-friendly, resilient, and written in Dart.

## Features

- Default score for every component is 100; users can edit any value.
- Add up to 4 homework grades and remove/reset them.
- Tap a CALCULATE button to compute and display the final grade.
- Persist user inputs so values remain after app restarts (use shared_preferences).
- Clean UI; a custom homework component with add/remove buttons is recommended.
- Include a screenshot as a sample (UI can be improved).

## Grade Components (weights)
- Participation & Attendance — 10%
- 4 Homework assignments — 20% (total)
- Group Presentation — 10%
- Midterm Exam 1 — 10%
- Midterm Exam 2 — 20%
- Final Project — 30%

## Requirements & Acceptance Criteria

1. Language: Dart (Flutter).
2. Correct, crash-free behavior with edge cases handled (empty inputs, invalid values, partial homework list).
3. High-quality, maintainable code.
4. Persist data between app launches (shared_preferences recommended).
5. UI allows: adding/removing homework grades, resetting homework list, editing all component scores, and triggering calculation.

## Optional / Recommended Improvements

- Create a reusable, slightly complex UI component for homework items (with + / − controls).
- Validate inputs (0–100) and show friendly error messages.
- Save and restore state automatically when the app starts.

## Notes

- The final grade should be computed as the weighted sum of components (homework weight distributed across entered homework items).
- Provide a clear result presentation and consider showing a breakdown per component.
- Keep the UX responsive and accessible.