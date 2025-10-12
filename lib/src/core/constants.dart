/// Core constants for the grade calculator application.

// Grading weights (must sum to 100)
const double weightHomeworks = 20.0;
const double weightParticipation = 10.0;
const double weightPresentation = 10.0;
const double weightMidterm1 = 15.0;
const double weightMidterm2 = 15.0;
const double weightFinalProject = 30.0;

// Homework configuration
const int maxHomeworkSlots = 4;
const int homeworkSlotsForFullWeight = 4;

// Default grade values
const double defaultGrade = 100.0;

// Grade constraints
const double minGrade = 0.0;
const double maxGrade = 100.0;

// Precision
const int gradePrecisionDecimals = 2;

// Storage keys
const String storageKeyAppState = 'homework_app_state_v1';
